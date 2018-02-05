//
//  SMOEMSpecsHeaderView.h
//  Smart Manager
//
//  Created by Prateek Jain on 05/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonGrayColor.h"

@interface SMOEMSpecsHeaderView : UITableViewHeaderFooterView
@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnSpecification;
- (IBAction)btnSpecificationDidClicked:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *imgArrow;


@end
