//
//  SMViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 04/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMImpersonateObject.h"

@protocol SMDropDownDelegate <NSObject>

-(void)showTheDropdown;
-(void)showTHeLogoutAlert;

@end

@protocol delegateForProfilePicBackNavigation <NSObject>

-(void)showHomeScreenOnClickingProfilePic;

@end

@interface SMViewController : UIViewController
{
    NSUserDefaults *prefs;
    SMImpersonateObject *impersonateObj;
}

//@property (strong, nonatomic) IBOutlet UIImageView *imgProfilePic;

@property (strong, nonatomic) IBOutlet UILabel *lblUserName;

@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (strong, nonatomic) IBOutlet UIButton *btnDownArrow;

@property (strong,nonatomic) id<SMDropDownDelegate> dropDownDelegate;
@property (strong,nonatomic) id<delegateForProfilePicBackNavigation> profilePicBackNavigationDelegate;

@property (strong, nonatomic) IBOutlet UILabel *lblCount;



@property (strong, nonatomic) IBOutlet UIButton *btnDropDown;


@property (strong, nonatomic) IBOutlet UIButton *btnLogout;







@end
