//
//  SMAppDelegate.h
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
#import "SMNavigationController.h"
#import  <CoreLocation/CoreLocation.h>
#import "SMRefreshDLList.h"
#import <OneSignal/OneSignal.h>

typedef void(^RetriveDeviceToken)(NSString *devicetoken, NSError *error);

@interface SMAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>
{
    JASidePanelController *sidePanelController;
    
    // for location
    
    CLLocationCoordinate2D coordCurrentLocation;
    CLLocationManager *locationManager;
     RetriveDeviceToken deviceTokenCompletionBlock;
    
    float currentLatitude;
    float currentLongitude;
   
    NSUserDefaults *prefs;
    BOOL isRefreshUI;
    BOOL isSmallImageSelected;
    BOOL launchedBefore;
    
    __block  NSString *tokenStr;
    
    dispatch_queue_t backGroundQueue;
    
}

@property (strong, nonatomic) OneSignal *oneSignal;

@property (nonatomic) BOOL isPresented;

@property (readonly) CLLocationCoordinate2D currentUserCoordinate;

@property(nonatomic,assign)BOOL isRefreshUI;
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) void(^DeviceTokenBlock)(NSString *);

@property (nonatomic, strong) SMNavigationController *gridNavigationController;
@property (nonatomic, strong) SMRefreshDLList *refrshObj;
@property (strong,nonatomic) NSString *geoLocationString;

@end
