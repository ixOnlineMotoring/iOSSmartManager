//
//  SMCustomTextFieldSearch.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 02/02/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMCustomTextFieldSearch.h"

@implementation SMCustomTextFieldSearch

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
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
    [self setLeftViewMode:UITextFieldViewModeAlways];
    
    [self setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)]];

    [self setExclusiveTouch:YES];
    // this chnage has been added by Jignesh On 5 jan2015
    
    self.font = UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? [UIFont fontWithName:FONT_NAME_BOLD size:15.0] : [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    
}
@end

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

