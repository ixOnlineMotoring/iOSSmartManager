//
//  HomeViewController.h
//  LLSimpleCameraExample
//
//  Created by Ömer Faruk Gül on 29/10/14.
//  Copyright (c) 2014 Ömer Faruk Gül. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLSimpleCamera.h"

@interface HomeViewController : UIViewController
{
    NSString  *filToBeuplaoded;
    BOOL blinkStatus;

}

typedef void (^SMCompetionBlockVideos)(BOOL success, NSString *videoPath, UIImage *thumbnailImage,NSString *videoName, NSError *error);

+(void)getTheGeneratedVideoWithCallBack:(SMCompetionBlockVideos)callBackVideos;



@property(nonatomic,strong)NSTimer *timer;
@property(assign)BOOL isCameraViewFromPhotosNExtras;
@property(assign)BOOL isCameraViewFromEBrochure;
@property(nonatomic,strong)NSString *videoVehicleName;
@end
