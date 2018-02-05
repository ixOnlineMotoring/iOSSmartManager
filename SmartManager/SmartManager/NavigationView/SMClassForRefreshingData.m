//
//  SMClassForRefreshingData.m
//  SmartManager
//
//  Created by Liji Stephen on 16/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMClassForRefreshingData.h"
#import "SMWebServices.h"
#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
#import "SMGlobalClass.h"
#import "SMGlobalClassForImpersonation.h"
#import "SMAppDelegate.h"
#import "SMBase64ImageEncodingObject.h"

@implementation SMClassForRefreshingData

void(^ getThePushNotificationResponseCallBack)(NSString *pushNotificationUserId);

#pragma mark - WebService implementation


-(id)init
{
    if (self = [super init])
    {
        isImpersonateFound = NO;
        
    }
    return self;
}

-(void)authenticateWithServerWithUsername:(NSString*)username andPassword:(NSString*)password
{
    HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    HUD.delegate = self;
    HUD.labelText = KLoaderAuthenticate;
    [HUD show:YES];
    
    NSString *str = password;
    
    NSLog(@"password = %@",[str MD5]);
    NSMutableURLRequest *requestURL=[SMWebServices loginWithUsername:username andPassword:[str MD5]];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
                      
            [SMGlobalClass sharedInstance].arrayOfModules = [[NSMutableArray alloc]init];
            [SMGlobalClass sharedInstance].arrayOfImpersonateClients = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


- (NSString *)extractString:(NSString *)fullString toLookFor:(NSString *)lookFor skipForwardX:(NSInteger)skipForward toStopBefore:(NSString *)stopBefore
{
    
    NSRange firstRange = [fullString rangeOfString:lookFor];
    NSRange secondRange = [[fullString substringFromIndex:firstRange.location + skipForward] rangeOfString:stopBefore];
    NSRange finalRange = NSMakeRange(firstRange.location + skipForward, secondRange.location + [stopBefore length]);
    
    return [fullString substringWithRange:finalRange];
}

-(void)getThePushNotificationIDWithCallBack:(SMCompetionBlockOfPushNotification)callBackPushNotificationUser
{
    getThePushNotificationResponseCallBack = callBackPushNotificationUser;
}

-(void)webserviceForSavingDeviceCodeFromOneSignalWithDeviceCode:(NSString*) deviceCode{
   
    
     NSMutableURLRequest *requestURL = [SMWebServices SaveDeviceTokenOfOneSignalWithUserHash:[SMGlobalClass sharedInstance].hashValue andCodeType:2 andDeviceCode:deviceCode];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}





#pragma mark - Parsing delegate methods

// The first method to implement is parser:didStartElement:namespaceURI:qualifiedName:attributes:, which is fired when the start tag of an element is found:

//---when the start of an element is found---

-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
attributes:(NSDictionary *) attributeDict
{
   
     prefs = [NSUserDefaults standardUserDefaults];

    if ([elementName isEqualToString:@"a:IsAuthenticated"])
    {
        isAuthenticated = YES;
    }
    
    if ([elementName isEqualToString:@"a:FailureReason"])
    {
        isFailureReason = YES;
    }
    
    if ([elementName isEqualToString:@"Identity"])
    {
        
        isIdentity = YES;
        
    }
    
    if ([elementName isEqualToString:@"Name"])
    {
        
        isName = YES;
        
    }
    if ([elementName isEqualToString:@"Surname"])
    {
        
        isSurName = YES;
        
    }
    
    if ([elementName isEqualToString:@"MemberID"])
    {
        
        isMemberID = YES;
        
    }
    if ([elementName isEqualToString:@"UserHash"])
    {
        
        isUserHash = YES;
        
    }
    
    if( [elementName isEqualToString:@"User"])
    {
        isUser = YES;
        
    }
    
    if([elementName isEqualToString:@"ClientImages"])
    {
        isClientImages = YES;
        [SMGlobalClass sharedInstance].arrayOfClientImages = [[NSMutableArray alloc]init];
    }
    if([elementName isEqualToString:@"MemberImages"])
    {
        isMemberImages = YES;
        [SMGlobalClass sharedInstance].arrayOfMemberImages = [[NSMutableArray alloc]init];
    }
    
    if([elementName isEqualToString:@"ClientImage"])
    {
        isIndividualClientImage = YES;
    }
    if([elementName isEqualToString:@"MemberImage"])
    {
        isIndividualMemberImage = YES;
    }
    
    if( [elementName isEqualToString:@"Client"])
    {
         if(isUser)
        {
            isClientName = YES;
            
            [SMGlobalClass sharedInstance].strClientID = [attributeDict valueForKey:@"id"];
            [SMGlobalClass sharedInstance].strDefaultClientID = [attributeDict valueForKey:@"id"];
            [prefs setValue:[SMGlobalClass sharedInstance].strDefaultClientID forKey:@"ClientID"];
            
        }
        
    }
    
    if([elementName isEqualToString:@"Modules"])
    {
        
        moduleElementFound = YES;
        
    }
    
    if( [elementName isEqualToString:@"Module"])
    {
        
        self.moduleObj = [[SMGridModuleData alloc]init];
        
        if(self.moduleObj!=nil)
        {
            self.moduleObj.moduleName = [attributeDict valueForKey:@"Name"];
            NSLog(@"ModuleNamee = %@",self.moduleObj.moduleName);
            
        }
        
        self.moduleObj.isQuickLink = [[attributeDict valueForKey:@"QuickLink"] boolValue];
        
        isModulePresent = YES;
        self.modulePageObj = [[SMGridModuleData alloc]init];
        self.modulePageObj.moduleName = @"Home";
        self.modulePageObj.isQuickLink = YES;
        [self.moduleObj.arrayOfPages addObject:self.modulePageObj];
    }
    if( [elementName isEqualToString:@"SubModule"])
    {
        isSubModulePresent = YES;
        self.subModuleObj = [[SMGridModuleData alloc]init];
        
        if(self.subModuleObj!=nil)
        {
            self.subModuleObj.moduleName = [attributeDict valueForKey:@"Name"];
            NSLog(@"Sub ModuleNamee = %@",self.subModuleObj.moduleName);
                       
        }
        
        //isModulePresent = YES;
        //self.modulePageObj = [[SMGridModuleData alloc]init];
        
    }

    
    if( [elementName isEqualToString:@"Page"])
    {
        if(!isSubModulePresent)
        {
            if(self.moduleObj!=nil)
            {
                self.modulePageObj = [[SMGridModuleData alloc]init];
                self.modulePageObj.isQuickLink = NO;
                self.modulePageObj.isAlertPresent = [[attributeDict valueForKey:@"Alerts"] boolValue];
            }
            
            isPageFound = YES;
        }
        else
        {
            if(self.subModuleObj!=nil)
            {
                self.modulePageObj = [[SMGridModuleData alloc]init];
                self.modulePageObj.isQuickLink = NO;
                self.modulePageObj.isAlertPresent = [[attributeDict valueForKey:@"Alerts"] boolValue];
            }
            isPageFound = YES;
        }
        
    }
    
    
    if( [elementName isEqualToString:@"Impersonate"])
    {
        isUser = NO;
        isImpersonateFound = YES;
        
    }
    
    [prefs synchronize];
    
     currentNodeContent = [NSMutableString stringWithString:@""];
    
    
}


//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
    
     prefs = [NSUserDefaults standardUserDefaults];
    
    if(isAuthenticated)
    {
        
        AuthenticatedValue = string;
        
    }
    if(isFailureReason)
    {
        failureReason = string;
    }
    
    if(isIdentity)
    {
        
        [SMGlobalClass sharedInstance].strMemberID = string;
        isIdentity = NO;
        
    }
    if(isName)
    {
        
        [prefs setValue:string forKey:@"Name"];
        isName = NO;
        
    }
    if(isSurName)
    {
       
       [prefs setValue:string forKey:@"Surname"];
        
        isSurName = NO;
        
    }
    if(isMemberID)
    {
         [prefs setValue:string forKey:@"Member_ID"];
        [SMGlobalClass sharedInstance].strCoreMemberID = string;
        isMemberID = NO;
        
    }
    if(isUserHash)
    {
       
        
        [SMGlobalClass sharedInstance].hashValue = string;
        isUserHash = NO;
        
    }
    
    if(isClientName)
    {
        
         [SMGlobalClass sharedInstance].strClientName = string;
         [prefs setValue:string forKey:@"ClientName"];
        
        [prefs setValue:[SMGlobalClass sharedInstance].strClientID  forKey:@"ClientID"];
        isClientName = NO;
        
    }
    
    if(isPageFound)
    {
        if(self.modulePageObj!=nil)
        {
            
            
            if([string isEqualToString:@"Customer Delivery"])
                string = @"Delivery";
            
            self.modulePageObj.moduleName = [NSString stringWithFormat:@"%@%@",self.modulePageObj.moduleName,string];
            NSLog(@"CHECK THIS = %@",self.modulePageObj.moduleName);
        }
        
    }
    
    if(isIndividualClientImage)
    {
        [[SMGlobalClass sharedInstance].arrayOfClientImages addObject:string];
        
    }
    
     [prefs synchronize];
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    
}



//Finally, when the parser encounters the end of an element, it fires the parser:didEndElement:namespaceURI:qualifiedName: method:


-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    NSLog(@"fgfgfgfgfg");
    prefs = [NSUserDefaults standardUserDefaults];
    
    if ([elementName isEqualToString:@"a:IsAuthenticated"])
    {
        
        if([AuthenticatedValue isEqualToString:@"false"])
        {
            
            [self.authenticateDelegate authenticationFailed];
        }
        else
        {
           
            if([failureReason length]!= 0)
            {
            
            NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"isQuickLink == %d",true];
            [SMGlobalClass sharedInstance].filteredArrayForBottomBar = [[NSMutableArray alloc] initWithArray:[[SMGlobalClass sharedInstance].arrayOfModules filteredArrayUsingPredicate:predicate1]];
            
    
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"isQuickLink == %d",false];
            [SMGlobalClass sharedInstance].filteredArrayForDashBoard = [[NSMutableArray alloc] initWithArray:[[SMGlobalClass sharedInstance].arrayOfModules filteredArrayUsingPredicate:predicate2]];
            
            if([[NSUserDefaults standardUserDefaults]objectForKey:@"Member_ID"]>0)
            {

                
                [self.authenticateDelegate authenticationSucceeded];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ReloadData" object:nil];
                
            }
                
        [prefs synchronize];
                
        }
        else
        {
            [self.authenticateDelegate authenticationPartiallyFailed];
            
        }
         
            // oneSignal Setup
            
            id oneSignal = [(SMAppDelegate *)[[UIApplication sharedApplication] delegate] oneSignal];
            
                        [oneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
                NSLog(@"UserId:%@", userId);
                [self webserviceForSavingDeviceCodeFromOneSignalWithDeviceCode:userId];
            }];
            

                // Background imageUploading from database
            
            _reach = [Reachability reachabilityForInternetConnection]; //retain reach
            [_reach startNotifier];
            
            NetworkStatus remoteHostStatus = [_reach currentReachabilityStatus];
            
             if (remoteHostStatus == ReachableViaWiFi)
            {
                NSLog(@"int **** wifi ****");
                [self carryOutTheBackgroundUploadingofStoredImages];
            }
            else if (remoteHostStatus == ReachableViaWWAN) {NSLog(@"init **** cell ****"); }
            

    }
            
    }
    //////////////////////////Monami/////////////////////////////////////////////
    ///////////Get Failure message from login screen after authentication comes true
    else if([elementName isEqualToString:@"a:FailureReason"]){
        
        if(AuthenticatedValue != nil ){
        if(![currentNodeContent isEqualToString:@""]){
        [self.authenticateDelegate authenticationFailedDuetoServer:currentNodeContent];
        }
        }
    }
    //////////////////////////////END//////////////////////////////////////////////
    else
    {
        
        if ([elementName isEqualToString:@"Modules"])
        {
             moduleElementFound = FALSE;
        }
        if ([elementName isEqualToString:@"Impersonate"])
        {
            isImpersonateFound = NO;
        }
        if( [elementName isEqualToString:@"Page"])
        {
            if(!isSubModulePresent)
            {
                if(self.moduleObj!=nil)
                {
                    NSLog(@"pageName = %@",self.modulePageObj.moduleName);
                    
                    [self.moduleObj.arrayOfPages addObject:self.modulePageObj];
                }
                isPageFound = NO;
            }
            else
            {
                if(self.subModuleObj!=nil)
                {
                    NSLog(@"pageName = %@",self.modulePageObj.moduleName);
                    
                    [self.subModuleObj.arrayOfPages addObject:self.modulePageObj];
                }
                isPageFound = NO;
            }
        }
        if( [elementName isEqualToString:@"SubModule"])
        {
            [self.moduleObj.arrayOfPages addObject:self.subModuleObj];
            isSubModulePresent = NO;
        }
        if ([elementName isEqualToString:@"Module"])
        {
            
              [[SMGlobalClass sharedInstance].arrayOfModules addObject:self.moduleObj];
            
            NSLog(@"ModuleArray = %@",[SMGlobalClass sharedInstance].arrayOfModules);
            isModulePresent = NO;
            
        }
        if([elementName isEqualToString:@"NotificationIdentifier"])
        {
            [SMGlobalClass sharedInstance].strPushNotificationUserID = currentNodeContent;
            NSLog(@"strPushNotificationUserID = %@",[SMGlobalClass sharedInstance].strPushNotificationUserID);
            getThePushNotificationResponseCallBack([SMGlobalClass sharedInstance].strPushNotificationUserID);
        }
        if([elementName isEqualToString:@"MemberImages"])
        {
            isMemberImages = NO;
        }
        if([elementName isEqualToString:@"ClientImage"])
        {
            isIndividualClientImage = NO;
        }
        if([elementName isEqualToString:@"MemberImage"])
        {
            isIndividualMemberImage = NO;
        }

        if([elementName isEqualToString:@"ClientImages"])
        {
            isClientImages = NO;
        }
        
        if([elementName isEqualToString:@"MemberImage"])
        {
            
        currentNodeContent = [[currentNodeContent stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"] mutableCopy];
            
        [[SMGlobalClass sharedInstance].arrayOfMemberImages addObject:currentNodeContent];
        }
        
    }
    
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    prefs = [NSUserDefaults standardUserDefaults];
    
    [SMGlobalClass sharedInstance].strName =  [NSString stringWithFormat:@"%@ %@",[prefs valueForKey:@"Name"],[prefs valueForKey:@"Surname"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUD hide:YES];
    });
    
    
    
    /*
    
    for (ImageDetails *individualImageObj in [[SMDatabaseManager theSingleTon]fetchImageDetails]) {
        
        NSLog(@"ImagePaths = %@",individualImageObj.imagePath);
        NSLog(@"ImageClientID = %@",individualImageObj.clientID);
        
        
        NSMutableURLRequest *requestURL= [SMWebServices saveTheImagesToTheServerWithUserHashValue:[SMGlobalClass sharedInstance].hashValue andClientID:[individualImageObj.clientID intValue] andBlogPostID:[individualImageObj.vehicleStockID intValue] andUserID:[individualImageObj.memberID intValue] andPriority:[individualImageObj.imagePriority intValue] andOriginalFileName:individualImageObj.imageFileName andEncodedImage:base64Str];
        
        // NSURLSessionTask *backGroundImageUploadTask = [self.backGroundSession uploadTaskWithRequest:requestURL fromFile:]
    }
    
    /  NSString docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"foo.png"]];
    [data writeToFile:databasePath atomically:YES];
    */
    
    
    
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if (error) {
        NSLog(@"%@ failed: %@", task.originalRequest.URL, error);
    }
    
    NSLog(@"REquestURKL: %@", task.originalRequest.URL);
    
    
    NSLog(@"Response = %@",task.response);
    NSLog(@"currentRequest = %@",task.currentRequest);
    NSLog(@"originalRequest = %@",task.originalRequest);
    if(task.state == NSURLSessionTaskStateCompleted)
    {
        NSLog(@"Task Completed");
    }
    
   /* if (responseData) {
        // my response is JSON; I don't know what yours is, though this handles both
        
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        if (response) {
            NSLog(@"response = %@", response);
        } else {
            NSLog(@"responseData = %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
        }
        
        [self.responsesData removeObjectForKey:@(task.taskIdentifier)];
    } else {
        NSLog(@"responseData is nil");
    }*/
}


//loading an image

- (UIImage*)loadImage:(NSString*)imageName1 {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [UIImage imageWithContentsOfFile:fullPathOfImage];
    
}

- (NSString*)loadImagePath:(NSString*)imageName1 {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return fullPathOfImage;
    
}

-(void)carryOutTheBackgroundUploadingofStoredImages
{
    NSLog(@"LookItsFromLogin");
    //  BackgroundImage upload
    
    // create NSURLSession for uploading the stored images from the local database.
    
    NSURLSession *upLoadSession ; //= [NSURLSession sessionWithConfiguration:conf delegate:self delegateQueue:nil];
    
    // [[SMDatabaseManager theSingleTon] removeAllRecords];
    
    arrmStoredImages = [[SMDatabaseManager theSingleTon]fetchImageDetails];
    NSLog(@"ARRAYCNTT = %lu",(unsigned long)arrmStoredImages.count);
    for (int i = 0; i < [arrmStoredImages count]; i++)
    {
        NSLog(@"FORLOOP");
        ImageDetails *individualImageObj = (ImageDetails*)[arrmStoredImages objectAtIndex:i];
        
        UIImage *imageToUpload = [self loadImage:[NSString stringWithFormat:@"%@.jpg",individualImageObj.imageFileName]];
        NSData *imageDataForUpload  = UIImageJPEGRepresentation(imageToUpload,0.6); //convert image into .jpg format.
        
        NSString * base64Str = [[SMBase64ImageEncodingObject shareManager]encodeBase64WithData:imageDataForUpload];
        
        NSMutableURLRequest *requestURL;//Prepare upload request
        
        if([individualImageObj.moduleIdentifier isEqualToString:@"1"])
        {
            NSLog(@"BLOG MODULE UPLOAD");
            requestURL = [SMWebServices saveTheImagesToTheServerWithUserHashValue:[SMGlobalClass sharedInstance].hashValue andClientID:[individualImageObj.clientID intValue] andBlogPostID:[individualImageObj.vehicleStockID intValue] andUserID:[individualImageObj.memberID intValue] andPriority:[individualImageObj.imagePriority intValue] andOriginalFileName:[NSString stringWithFormat:@"%@.jpg",individualImageObj.imageFileName] andEncodedImage:base64Str];
        }
        else if([individualImageObj.moduleIdentifier isEqualToString:@"2"])
        {
            NSLog(@"VEHICLE MODULE UPLOAD");
            requestURL = [SMWebServices addImageToVehicleBase64ForUserHash:[SMGlobalClass sharedInstance].hashValue usedVehicleStockID:[individualImageObj.vehicleStockID intValue] imageBase64:base64Str imageName:[NSString stringWithFormat:@"%@.jpg",individualImageObj.imageFileName] imageTitle:[NSString stringWithFormat:@"%@",individualImageObj.imageFileName] imageSource:@"phone app" imagePriority:[individualImageObj.imagePriority intValue] imageIsEtched:NO imageIsBranded:NO imageAngle:@""];
        }
        
        if (i == 0) {
            
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
            config.HTTPMaximumConnectionsPerHost = 1;
            upLoadSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
            
        }
        NSURLSessionDataTask *uploadTask = [upLoadSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"Response = %@",response.description);
            NSLog(@"error = %@",error.description);
            if (!error) {
                NSLog(@"succeed");
                
                [[SMDatabaseManager theSingleTon] removeUploadedImageFromDatabase:individualImageObj.imageFileName];
                
            }
            
        }];
        
        [uploadTask resume];
        
    }

}


@end
