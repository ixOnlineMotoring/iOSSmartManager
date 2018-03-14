//
//  SMNavigationController.h
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMViewController.h"



@interface SMNavigationController : UINavigationController<SMDropDownDelegate,UINavigationControllerDelegate,delegateForProfilePicBackNavigation>
{
    

}

@property(nonatomic,strong) UIViewController *viewController;

-(void)customizeNavigationController:(UINavigationController *)navigationController;
-(void)addHeader:(UIViewController *)viewController;

@property (nonatomic, strong) SMViewController *headerViewController;

@end
