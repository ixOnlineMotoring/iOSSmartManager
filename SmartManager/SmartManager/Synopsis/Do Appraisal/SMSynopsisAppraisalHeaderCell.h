//
//  SMSynopsisAppraisalHeaderCell.h
//  Smart Manager
//
//  Created by Prateek Jain on 29/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMSynopsisAppraisalHeaderCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblNameYear;
@property (strong, nonatomic) IBOutlet UILabel *lblDetails;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UILabel *lblAppraiser;
@property (strong, nonatomic) IBOutlet UIImageView *imgviewVehicle;
@property (strong, nonatomic) IBOutlet UITextView *txtViewDetails;




@end
