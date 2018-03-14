//
//  SMGlobalClass.m
//  SmartManager
//
//  Created by Liji Stephen on 08/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMGlobalClass.h"
#import "SMBase64ImageEncodingObject.h"
#import "ASIFormDataRequest.h"
@implementation SMGlobalClass
{
    BOOL isWifiAvailable;
}

@synthesize strClient,strIdentity,strMemberID,strName,strSurName,arrayOfImpersonateClients,strClientID,filteredArrayForDashBoard,filteredArrayForBottomBar,hashValue,receivedBlogPostID,arrayOfImagesToBeDeleted,strDefaultClientID,strCoreMemberID,indexpathForTaskDetails,strClientName,selectedTaskId,isTaskOverDue,isListModule,totalImageSelected,isFromCamera,photoExistingCount,Base64String_CustomerDLScan,googleLongitude,googleLatitude,imageThumbnailForVideo,wasSmallImageSelected,indexpathOfSmallPhoto,selectedRowForCustomPopup,isTheSortFirstAttemptForCustomPopup,strPushNotificationUserID,isBrochureFlag
,strGroupID,isFromEbrochure,isTapOnCancel;

static SMGlobalClass *sharedInstance;

-(id)init
{
    
    if (self = [super init])
    {
        self.arrayOfImagesToBeDeleted = [[NSMutableArray alloc]init];
        self.arrayOfVideosToBeDeleted = [[NSMutableArray alloc]init];
    }
    return self;
}

+(SMGlobalClass *)sharedInstance{
    
    @synchronized([SMGlobalClass class]){
        
        if (sharedInstance==nil) {
            sharedInstance=[[self alloc]init];
            
            [sharedInstance setUpRechability];
           
        }
        
        return sharedInstance;
    }
    
    return nil;
}



-(void)setUpRechability
{
    NSLog(@"SetupReachability called");
    isWifiAvailable = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:sharedInstance selector:@selector(handleNetworkChange:) name:kReachabilityChangedNotification object:nil];
    
    _reach = [Reachability reachabilityForInternetConnection];
   // [_reach startNotifier];
    
    NetworkStatus remoteHostStatus = [_reach currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        NSLog(@"no");
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {
        
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        NSLog(@"cell");
    }
    
}

- (void) handleNetworkChange:(NSNotification *)notice
{
    NSLog(@"handleNetworkChange called %@",[NSNotificationCenter defaultCenter].observationInfo);
    NetworkStatus remoteHostStatus = [_reach currentReachabilityStatus];
    
    if(remoteHostStatus == NotReachable)
    {
        NSLog(@"no");
        isWifiAvailable = NO;
    }
    else if(remoteHostStatus == ReachableViaWiFi)
    {
        NSLog(@"wifi");
        if(!isWifiAvailable) {
         [self carryOutTheBackgroundUploadingofStoredImages];
         [self carryOutTheBackgroundUploadingofStoredVideos];
         isWifiAvailable = YES;
        }
       
    }
    else if(remoteHostStatus == ReachableViaWWAN)
    {
        NSLog(@"cell");
        isWifiAvailable = NO;
    }
    
    
}


#pragma mark - Save and Fetch Images

- (void)saveImage:(UIImage*)image imageName:(NSString*)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(image,0.7); //convert image into .jpeg format.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName]];
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    NSLog(@"image saved");
}

- (void)saveImageWithoutExtension:(UIImage*)image imageName:(NSString*)imageName
{
    NSData *imageData = UIImageJPEGRepresentation(image,0.7); //convert image into .jpeg format.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]];
    [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    NSLog(@"image saved");
}

- (NSString*)getImageFromImageName:(NSString*)imageName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    return getImagePath;
}
-(UIImage *)generateVideoThumbnailImage:(NSString *)url
{
    NSLog(@"URL = %@",url);
    
    MPMoviePlayerController *mp = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:url]];
    mp.shouldAutoplay = NO;
    mp.initialPlaybackTime = 1.0;
    mp.currentPlaybackTime = 1.0;
    // get the thumbnail
    UIImage *FrameImage = [mp thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    //
    //    return thumbnail;
    
    
    //    NSURL *urlPath = [NSURL fileURLWithPath:url];
    //    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:urlPath options:nil];
    //    AVAssetImageGenerator *generateImg = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    //    NSError *error = NULL;
    //    CMTime time = CMTimeMake(1, 65);
    //    CGImageRef refImg = [generateImg copyCGImageAtTime:time actualTime:NULL error:&error];
    //    NSLog(@"error==%@, Refimage==%@", error, refImg);
    //
    //    UIImage *FrameImage = [self scaleAndRotateImage:[[UIImage alloc] initWithCGImage:refImg]];
    
    
    return FrameImage;
}


- (UIImage *)scaleAndRotateImage:(UIImage *)image  {
    
    CGImageRef imgRef = image.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    
    CGFloat boundHeight;
    
    boundHeight = bounds.size.height;
    bounds.size.height = bounds.size.width;
    bounds.size.width = boundHeight;
    transform = CGAffineTransformMakeScale(-1.0, 1.0);
    transform = CGAffineTransformRotate(transform, M_PI / 2.0); //use angle/360 *MPI
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imgRef);
    UIImage *imageCopy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCopy;
    
}
-(MPMoviePlayerViewController *)allocMoviePlayerView:(NSString *)moviePath;
{
    MPMoviePlayerViewController *moviePlayerView = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL fileURLWithPath:moviePath]];
    moviePlayerView.moviePlayer.controlStyle =  MPMovieControlStyleFullscreen;
    moviePlayerView.moviePlayer.shouldAutoplay=YES;
    [moviePlayerView.moviePlayer prepareToPlay];
    
    return moviePlayerView;
}

- (NSString *)saveVideo:(NSString *)videoURLs
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"ddHHmmssSSS"];
    
    NSString *dateString=[formatter stringFromDate:[NSDate date]];
    
    NSString *videoName =[NSString stringWithFormat:@"%@_asset",dateString];
    
    NSString *documentsDirectory;
    if (documentsDirectory == nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        documentsDirectory = [paths objectAtIndex:0];
    }
    
    NSData *videoData = [NSData dataWithContentsOfFile:videoURLs];
    NSString *fullPathOftheVideo = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.MOV", videoName]];
    BOOL success = [videoData writeToFile:fullPathOftheVideo atomically:NO];
    //    NSLog(@"Video upload %hhd",success);
    videoData = nil;
    
    
    return fullPathOftheVideo;
}

#pragma mark background Image uploading 

//loading an image

- (UIImage*)loadImage:(NSString*)imageName1 {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [UIImage imageWithContentsOfFile:fullPathOfImage];
    
}

-(void)carryOutTheBackgroundUploadingofStoredVideos{
    self.videosTotalCount = 0;
    NSLog(@"LookItsFromGlobalClass");
    
    NSString *urlString = [SMWebServices uploadVideosWebserviceUrl];
    
    // this stuff is for adding the new videos to the server
    
    NSArray  *arrmStoredVideos = [[SMDatabaseManager theSingleTon] fetchVideoDetails];
    NSLog(@"ARRAYCNTT = %lu",(unsigned long)arrmStoredVideos.count);
    self.videosTotalCount = (int) arrmStoredVideos.count;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
    int i =0;
    for (VideoDetail *objVideo in arrmStoredVideos)
    {
        NSLog(@"FORLOOP");
        //VideoDetail *objVideo = (VideoDetail *)[arrmStoredVideos objectAtIndex:i];
        NSLog(@"objVideo.videoFullPath = %@",objVideo.videoFullPath);
        NSString *isSearchable;
        
        if([objVideo.searchable isEqualToString:@"true"])
            isSearchable = @"true";
        else
            isSearchable = @"false";
        
        
            NSString *fileNameString = [objVideo.videoFullPath lastPathComponent];
            
        
            ASIFormDataRequest *request =[ASIFormDataRequest requestWithURL:[NSURL URLWithString: urlString]];
            [request setTimeOutSeconds:100];
            
            [request setDelegate:self];
            [request setDidFailSelector:@selector(uploadFailed:)];
            [request setDidFinishSelector:@selector(uploadFinished:)];
        
        
            if (objVideo.variantId != nil) {
                [request addRequestHeader:@"userHash" value:[SMGlobalClass sharedInstance].hashValue];
                [request addRequestHeader:@"Client" value:[SMGlobalClass sharedInstance].strClientID];
                [request addRequestHeader:@"usedVehicleStockID" value:objVideo.variantId];
                [request addRequestHeader:@"fileName" value:fileNameString];
                [request addRequestHeader:@"title" value:objVideo.videoTitle];
                [request addRequestHeader:@"description" value:objVideo.videoDescription];
                [request addRequestHeader:@"tags" value:objVideo.videoTags];
                [request addRequestHeader:@"searchable" value:isSearchable];
                [request addRequestHeader:@"filepathForiOSApp" value:objVideo.videoFullPath];
                [request addRequestHeader:@"videoCount" value:[NSString stringWithFormat:@"%d",i]];
                i++;
                [request setFile:[[NSURL URLWithString:objVideo.videoFullPath] path] forKey:@"uploadfile"]; // this is POSIX path
                [request setPostFormat:ASIMultipartFormDataPostFormat];
                [request setRequestMethod:@"POST"];
                 NSLog(@"%@",request);
                [request startSynchronous];
                

            }
        }
    });
}

- (void)uploadFailed:(ASIHTTPRequest *)theRequest
{
    NSError *error = [theRequest error];
    NSString *errorString = [error localizedDescription];
    NSLog(@"/*/Failed to get data : %@",errorString);
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    
    NSString *count = theRequest.requestHeaders[@"videoCount"];
    
    if ((self.videosTotalCount-1) == count.intValue) {
        NSArray * arrmStoredVideos = [[SMDatabaseManager theSingleTon]fetchVideoDetails];
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        if ((self.videosTotalCount - arrmStoredVideos.count) == 1) {
            localNotification.alertBody = [NSString stringWithFormat: @"%lu Video uploaded successfully",self.videosTotalCount - arrmStoredVideos.count];
        }else{
            localNotification.alertBody = [NSString stringWithFormat: @"%lu Videos uploaded successfully",self.videosTotalCount - arrmStoredVideos.count];
        }
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"%lu Videos uploaded successfully",self.videosTotalCount - arrmStoredVideos.count);
    }    
}

- (void)uploadFinished:(ASIHTTPRequest *)theRequest
{
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    NSString *response = [theRequest responseString];
    NSLog(@"/*/Response received : %@",response);
    
    NSRange range = [response rangeOfString:@"<Errors>"];
    
    if (range.location == NSNotFound)
    {
        NSLog(@"Authenticated!");// if <error> not found, record is present
        [[SMDatabaseManager theSingleTon] removeUploadedVideoFromDatabase:theRequest.requestHeaders[@"filepathForiOSApp"]];
    }
    else
    {
        if ([response containsString:@"Duplicate video detected"]) {
            [[SMDatabaseManager theSingleTon] removeUploadedVideoFromDatabase:theRequest.requestHeaders[@"filepathForiOSApp"]];
        }
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
    }
    
    NSString *count = theRequest.requestHeaders[@"videoCount"];
    
    if ((self.videosTotalCount-1) == count.intValue) {
        NSArray * arrmStoredVideos = [[SMDatabaseManager theSingleTon]fetchVideoDetails];
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        UILocalNotification* localNotification = [[UILocalNotification alloc] init];
        localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        if ((self.videosTotalCount - arrmStoredVideos.count) == 1) {
            localNotification.alertBody = [NSString stringWithFormat: @"%lu Video uploaded successfully",self.videosTotalCount - arrmStoredVideos.count];
            
        }else{
            localNotification.alertBody = [NSString stringWithFormat: @"%lu Videos uploaded successfully",self.videosTotalCount - arrmStoredVideos.count];
        }
        localNotification.timeZone = [NSTimeZone defaultTimeZone];
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        NSLog(@"%lu Videos uploaded successfully",self.videosTotalCount - arrmStoredVideos.count);
    }
    
    // uploadingHUD.progress = 0.0;
}

-(void)carryOutTheBackgroundUploadingofStoredImages
{
     NSLog(@"LookItsFromGlobalClass");
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
            requestURL = [SMWebServices saveTheImagesToTheServerWithUserHashValue:[SMGlobalClass sharedInstance].hashValue andClientID:[individualImageObj.clientID intValue] andBlogPostID:[individualImageObj.vehicleStockID intValue] andUserID:[individualImageObj.memberID intValue] andPriority:[individualImageObj.imagePriority intValue] andOriginalFileName:[NSString stringWithFormat:@"%@.jpg",individualImageObj.imageFileName] andEncodedImage:base64Str];
            
            
            
        }
        else if([individualImageObj.moduleIdentifier isEqualToString:@"2"])
        {
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
                if ((i+1) == [arrmStoredImages count]) {
                    NSArray *arrUpdatedStoredImage = [[SMDatabaseManager theSingleTon] fetchImageDetails];
                    
                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
                    if (([arrmStoredImages count] - arrUpdatedStoredImage.count) == 1) {
                        localNotification.alertBody = [NSString stringWithFormat: @"%lu Image uploaded successfully",[arrmStoredImages count] - arrUpdatedStoredImage.count];
                        
                    }else{
                        localNotification.alertBody = [NSString stringWithFormat: @"%lu Images uploaded successfully",[arrmStoredImages count] - arrUpdatedStoredImage.count];
                    }
                    localNotification.timeZone = [NSTimeZone defaultTimeZone];
                    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
                    NSLog(@"%lu Videos uploaded successfully",[arrmStoredImages count] - arrUpdatedStoredImage.count);
                }
            }
            
        }];
        
        [uploadTask resume];
        
    }
    
}



@end
