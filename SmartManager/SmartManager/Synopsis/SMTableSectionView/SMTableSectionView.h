//
//  SMTableSectionView.h
//  Smart Manager
//
//  Created by Sandeep on 19/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonGrayColor.h"

@interface SMTableSectionView : UIView
@property (weak, nonatomic)IBOutlet SMCustomButtonGrayColor *sectionButton;
@property (weak, nonatomic)IBOutlet UIImageView *imgArrowDown;
@end
