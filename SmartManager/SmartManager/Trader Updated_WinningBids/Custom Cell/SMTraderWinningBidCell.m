//
//  SMTraderWinningBidCell.m
//  Smart Manager
//
//  Created by Prateek Jain on 27/10/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMTraderWinningBidCell.h"

@implementation SMTraderWinningBidCell

- (void)awakeFromNib
{
     [super awakeFromNib];
    // Initialization code
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }
    

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
