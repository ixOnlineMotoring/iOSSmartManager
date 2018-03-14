//
//  CustomTextView.h
//  GoocitiPartner
//
//  Created by Prateek on 1/10/13.
//
//

#import <UIKit/UIKit.h>
#import "SMCustomColor.h"
@interface CustomTextView : UITextView
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

@end