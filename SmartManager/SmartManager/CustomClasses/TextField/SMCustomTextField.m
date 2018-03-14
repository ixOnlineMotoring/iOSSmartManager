//
//  SMCustomTextField.m
//  SmartManager
//
//  Created by Liji Stephen on 05/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMCustomTextField.h"

@implementation SMCustomTextField

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
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self setExclusiveTouch:YES];
    // this chnage has been added by Jignesh On 5 jan2015
   
    self.font = UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? [UIFont fontWithName:FONT_NAME size:15.0] : [UIFont fontWithName:FONT_NAME size:20.0];

}
@end
