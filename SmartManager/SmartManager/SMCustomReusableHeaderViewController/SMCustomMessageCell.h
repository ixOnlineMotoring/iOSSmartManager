//
//  SMCustomMessageCell.h
//  Smart Manager
//
//  Created by Prateek Jain on 05/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCustomMessageCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblUserName;

@property (strong, nonatomic) IBOutlet UILabel *lblMessage;

@property (strong, nonatomic) IBOutlet UILabel *lblMessageTime;



@end
