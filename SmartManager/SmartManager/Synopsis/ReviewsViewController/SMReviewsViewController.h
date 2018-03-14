//
//  SMReviewsViewController.h
//  Smart Manager
//
//  Created by Sandeep on 24/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMReviewsTitleViewCell.h"
#import "SMReviewsViewCell.h"
#import "SMReviewsDetailViewController.h"

@interface SMReviewsViewController : UIViewController
{
    IBOutlet UITableView *tblReviewsView;
}
@property (strong,nonatomic) NSString *strVariantID;
@property (strong,nonatomic) NSString *strModelID;
@property (strong,nonatomic) NSString *strYear;
@property (strong,nonatomic) NSString *strFriendlyName;
@end
