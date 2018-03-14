//
//  SMVINLookUpViewController.h
//  SmartManager
//
//  Created by Priya on 17/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMVINLookupObject.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreMedia/CoreMedia.h>

#import "SMCustomButtonBlue.h"

@interface DecoderResult : NSObject
{
    BOOL succeeded;
    NSString *result;
}

@property (nonatomic, assign) BOOL succeeded;
@property (nonatomic, retain) NSString *result;

+(DecoderResult *)createSuccess:(NSString *)result;
+(DecoderResult *)createFailure;

@end



typedef enum eMainScreenState {
    NORMAL,
    LAUNCHING_CAMERA,
    CAMERA,
    CAMERA_DECODING,
    DECODE_DISPLAY,
    CANCELLING
} MainScreenState;

@interface SMVINLookUpViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    IBOutlet UIButton           *VINscanButton;
    IBOutlet SMCustomButtonBlue *savedVINButton;
    IBOutlet UILabel            *lblTitle;
    IBOutlet UIView             *scanView;
    IBOutlet UIButton           *btnBack;
    
    
    SMVINLookupObject *VINLookupObject;


}

#pragma mark - Properties
@property (nonatomic, assign) MainScreenState state;
@property (nonatomic, retain) AVCaptureSession *captureSession;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *prevLayer;
@property (nonatomic, retain) AVCaptureDevice *device;
@property (nonatomic, retain) NSTimer *focusTimer;
#pragma mark -


#pragma mark - Maneetee Works
- (void)decodeResultNotification: (NSNotification *)notification;
- (void)initCapture;
- (void)startScanning;
- (void)stopScanning;
- (void)toggleTorch;
#pragma mark - Properties


#pragma mark - User Define Functions
-(IBAction)btnBackDidClicked:(id)sender;
-(IBAction)btnVINScanDidClicked:(id)sender;
-(IBAction)btnSavedVINDidClicked:(id)sender;
#pragma mark -

@end
