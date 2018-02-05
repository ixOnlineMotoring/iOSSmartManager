//
//  SMCustomerDLScanViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 04/05/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>
#import "SMVINLookupObject.h"
#import "SMStockAuditVinDetailsViewController.h"
#import "SMAppDelegate.h"
#import "SMSynopsisScanDetailViewController.h"
#import  <CoreLocation/CoreLocation.h>

@protocol pushDLDetailsScreen <NSObject>

-(void)pushTheDetailScreenFromTheListingScreen;

@end

typedef enum eMainScreenStateDL {
    NORMAL_DL,
    LAUNCHING_CAMERA_DL,
    CAMERA_DL,
    CAMERA_DECODING_DL,
    DECODE_DISPLAY_DL,
    CANCELLING_DL
} MainScreenStateDL;


@interface SMCustomerDLScanViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,CLLocationManagerDelegate>
{
    NSString          *base64Str;
    SMVINLookupObject *VINLookupObject;
    SMStockAuditVinDetailsViewController *VINLookUpDetailsView;
    SMSynopsisScanDetailViewController   *VINSynonpisDetailsView;
    SMAppDelegate *appDelegate;
    
    // for location
    
    CLLocationCoordinate2D coordCurrentLocation;
    CLLocationManager *locationManager;
    
    float currentLatitude;
    float currentLongitude;
    dispatch_queue_t backGroundQueue;


}

#pragma mark - Properties
@property (nonatomic, assign) MainScreenStateDL state;
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;
@property (nonatomic, retain) AVCaptureDevice *device;
@property (nonatomic, retain) NSTimer *focusTimer;
@property (nonatomic, retain) NSString *strFromViewController;


#pragma mark -


#pragma mark - Maneetee Works
- (void)decodeResultNotification: (NSNotification *)notification;
- (void)initCapture;
- (void)startScanning;
- (void)stopScanning;
- (void)toggleTorch;
#pragma mark - Properties


@property (nonatomic, weak) id <pushDLDetailsScreen> pushDetailsDelegate;

@property (readonly) CLLocationCoordinate2D currentUserCoordinate;
@property (strong,nonatomic) NSString *geoLocationString;

@property(assign)BOOL isComingFromStockAudit;
@property(assign)BOOL isComingFromSynopsis;

@property (strong, nonatomic) IBOutlet UIView *scanView;

-(IBAction)btnBackDidClicked:(id)sender;


@end
