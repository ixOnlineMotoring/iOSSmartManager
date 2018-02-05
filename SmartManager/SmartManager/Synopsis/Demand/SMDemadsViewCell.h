//
//  SMDemadsViewCell.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 13/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMDemadsViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblHeaderName;


@property (strong, nonatomic) IBOutlet UILabel *lblVariantName;
@property (strong, nonatomic) IBOutlet UILabel *lblVariantLeadsRanked;
@property (strong, nonatomic) IBOutlet UILabel *lblVariantSalesRanked;



@property (strong, nonatomic) IBOutlet UILabel *lblModelName;

@property (strong, nonatomic) IBOutlet UILabel *lblModelLeadsRanked;
@property (strong, nonatomic) IBOutlet UILabel *lblModelSalesRanked;


@end
