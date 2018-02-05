//
//  SMLeadPoolViewController.h
//  Smart Manager
//
//  Created by Sandeep on 23/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMLeadPoolView.h"
#import "SMLeadPoolViewCell.h"
#import "SMReviewsViewController.h"
#import "SMLeadPoolFooterView.h"

@interface SMLeadPoolViewController : UIViewController
{
    SMLeadPoolView *loadPoolViewObj;
    SMLeadPoolFooterView *leadPoolFooterView;
    IBOutlet UITableView *tblLoadPoolView;
}

@property (strong,nonatomic) NSString *strModelName;
@property (strong,nonatomic) NSString *strYear;
@property (strong,nonatomic) NSString *strVariantID;
@property (strong,nonatomic) NSString *strModelId;

@end
