//
//  SMModuleGridViewCell.h
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMModuleGridViewCell : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UILabel *lblModuleName;

@property (strong, nonatomic) IBOutlet UIImageView *imgModuleImage;


@property (strong, nonatomic) IBOutlet UILabel *lblCount;

@property (strong, nonatomic) IBOutlet UILabel *lblImage;


@end
