//
//  SMCreateBlogTableViewCell.m
//  SmartManager
//
//  Created by Ketan Nandha on 10/03/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCreateBlogTableViewCell.h"

@implementation SMCreateBlogTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        [self setBackgroundColor:[UIColor clearColor]];
    }

    // Configure the view for the selected state
}

@end
