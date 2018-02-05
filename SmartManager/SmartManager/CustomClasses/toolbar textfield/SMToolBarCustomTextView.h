//
//  SMToolBarCustomTextView.h
//  SmartManager
//
//  Created by Priya on 30/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SMToolBarCustomTextViewDelegate <NSObject>

-(void)textViewDoneButtOnDidPressed;

@end
@interface SMToolBarCustomTextView : UITextView
{
    NSString *placeholder;
    UIColor *placeholderColor;
    
@private
    UILabel *placeHolderLabel;
}

@property (nonatomic, retain) UILabel *placeHolderLabel;
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

-(void)textChanged:(NSNotification*)notification;
@property (strong, nonatomic) id <SMToolBarCustomTextViewDelegate>toolbarDelegate;

@end
