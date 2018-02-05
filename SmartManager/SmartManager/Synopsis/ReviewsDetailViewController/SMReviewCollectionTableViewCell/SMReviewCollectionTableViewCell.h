//
//  SMReviewCollectionTableViewCell.h
//  Smart Manager
//
//  Created by Sandeep on 28/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMReviewCollectionTableViewCell : UITableViewCell
@property (weak, nonatomic)IBOutlet UILabel *vechiclesNameLabel;

@property (weak, nonatomic)IBOutlet UILabel *vechiclesShotDescriptionLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionViewPhotos;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionConstraitHeight;
@end
