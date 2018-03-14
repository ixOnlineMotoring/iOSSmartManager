//
//  SMClassForRefreshingData.h
//  SmartManager
//
//  Created by Liji Stephen on 16/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SMGridModuleData.h"
#import "SMModulePageObject.h"
#import "MBProgressHUD.h"
#import "Reachability.h"

@protocol SMAuthenticationDelegate <NSObject>

-(void)authenticationSucceeded;
-(void)authenticationFailed;
-(void)authenticationPartiallyFailed;
///////////////////Monami//////////////////////////////////
// Add custom delegate method for failure message in Login Screen
-(void)authenticationFailedDuetoServer:(NSString *)message;
/////////////////////////END//////////////////////////////
@end


@interface SMClassForRefreshingData : NSObject<NSXMLParserDelegate,MBProgressHUDDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
    NSUserDefaults *prefs;
    
    //---web service access---
    
    NSMutableString *soapResults;
   NSMutableString *currentNodeContent;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    BOOL moduleElementFound;
    BOOL isAuthenticated;
    BOOL isImpersonateFound;
    BOOL isPageFound;
    BOOL isModulePresent;
    BOOL isSubModulePresent;
    
    BOOL isUser;
     BOOL isIdentity;
     BOOL isName;
     BOOL isSurName;
     BOOL isMemberID;
     BOOL isClientId;
     BOOL isUserHash;
     BOOL isClientName;
     BOOL isClientImages;
     BOOL isMemberImages;
    BOOL isIndividualClientImage;
    BOOL isFailureReason;
    BOOL isIndividualMemberImage;
    
    NSString *AuthenticatedValue;
    NSString *failureReason;
    NSArray *filteredArrayForDashBoard;
    NSArray *filteredArrayForBottomBar;
    
   
    NSMutableArray *dashBoardArray;
    NSMutableArray *bottomBarArray;
    NSMutableArray *arrmStoredImages;
    
    MBProgressHUD *HUD;
    NSMutableData *responsesData;
    
}

-(void)authenticateWithServerWithUsername:(NSString*)username andPassword:(NSString*)password;

typedef void (^SMCompetionBlockOfPushNotification)(NSString *pushNotificationUserId);

-(void)getThePushNotificationIDWithCallBack:(SMCompetionBlockOfPushNotification)callBackPushNotificationUser;

@property (nonatomic, strong) SMGridModuleData *moduleObj;
@property (nonatomic, strong) SMGridModuleData *subModuleObj;
@property (nonatomic, strong) SMGridModuleData *modulePageObj;

@property(nonatomic,strong)id <SMAuthenticationDelegate> authenticateDelegate;

@property (nonatomic, strong) NSURLSession *backGroundSession;
@property (retain, nonatomic)  Reachability* reach;


@end
