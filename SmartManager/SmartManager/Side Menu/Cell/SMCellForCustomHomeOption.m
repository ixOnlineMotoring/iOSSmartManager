//
//  SMCellForCustomHomeOption.m
//  SmartManager
//
//  Created by Liji Stephen on 25/02/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCellForCustomHomeOption.h"

@implementation SMCellForCustomHomeOption

- (void)awakeFromNib {
    // Initialization code
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.lblHome setFont:[UIFont fontWithName:FONT_NAME size:15.0]];
    }
    else
    {
        [self.lblHome setFont:[UIFont fontWithName:FONT_NAME size:23.0]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
