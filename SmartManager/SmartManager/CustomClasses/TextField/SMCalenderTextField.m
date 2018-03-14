//
//  SMCalenderTextField.m
//  SmartManager
//
//  Created by Ketan Nandha on 10/03/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCalenderTextField.h"
#import "SMConstants.h"
#import "Fontclass.h"

@implementation SMCalenderTextField


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    self.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.layer.borderWidth= 0.8f;
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;

    UIButton *btnCalender;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        btnCalender = [[UIButton alloc]initWithFrame:CGRectMake(5, 7, 15, 15)];
        self.font = [UIFont fontWithName:FONT_NAME size:15.0];
    }
    else
    {
        ///////////////// Monami iPad Date icon aligment not proper
        btnCalender = [[UIButton alloc]initWithFrame:CGRectMake(0, 8, 25, 25)];
        self.font = [UIFont fontWithName:FONT_NAME size:20.0];
    }

    [Fontclass AttributeStringMethodwithFontWithButton:btnCalender iconID:85];
    [btnCalender setUserInteractionEnabled:NO];
    [self addSubview:btnCalender];
    
    [self setLeftViewMode:UITextFieldViewModeAlways];

    [self setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 5, 22, 22)]];
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    // this chnage has been added by ketan On 10 march 2015
}


@end
