//
//  SMForwardAppraisalViewController.m
//  Smart Manager
//
//  Created by Ketan Nandha on 31/05/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import "SMForwardAppraisalViewController.h"
#import "SMCustomTextField.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomColor.h"
#import "UIImageView+WebCache.h"
#import "FGalleryViewController.h"
#import "SMAppDelegate.h"

@interface SMForwardAppraisalViewController ()<FGalleryViewControllerDelegate>
{

    IBOutlet UIImageView *imgVehicleImage;

    IBOutlet UILabel *lblVehicleName;

    IBOutlet UILabel *lblVehicleDetails;

    IBOutlet UILabel *lblDate;

    IBOutlet UILabel *lblAppraiserName;
    
    IBOutlet SMCustomTextField *txtFieldEmailInput;
    
    IBOutlet SMCustomButtonBlue *btnSend;

    IBOutlet UITableView *tblViewForwardAppraisal;
    
    IBOutlet UIView *viewTableHeader;
    FGalleryViewController *networkGallery;
    
}

@end

@implementation SMForwardAppraisalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Forward Internal Appraisal"];
    [self addingProgressHUD];
    tblViewForwardAppraisal.tableHeaderView = viewTableHeader;
     tblViewForwardAppraisal.tableFooterView = [[UIView alloc]init];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSURL *url = [NSURL URLWithString:self.objSMSynopsisResult.strVariantImage];
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        
        UIImage *tmpImage = [[UIImage alloc] initWithData:data];
        
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            imgVehicleImage.image = tmpImage;
        });
    });
    
    
   [btnVehicleImage addTarget:self action:@selector(btnImageGalleryDidClicked) forControlEvents:UIControlEventTouchUpInside];
    [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear] andWithSecondText:self.objSMSynopsisResult.strFriendlyName forLabel: lblVehicleName];
    
    lblVehicleDetails.text = self.objSMSynopsisResult.strVariantDetails;
    
    
}

#pragma mark - FGalleryViewController Delegate Method
-(void)btnImageGalleryDidClicked{
    
    networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
    appdelegate.isPresented =  YES;
    [self.navigationController pushViewController:networkGallery animated:YES];
}

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    return 1;
    //    if(gallery == networkGallery)
    //    {
    //        int num;
    //
    //        num = (int)[arrayFullImages count];
    //
    //        return num;
    //    }
    //    else
    //        return 0;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    //    if( gallery == networkGallery )
    //    {
    //        caption = [networkCaptions objectAtIndex:index];
    //    }
    caption = self.objSMSynopsisResult.strVariantImage;
    return @"";
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    return self.objSMSynopsisResult.strVariantImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnSendDidClicked:(id)sender
{
    [self.view endEditing:YES];
    
    txtFieldEmailInput.text = [txtFieldEmailInput.text stringByReplacingOccurrencesOfString:@" " withString:@""];

        NSArray *arr = [txtFieldEmailInput.text componentsSeparatedByString:@";"];
    
        if(arr.count == 1 && [arr[0] containsString:@","])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:@"please separate email addresses with semi colon." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    
        for(int i=0; i<arr.count;i++)
        {
            if(![self isValidEmail:arr[i]])
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:[NSString stringWithFormat:@"Email address: %@ is incorrect",arr[i]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [alert show];
                return;
            }
        }
    if([txtFieldEmailInput.text length] >0)
    {
        [self webserviceCallForSendingEmailIDs:[arr componentsJoinedByString:@";"]];
    }
    else
    {
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:KLoaderTitle message:@"Please enter email address." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert2 show];
        return;
    
    }
    
}

-(BOOL)isValidEmail:(NSString*) emailID
{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExpred =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    BOOL myStringCheck = [regExpred evaluateWithObject:emailID];
    
    if(!myStringCheck)
    {
        return NO;
    }
    else
        return YES;

}

#pragma mark - Webservice integration

-(void) webserviceCallForSendingEmailIDs:(NSString*) emailIDs
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
     NSMutableURLRequest * requestURL = [SMWebServices sendForwardAppraisalEmailsWithUserHash:[SMGlobalClass sharedInstance].hashValue andAppraisalID:self.objSMSynopsisResult.appraisalID andEmailIDs:emailIDs andVin:self.objSMSynopsisResult.strVINNo];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            NSLog(@"error = %@",error.description);
                                            if (error!=nil)
                                            {
                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                    // Do something...
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        SMAlert(@"Error", error.localizedDescription);
                                                        [self hideProgressHUD];
                                                        return;
                                                    });
                                                });
                                                
                                            }
                                            else
                                            {
                                                xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}

#pragma mark - NSXMLParser Delegate Methods

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Message"])
   {
       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:currentNodeContent preferredStyle:UIAlertControllerStyleAlert];
       
       UIAlertAction* okButton = [UIAlertAction
                                  actionWithTitle:@"Ok"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction * action) {
                                      //Handle your yes please button action here
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }];
       
       [alertController addAction:okButton];
       [self presentViewController:alertController animated:YES completion:nil];
   }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Do stuff to UI
        [HUD hide:YES];
    });
    
}
#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.color = [UIColor blackColor];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}
-(void) hideProgressHUD
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
        });
    });
}



@end
