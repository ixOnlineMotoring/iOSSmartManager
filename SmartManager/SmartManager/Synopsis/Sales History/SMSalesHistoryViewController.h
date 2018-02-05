//
//  SMSalesHistoryViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 14/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSalesHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSString *strModelName;
@property (strong, nonatomic) NSString *strYear;
@property (strong, nonatomic) NSString *strVariantId;
@end
