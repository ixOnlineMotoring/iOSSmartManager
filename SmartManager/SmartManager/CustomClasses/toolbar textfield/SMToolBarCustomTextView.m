//
//  SMToolBarCustomTextView.m
//  SmartManager
//
//  Created by Priya on 30/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMToolBarCustomTextView.h"
#import "SMConstants.h"
@implementation SMToolBarCustomTextView
@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;
@synthesize delegate;

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
#if __has_feature(objc_arc)
#else
    [placeHolderLabel release]; placeHolderLabel = nil;
    [placeholderColor release]; placeholderColor = nil;
    [placeholder release]; placeholder = nil;
    [super dealloc];
#endif
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setPlaceholder:@""];
    [self setPlaceholderColor:[UIColor lightGrayColor]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if( (self = [super initWithFrame:frame]) )
    {
        [self setPlaceholder:@""];
        [self setPlaceholderColor:[UIColor lightGrayColor]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
        if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad)
        {
            self.layer.borderWidth = 0.5f;
            self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
            self.layer.cornerRadius = 5.0f;
            [self setBackgroundColor:[UIColor whiteColor]];
        }
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification
{
    if([[self placeholder] length] == 0)
    {
        return;
    }
    
    if([[self text] length] == 0)
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    else
    {
        [[self viewWithTag:999] setAlpha:0];
    }
}

- (void)setText:(NSString *)text {
    [super setText:text];
    [self textChanged:nil];
}

- (void)drawRect:(CGRect)rect
{
    self.keyboardAppearance = UIKeyboardAppearanceDark;

    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            
            // some chnages by jignesh
            
            // adding font
            // chnaging label size
            
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7,7,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
            
            self.font = UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone] : [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
            
            placeHolderLabel.font = self.font;
            placeHolderLabel.backgroundColor = [UIColor clearColor];
            placeHolderLabel.textColor = self.placeholderColor;
            placeHolderLabel.alpha = 0;
            placeHolderLabel.tag = 999;
            [self addSubview:placeHolderLabel];
        }
        
        placeHolderLabel.text = self.placeholder;
        [placeHolderLabel sizeToFit];
        [self sendSubviewToBack:placeHolderLabel];
    }
    
    if( [[self text] length] == 0 && [[self placeholder] length] > 0 )
    {
        [[self viewWithTag:999] setAlpha:1];
    }
    
    UIToolbar* numberToolbar9= [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar9.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar9.items = [NSArray arrayWithObjects:
                            [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonPressed)],
                            nil];
    [numberToolbar9 sizeToFit];
    self.inputAccessoryView = numberToolbar9;
    [super drawRect:rect];
    
    
}

-(void)doneButtonPressed
{
    [self.toolbarDelegate textViewDoneButtOnDidPressed];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
