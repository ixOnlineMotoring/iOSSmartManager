//
//  SMVehicleNameVinNoCell.h
//  SmartManager
//
//  Created by Liji Stephen on 09/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMStockAuditDetailObject.h"
#import "FGalleryViewController.h"


@protocol pushingViewContollerForEnlargingPhotoDelegate <NSObject>

-(void) pushTheViewControllerForEnlargedImageWithObject:(FGalleryViewController*)galleryObject;


@end



@interface SMVehicleNameVinNoCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource,FGalleryViewControllerDelegate>

{
    // For Gallery View
    
    NSArray                     *   localCaptions;
    NSArray                     *   localImages;
    NSArray                     *   networkCaptions;
    NSArray                     *   networkImages;
    FGalleryViewController      *   localGallery;
    FGalleryViewController      *   networkGallery;

    NSString *finalPathLicseImage;
    NSString *finalPathVechImage;

    

}

@property (nonatomic, weak) id <pushingViewContollerForEnlargingPhotoDelegate> enlargePhotoDelegate;


@property (strong, nonatomic) IBOutlet UILabel *lblVinNo;

@property (strong, nonatomic) IBOutlet UILabel *lblVehicleName;

@property (strong, nonatomic) IBOutlet UILabel *lblVehicleTime;

@property (strong, nonatomic) IBOutlet UIView *viewRowSeparator;


@property (strong, nonatomic) IBOutlet UICollectionView *sliderCollectionView;


@property (strong, nonatomic) SMStockAuditDetailObject *stockAuditObj;


@end
