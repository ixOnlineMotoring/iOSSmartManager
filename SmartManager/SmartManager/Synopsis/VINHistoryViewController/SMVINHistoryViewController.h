//
//  SMVINHistoryViewController.h
//  Smart Manager
//
//  Created by Sandeep on 29/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMVINHistoryViewController : UIViewController
{
    IBOutlet UITableView *tblSMVINHistoryView;
}
@property (strong,nonatomic) NSString *strYear;
@property (strong,nonatomic) NSString *strVehicleName;
@property (strong,nonatomic) NSString *strVINNo;
@end

