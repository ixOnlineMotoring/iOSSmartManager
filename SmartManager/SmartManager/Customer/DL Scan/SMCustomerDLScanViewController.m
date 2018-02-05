//
//  SMCustomerDLScanViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 04/05/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//


#import "SMCustomerDLScanViewController.h"
#import "SMDecoderResultObject.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>


#import <pdf417/PPBarcode.h>
#import "PPYBarcodeOverlayViewController.h"
#import "PPCameraOverlayViewController.h"
#import "SMBase64ImageEncodingObject.h"
#import "SMGlobalClass.h"
#import "SMCustomerScanDetailViewController.h"
#import "Constant.h"
#import "SMConstants.h"

#import "SMCustomColor.h"
#define USE_MWOVERLAY true

#include <mach/mach_host.h>
//#import "mainScreen.h"
#import "BarcodeScanner.h"

#if USE_MWOVERLAY
#import "MWOverlay.h"
#endif
#import "MWResult.h"
#define PDF_OPTIMIZED true

#define USE_TOUCH_TO_ZOOM false

#define MAX_THREADS 2

// !!! Rects are in format: x, y, width, height !!!
#define RECT_LANDSCAPE_1D       4, 20, 92, 60
#define RECT_LANDSCAPE_2D       20, 5, 60, 90
#define RECT_PORTRAIT_1D        20, 4, 60, 92
#define RECT_PORTRAIT_2D        20, 5, 60, 90
#define RECT_FULL_1D            4, 4, 92, 92
#define RECT_FULL_2D            20, 5, 60, 90
#define RECT_DOTCODE            30, 20, 40, 60


static NSString *DecoderDLResultNotification = @"DecoderResultNotification";

@interface SMCustomerDLScanViewController ()<UIAlertViewDelegate, PPBarcodeDelegate>
{
    AVCaptureSession            *_captureSession;
    AVCaptureDevice             *_device;
    AVCaptureVideoPreviewLayer  *_prevLayer;
    bool                          running;
    NSString                    * lastFormat;
    
    MainScreenStateDL                 state;
    
    CGImageRef                      decodeImage;
    NSString                    *	decodeResult;
    int                             width;
    int                             height;
    int                             bytesPerRow;
    unsigned char               *   baseAddress;
    NSTimer                     *   focusTimer;
    
    
    int param_ZoomLevel1;
    int param_ZoomLevel2;
    int zoomLevel;
    bool videoZoomSupported;
    float firstZoom;
    float secondZoom;
    
    int activeThreads;
    int availableThreads;
    
    
    
}

- (void)presentCameraViewController:(UIViewController*)cameraViewController isModal:(BOOL)isModal;

- (void)dismissCameraViewControllerModal:(BOOL)isModal;

- (NSString*)barcodeDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData;

- (NSString*)simplifiedDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData;

- (PPBarcodeCoordinator*)createBarcodeCoordinator;


@property (nonatomic, assign) BOOL useModalCameraView;

@property (nonatomic, assign) UIViewController<PPScanningViewController>* currentCameraViewController;



@end

@implementation SMCustomerDLScanViewController

@synthesize captureSession = _captureSession;
@synthesize prevLayer = _prevLayer;
@synthesize device = _device;
@synthesize state;
@synthesize focusTimer;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.isComingFromStockAudit)
    {
        [self setTheDirections];
    }
    
    
    [self.scanView.layer setFrame:[UIScreen mainScreen].bounds];
    [self.scanView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.scanView];
    
    appDelegate = (SMAppDelegate *)[UIApplication sharedApplication].delegate;
    

    
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"On iOS simulator camera is not Supported");
#else
    [self initCapture];
#endif
    [self startScanning];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.focusTimer = nil;
    availableThreads = 0;
    [self stopScanning];
    [locationManager stopUpdatingLocation];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DecoderDLResultNotification object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   backGroundQueue = dispatch_queue_create("FetchingCurrentLocationInTheBackground", NULL);
    
     self.prevLayer = nil;
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(decodeResultNotification:) name:DecoderDLResultNotification object: nil];

    param_ZoomLevel1 = 0; //set automatic
    param_ZoomLevel2 = 0; //set automatic
    zoomLevel = 0;
    
    [self initDecoder];
    
    
}


// IOS 7 statusbar hide
- (BOOL)prefersStatusBarHidden
{
    return YES;
}


#pragma mark -
#pragma mark Initialization
- (void)initDecoder
{
    //register your copy of library with givern user/password
    MWB_registerCode(MWB_CODE_MASK_39,      "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_93,      "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_25,      "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_128,     "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_AZTEC,   "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_DM,      "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_EANUPC,  "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_QR,      "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_PDF,     "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_RSS,     "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_CODABAR, "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_DOTCODE, "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_11,      "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    MWB_registerCode(MWB_CODE_MASK_MSI,     "iXOM.PDF.iOS.UDL", "28E0A40AF76B823956471E39D8E54FC55CC578F11D956C2847C26D040367AD2E");
    
    // choose code type or types you want to search for
    
    if (PDF_OPTIMIZED){
        MWB_setActiveCodes(MWB_CODE_MASK_PDF);
        MWB_setDirection(MWB_SCANDIRECTION_HORIZONTAL);
        MWB_setScanningRect(MWB_CODE_MASK_PDF,    RECT_LANDSCAPE_1D);
    } else {
        // Our sample app is configured by default to search all supported barcodes...
        MWB_setActiveCodes(MWB_CODE_MASK_25     |
                           MWB_CODE_MASK_39     |
                           MWB_CODE_MASK_93     |
                           MWB_CODE_MASK_128    |
                           MWB_CODE_MASK_AZTEC  |
                           MWB_CODE_MASK_DM     |
                           MWB_CODE_MASK_EANUPC |
                           MWB_CODE_MASK_PDF    |
                           MWB_CODE_MASK_QR     |
                           MWB_CODE_MASK_CODABAR|
                           MWB_CODE_MASK_RSS);
        
        // Our sample app is configured by default to search both directions...
        MWB_setDirection(MWB_SCANDIRECTION_HORIZONTAL | MWB_SCANDIRECTION_VERTICAL);
        // set the scanning rectangle based on scan direction(format in pct: x, y, width, height)
        MWB_setScanningRect(MWB_CODE_MASK_25,     RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_39,     RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_93,     RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_128,    RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_AZTEC,  RECT_FULL_2D);
        MWB_setScanningRect(MWB_CODE_MASK_DM,     RECT_FULL_2D);
        MWB_setScanningRect(MWB_CODE_MASK_EANUPC, RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_PDF,    RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_QR,     RECT_FULL_2D);
        MWB_setScanningRect(MWB_CODE_MASK_RSS,    RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_CODABAR,RECT_FULL_1D);
        MWB_setScanningRect(MWB_CODE_MASK_DOTCODE,RECT_DOTCODE);
    }
    
    
    // But for better performance, only activate the symbologies your application requires...
    // MWB_setActiveCodes( MWB_CODE_MASK_25 );
    // MWB_setActiveCodes( MWB_CODE_MASK_39 );
    // MWB_setActiveCodes( MWB_CODE_MASK_93 );
    // MWB_setActiveCodes( MWB_CODE_MASK_128 );
    // MWB_setActiveCodes( MWB_CODE_MASK_AZTEC );
    // MWB_setActiveCodes( MWB_CODE_MASK_DM );
    // MWB_setActiveCodes( MWB_CODE_MASK_EANUPC );
    // MWB_setActiveCodes( MWB_CODE_MASK_PDF );
    // MWB_setActiveCodes( MWB_CODE_MASK_QR );
    // MWB_setActiveCodes( MWB_CODE_MASK_RSS );
    // MWB_setActiveCodes( MWB_CODE_MASK_CODABAR );
    // MWB_setActiveCodes( MWB_CODE_MASK_DOTCODE );
    
    
    // But for better performance, set like this for PORTRAIT scanning...
    // MWB_setDirection(MWB_SCANDIRECTION_VERTICAL);
    // set the scanning rectangle based on scan direction(format in pct: x, y, width, height)
    // MWB_setScanningRect(MWB_CODE_MASK_25,     RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_39,     RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_93,     RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_128,    RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_AZTEC,  RECT_PORTRAIT_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_DM,     RECT_PORTRAIT_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_EANUPC, RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_PDF,    RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_QR,     RECT_PORTRAIT_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_RSS,    RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_CODABAR,RECT_PORTRAIT_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_DOTCODE,RECT_DOTCODE);
    
    // or like this for LANDSCAPE scanning - Preferred for dense or wide codes...
    // MWB_setDirection(MWB_SCANDIRECTION_HORIZONTAL);
    // set the scanning rectangle based on scan direction(format in pct: x, y, width, height)
    // MWB_setScanningRect(MWB_CODE_MASK_25,     RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_39,     RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_93,     RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_128,    RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_AZTEC,  RECT_LANDSCAPE_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_DM,     RECT_LANDSCAPE_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_EANUPC, RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_PDF,    RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_QR,     RECT_LANDSCAPE_2D);
    // MWB_setScanningRect(MWB_CODE_MASK_RSS,    RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_CODABAR,RECT_LANDSCAPE_1D);
    // MWB_setScanningRect(MWB_CODE_MASK_DOTCODE,RECT_DOTCODE);
    
    
    // set decoder effort level (1 - 5)
    // for live scanning scenarios, a setting between 1 to 3 will suffice
    // levels 4 and 5 are typically reserved for batch scanning
    MWB_setLevel(3);
    
    
    //Set minimum result length for low-protected barcode types
    MWB_setMinLength(MWB_CODE_MASK_25, 5);
    MWB_setMinLength(MWB_CODE_MASK_MSI, 5);
    MWB_setMinLength(MWB_CODE_MASK_39, 5);
    MWB_setMinLength(MWB_CODE_MASK_CODABAR, 5);
    MWB_setMinLength(MWB_CODE_MASK_11, 5);
    
    
    
    //Use MWResult class instead of barcode raw byte array as result
    MWB_setResultType(MWB_RESULT_TYPE_MW);
    
    
    
    //get and print Library version
   // int ver = MWB_getLibVersion();
   // int v1 = (ver >> 16);
   // int v2 = (ver >> 8) & 0xff;
   // int v3 = (ver & 0xff);
   // NSString *libVersion = [NSString stringWithFormat:@"%d.%d.%d", v1, v2, v3];
    //NSLog(@"Lib version: %@", libVersion);
    
    
}

-(void) reFocus {
    ////NSLog(@"refocus");
    
    NSError *error;
    if ([self.device lockForConfiguration:&error])
    {
        
        if ([self.device isFocusPointOfInterestSupported])
        {
            [self.device setFocusPointOfInterest:CGPointMake(0.49,0.49)];
            [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        [self.device unlockForConfiguration];
        
    }
}

- (void)toggleTorch
{
    if ([self.device isTorchModeSupported:AVCaptureTorchModeOn]) {
        NSError *error;
        
        if ([self.device lockForConfiguration:&error]) {
            if ([self.device torchMode] == AVCaptureTorchModeOn)
                [self.device setTorchMode:AVCaptureTorchModeOff];
            else
                [self.device setTorchMode:AVCaptureTorchModeOn];
            
            if([self.device isFocusModeSupported: AVCaptureFocusModeContinuousAutoFocus])
                self.device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
            
            [self.device unlockForConfiguration];
        } else {
            
        }
    }
}


- (void)initCapture
{
    /*We setup the input*/
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    
    if (captureInput == nil){
        NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
        [[[UIAlertView alloc] initWithTitle:@"Camera Unavailable" message:[NSString stringWithFormat:@"The %@ has not been given a permission to your camera. Please check the Privacy Settings: Settings -> %@ -> Privacy -> Camera", appName, appName] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        
        return;
    }
    
    
    /*We setupt the output*/
    AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    captureOutput.alwaysDiscardsLateVideoFrames = YES;
    //captureOutput.minFrameDuration = CMTimeMake(1, 10); Uncomment it to specify a minimum duration for each video frame
    [captureOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    // Set the video output to store frame in BGRA (It is supposed to be faster)
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    // Set the video output to store frame in 422YpCbCr8(It is supposed to be faster)
    
    //************************Note this line
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange];
    
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [captureOutput setVideoSettings:videoSettings];
    
    //And we create a capture session
    self.captureSession = [[AVCaptureSession alloc] init];
    //We add input and output
    [self.captureSession addInput:captureInput];
    [self.captureSession addOutput:captureOutput];
    
    
    
    if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720])
    {
        NSLog(@"Set preview port to 1280X720");
        self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    } else
        //set to 640x480 if 1280x720 not supported on device
        if ([self.captureSession canSetSessionPreset:AVCaptureSessionPreset640x480])
        {
            NSLog(@"Set preview port to 640X480");
            self.captureSession.sessionPreset = AVCaptureSessionPreset640x480;
        }
    
    
    // Limit camera FPS to 15 for single core devices (iPhone 4 and older) so more CPU power is available for decoder
    host_basic_info_data_t hostInfo;
    mach_msg_type_number_t infoCount;
    infoCount = HOST_BASIC_INFO_COUNT;
    host_info( mach_host_self(), HOST_BASIC_INFO, (host_info_t)&hostInfo, &infoCount ) ;
    
    if (hostInfo.max_cpus < 2){
        if ([self.device respondsToSelector:@selector(setActiveVideoMinFrameDuration:)]){
            [self.device lockForConfiguration:nil];
            [self.device setActiveVideoMinFrameDuration:CMTimeMake(1, 15)];
            [self.device unlockForConfiguration];
        } else {
            AVCaptureConnection *conn = [captureOutput connectionWithMediaType:AVMediaTypeVideo];
            [conn setVideoMinFrameDuration:CMTimeMake(1, 15)];
        }
        
    }
    
    NSLog(@"hostInfo.max_cpus %d",hostInfo.max_cpus);
    availableThreads = MIN(MAX_THREADS, hostInfo.max_cpus);
    activeThreads = 0;
    
    
    /*We add the preview layer*/
    
    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession: self.captureSession];
    
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        self.prevLayer.frame = CGRectMake(0, 60, MAX(self.view.frame.size.width,self.view.frame.size.height), MIN(self.view.frame.size.width,self.view.frame.size.height+5));
    }
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        self.prevLayer.frame = CGRectMake(0, 60, MAX(self.view.frame.size.width,self.view.frame.size.height), MIN(self.view.frame.size.width,self.view.frame.size.height+5));
    }
    
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        self.prevLayer.frame = CGRectMake(0, 60, MIN(self.view.frame.size.width,self.view.frame.size.height), MAX(self.view.frame.size.width,self.view.frame.size.height+5));
    }
    if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        self.prevLayer.frame = CGRectMake(0, 60, MIN(self.view.frame.size.width,self.view.frame.size.height), MAX(self.view.frame.size.width,self.view.frame.size.height+5));
    }
    
    
    self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.scanView.layer addSublayer: self.prevLayer];
#if USE_MWOVERLAY
    [MWOverlay addToPreviewLayer:self.prevLayer];
#endif

    
    videoZoomSupported = false;
    
    if ([self.device respondsToSelector:@selector(setActiveFormat:)] &&
        [self.device.activeFormat respondsToSelector:@selector(videoMaxZoomFactor)] &&
        [self.device respondsToSelector:@selector(setVideoZoomFactor:)]){
        
        float maxZoom = 0;
        if ([self.device.activeFormat respondsToSelector:@selector(videoZoomFactorUpscaleThreshold)]){
            maxZoom = self.device.activeFormat.videoZoomFactorUpscaleThreshold;
        } else {
            maxZoom = self.device.activeFormat.videoMaxZoomFactor;
        }
        
        float maxZoomTotal = self.device.activeFormat.videoMaxZoomFactor;
        
        if ([self.device respondsToSelector:@selector(setVideoZoomFactor:)] && maxZoomTotal > 1.1){
            videoZoomSupported = true;
            
            
            
            if (param_ZoomLevel1 != 0 && param_ZoomLevel2 != 0){
                
                if (param_ZoomLevel1 > maxZoomTotal * 100){
                    param_ZoomLevel1 = (int)(maxZoomTotal * 100);
                }
                if (param_ZoomLevel2 > maxZoomTotal * 100){
                    param_ZoomLevel2 = (int)(maxZoomTotal * 100);
                }
                
                firstZoom = 0.01 * param_ZoomLevel1;
                secondZoom = 0.01 * param_ZoomLevel2;
                
                
            } else {
                
                if (maxZoomTotal > 2){
                    
                    if (maxZoom > 1.0 && maxZoom <= 2.0){
                        firstZoom = maxZoom;
                        secondZoom = maxZoom * 2;
                    } else
                        if (maxZoom > 2.0){
                            firstZoom = 2.0;
                            secondZoom = 4.0;
                        }
                    
                }
            }
            
            
        } else {
            
        }
        
        
        
        
    }
    
    
    
    self.focusTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(reFocus) userInfo:nil repeats:YES];
}


- (void) onVideoStart: (NSNotification*) note
{
    if(running)
        return;
    running = YES;
    
    // lock device and set focus mode
    NSError *error = nil;
    if([self.device lockForConfiguration: &error])
    {
        if([self.device isFocusModeSupported: AVCaptureFocusModeContinuousAutoFocus])
            self.device.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    }
}

- (void) onVideoStop: (NSNotification*) note
{
    if(!running)
        return;
    [self.device unlockForConfiguration];
    running = NO;
}

#pragma mark - Getting Current Location


-(void)setTheDirections
{
    if(locationManager==nil)
    {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        locationManager.distanceFilter = 10;
    }
    
    
    locationManager.delegate = self;
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
    {
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        
        
        // If the status is denied or only granted for when in use, display an alert
        if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied )
        {
            NSString *title;
            title = (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined) ? @"Location services are off" : @"Background location is not enabled";
            NSString *message = @"You can enable access in Settings->Privacy->Location->Location Services";
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
        }
        // The user has not enabled any location services. Request background authorization.
        else if (status == kCLAuthorizationStatusNotDetermined)
        {
            [locationManager requestWhenInUseAuthorization];
        }
    }
    
    
    [locationManager startUpdatingLocation];
    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    
    locationManager.delegate = nil;
    [locationManager stopUpdatingLocation];
    _currentUserCoordinate = [newLocation coordinate];
    
    
    [SMGlobalClass sharedInstance].googleLatitude =  _currentUserCoordinate.latitude;
    [SMGlobalClass sharedInstance].googleLongitude = _currentUserCoordinate.longitude;
    
    dispatch_async(backGroundQueue, ^{
        
        NSData *datAddress=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyBIdVyndCKPLHyYHXxEq9lRR-zwtF9_JS0", _currentUserCoordinate.latitude, _currentUserCoordinate.longitude]]];
        
        // NSLog(@"datAddress=%@",[[NSString alloc]initWithData:datAddress encoding:NSUTF8StringEncoding]);
        
        NSDictionary *dictAddress;
        
        if([datAddress length] > 0)
        {
            dictAddress=[NSJSONSerialization JSONObjectWithData:datAddress options:NSJSONReadingMutableContainers error:NULL];
        }
        
        NSLog(@"formatted_address results %@",[[dictAddress objectForKey:@"results"]valueForKey:@"formatted_address"][0]);
        
        
        self.geoLocationString = [[dictAddress objectForKey:@"results"]valueForKey:@"formatted_address"][0];
    }) ;
    
    
}



-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location services disabled." message:@"Please enable the location services on your device." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];
    
    
}

- (void)reverseGeocodeLocation:(CLLocation *)location
{
    CLGeocoder* reverseGeocoder = [[CLGeocoder alloc] init];
    if (reverseGeocoder)
    {
        [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
         {
             CLPlacemark* placemark = [placemarks firstObject];
             if (placemark)
             {
                 NSMutableArray *addressStringArray =[[NSMutableArray alloc]init];
                 
                 self.geoLocationString = [[NSMutableString alloc]init];
                 
                 //Using blocks, get zip code
                 NSString *street = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressStreetKey];
                 NSString *state = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressStateKey];
                 NSString *city = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressCityKey];
                 NSString *country = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressCountryKey];
                 NSString *Zipcode = [placemark.addressDictionary objectForKey:(NSString*)kABPersonAddressZIPKey];
                 
                 NSLog(@"....street = %@",street);
                 NSLog(@"....city = %@",city);
                 NSLog(@"....state = %@",state);
                 NSLog(@".....country = %@",country);
                 NSLog(@"....zip = %@",Zipcode);
                 
                 
                 
                 NSLog(@"placemark.addressDictionary = %@",placemark.addressDictionary);
                 NSString *name = @"";
                 NSString *locality = @"";
                 NSString *administrativeArea = @"";
                 NSString *subAdministrativeArea = @"";
                 NSString *postalCode = @"";
                 NSString *ISOcountryCode = @"";
                 //  NSString *country = @"";
                 
                 
                 if (placemarks.count >= 1)
                 {
                     CLPlacemark * myPlacemark = [placemarks objectAtIndex:0];
                     
                     if ([[myPlacemark name] length] != 0)
                     {
                         name = [myPlacemark name];
                         [addressStringArray addObject:name];
                     }
                     NSLog(@"name : %@",name);
                     
                     
                     if ([[myPlacemark locality] length] != 0)
                     {
                         locality = [myPlacemark locality];
                         [addressStringArray addObject:locality];
                     }
                     NSLog(@"locality : %@",locality);
                     
                     if ([[myPlacemark administrativeArea] length] != 0)
                     {
                         administrativeArea = [myPlacemark administrativeArea];
                         [addressStringArray addObject:administrativeArea];
                     }
                     NSLog(@"administrativeArea : %@",administrativeArea);
                     
                     if ([[myPlacemark subAdministrativeArea] length] != 0)
                     {
                         subAdministrativeArea = [myPlacemark subAdministrativeArea];
                         [addressStringArray addObject:subAdministrativeArea];
                     }
                     NSLog(@"subAdministrativeArea : %@",subAdministrativeArea);
                     
                     if ([[myPlacemark ISOcountryCode] length] != 0)
                     {
                         ISOcountryCode = [myPlacemark ISOcountryCode];
                         [addressStringArray addObject:ISOcountryCode];
                     }
                     NSLog(@"ISOcountryCode : %@",ISOcountryCode);
                     
                     if ([[myPlacemark country] length] != 0)
                     {
                         country = [myPlacemark country];
                         [addressStringArray addObject:country];
                     }
                     NSLog(@"country : %@",country);
                     if ([[myPlacemark postalCode] length] != 0)
                     {
                         postalCode = [myPlacemark postalCode];
                         [addressStringArray addObject:postalCode];
                     }
                     NSLog(@"postalCode : %@",postalCode);
                 }
                 
                 self.geoLocationString = [addressStringArray componentsJoinedByString:@", "];
                 NSLog(@"addressString : %@",self.geoLocationString);
             }
             
             
         }];
    }
}


#pragma mark -
#pragma mark AVCaptureSession delegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    if (state != CAMERA_DL && state != CAMERA_DECODING_DL) {
        return;
    }
    
    if (activeThreads >= availableThreads){
        return;
    }
    
    if (self.state != CAMERA_DECODING_DL)
    {
        self.state = CAMERA_DECODING_DL;
    }
    
    activeThreads++;
    
    
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    //Lock the image buffer
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    //Get information about the image
    baseAddress = (uint8_t *)CVPixelBufferGetBaseAddressOfPlane(imageBuffer,0);
    int pixelFormat = CVPixelBufferGetPixelFormatType(imageBuffer);
    switch (pixelFormat) {
        case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
            //NSLog(@"Capture pixel format=NV12");
            bytesPerRow = (int) CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
            width = bytesPerRow;//CVPixelBufferGetWidthOfPlane(imageBuffer,0);
            height = (int) CVPixelBufferGetHeightOfPlane(imageBuffer,0);
            break;
        case kCVPixelFormatType_422YpCbCr8:
            //NSLog(@"Capture pixel format=UYUY422");
            bytesPerRow = (int) CVPixelBufferGetBytesPerRowOfPlane(imageBuffer,0);
            width = (int) CVPixelBufferGetWidth(imageBuffer);
            height = (int) CVPixelBufferGetHeight(imageBuffer);
            int len = width*height;
            int dstpos=1;
            for (int i=0;i<len;i++){
                baseAddress[i]=baseAddress[dstpos];
                dstpos+=2;
            }
            
            break;
        default:
            //	NSLog(@"Capture pixel format=RGB32");
            break;
    }
    
    
    unsigned char *frameBuffer = malloc(width * height);
    memcpy(frameBuffer, baseAddress, width * height);
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        
        
        unsigned char *pResult=NULL;
        
        int resLength = MWB_scanGrayscaleImage(frameBuffer,width,height, &pResult);
        
        
        free(frameBuffer);
        NSLog(@"Frame decoded. Active threads: %d", activeThreads);
        
        MWResults *mwResults = nil;
        MWResult *mwResult = nil;
        if (resLength > 0){
            
            if (self.state == NORMAL_DL){
                resLength = 0;
                free(pResult);
                
            } else {
                mwResults = [[MWResults alloc] initWithBuffer:pResult];
                if (mwResults && mwResults.count > 0){
                    mwResult = [mwResults resultAtIntex:0];
                }
                
                free(pResult);
            }
        }
        
        //CVPixelBufferUnlockBaseAddress(imageBuffer,0);
        
        //ignore results less than 4 characters - probably false detection
        if (mwResult)
        {
            NSLog(@"hererererer");
            
            self.state = NORMAL_DL;
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self.captureSession stopRunning];
#if USE_MWOVERLAY
                [MWOverlay showLocation:mwResult.locationPoints.points imageWidth:mwResult.imageWidth imageHeight:mwResult.imageHeight];
#endif
                NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
                SMDecoderResultObject *notificationResult = [SMDecoderResultObject createSuccess:mwResult];
                [center postNotificationName:DecoderDLResultNotification object: notificationResult];
            });
            
        }
        else
        {
            self.state = CAMERA_DL;
        }
        
        
        activeThreads --;
        
    });
}

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload
{
    [self stopScanning];
    
    self.prevLayer = nil;
    [super viewDidUnload];
}

- (void)dealloc {
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
    [SMDecoderResultObject shareCommonClassManager].result = nil;
}



- (void) startScanning
{
    self.state = LAUNCHING_CAMERA_DL;
    [self.captureSession startRunning];
    self.prevLayer.hidden = NO;
    self.state = CAMERA_DL;
}

- (void)stopScanning {
    [self.captureSession stopRunning];
    self.state = NORMAL_DL;
    self.prevLayer.hidden = YES;
    
    
}

- (void) deinitCapture
{
    if (self.focusTimer)
    {
        [self.focusTimer invalidate];
        //self.focusTimer = nil;
        
    }
    
    if (self.captureSession != nil)
    {
#if USE_MWOVERLAY
        [MWOverlay removeFromPreviewLayer];
#endif
        
#if !__has_feature(objc_arc)
        [self.captureSession release];
#endif
        self.captureSession=nil;
        
        [self.prevLayer removeFromSuperlayer];
        self.prevLayer = nil;
    }
}


- (void)decodeResultNotification: (NSNotification *)notification
{
    
    NSLog(@"NOTIFICATION FIRED");
    
    if ([notification.object isKindOfClass:[SMDecoderResultObject class]])
    {
        SMDecoderResultObject *obj = (SMDecoderResultObject*)notification.object;
        if (obj.succeeded)
        {
            NSString *typeName = obj.result.typeName;
            if (obj.result.isGS1){
                
                typeName = [NSString stringWithFormat:@"%@ (GS1)", typeName];
            }
            
            
            self.state = NORMAL_DL;
            [self.captureSession stopRunning];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            
            [self deinitCapture];
            self.prevLayer.hidden = YES;
            [_scanView removeFromSuperview];
            
            
            if(!self.isComingFromStockAudit && !self.isComingFromSynopsis)
            {
                
                NSLog(@"Result.Bytes = %@",obj.result.text);
                
                NSData *resultData = [NSData dataWithBytes:obj.result.bytes length:obj.result.bytesLength];
                
                
                NSString *base64Encoded = [resultData base64EncodedStringWithOptions:0];
                
                [SMGlobalClass sharedInstance].Base64String_CustomerDLScan = base64Encoded;
                
                NSLog(@"Base64Data = %@ ",[SMGlobalClass sharedInstance].Base64String_CustomerDLScan);
                
                if([[SMGlobalClass sharedInstance].Base64String_CustomerDLScan hasPrefix:@"AZs"])
                {
                    
                    [self.navigationController popViewControllerAnimated:NO];
                    [self.pushDetailsDelegate pushTheDetailScreenFromTheListingScreen];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"This is not a valid Drivers license barcode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alert.tag = 100;
                    [alert show];
                    
                }
                
                
            }
            else
            {
                decodeResult = [[NSString alloc] initWithString:obj.result.text];
                
                NSString* uiMessage = [NSString stringWithFormat:@"%@", decodeResult];
                
                
                NSArray *responseArray=[uiMessage componentsSeparatedByString:@"%"];
                NSLog(@"responseArray = %@",responseArray);
                
                if([responseArray count] >5)
                {
                                     
                    VINLookupObject=[[SMVINLookupObject alloc]init];
                    VINLookupObject.Entry0=[responseArray objectAtIndex:1];
                    VINLookupObject.Entry1=[responseArray objectAtIndex:2];
                    VINLookupObject.Entry2=[responseArray objectAtIndex:3];
                    VINLookupObject.Entry3=[responseArray objectAtIndex:4];
                    VINLookupObject.Entry4=[responseArray objectAtIndex:5];
                    VINLookupObject.Registration=[responseArray objectAtIndex:6];
                    VINLookupObject.Entry6=[responseArray objectAtIndex:7];
                    VINLookupObject.Shape=[responseArray objectAtIndex:8];
                    VINLookupObject.Make=[responseArray objectAtIndex:9];
                    VINLookupObject.Model=[responseArray objectAtIndex:10];
                    VINLookupObject.Colour=[responseArray objectAtIndex:11];
                    VINLookupObject.VIN=[responseArray objectAtIndex:12];
                    VINLookupObject.EngineNo=[responseArray objectAtIndex:13];
                    VINLookupObject.DateExpires=[responseArray objectAtIndex:14];
                    VINLookupObject.geoLocationAddress = self.geoLocationString;

                    NSLog(@"VINLookupObject.Entry0 = %@",VINLookupObject.VIN);
                   /* NSLog(@"VINLookupObject.Entry0 = %@",VINLookupObject.Entry1);
                    NSLog(@"VINLookupObject.Entry0 = %@",VINLookupObject.Entry2);
                    NSLog(@"VINLookupObject.Entry0 = %@",VINLookupObject.Entry3);
                    NSLog(@"VINLookupObject.Entry0 = %@",VINLookupObject.Entry4);
                    NSLog(@"VINLookupObject.Entry0 = %@",VINLookupObject.Entry6);*/
                    NSLog(@"Model = %@",VINLookupObject.Make);
                    NSLog(@"Model = %@",VINLookupObject.Model);

                    if([self.strFromViewController isEqualToString:@"SMSynopsisVINScanViewController"])
                    {
                       /* if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                        {
                            VINSynonpisDetailsView  =[[SMSynopsisScanDetailViewController alloc]initWithNibName:@"SMSynopsisScanDetailViewController" bundle:nil];
                        }
                        else
                        {
                             VINSynonpisDetailsView  =[[SMSynopsisScanDetailViewController alloc]initWithNibName:@"SMSynopsisScanDetailViewController_iPad" bundle:nil];
                        }*/
                        
                        
                        UIStoryboard *tableViewStoryboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
                        SMSynopsisScanDetailViewController   *VINSynonpisDetailsView1 = (SMSynopsisScanDetailViewController* )[tableViewStoryboard instantiateViewControllerWithIdentifier:@"SMSynopsisScanDetailsTableViewController"];
                        
                       // SMVINLookupObject *obj = (SMVINLookupObject*)[savedVINScanArray objectAtIndex:indexPath.row];
                        
                        VINSynonpisDetailsView1.VINLookupObject=VINLookupObject;
                        VINSynonpisDetailsView1.isFromScanPage = YES;
                        [appDelegate.gridNavigationController pushViewController:VINSynonpisDetailsView1 animated:YES];
                       // [self pushViewControllerAfterCertainTime];
                    }
                    else if([self.strFromViewController isEqualToString:@"SMSynopsisSummaryViewController"])
                    {
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"postNotificationForVINNumber" object:VINLookupObject.VIN
                         ];
                    }
                    else
                    {
                        VINLookUpDetailsView=[[SMStockAuditVinDetailsViewController alloc]initWithNibName:@"SMStockAuditVinDetailsViewController" bundle:nil];
                        VINLookUpDetailsView.VINLookupObject=VINLookupObject;
                        [self pushViewControllerAfterCertainTime];
                    }
                                       
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"This is not a valid VIN barcode" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alert.tag = 100;
                    [alert show];
                    
                }
                
                
            }
            
        }
    }
}


-(void)pushViewControllerAfterCertainTime
{
    NSLog(@" self.navigationController = %@",appDelegate.gridNavigationController);
    if(![self.strFromViewController isEqualToString:@"SMSynopsisVINScanViewController"])
    {
        [appDelegate.gridNavigationController pushViewController:VINLookUpDetailsView animated:YES];
    }
    else
    {
        NSLog(@"herererer....");
        [appDelegate.gridNavigationController pushViewController:VINSynonpisDetailsView animated:YES];
    }
    
}




-(void)pushViewControllerToLicenceDetailsScreen
{
    SMCustomerScanDetailViewController *customerDetails = [[SMCustomerScanDetailViewController alloc] initWithNibName:@"SMCustomerScanDetailViewController" bundle:nil];
    customerDetails.isFromDLListScreen = NO;
    [self.navigationController pushViewController:customerDetails animated:YES];

}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        [self startScanning];
    }
}

- (NSUInteger)supportedInterfaceOrientations
{
    
    
    UIInterfaceOrientation interfaceOrientation =[[UIApplication sharedApplication] statusBarOrientation];
    
    switch (interfaceOrientation)
    {
        case UIInterfaceOrientationPortrait:
            return UIInterfaceOrientationMaskPortrait;
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            return UIInterfaceOrientationMaskPortraitUpsideDown;
            break;
        case UIInterfaceOrientationLandscapeLeft:
            return UIInterfaceOrientationMaskLandscapeLeft;
            break;
        case UIInterfaceOrientationLandscapeRight:
            return UIInterfaceOrientationMaskLandscapeRight;
            break;
            
        default:
            break;
    }
    
    return UIInterfaceOrientationMaskAll;
    
}

- (BOOL) shouldAutorotate
{
    
    return YES;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
#if USE_TOUCH_TO_ZOOM
    [self doZoomToggle:nil];
#else
    [self toggleTorch];
#endif
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft){
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
        self.prevLayer.frame = CGRectMake(0, 0, MAX(self.view.frame.size.width,self.view.frame.size.height), MIN(self.view.frame.size.width,self.view.frame.size.height));
    }
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight){
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationLandscapeRight;
        self.prevLayer.frame = CGRectMake(0, 0, MAX(self.view.frame.size.width,self.view.frame.size.height), MIN(self.view.frame.size.width,self.view.frame.size.height));
    }
    
    
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationPortrait;
        self.prevLayer.frame = CGRectMake(0, 0, MIN(self.view.frame.size.width,self.view.frame.size.height), MAX(self.view.frame.size.width,self.view.frame.size.height));
    }
    if (toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        self.prevLayer.connection.videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
        self.prevLayer.frame = CGRectMake(0, 0, MIN(self.view.frame.size.width,self.view.frame.size.height), MAX(self.view.frame.size.width,self.view.frame.size.height));
    }
    
    [MWOverlay updateOverlay];
    
    
}

#pragma mark - camera delegate

/**
 * Method presents a modal view controller and uses non deprecated method in iOS 6
 */
- (void)presentCameraViewController:(UIViewController*)cameraViewController isModal:(BOOL)isModal {
    if (isModal) {
        cameraViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        cameraViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]) {
            [self presentViewController:cameraViewController animated:YES completion:nil];
        } else {
            [self presentViewController:cameraViewController animated:YES completion:nil];
        }
    } else {
        [[self navigationController] pushViewController:cameraViewController animated:YES];
    }
}

/**
 * Method dismisses a modal view controller and uses non deprecated method in iOS 6
 */
- (void)dismissCameraViewControllerModal:(BOOL)isModal
{
    if (isModal)
    {
        if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)])
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        else
        {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

#pragma mark -
#pragma mark PPBarcode delegate methods

- (void)cameraViewControllerWasClosed:(id<PPScanningViewController>)cameraViewController {
    [self setCurrentCameraViewController:nil];
    
    // this stops the scanning and dismisses the camera screen
    [self dismissCameraViewControllerModal:[self useModalCameraView]];
}

- (void)processScanningResult:(PPScanningResult*)result
         cameraViewController:(id<PPScanningViewController>)cameraViewController {
    
    // continue scanning if nothing was returned
    if (result == nil) {
        return;
    }
    
    // this pauses scanning without dismissing camera screen
    [cameraViewController pauseScanning];
    
    // obtain UTF8 string from barcode data
    NSString *message = [[NSString alloc] initWithData:[result data] encoding:NSUTF8StringEncoding];
    if (message == nil) {
        // if UTF8 wasn't correct encoding, try ASCII
        message = [[NSString alloc] initWithData:[result data] encoding:NSASCIIStringEncoding];
    }
    //NSLog(@"Barcode text:\n%@", message);
    
    NSString* type = [PPScanningResult toTypeName:[result type]];
    //NSLog(@"Barcode type:\n%@", type);
    
    // Check if barcode is uncertain
    // This is guaranteed not to happen if you didn't set kPPScanUncertainBarcodes key value
    BOOL isUncertain = [result isUncertain];
    if (isUncertain) {
        //NSLog(@"Uncertain scanning data!");
        type = [type stringByAppendingString:@" - uncertain"];
        
        // Perform some kind of integrity validation to see if the returned value is really complete
        BOOL valid = YES;
        if (!valid) {
            // this resumes scanning, and tries agian to find valid barcode
            [cameraViewController resumeScanning];
            return;
        }
    }
      
    if ([message characterAtIndex:0] != '%')
    {
        
        [[[UIAlertView alloc] initWithTitle:KLoaderTitle
                                    message:@"This is not valid barcode."
                                   delegate:self
                          cancelButtonTitle:@"Try again"
                          otherButtonTitles:nil]show];
        
    }
    else
    {
        
    }
    
}


- (void)processUSDLResult:(PPUSDLResult*)result
     cameraViewController:(id<PPScanningViewController>)cameraViewController {
    
}

- (UIImage*)drawResultLocations:(NSArray*)points onImage:(UIImage*)image {
    // begin a graphics context of sufficient size
    UIGraphicsBeginImageContext(image.size);
    
    // draw original image into the context
    [image drawAtPoint:CGPointZero];
    
    // get the context for CoreGraphics
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // set stroking color and draw circle
    [[UIColor greenColor] setStroke];
    
    // Set the width of the pen mark
    CGContextSetLineWidth(ctx, 3.0);
    
    [points enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGPoint point = [obj CGPointValue];
        
        // make circle rect 5 px from border
        CGRect circleRect = CGRectMake(point.x - 5, point.y - 5,
                                       11, 11);
        // draw circle
        CGContextStrokeEllipseInRect(ctx, circleRect);
    }];
    
    // make image out of bitmap context
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // free the context
    UIGraphicsEndImageContext();
    
    return retImage;
}

- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController
            didOutputResults:(NSArray *)results {
    NSMutableArray* locations = [[NSMutableArray alloc] init];
    
    [results enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[PPBaseResult class]]) {
            PPBaseResult* result = (PPBaseResult*)obj;
            if ([result resultType] == PPBaseResultTypeBarcode && [result isKindOfClass:[PPScanningResult class]]) {
                PPScanningResult* scanningResult = (PPScanningResult*)result;
                [self processScanningResult:scanningResult cameraViewController:cameraViewController];
            }
            
            if ([result resultType] == PPBaseResultTypeUSDL && [result isKindOfClass:[PPUSDLResult class]]) {
                PPUSDLResult* usdlResult = (PPUSDLResult*)result;
                [self processUSDLResult:usdlResult cameraViewController:cameraViewController];
            }
            
            [locations addObjectsFromArray:[result locationOnImage]];
        }
    }];
    
    
}

- (void)cameraViewController:(UIViewController<PPScanningViewController> *)cameraViewController didMakeSuccessfulScanOnImage:(UIImage *)image {
    //    [[self imageView] setImage:image];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(alertView.tag == 100)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Try again"])
    {
        [[self currentCameraViewController] resumeScanning];
    }
}

#pragma mark - Helper methods for barcode decoding

- (NSString*)barcodeDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData {
    // obtain barcode elements array
    NSArray* barcodeElements = [barcodeDetailedData barcodeElements];
    NSMutableString* barcodeDetailedDataString = [NSMutableString stringWithFormat:@"Total elements: %lu\n", (unsigned long)[barcodeElements count]];
    
    for (int i = 0; i < [barcodeElements count]; ++i) {
        
        // each element in barcodeElements array is of type PPBarcodeElement*
        PPBarcodeElement* barcodeElement = [[barcodeDetailedData barcodeElements] objectAtIndex:i];
        
        // you can determine element type with [barcodeElement elementType]
        [barcodeDetailedDataString appendFormat:@"Element #%d is of type %@\n", (i + 1), [barcodeElement elementType] == PPTextElement ? @"text" : @"byte"];
        
        // obtain raw bytes of the barcode element
        NSData* bytes = [barcodeElement elementBytes];
        [barcodeDetailedDataString appendFormat:@"Length=%lu {", (unsigned long)[bytes length]];
        
        const unsigned char* nBytes = [bytes bytes];
        for (int j = 0; j < [bytes length]; ++j) {
            // append each byte to raw result
            [barcodeDetailedDataString appendFormat:@"%d", nBytes[j]];
            
            // delimit bytes with comma
            if (j != [bytes length] - 1) {
                [barcodeDetailedDataString appendString:@", "];
            }
        }
        
        [barcodeDetailedDataString appendString:@"}\n"];
    }
    
    return barcodeDetailedDataString;
}

- (NSString*)simplifiedDetailedDataString:(PPBarcodeDetailedData*)barcodeDetailedData {
    
    NSMutableString* simplifiedRawInfo = [NSMutableString stringWithString:@"Raw data merged:\n{"];
    
    // if you don't like bothering with barcode elements
    // you can get all barcode bytes in one byte array with
    // getAllData method
    NSData* allData = [barcodeDetailedData getAllData];
    const unsigned char* allBytes = [allData bytes];
    
    for (int i = 0; i < [allData length]; ++i) {
        // append each byte to raw result
        [simplifiedRawInfo appendFormat:@"%d", allBytes[i]];
        
        // delimit bytes with comma
        if (i != [allData length] - 1) {
            [simplifiedRawInfo appendString:@", "];
        }
    }
    
    [simplifiedRawInfo appendString:@"}\n"];
    
    return simplifiedRawInfo;
}

- (IBAction)openImage:(id)sender
{
    //    PPImageViewController* imageVC = [[PPImageViewController alloc] initWithNibName:@"PPImageViewController" bundle:nil];
    //    [imageVC setImage:self.imageView.image];
    //    [[self navigationController] pushViewController:imageVC animated:YES];
}
#pragma mark Starting PhotoPay

- (PPBarcodeCoordinator*)createBarcodeCoordinator {
    // Check if barcode scanning is supported
    NSError *error;
    if ([PPBarcodeCoordinator isScanningUnsupported:&error]) {
        NSString *messageString = [error localizedDescription];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning"
                                                        message:messageString
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
        [alert show];
        return nil;
    }
    
    // Create object which stores pdf417 framework settings
    NSMutableDictionary* coordinatorSettings = [[NSMutableDictionary alloc] init];
    
    // Set YES/NO for scanning pdf417 barcode standard (default YES)
    [coordinatorSettings setValue:@(YES) forKey:kPPRecognizePdf417Key];
    // Set YES/NO for scanning qr code barcode standard (default NO)
    [coordinatorSettings setValue:@(YES) forKey:kPPRecognizeQrCodeKey];
    // Set YES/NO for scanning all 1D barcode standards (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognize1DBarcodesKey];
    // Set YES/NO for scanning code 128 barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeCode128Key];
    // Set YES/NO for scanning code 39 barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeCode39Key];
    // Set YES/NO for scanning EAN 8 barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeEAN8Key];
    // Set YES/NO for scanning EAN 13 barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeEAN13Key];
    // Set YES/NO for scanning ITF barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeITFKey];
    // Set YES/NO for scanning UPCA barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeUPCAKey];
    // Set YES/NO for scanning UPCE barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeUPCEKey];
    // Set YES/NO for scanning UPCA barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeUPCAKey];
    // Set YES/NO for scanning UPCE barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeUPCEKey];
    // Set YES/NO for scanning Aztec barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeAztecKey];
    // Set YES/NO for scanning DataMatrix barcode standard (default NO)
    [coordinatorSettings setValue:@(NO) forKey:kPPRecognizeDataMatrixKey];
    
    // There are 5 resolution modes:
    //      kPPUseVideoPreset640x480
    //      kPPUseVideoPresetMedium
    //      kPPUseVideoPresetHigh
    //      kPPUseVideoPresetHighest
    //      kPPUseVideoPresetPhoto
    // Set only one.
    [coordinatorSettings setValue:@(YES) forKey:kPPUseVideoPresetHigh];
    
    // Set this to true to scan even barcode not compliant with standards
    // For example, malformed PDF417 barcodes which were incorrectly encoded
    // Use only if necessary because it slows down the recognition process
    [coordinatorSettings setValue:@(YES) forKey:kPPScanUncertainBarcodes];
    
    // Use automatic scale detection feature. This normally should not be used.
    // The only situation where this helps in getting better scanning results is
    // when using kPPUseVideoPresetPhoto on iPad devices.
    // Video preview resoution of 2045x1536 in that case is very large and autoscale helps.
    [coordinatorSettings setValue:@(NO) forKey:kPPUseAutoscaleDetection];
    
    // Set this to true to scan barcodes which don't have quiet zone (white area) around it
    // Use only if necessary because it slows down the recognition process
    [coordinatorSettings setValue:@(YES) forKey:kPPAllowNullQuietZone];
    
    // Set this to true to allow scanning barcodes with inverted intensities (i.e. white barcodes on black background)
    // NOTE: this options doubles the frame processing time
    // [coordinatorSettings setValue:@(YES) forKey:kPPAllowInverseBarcodes];
    
    // Set this if you want to use front facing camera
    // [coordinatorSettings setValue:@(YES) forKey:kPPUseFrontFacingCamera];
    
    // if for some reason overlay should not autorotate
    // for example, if Navigation View controller on which Camera is presented handles rotation by itself
    // of when FormSheet or PageSheet modal view is used on iPads
    // then, disable rotation for overlays. Use this carefully.
    // Autorotation is YES by defalt
    [coordinatorSettings setValue:@(YES) forKey:kPPOverlayShouldAutorotate];
    
    
    
    
    
    // Set the scanning region, if necessary
    // If you use custom overlay view controller, it's reccommended that you set scanning roi there
    [coordinatorSettings setValue:[NSValue valueWithCGRect:CGRectMake(0.05, 0.05, 0.9, 0.9)] forKey:kPPScanningRoi];
    
    /**
     Set your license key here.
     This license key allows setting overlay views for this application ID: net.photopay.barcode.pdf417-sample
     To test your custom overlays, please use this demo app directly or visit our website www.pdf417.mobi for commercial license
     */
    [coordinatorSettings setValue:@"YW3B-R6SF-6NPE-TIZM-LKAT-WHIM-XMPN-FIXD"
                           forKey:kPPLicenseKey];
    
    /**
     If you use enterprise license, set the owner name of the licese.
     If you use regular per app license, leave this line commented.
     */
    // [coordinatorSettings setValue:@"Owner name" forKey:kPPLicenseOwner];
    
    // present modal (recommended and default) - make sure you dismiss the view controller when done
    // you also can set this to NO and push camera view controller to navigation view controller
    [coordinatorSettings setValue:@([self useModalCameraView]) forKey:kPPPresentModal];
    
    // Define the sound filename played on successful recognition
    NSString* soundPath = [[NSBundle mainBundle] pathForResource:@"beep" ofType:@"mp3"];
    [coordinatorSettings setValue:soundPath forKey:kPPSoundFile];
    
    // Allocate and the recognition coordinator object
    PPBarcodeCoordinator *coordinator = [[PPBarcodeCoordinator alloc] initWithSettings:coordinatorSettings];
    return coordinator;
}

-(IBAction)btnBackDidClicked:(id)sender
{
    [self.captureSession stopRunning];
    self.state = NORMAL_DL;
    self.prevLayer.hidden = YES;
    [self.scanView removeFromSuperview];
    //[self dismissViewControllerAnimated:NO completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)doZoomToggle:(id)sender {
    
    zoomLevel++;
    if (zoomLevel > 2){
        zoomLevel = 0;
    }
    
    [self updateDigitalZoom];
    
}

- (void) updateDigitalZoom {
    
    if (videoZoomSupported){
        
        [self.device lockForConfiguration:nil];
        
        switch (zoomLevel) {
            case 0:
                [self.device setVideoZoomFactor:1 /*rampToVideoZoomFactor:1 withRate:4*/];
                break;
            case 1:
                [self.device setVideoZoomFactor:firstZoom /*rampToVideoZoomFactor:firstZooom withRate:4*/];
                break;
            case 2:
                [self.device setVideoZoomFactor:secondZoom /*rampToVideoZoomFactor:secondZoom withRate:4*/];
                break;
                
            default:
                break;
        }
        [self.device unlockForConfiguration];
        
    }
}



/*
 #pragma mark - Navigation
 
 In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 Get the new view controller using [segue destinationViewController].
 Pass the selected object to the new view controller.
 }
 */


//@end

/*
 *  Implementation of the object that returns decoder results (via the notification
 *	process)
 */

/*@implementation DecoderResult

@synthesize succeeded;
@synthesize result;

+(DecoderResult *)createSuccess:(NSString *)result {
    DecoderResult *obj = [[DecoderResult alloc] init];
    if (obj != nil) {
        obj.succeeded = YES;
        obj.result = result;
    }
    return obj;
}

+(DecoderResult *)createFailure {
    DecoderResult *obj = [[DecoderResult alloc] init];
    if (obj != nil) {
        obj.succeeded = NO;
        obj.result = nil;
    }
    return obj;
}
*/
//- (void)dealloc
//{
//
//}



@end
