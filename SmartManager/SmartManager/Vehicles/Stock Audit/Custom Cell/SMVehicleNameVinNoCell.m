//
//  SMVehicleNameVinNoCell.m
//  SmartManager
//
//  Created by Liji Stephen on 09/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMVehicleNameVinNoCell.h"
#import "SMTradeDetailSlider.h"
#import "UIImageView+WebCache.h"


@implementation SMVehicleNameVinNoCell

@synthesize enlargePhotoDelegate;
@synthesize stockAuditObj;


- (void)awakeFromNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {

        self.lblVinNo.font = [UIFont fontWithName:FONT_NAME size:14.0];
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME size:14.0];
        self.lblVehicleTime.font = [UIFont fontWithName:FONT_NAME size:14.0];
        
        [self.sliderCollectionView registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil]            forCellWithReuseIdentifier:@"Cell"];
        
    }
    else
    {
        self.lblVinNo.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.lblVehicleName.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.lblVehicleTime.font = [UIFont fontWithName:FONT_NAME size:18.0];
        
        [self.sliderCollectionView         registerNib:[UINib nibWithNibName:@"CollectionCell_iPad" bundle:nil]            forCellWithReuseIdentifier:@"Cell"];
        
    }
    
}

#pragma mark - CollectionView Datasource / Delegate methods.

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMTradeDetailSlider *sliderCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    if(indexPath.item == 0)
    {
        [sliderCell.imageVehicle   setImageWithURL:[NSURL URLWithString:self.stockAuditObj.auditLicenseURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"] success:^(UIImage *image, BOOL cached)
         {
             
         }
                                           failure:^(NSError *error)
         {
             
         }];

    
    }
    else
    {
        [sliderCell.imageVehicle   setImageWithURL:[NSURL URLWithString:self.stockAuditObj.auditVehicleURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"] success:^(UIImage *image, BOOL cached)
         {
             
         }
                                           failure:^(NSError *error)
         {
             
         }];
    }
    
        
        
    sliderCell.backgroundColor = [UIColor lightGrayColor];
    [sliderCell.imageVehicle setContentMode:UIViewContentModeScaleAspectFit];
    return sliderCell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    networkGallery.startingIndex = indexPath.row;
    [enlargePhotoDelegate pushTheViewControllerForEnlargedImageWithObject:networkGallery];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return (collectionView.tag == 1) ? CGSizeMake(46, 46) : CGSizeMake(46, 46);
    }
    else
    {
        
        
        self.sliderCollectionView.frame = CGRectMake(self.sliderCollectionView.frame.origin.x, self.sliderCollectionView.frame.origin.y, self.sliderCollectionView.frame.size.width, 55);
        
        return (collectionView.tag == 1) ? CGSizeMake(46, 46) : CGSizeMake(46, 46);
    }
}

#pragma mark collection view cell paddings


#pragma mark -


#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    
    if(gallery == networkGallery)
    {
        int num;
        num = 2;
        return num;
    }
    return 0;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    if( gallery == networkGallery )
    {
        caption = [networkCaptions objectAtIndex:index];
    }
    return caption;
}



- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    
    if (index == 0)
    {
        return self.stockAuditObj.auditLicenseURL;
    }
    
    return self.stockAuditObj.auditVehicleURL;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
