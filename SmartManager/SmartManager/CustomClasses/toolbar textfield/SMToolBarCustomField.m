//
//  SMToolBarCustomField.m
//  SmartManager
//
//  Created by Priya on 30/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMToolBarCustomField.h"

@implementation SMToolBarCustomField
@synthesize toolbarDelegate;
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
    
    self.keyboardAppearance = UIKeyboardAppearanceDark;

    [self setLeftViewMode:UITextFieldViewModeAlways];
    
    [self setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    
    // This condition has been added by jignesh
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        [self setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)]];

    }
    else
    {
    
        [self setLeftView:[[UIView alloc]initWithFrame:CGRectMake(0, 3, 5, 0)]];

    }
    
    self.font = UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? [UIFont fontWithName:FONT_NAME size:15.0] : [UIFont fontWithName:FONT_NAME size:20.0];
    

    
    UIToolbar* numberToolbar9= [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar9.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar9.items = [NSArray arrayWithObjects:
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)],
                            nil];
    [numberToolbar9 sizeToFit];
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;

    self.inputAccessoryView = numberToolbar9;
    
}

-(void)doneButtonPressed
{
    [self.toolbarDelegate doneButtOnDIdPressed];
}
@end
