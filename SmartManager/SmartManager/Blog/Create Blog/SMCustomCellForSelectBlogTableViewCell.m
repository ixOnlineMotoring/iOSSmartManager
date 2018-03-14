//
//  SMCustomCellForSelectBlogTableViewCell.m
//  SmartManager
//
//  Created by Liji Stephen on 20/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMCustomCellForSelectBlogTableViewCell.h"

@implementation SMCustomCellForSelectBlogTableViewCell

- (void)awakeFromNib
{
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 7, 30)];
    self.lblBlogPostType.leftView = view3;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
