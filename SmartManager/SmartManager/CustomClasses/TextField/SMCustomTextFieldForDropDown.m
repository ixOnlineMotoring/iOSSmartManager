//
//  SMCustomTextFieldForDropDown.m
//  SmartManager
//
//  Created by Liji Stephen on 17/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMCustomTextFieldForDropDown.h"

@implementation SMCustomTextFieldForDropDown

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
    self.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.layer.borderWidth= 0.8f;
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 0)]];
        
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 22.0, 17.0)];
    imageview.image = [UIImage imageNamed:@"down_arrow"];
    imageview.contentMode = UIViewContentModeScaleAspectFit;
    [self setRightViewMode:UITextFieldViewModeAlways];
    [self setRightView:imageview];
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    // This change has been added by jignesh on 5 jan
    
    self.font = UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? [UIFont fontWithName:FONT_NAME size:15.0] : [UIFont fontWithName:FONT_NAME size:20.0];
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
