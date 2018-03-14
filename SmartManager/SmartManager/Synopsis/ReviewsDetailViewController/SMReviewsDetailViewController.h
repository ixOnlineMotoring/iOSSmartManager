//
//  SMReviewsDetailViewController.h
//  Smart Manager
//
//  Created by Sandeep on 24/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMReviewTitleViewCell.h"
#import "SMReviewCollectionTableViewCell.h"
#import "SMVINHistoryViewController.h"
#import "SMReviewsObject.h"
@interface SMReviewsDetailViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource,MBProgressHUDDelegate,UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UITableView *tblReviewDetail;
     MBProgressHUD *HUD;
    SMReviewsObject *reviewDetailObj;
}
@property (strong,nonatomic) NSString *strYear;
@property (strong,nonatomic) NSString *strFriendlyName;
@property (strong,nonatomic)  SMReviewsObject *objReviews;

@end
