//
//  SMSendInfoMultiSelectCell.m
//  Smart Manager
//
//  Created by Prateek Jain on 19/10/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMSendInfoMultiSelectCell.h"

@implementation SMSendInfoMultiSelectCell

- (void)awakeFromNib
{
    // Initialization code
    
    // Initialization code
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        self.lblSendVideosPhots.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
    }
    else
    {
        self.lblSendVideosPhots.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
