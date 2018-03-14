//
//  SMSearchBlogTableViewSliderCell.m
//  SmartManager
//
//  Created by Liji Stephen on 02/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMSearchBlogTableViewSliderCell.h"

@implementation SMSearchBlogTableViewSliderCell

- (void)awakeFromNib
{
    // Initialization code
    
    self.layer.affineTransform=CGAffineTransformMakeRotation(M_PI_2);
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblDetails.font = [UIFont fontWithName:FONT_NAME size:12.0];
        self.lblDaysRemaining.font = [UIFont fontWithName:FONT_NAME size:12.0];
        self.lblImageCount.font = [UIFont fontWithName:FONT_NAME size:12.0];
        self.lblType.font = [UIFont fontWithName:FONT_NAME size:12.0];
        self.lblActive.font = [UIFont fontWithName:FONT_NAME size:12.0];
        self.lblActiveDate.font = [UIFont fontWithName:FONT_NAME size:12.0];
        self.lblCreatedBy.font = [UIFont fontWithName:FONT_NAME size:12.0];
    }
    else
    {
        self.lblTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lblDetails.font = [UIFont fontWithName:FONT_NAME size:17.0];
        self.lblDaysRemaining.font = [UIFont fontWithName:FONT_NAME size:17.0];
        self.lblImageCount.font = [UIFont fontWithName:FONT_NAME size:17.0];
        self.lblType.font = [UIFont fontWithName:FONT_NAME size:17.0];
        self.lblActive.font = [UIFont fontWithName:FONT_NAME size:17.0];
        self.lblActiveDate.font = [UIFont fontWithName:FONT_NAME size:17.0];
        self.lblCreatedBy.font = [UIFont fontWithName:FONT_NAME size:17.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
