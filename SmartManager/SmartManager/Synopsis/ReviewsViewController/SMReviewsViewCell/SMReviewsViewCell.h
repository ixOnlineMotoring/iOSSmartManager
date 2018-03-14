//
//  SMReviewsViewCell.h
//  Smart Manager
//
//  Created by Sandeep on 24/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelAutolayout.h"
#import "SMAutolayoutLightLabel.h"
@interface SMReviewsViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet SMCustomLabelAutolayout *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIImageView *imgReview;
@property (strong, nonatomic) IBOutlet SMAutolayoutLightLabel *lblDecricription;
@property (strong, nonatomic) IBOutlet UIWebView *webViewDescription;

@property (strong, nonatomic) IBOutlet UILabel *lblOtherMakeModel;

@property (strong, nonatomic) IBOutlet UILabel *lblTopSeparator;

@property (strong, nonatomic) IBOutlet UILabel *lblBottomSeparator;

@property (strong, nonatomic) IBOutlet UILabel *lblNoArticles;


@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintForWebview;

@end
