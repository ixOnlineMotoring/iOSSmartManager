//
//  SMAppNotificationCell.h
//  Smart Manager
//
//  Created by Ketan Nandha on 02/02/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMAppNotificationCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UILabel *lblDate;

@property (strong, nonatomic) IBOutlet UILabel *lblDescription;

@property (strong, nonatomic) IBOutlet UITextView *txtViewDescription;

@property (strong, nonatomic) IBOutlet UIView *viewTransparentBackground;

@end
