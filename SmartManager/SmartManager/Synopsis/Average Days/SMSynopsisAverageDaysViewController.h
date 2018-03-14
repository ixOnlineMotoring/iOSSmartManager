//
//  SMSynopsisAverageDaysViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 13/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSynopsisAverageDaysViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong,nonatomic) NSString *strYear;
@property (strong,nonatomic) NSString *strModelID;
@end
