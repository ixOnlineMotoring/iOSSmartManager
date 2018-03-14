//
//  CustomTextView.m
//  GoocitiPartner
//
//  Created by Prateek on 1/10/13.
//
//

#import "CustomTextView.h"

@implementation CustomTextView

@synthesize placeHolderLabel;
@synthesize placeholder;
@synthesize placeholderColor;


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
    self.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.layer.borderWidth= 0.8f;
    self.autocapitalizationType = UITextAutocapitalizationTypeSentences;
    
   

    [self setPlaceholder:@""];
    self.font = [UIFont fontWithName:FONT_NAME size:14.0];
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
//            self.layer.borderWidth = 0.5f;
//            self.layer.borderColor = [[UIColor lightGrayColor] CGColor];
//            self.layer.cornerRadius = 5.0f;
//            [self setBackgroundColor:[UIColor whiteColor]];
            
          
            self.layer.borderColor = (__bridge CGColorRef)([SMCustomColor setBackGroundColorForTextView]);
            self.layer.borderWidth= 0.8f;
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
    if( [[self placeholder] length] > 0 )
    {
        if ( placeHolderLabel == nil )
        {
            
            // some modification bu jignesh
            
            // 1. adding fonnt
            // 2. Frame 8 has chnaged to 3
            
            placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5,3,self.bounds.size.width - 16,0)];
            placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
            placeHolderLabel.numberOfLines = 0;
           // self.font = UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone] : [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
             self.font = UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone ? [UIFont fontWithName:FONT_NAME size:15.0] : [UIFont fontWithName:FONT_NAME size:20.0];
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
    
    [super drawRect:rect];
}
@end