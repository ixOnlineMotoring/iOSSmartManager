//
//  SMCustomerTableViewCell.h
//  SmartManager
//
//  Created by Jignesh on 02/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "SMCustomLable.h"
@interface SMCustomerTableViewCell :  SWTableViewCell<SWTableViewCellDelegate>

@property(strong, nonatomic) IBOutlet UIButton *buttonSearch;

@property (nonatomic,strong) NSIndexPath  *indexPathCell;


@property (strong, nonatomic) IBOutlet UIImageView *imgDriverImage;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblDriverName;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblDriverID;


@end
