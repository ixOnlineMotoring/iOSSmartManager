//
//  SMOEMSpecsViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 05/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMOEMSpecsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSString *strVariantId;
@property (strong,nonatomic) NSString *strYear;

@end
