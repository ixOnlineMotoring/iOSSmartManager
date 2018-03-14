//
//  SMBiddingButton.m
//  SmartManager
//
//  Created by Jignesh on 17/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMBiddingButton.h"

@implementation SMBiddingButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    isStateSelected = NO;
}

-(void)changeState
{
//    isStateSelected = !isStateSelected;
//    if (isStateSelected) // YES
//    {
//        NSMutableAttributedString * string =
//        [[NSMutableAttributedString alloc] initWithString:@"Enable Automated Bidding"];
//        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,6)];
//        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(7,17)];
//        
//        [self setAttributedTitle:string forState:UIControlStateNormal];
//
//    }
//    else // NO
//    {
//       
//        
//        NSMutableAttributedString * string =
//        [[NSMutableAttributedString alloc] initWithString:@"Disable Automated Bidding"];
//        [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,7)];
//        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(8,17)];
//        [self setAttributedTitle:string forState:UIControlStateNormal];
//
//    }
}

-(void)setSelected:(BOOL)selected
{
 
    
    
    

//    NSMutableAttributedString * string =
//    [[NSMutableAttributedString alloc] initWithString:@"Disabled Automated Bidding"];
//    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,8)];
//    [self setAttributedTitle:string forState:UIControlStateNormal];
    
}




@end
