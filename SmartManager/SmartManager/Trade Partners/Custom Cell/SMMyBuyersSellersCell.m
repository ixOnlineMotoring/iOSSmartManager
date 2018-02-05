//
//  SMMyBuyersSellersCell.m
//  Smart Manager
//
//  Created by Prateek Jain on 07/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMMyBuyersSellersCell.h"

@implementation SMMyBuyersSellersCell

- (void)awakeFromNib
{
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    }
    else
    {
       self.lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
       self.lblType.font = [UIFont fontWithName:FONT_NAME size:15.0];
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
