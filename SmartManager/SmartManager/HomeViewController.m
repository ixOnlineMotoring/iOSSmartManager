//
//  HomeViewController.m
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import "HomeViewController.h"
#import "ViewUtils.h"
#import "VideoViewController.h"
#import "SMGlobalClass.h"
#import "SMVideoInfoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface HomeViewController ()
{
    int currMinute;
    int currSeconds;

}
@property (strong, nonatomic) LLSimpleCamera *camera;
@property (strong, nonatomic) UILabel *errorLabel;
@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UILabel *timerLabel;
@property (strong, nonatomic) UILabel *timerAlertLabel;
@property (strong, nonatomic) UIButton *flashButton;
@property (strong, nonatomic) UISegmentedControl *segmentedControl;
@end

@implementation HomeViewController

void(^ getTheVideoResponseCallBack)(BOOL success, NSString *videoPath, UIImage *thumbnailImage,NSString *videoName, NSError *error);

@synthesize timer;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor blackColor];
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    // ----- initialize camera -------- //
    
    // create camera vc
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPreset640x480
                                                 position:CameraPositionBack
                                             videoEnabled:YES];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
    __weak typeof(self) weakSelf = self;
    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
        
        NSLog(@"Device changed.");
        
        // device changed, check if flash is available
        if([camera isFlashAvailable]) {
            weakSelf.flashButton.hidden = NO;
            
            if(camera.flash == CameraFlashOff) {
                weakSelf.flashButton.selected = NO;
            }
            else {
                weakSelf.flashButton.selected = YES;
            }
        }
        else {
            weakSelf.flashButton.hidden = YES;
        }
    }];
    
    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
        NSLog(@"Camera error: %@", error);
        
        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
                
                if(weakSelf.errorLabel) {
                    [weakSelf.errorLabel removeFromSuperview];
                }
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = @"We need permission for the camera.\nPlease go to your settings.";
                label.numberOfLines = 2;
                label.lineBreakMode = NSLineBreakByWordWrapping;
                label.backgroundColor = [UIColor clearColor];
                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
                label.textColor = [UIColor whiteColor];
                label.textAlignment = NSTextAlignmentCenter;
                [label sizeToFit];
                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
                weakSelf.errorLabel = label;
                [weakSelf.view addSubview:weakSelf.errorLabel];
            }
        }
    }];
    
    // ----- camera buttons -------- //
    
    // snap button to capture image
    self.snapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    self.snapButton.clipsToBounds = YES;
    self.snapButton.layer.cornerRadius = self.snapButton.width / 2.0f;
    self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.snapButton.layer.borderWidth = 2.0f;
    self.snapButton.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
    self.snapButton.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.snapButton.layer.shouldRasterize = YES;
    [self.snapButton addTarget:self action:@selector(snapButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapButton];
    
    // button to toggle flash
   /* self.flashButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.flashButton.frame = CGRectMake(0, 0, 16.0f + 20.0f, 24.0f + 20.0f);
    self.flashButton.tintColor = [UIColor whiteColor];
    [self.flashButton setImage:[UIImage imageNamed:@"camera-flash.png"] forState:UIControlStateNormal];
    self.flashButton.imageEdgeInsets = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
    [self.flashButton addTarget:self action:@selector(flashButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.flashButton];*/
    
    // button to toggle camera positions
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    self.timerLabel = [[UILabel alloc]initWithFrame:CGRectMake(200.0, 10.0, 110.0, 30.0)];
    self.timerLabel.backgroundColor = [UIColor darkGrayColor];
    self.timerLabel.textColor = [UIColor whiteColor];
    self.timerLabel.textAlignment = NSTextAlignmentCenter;
    self.timerLabel.layer.cornerRadius = 4.0;
    self.timerLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:13.0];
    [self.timerLabel setText:@"Time limit : 2:00"];
    [self.view addSubview:self.timerLabel];
    
       
    currMinute=2;
    currSeconds=00;
    
    
    
    /*self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Picture",@"Video"]];
    self.segmentedControl.frame = CGRectMake(12.0f, screenRect.size.height - 67.0f, 120.0f, 32.0f);
    self.segmentedControl.selectedSegmentIndex = 0;
    self.segmentedControl.tintColor = [UIColor whiteColor];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:self.segmentedControl];*/
}

-(void)startTimer
{
    self.timer=[NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)(1.0) target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
    blinkStatus = NO;
    
}
-(void)blink
{
    if(blinkStatus == NO)
    {
        self.timerLabel.backgroundColor = [UIColor redColor];
        blinkStatus = YES;
    }
    else
    {
        self.timerLabel.backgroundColor = [UIColor grayColor];
        blinkStatus = NO;
    }
}
-(void)timerFired
{
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [self.timerLabel setText:[NSString stringWithFormat:@"%@%d%@%02d",@"Time left : ",currMinute,@":",currSeconds]];
        if(currMinute ==0 && currSeconds == 00)
        {
            
            {
                self.flashButton.hidden = NO;
                
                self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
                self.snapButton.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
                
                [self.camera stopRecording:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error)
                 {
                     
                     
                     NSString* moviePath = [outputFileUrl path];
                     
                     if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath))
                     {
                         UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
                     }
                     
                     [self.timer invalidate];
                     self.timer = nil;
                     
                     NSString *videoTimeStamp=[self createIdFromCurrentDateTimestamp];
                     
                     filToBeuplaoded= [NSString stringWithFormat:@"%@-Video-Thumbnail",videoTimeStamp];
                     
                     
                     UIImage *videoThumImage=[[SMGlobalClass sharedInstance]generateVideoThumbnailImage:moviePath];
                     
                     [[SMGlobalClass sharedInstance]saveImage:videoThumImage imageName:filToBeuplaoded];
                     
                     getTheVideoResponseCallBack(YES,moviePath,videoThumImage,filToBeuplaoded,nil);
                     
                     SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
                     videoInfoVC.thumbNailImage = videoThumImage;
                     videoInfoVC.videoPathURL = moviePath;
                     videoInfoVC.isFromCameraView = YES;
                     videoInfoVC.isFromPhotosNExtrasDetailPage = self.isCameraViewFromPhotosNExtras;
                     videoInfoVC.isFromSendBrochureDetailPage = self.isCameraViewFromEBrochure;
                     videoInfoVC.isFromListPage = NO;
                     videoInfoVC.vehicleName = self.videoVehicleName;
                     [self.navigationController pushViewController:videoInfoVC animated:YES];
                     return ;
                     
                    // [self.navigationController popViewControllerAnimated:NO];
                     
                     
                 }];
            }
            //[self.navigationController popViewControllerAnimated:YES];
            
        }
        else if (currMinute ==0 && currSeconds <= 10)
        {
            [self blink];
        }
        
       
    }
    else
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

-(NSString*)createIdFromCurrentDateTimestamp
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmssSSS"];
    return [dateFormatter stringFromDate:[NSDate date]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
    [self.timerLabel setText:@"Time limit : 2:00"];
    currMinute=2;
    currSeconds=00;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
     [self.timer invalidate];
    self.timer = nil;
    // stop the camera
    [self.camera stop];
}

+(void)getTheGeneratedVideoWithCallBack:(SMCompetionBlockVideos)callBackVideos
{
    getTheVideoResponseCallBack = callBackVideos;

}

/* camera button methods */

- (void)switchButtonPressed:(UIButton *)button {
    [self.camera togglePosition];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
                                                   inDomains:NSUserDomainMask] lastObject];
}

- (void)flashButtonPressed:(UIButton *)button {
    
    if(self.camera.flash == CameraFlashOff) {
        BOOL done = [self.camera updateFlashMode:CameraFlashOn];
        if(done) {
            self.flashButton.selected = YES;
            self.flashButton.tintColor = [UIColor yellowColor];
        }
    }
    else {
        BOOL done = [self.camera updateFlashMode:CameraFlashOff];
        if(done) {
            self.flashButton.selected = NO;
            self.flashButton.tintColor = [UIColor whiteColor];
        }
    }
}

- (void)snapButtonPressed:(UIButton *)button
{
    
        if(!self.camera.isRecording)
        {
            self.segmentedControl.hidden = YES;
            self.flashButton.hidden = YES;
            
            self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
            self.snapButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
            
            // start recording
             NSString *videoTimeStamp=[self createIdFromCurrentDateTimestamp];
            NSURL *outputURL = [[[self applicationDocumentsDirectory]
                                 URLByAppendingPathComponent:videoTimeStamp] URLByAppendingPathExtension:@"mov"];
            [self startTimer];
           [self.camera startRecordingWithOutputUrl:outputURL];
        }
        else
        {
            self.flashButton.hidden = NO;
            
            self.snapButton.layer.borderColor = [UIColor whiteColor].CGColor;
            self.snapButton.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
            
            [self.camera stopRecording:^(LLSimpleCamera *camera, NSURL *outputFileUrl, NSError *error)
            {
                
                
               NSString* moviePath = [outputFileUrl path];
                
                ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
               
                
                if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:outputFileUrl])
                {
                    [library writeVideoAtPathToSavedPhotosAlbum:outputFileUrl
                     
                     
                        completionBlock:^(NSURL *assetURL, NSError *error)
                    {
                        
                    }
                     ];
                } 
               
                
                
                /*if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath))
                {
                    UISaveVideoAtPathToSavedPhotosAlbum (moviePath, nil, nil, nil);
                }*/
                
                [self.timer invalidate];
                
                //----- LIST ALL FILES -----
               /* NSArray *paths1 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                NSString *documentsDirectory1 = [paths1 objectAtIndex:0];
                NSString *documentFilePath1 = [documentsDirectory1 stringByAppendingPathComponent:@"/DocumentRecord"];
                
                NSString *pdfPath = [NSString stringWithFormat:@"%@/%@",documentFilePath1,pdfFileName];
                RSALog(@"filePath %@",pdfPath);*/
                
                
                NSString *videoTimeStamp=[self createIdFromCurrentDateTimestamp];
                
                filToBeuplaoded= [NSString stringWithFormat:@"%@-Video-Thumbnail",videoTimeStamp];
                
                
                UIImage *videoThumImage=[[SMGlobalClass sharedInstance]generateVideoThumbnailImage:moviePath];
                
                if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
                {
                     //videoThumImage = [self rotateUIImage:videoThumImage clockwise:NO];
                }
                
                [[SMGlobalClass sharedInstance]saveImage:videoThumImage imageName:filToBeuplaoded];
                
                 NSLog(@"self.videoVehicleName = %@",self.videoVehicleName);
                getTheVideoResponseCallBack(YES,moviePath,videoThumImage,filToBeuplaoded,nil);
                
                SMVideoInfoViewController *videoInfoVC = [[SMVideoInfoViewController alloc] initWithNibName:@"SMVideoInfoViewController" bundle:nil];
                videoInfoVC.thumbNailImage = videoThumImage;
                 videoInfoVC.videoPathURL = moviePath;
                 videoInfoVC.isFromCameraView = YES;
                videoInfoVC.isFromPhotosNExtrasDetailPage = self.isCameraViewFromPhotosNExtras;
                videoInfoVC.isFromSendBrochureDetailPage = self.isCameraViewFromEBrochure;
                videoInfoVC.isFromListPage = NO;
                videoInfoVC.vehicleName = self.videoVehicleName;
                [self.navigationController pushViewController:videoInfoVC animated:YES];

                
                //[self.navigationController popViewControllerAnimated:NO];
                
               // VideoViewController *vc = [[VideoViewController alloc] initWithVideoUrl:outputFileUrl];
                //[self.navigationController pushViewController:vc animated:YES];
            }];
        }
}

/*- (UIImageOrientation)getVideoOrientationFromAsset:(AVAsset *)asset
{
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = [videoTrack naturalSize];
    CGAffineTransform txf = [videoTrack preferredTransform];
    
    if (size.width == txf.tx && size.height == txf.ty)
        return UIImageOrientationLeft; //return UIInterfaceOrientationLandscapeLeft;
    else if (txf.tx == 0 && txf.ty == 0)
        return UIImageOrientationRight; //return UIInterfaceOrientationLandscapeRight;
    else if (txf.tx == 0 && txf.ty == size.width)
        return UIImageOrientationDown; //return UIInterfaceOrientationPortraitUpsideDown;
    else
        return UIImageOrientationUp;  //return UIInterfaceOrientationPortrait;
}


- (AVAssetExportSession*)applyCropToVideoWithAsset:(AVAsset*)asset AtRect:(CGRect)cropRect OnTimeRange:(CMTimeRange)cropTimeRange ExportToUrl:(NSURL*)outputUrl ExistingExportSession:(AVAssetExportSession*)exporter WithCompletion:(void(^)(BOOL success, NSError* error, NSURL* videoUrl))completion
{
    
    //    NSLog(@"CALLED");
    //create an avassetrack with our asset
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    //create a video composition and preset some settings
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    
    CGFloat cropOffX = cropRect.origin.x;
    CGFloat cropOffY = cropRect.origin.y;
    CGFloat cropWidth = cropRect.size.width;
    CGFloat cropHeight = cropRect.size.height;
    //    NSLog(@"width: %f - height: %f - x: %f - y: %f", cropWidth, cropHeight, cropOffX, cropOffY);
    
    videoComposition.renderSize = CGSizeMake(cropWidth, cropHeight);
    
    //create a video instruction
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = cropTimeRange;
    
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    
    UIImageOrientation videoOrientation = [self getVideoOrientationFromAsset:asset];
    
    CGAffineTransform t1 = CGAffineTransformIdentity;
    CGAffineTransform t2 = CGAffineTransformIdentity;
    
    switch (videoOrientation) {
        case UIImageOrientationUp:
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height - cropOffX, 0 - cropOffY );
            t2 = CGAffineTransformRotate(t1, M_PI_2 );
            break;
        case UIImageOrientationDown:
            t1 = CGAffineTransformMakeTranslation(0 - cropOffX, clipVideoTrack.naturalSize.width - cropOffY ); // not fixed width is the real height in upside down
            t2 = CGAffineTransformRotate(t1, - M_PI_2 );
            break;
        case UIImageOrientationRight:
            t1 = CGAffineTransformMakeTranslation(0 - cropOffX, 0 - cropOffY );
            t2 = CGAffineTransformRotate(t1, 0 );
            break;
        case UIImageOrientationLeft:
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.width - cropOffX, clipVideoTrack.naturalSize.height - cropOffY );
            t2 = CGAffineTransformRotate(t1, M_PI  );
            break;
        default:
            NSLog(@"no supported orientation has been found in this video");
            break;
    }
    
    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    
    //add the transformer layer instructions, then add to video composition
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    //Remove any prevouis videos at that path
    [[NSFileManager defaultManager]  removeItemAtURL:outputUrl error:nil];
    
    if (!exporter){
        exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality] ;
    }
    // assign all instruction for the video processing (in this case the transformation for cropping the video
    exporter.videoComposition = videoComposition;
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    if (outputUrl){
        exporter.outputURL = outputUrl;
        [exporter exportAsynchronouslyWithCompletionHandler:^{
            switch ([exporter status]) {
                case AVAssetExportSessionStatusFailed:
                    NSLog(@"crop Export failed: %@", [[exporter error] localizedDescription]);
                    if (completion){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(NO,[exporter error],nil);
                        });
                        return;
                    }
                    break;
                case AVAssetExportSessionStatusCancelled:
                    NSLog(@"crop Export canceled");
                    if (completion){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(NO,nil,nil);
                        });
                        return;
                    }
                    break;
                default:
                    break;
            }
            if (completion){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(YES,nil,outputUrl);
                });
            }
            
        }];
    }
    
    return exporter;
}

*/
- (UIImage*)rotateUIImage:(UIImage*)sourceImage clockwise:(BOOL)clockwise
{
    CGSize size = sourceImage.size;
    UIGraphicsBeginImageContext(CGSizeMake(size.height, size.width));
    [[UIImage imageWithCGImage:[sourceImage CGImage] scale:1.0 orientation:clockwise ? UIImageOrientationRight : UIImageOrientationLeft] drawInRect:CGRectMake(0,0,size.height ,size.width)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}


/* other lifecycle methods */
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.camera.view.frame = self.view.contentBounds;
    
    self.snapButton.center = self.view.contentCenter;
    self.snapButton.bottom = self.view.height - 15;
    
    self.flashButton.center = self.view.contentCenter;
    self.flashButton.top = 5.0f;
    
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
