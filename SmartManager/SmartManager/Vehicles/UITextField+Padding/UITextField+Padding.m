//
//  UITextField+Padding.m
//  CashCity
//
//  Created by Jignesh on 09/04/14.
//  Copyright (c) 2014 Netwin. All rights reserved.
//

#import "UITextField+Padding.h"

@implementation UITextField (Padding)
-(void) setLeftPadding:(int) paddingValue
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, paddingValue, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}

-(void) setTopPadding:(int) paddingVal
{

    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 5, self.frame.size.height)];
    self.leftView = paddingView;
    self.leftViewMode = UITextFieldViewModeAlways;
}
@end
