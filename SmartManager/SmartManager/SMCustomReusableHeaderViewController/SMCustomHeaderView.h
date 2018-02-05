//
//  SMCustomHeaderView.h
//  Smart Manager
//
//  Created by Prateek Jain on 05/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonBlue.h"

@interface SMCustomHeaderView : UITableViewHeaderFooterView



@property (strong, nonatomic) IBOutlet UILabel *lblFirst;

@property (strong, nonatomic) IBOutlet UILabel *lblSecond;

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnMessage;

@property (strong, nonatomic) IBOutlet UIImageView *imgViewArrow;


@property(assign) BOOL isSectionExpanded;

- (IBAction)btnMessagesDidClicked:(id)sender;


@end
