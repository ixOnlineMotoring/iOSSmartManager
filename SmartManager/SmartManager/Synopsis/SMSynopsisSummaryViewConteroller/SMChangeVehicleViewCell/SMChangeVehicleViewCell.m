//
//  SMChangeVehicleViewCell.m
//  Smart Manager
//
//  Created by Sandeep on 21/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMChangeVehicleViewCell.h"

@implementation SMChangeVehicleViewCell

- (void)awakeFromNib {
    // Initialization code
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        self.layoutMargins = UIEdgeInsetsZero;
        self.preservesSuperviewLayoutMargins = NO;
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter  setDateFormat:@"yyyy"];
   NSString *currentYear = [formatter stringFromDate:[NSDate date]];
    self.txtYear.text = currentYear;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnClearDidClicked:(id)sender
{
    self.txtMake.text = @"";
    self.txtModel.text = @"";
    self.txtVariant.text = @"";
    
}
@end
