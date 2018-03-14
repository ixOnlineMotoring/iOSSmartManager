//
//  SMCustomInteriorTableViewCell.h
//  Smart Manager
//
//  Created by Prateek Jain on 04/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"

@interface SMCustomInteriorTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UIButton *btnCheckBox;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldPrice;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldTitleInput;






@end
