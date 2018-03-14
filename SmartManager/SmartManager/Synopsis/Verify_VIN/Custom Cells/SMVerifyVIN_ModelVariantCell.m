//
//  SMVerifyVIN_ModelVariantCell.m
//  Smart Manager
//
//  Created by Prateek Jain on 19/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMVerifyVIN_ModelVariantCell.h"

@implementation SMVerifyVIN_ModelVariantCell

- (void)awakeFromNib
{
    // Initialization code
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
    }
   /* NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yyyy"];
    NSString  *currentYear = [formatter stringFromDate:[NSDate date]];
    self.txtFieldYear.text = currentYear;*/
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClearDidClicked:(id)sender
{
    self.txtFieldMake.text = @"";
    self.txtFieldModel.text = @"";
    self.txtFieldVariant.text = @"";
    
}
@end
