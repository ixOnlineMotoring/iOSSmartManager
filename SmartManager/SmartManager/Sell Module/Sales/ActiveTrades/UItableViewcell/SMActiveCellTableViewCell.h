//
//  SMActiveCellTableViewCell.h
//  Smart Manager
//
//  Created by Jignesh on 03/11/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMActiveCellTableViewCell : UITableViewCell
{


}

@property (weak, nonatomic) IBOutlet UIButton *btnCheckBox;
@property (strong, nonatomic) IBOutlet UILabel *lblClientName;
@property (strong, nonatomic) IBOutlet UILabel *lblUserInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblAmount;
@end
