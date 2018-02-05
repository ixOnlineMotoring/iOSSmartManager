//
//  SMCustomMoreInfoCell.m
//  Smart Manager
//
//  Created by Tejas on 03/09/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomMoreInfoCell.h"

@implementation SMCustomMoreInfoCell

- (void)awakeFromNib
{
    // Initialization code
   // self.textViewComment.toolbarDelegate = self;
    self.textViewComment.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.textViewComment.layer.borderWidth= 0.8f;
    

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnSendEmailCommentDidClicked:(id)sender {
}
@end
