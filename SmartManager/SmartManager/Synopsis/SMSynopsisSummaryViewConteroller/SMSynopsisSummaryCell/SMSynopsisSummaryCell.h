//
//  SMSynopsisSummaryCell.h
//  Smart Manager
//
//  Created by Sandeep on 21/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSynopsisSummaryCell : UITableViewCell
@property (strong, nonatomic)IBOutlet UIView *objContentView;
@property (strong, nonatomic)IBOutlet UILabel *titleLabel;;
@property (weak, nonatomic) IBOutlet UILabel *pricingLabel;
@property (weak, nonatomic) IBOutlet UILabel *tradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *marketLabel;
@property (weak, nonatomic) IBOutlet UILabel *retailLabel;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;
@property (strong, nonatomic) IBOutlet UIView *view4;
@property (strong, nonatomic) IBOutlet UIView *view5;
@property (strong, nonatomic) IBOutlet UILabel *lblTUAPriceCheck;
@property (strong, nonatomic) IBOutlet UIButton *btnUpdate;
@property (strong, nonatomic) IBOutlet UIButton *btnFetchPricing;

@property (strong, nonatomic) IBOutlet UILabel *lblTrade;
@property (strong, nonatomic) IBOutlet UILabel *lblMarket;
@property (strong, nonatomic) IBOutlet UILabel *lblRetail;

// Pricing section price values

@property (strong, nonatomic) IBOutlet UILabel *lblRetailPriceValue;

@property (strong, nonatomic) IBOutlet UILabel *lblTradePriceValue;

@property (strong, nonatomic) IBOutlet UILabel *lblMarketPriceValue;

@property (strong, nonatomic) IBOutlet UILabel *lblSLTradePrice;

@property (strong, nonatomic) IBOutlet UILabel *lblSLMarketPrice;

@property (strong, nonatomic) IBOutlet UILabel *lblSLRetailPrice;




@end
