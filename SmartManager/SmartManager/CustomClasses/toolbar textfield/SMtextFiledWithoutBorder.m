//
//  SMtextFiledWithoutBorder.m
//  SmartManager
//
//  Created by Priya on 31/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMtextFiledWithoutBorder.h"
#import "SMConstants.h"


@implementation SMtextFiledWithoutBorder
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    self.layer.borderColor=[UIColor clearColor].CGColor;
    self.layer.borderWidth= 0.8f;
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)]];
    
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22.0, 17.0)];
    imageview.image = [UIImage imageNamed:@"down_arrow"];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self setRightView:imageview];
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.font = [UIFont fontWithName:FONT_NAME size:14.0];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
