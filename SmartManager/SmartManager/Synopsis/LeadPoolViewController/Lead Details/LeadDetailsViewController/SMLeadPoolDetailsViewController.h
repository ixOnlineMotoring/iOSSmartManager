//
//  SMLeadPoolDetailsViewController.h
//  Smart Manager
//
//  Created by Ankit S on 8/4/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMLeadPoolDetailsViewController : UIViewController
@property (strong,nonatomic) NSString *strClientOrGroupName;
@property (strong,nonatomic) NSString *strYear;
@property (strong,nonatomic) NSString *strVariantID;
@property (strong,nonatomic) NSString *strModelId;
@property (strong,nonatomic) NSString *strLeadStatusId;
@property BOOL isActive;
@property BOOL isClient;
@end
