//
//  SMSynopsisSimilarVehiclesViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 13/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface SMSynopsisSimilarVehiclesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *arrayForSections;
    NSMutableArray *arrayOfInnerObjects;
    NSComparisonResult result;
    UIImageView *imageViewArrowForsection;
    UILabel *countLbl;
  
    
    
    __weak IBOutlet UITableView *tblViewSimilarVehicles;
    
    IBOutlet UIView *headerView;

}

@property(strong,nonatomic) NSString *strYear;
@property(strong,nonatomic) NSString *strVariantID;
@property(strong,nonatomic) NSString *strFriendlyName;
@end
