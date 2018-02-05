//
//  SMAppDelegate.m
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMAppDelegate.h"
#import "SMSideMenuViewController.h"
#import "SMGridViewViewController.h"
#import "JASidePanelController.h"
#import "SMLoginViewController.h"
#import "SMGlobalClass.h"
#import "SMCommonClassMethods.h"
#import "UIImageView+WebCache.h"
#import <AddressBookUI/AddressBookUI.h>
#import <CoreLocation/CLGeocoder.h>
#import <CoreLocation/CLPlacemark.h>
#import "FGalleryViewController.h"
#import "AGPushNoteView.h"
#import "SDImageCache.h"
@implementation SMAppDelegate
@synthesize isRefreshUI;
@synthesize geoLocationString;
@synthesize isPresented;



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    self.isPresented = NO;
    
    launchedBefore =  [[NSUserDefaults standardUserDefaults] boolForKey:@"launchedBefore"];
    if (launchedBefore)  {
       
        NSLog(@"Not first launch.");
    }
    else {
        NSLog(@"first launch.");
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"SubcriptionDone"];
        //NSUserDefaults.standardUserDefaults().[setBool(true, forKey: "launchedBefore")
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"launchedBefore"];
    }
    
    
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
    //[[SMDatabaseManager theSingleTon]removeAllRecordsForVideos];
    NSArray * arrmStoredVideos = [[SMDatabaseManager theSingleTon]fetchVideoDetails];
    
    self.refrshObj = [[SMRefreshDLList alloc]init];
    [application setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    backGroundQueue = dispatch_queue_create("FetchingCurrentLocationInTheBackground", NULL);
    
    //[self setTheDirections];
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"Member_ID"]>0)
    {
    
        [SMGlobalClass sharedInstance].strName = [[NSUserDefaults standardUserDefaults] valueForKey:@"Name"];
        [SMGlobalClass sharedInstance].strSurName = [[NSUserDefaults standardUserDefaults] valueForKey:@"Surname"];
        [SMGlobalClass sharedInstance].strMemberID = [[NSUserDefaults standardUserDefaults] valueForKey:@"Identity"];
        [SMGlobalClass sharedInstance].strClient = [[NSUserDefaults standardUserDefaults] valueForKey:@"ClientName"];
        [SMGlobalClass sharedInstance].arrayOfModules = [[NSUserDefaults standardUserDefaults] valueForKey:@"Identity"];
        
        [SMGlobalClass sharedInstance].strName =  [NSString stringWithFormat:@"%@ %@",[SMGlobalClass sharedInstance].strName,[SMGlobalClass sharedInstance].strSurName];
        
        NSString *moduleStr =  [[NSUserDefaults standardUserDefaults] valueForKey:@"Modules"];
        
        NSLog(@"moduleStr = %@",moduleStr);
        
        [SMGlobalClass sharedInstance].arrayOfModules = [[NSMutableArray alloc]initWithArray:[moduleStr componentsSeparatedByString:@","]];
    }
    
    SMSideMenuViewController *sideMenuViewController;
    SMGridViewViewController *gridViewController;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        gridViewController = [[SMGridViewViewController alloc]initWithNibName:@"SMGridViewViewController" bundle:nil];
        
       // sideMenuViewController = [[SMSideMenuViewController alloc]initWithNibName:@"SMSideMenuViewController" bundle:nil];
    }
    else
    {
        gridViewController = [[SMGridViewViewController alloc]initWithNibName:@"SMGridViewViewController_iPad" bundle:nil];
        
       // sideMenuViewController = [[SMSideMenuViewController alloc]initWithNibName:@"SMSideMenuViewController_iPad" bundle:nil];
    }
    
    self.gridNavigationController = [[SMNavigationController alloc]initWithRootViewController:gridViewController];
     gridViewController.navigationController = self.gridNavigationController;

    [self.gridNavigationController addHeader:gridViewController];
    
    sidePanelController = [[JASidePanelController alloc]init];
  //  [sidePanelController setRightPanel:sideMenuViewController];
    [sidePanelController setCenterPanel:self.gridNavigationController];
    
   // sideMenuViewController.sidePanelController = sidePanelController;
    
    self.gridNavigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.gridNavigationController.navigationBar setTranslucent:NO];// this is to show the ui properly so that the views dont get hidden behind the navigation bar.
    
    [self customizedNavigationControl];
    
    self.window.rootViewController = sidePanelController;
     self.window.backgroundColor = [UIColor colorWithRed:38.0/255 green:41.0/255 blue:46.0/255 alpha:1.0];
    [self.window makeKeyAndVisible];
    
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
    NSString *documentFilePath = [documentsDirectory stringByAppendingPathComponent:@"/DocumentRecord"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:documentFilePath])	//Does directory already exist?
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:documentFilePath
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error])
        {
            
        }
    }

    //[sidePanelController showRightPanelAnimated:NO];
    [sidePanelController showCenterPanelAnimated:NO];
    
    if(![[NSUserDefaults standardUserDefaults]objectForKey:@"Member_ID"]>0)
    {
        [self presentLoginView];
    }
    else
    {
        prefs = [NSUserDefaults standardUserDefaults];
        [gridViewController.refreshData authenticateWithServerWithUsername:[prefs valueForKey:@"UserName"] andPassword:[prefs valueForKey:@"Password"]];
    }
    
    self.oneSignal = [[OneSignal alloc] initWithLaunchOptions:launchOptions
                                                        appId:@"06a1817b-6dad-4d2a-9e0d-98d5ba2e2055"
                                           handleNotification:nil];
    
    /*self.oneSignal = [[OneSignal alloc] initWithLaunchOptions:launchOptions appId:@"06a1817b-6dad-4d2a-9e0d-98d5ba2e2055" handleNotification:^(NSString *message, NSDictionary *additionalData, BOOL isActive) {
        {
            NSLog(@"message = %@",message);
             NSLog(@"additionalData: %@", additionalData);
            
        }
    }];*/
    
    
    [self.oneSignal enableInAppAlertNotification:YES];
    
   [gridViewController.refreshData getThePushNotificationIDWithCallBack:^(NSString *pushNotificationUserId) {
        NSLog(@"pushNotificationUserIDD = %@",pushNotificationUserId);
        
        [self.oneSignal sendTags:@{@"key1" : pushNotificationUserId} onSuccess:^(NSDictionary *result) {
            NSLog(@"result = %@",result);
        } onFailure:^(NSError *error) {
            NSLog(@"Error sending ID = %@",error);
        }];
        
        [self.oneSignal IdsAvailable:^(NSString* userId, NSString* pushToken) {
            NSLog(@"UserId:%@", userId);
            if (pushToken != nil)
                NSLog(@"pushToken: %@", pushToken);
        }];
    }];
    
       
   NSLog(@"DBPath = %@",[self getDBPath]) ;
    [self getDeviceToken];
    return YES;
    
}

-(NSString*)getDBPath
{
    NSArray *path =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentdirectory = [path objectAtIndex:0];
    return [documentdirectory stringByAppendingPathComponent:@"ImageDataModel.sqlite"];
}

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //self.refrshObj = nil;
}

-(void)customizedNavigationControl
{
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    float ver_float = [ver floatValue];
    if (ver_float < 7.0)
    {
        [self.gridNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header2"] forBarMetrics:UIBarMetricsDefault];
        self.gridNavigationController.navigationBar.tintColor = [UIColor colorWithRed:82.0/255 green:182.0/255 blue:218.0/255 alpha:1.0];
    }
    else
    {
        self.gridNavigationController.navigationBar.tintColor = [UIColor whiteColor];
        [self.gridNavigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header1"] forBarMetrics:UIBarMetricsDefault];
    }
}

#pragma mark - Present Login View Controller

-(void)presentLoginView
{
    SMLoginViewController *loginViewController;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        loginViewController = [[SMLoginViewController alloc]initWithNibName:@"SMLoginViewController" bundle:nil];
    }
    else
    {
        loginViewController = [[SMLoginViewController alloc]initWithNibName:@"SMLoginViewController~ipad" bundle:nil];
    }
    [sidePanelController presentViewController:loginViewController animated:NO completion:NULL];
}


// This function has been added by jignesh K
// Date:     20 July
// Purpose - To play video of landscape mode only

//- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)windowx
//{
//    
//    
//    if ([self.window.rootViewController isKindOfClass:NSClassFromString(@"FGalleryViewController")])
//    {
//        return UIInterfaceOrientationMaskAll;
//    }
//    else
//    {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}
//    
//
//    if ([[self.window.rootViewController presentedViewController] isKindOfClass:NSClassFromString(@"FGalleryViewController")])
//    {
//        if ([self.window.rootViewController presentedViewController].isBeingDismissed)
//        {
//            return UIInterfaceOrientationMaskPortrait;
//        }
//        else
//        {
//            return UIInterfaceOrientationMaskAll;
//        }
//    }
//    else
//    {
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}




#pragma mark - Push Notification

-(void)allowedPushNotification:(UIApplication *)application
{


#ifdef TARGET_IPHONE_SIMULATOR
    NSString *model = [[UIDevice currentDevice] model];
    
    if ([model isEqualToString:@"iPhone Simulator"])
    {
        [SMCommonClassMethods setDeviceToken:@"Test123"];
    }
    else
    {
        if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
        {
            // iOS 8 Notifications
            [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
            
            [application registerForRemoteNotifications];
        }
        else
        {
            [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound)];
        }
    }
#endif

}
// this will get our device token
/*- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    tokenStr = [deviceToken description];
    
    _DeviceTokenBlock= ^(NSString *deviceTokenReceived)
    {
        // Separete Your device token with <,< and blanksapace And Setting
        [SMCommonClassMethods setDeviceToken:[[[deviceTokenReceived
                                       stringByReplacingOccurrencesOfString:@"<"  withString:@""]
                                      stringByReplacingOccurrencesOfString:@">"  withString:@""]
                                     stringByReplacingOccurrencesOfString:@" "  withString:@""]];
    };
    
    _DeviceTokenBlock(tokenStr);
    
}*/
/*-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"FAILEDDD TO GET DEVICE TOKEN");
    [SMCommonClassMethods setDeviceToken:@"__FAILED_TO_GET_DEVICE_TOKEN__"];
}*/

#pragma mark -


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
            [locationManager requestAlwaysAuthorization];
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
   /* UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Location services disabled." message:@"Please enable the location services on your device." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    
    [alert show];*/
    
    
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


- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if (self.isPresented)
        return UIInterfaceOrientationMaskAll;
    else return UIInterfaceOrientationMaskPortrait;
}


#pragma mark -
#pragma mark - Device Token
/// To get Device token
-(void)getDeviceToken
{
    [self registerRemoteNotificationWithCompletionBlock:^(NSString *devicetoken, NSError *error) {
        
        if (!error)
        {
            NSLog(@"Device Token : %@",devicetoken);
           // [UtilityClass saveCustomObject:devicetoken forKey:kDeviceToken];
        }
        else
        {
            //@"FAILED";
            NSLog(@"Device Token Failed : %@",error);
            
            //[UtilityClass saveCustomObject:@"" forKey:kDeviceToken];
            
        }
        
    }];
}


/// Ask permission for Push Notifications
-(void)registerRemoteNotificationWithCompletionBlock:(RetriveDeviceToken)completionBlock
{
    deviceTokenCompletionBlock = completionBlock;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=8.0)
    {
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
         UIUserNotificationTypeBadge |
         UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication]registerForRemoteNotifications];
    }
    else
    {
        
    }
}


#pragma mark -
#pragma mark - Push Notification Delegates

/// Register for Push Notifications
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSMutableString *string = [[NSMutableString alloc]init];
    int length = (int)[deviceToken length];
    char const *bytes = [deviceToken bytes];
    for (int i=0; i< length; i++)
    {
        [string appendString:[NSString stringWithFormat:@"%02.2hhx",bytes[i]]];
    }
    
    if (deviceTokenCompletionBlock)
        deviceTokenCompletionBlock(string,nil);
    
}

/// Fail to register for Push Notifications
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"FAILED");
    
    if (deviceTokenCompletionBlock)
        deviceTokenCompletionBlock(@"__FAILED_TO_GET_DEVICE_TOKEN__",error);
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    
    NSLog(@"Push Notification: %@",userInfo);
    
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    UIApplicationState state = [application applicationState];
    if (state == UIApplicationStateActive) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Reminder"
//                                                        message:notification.alertBody
//                                                       delegate:self cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
        
        [AGPushNoteView showWithNotificationMessage:notification.alertBody];
    }
    
}




@end
