//
//  SMCellOfPlusImage.h
//  SmartManager
//
//  Created by Liji Stephen on 20/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCellOfPlusImage : UICollectionViewCell


@property (strong, nonatomic) IBOutlet UIButton *btnDelete;


@property (strong, nonatomic) IBOutlet UIImageView *imgActualImage;


@property (strong, nonatomic) IBOutlet UIImageView *imgPlusImage;


- (IBAction)btnDeleteDidClicked:(id)sender;

@end
