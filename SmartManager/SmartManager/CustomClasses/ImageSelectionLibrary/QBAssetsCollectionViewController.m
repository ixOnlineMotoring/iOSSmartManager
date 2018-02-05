//
//  QBAssetsCollectionViewController.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/31.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBAssetsCollectionViewController.h"

// Views
#import "QBAssetsCollectionViewCell.h"
#import "QBAssetsCollectionFooterView.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"

@interface QBAssetsCollectionViewController ()

@property (nonatomic, strong) NSMutableArray *assets;

@property (nonatomic, assign) NSInteger numberOfPhotos;
@property (nonatomic, assign) NSInteger numberOfVideos;

@end

@implementation QBAssetsCollectionViewController

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout
{
    self = [super initWithCollectionViewLayout:layout];
    
    if (self) {
        // View settings
        self.collectionView.backgroundColor = [UIColor whiteColor];
        
        // Register cell class
        [self.collectionView registerClass:[QBAssetsCollectionViewCell class]
                forCellWithReuseIdentifier:@"AssetsCell"];
        [self.collectionView registerClass:[QBAssetsCollectionFooterView class]
                forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                       withReuseIdentifier:@"FooterView"];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if([SMGlobalClass sharedInstance].wasSmallImageSelected)
    {
        [self.collectionView deselectItemAtIndexPath:[SMGlobalClass sharedInstance].indexpathOfSmallPhoto animated:YES];
    }
    
    
    [super viewWillAppear:animated];
    
     isSmallImageSelected = NO;
    
    // Scroll to bottom --- iOS 7 differences
    CGFloat topInset;
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        topInset = ((self.edgesForExtendedLayout && UIRectEdgeTop) && (self.collectionView.contentInset.top == 0)) ? (20.0 + 44.0) : 0.0;
    } else {
        topInset = (self.collectionView.contentInset.top == 0) ? (20.0 + 44.0) : 0.0;
    }
    
    [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.collectionViewLayout.collectionViewContentSize.height - self.collectionView.frame.size.height + topInset)
                                 animated:NO];
    
    // Validation
    if (self.allowsMultipleSelection) {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.imagePickerController.selectedAssetURLs.count];
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.imagePickerController.selectedAssetURLs.count];
    }
    
    [self addingProgressHUD];
}

-(void)viewDidLoad
{
    

}

-(void)viewDidDisappear:(BOOL)animated
{
    
   
    NSLog(@"assetsgroup = %@",self.assetsGroup);
    
//     if(self.assets.count>0)
//     {
//         self.assetsGroup = nil;
//         [self.assets removeAllObjects];
//     
//     }
    
   // NSLog(@"self.assets = %d",self.assets.count);
  //  NSLog(@"assetsgroup = %@",self.assetsGroup);
    
}

#pragma mark - Accessors

- (void)setFilterType:(QBImagePickerControllerFilterType)filterType
{
    _filterType = filterType;
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(self.filterType)];
}

- (void)setAssetsGroup:(ALAssetsGroup *)assetsGroup
{
    _assetsGroup = assetsGroup;
    
    // Set title
    self.title = [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    
    // Get the number of photos and videos
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    self.numberOfPhotos = self.assetsGroup.numberOfAssets;
    
    [self.assetsGroup setAssetsFilter:[ALAssetsFilter allVideos]];
    self.numberOfVideos = self.assetsGroup.numberOfAssets;
    
    // Set assets filter
    [self.assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(self.filterType)];
    
    // Load assets
    self.assets = [NSMutableArray array];
    
    __weak typeof(self) weakSelf = self;
    [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [weakSelf.assets addObject:result];
        }
    }];
    
    // Update view
    [self.collectionView reloadData];
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    self.collectionView.allowsMultipleSelection = allowsMultipleSelection;
    
    // Show/hide done button
    if (allowsMultipleSelection) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}

- (BOOL)allowsMultipleSelection
{
    return self.collectionView.allowsMultipleSelection;
}


#pragma mark - Actions

- (void)done:(id)sender
{
   // if(isSmallImageSelected)
    // return;
    
    // Change Required
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewControllerDidFinishSelection:)])
    {
        [self.delegate assetsCollectionViewControllerDidFinishSelection:self];
    }
}

#pragma mark - Managing Selection

- (void)selectAssetHavingURL:(NSURL *)URL
{
    for (NSInteger i = 0; i < self.assets.count; i++) {
        ALAsset *asset = [self.assets objectAtIndex:i];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        
        if ([assetURL isEqual:URL]) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            
            return;
        }
    }
}


#pragma mark - Validating Selections

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSLog(@"numberofselections = %d",numberOfSelections);
    
    NSLog(@"Max number of selections: %d",self.maximumNumberOfSelection);
    
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection)
    {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}

- (BOOL)validateMaximumNumberOfSelections:(NSUInteger)numberOfSelections
{
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        return (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return YES;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assetsGroup.numberOfAssets;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    QBAssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AssetsCell" forIndexPath:indexPath];
    cell.showsOverlayViewWhenSelected = self.allowsMultipleSelection;
    
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    cell.asset = asset;
    
    [cell showSelectedUnselectedStatus];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.bounds.size.width, 46.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Number of photos = %d",self.numberOfPhotos);
    
    
    if (kind == UICollectionElementKindSectionFooter) {
        QBAssetsCollectionFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                                      withReuseIdentifier:@"FooterView"
                                                                                             forIndexPath:indexPath];
        
        switch (self.filterType) {
            case QBImagePickerControllerFilterTypeNone:
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"",
                                                                                                  @"QBImagePickerController",
                                                                                                  nil),
                                             self.numberOfPhotos,
                                             self.numberOfVideos
                                             ];
                break;
                
            case QBImagePickerControllerFilterTypePhotos:
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_photos",
                                                                                                  @"QBImagePickerController",
                                                                                                  nil),
                                             self.numberOfPhotos
                                             ];
                break;
                
            case QBImagePickerControllerFilterTypeVideos:
                footerView.textLabel.text = [NSString stringWithFormat:NSLocalizedStringFromTable(@"format_videos",
                                                                                                  @"QBImagePickerController",
                                                                                                  nil),
                                             self.numberOfVideos
                                             ];
                break;
        }
        
        return footerView;
    }
    
    return nil;
}


#pragma mark - UICollectionViewDelegateFlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.row % 2 == 0) {
//        return CGSizeMake(50.5, 50.f);
//    }
//    
//    CGFloat size = (indexPath.row + 1) * 5.f;
//    
//    return CGSizeMake(size, size);
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
   // NSLog(@"shouldSelectItem = %hhd",[self validateMaximumNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)]);
    
    return [self validateMaximumNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
     NSLog(@"assetttt = %@",asset);
    [SMGlobalClass sharedInstance].indexpathOfSmallPhoto = indexPath;
    UIImage *img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];

    //NSLog(@"image width = %f",img.size.width);
    //NSLog(@"image height = %f",img.size.height);
    
    
    
    // Validation
    if (self.allowsMultipleSelection)
    {
        // test this
        
        isAlertShownOnce = NO;
        
       // NSLog(@"self.imagePickerController count: %d",self.imagePickerController.selectedAssetURLs.count);
        
       
        
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)];
        
        
        
        if(!self.navigationItem.rightBarButtonItem.enabled && !isAlertShownOnce)
        {
            NSString *alertMeassage;
            
            isAlertShownOnce = YES;
            
            if(self.maximumNumberOfSelection == 10)
                alertMeassage = @"";
            else
                alertMeassage = [NSString stringWithFormat:@"You can now select only %d photos ",(int)self.maximumNumberOfSelection];
                
            
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Maximum 20 photos per upload." message:alertMeassage delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
           

        }
        
        
        if(img.size.width < 400 || img.size.height < 200)
        {
            
            isAlertShownOnce = YES;
            isSmallImageSelected = YES;
            /*UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Smart Manager" message:@"Image size is too small to be selected." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];*/
            
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Image size is too small to be selected." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel)
                {
                    //[self.imagePickerController.selectedAssetURLs removeObject:[self.assets objectAtIndex:selectedIndexRow]];
                    
                   /* NSMutableSet *mutableSet = [NSMutableSet setWithSet: self.imagePickerController.selectedAssetURLs];
                    [mutableSet removeObject:[self.assets objectAtIndex:selectedIndexRow]];
                    self.imagePickerController.selectedAssetURLs = mutableSet;*/
                    
                    NSURL *url= (NSURL*) [[asset valueForProperty:ALAssetPropertyURLs] valueForKey:[[[asset valueForProperty:ALAssetPropertyURLs] allKeys] objectAtIndex:0]];
                    
                     NSLog(@"asset URL = %@",url);
                    
                    return;
                    
                }
                
            }];
            
            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
            [SMGlobalClass sharedInstance].wasSmallImageSelected = YES;
        }
        else
        {
             [SMGlobalClass sharedInstance].wasSmallImageSelected = NO;
        }

        
        if (!self.navigationItem.rightBarButtonItem.enabled)
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];

        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didSelectAsset:)])
            {
                [self.delegate assetsCollectionViewController:self didSelectAsset:asset];
            }
            
        }
    }
    else
    {
        /* self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count + 1)];
        
        if (!self.navigationItem.rightBarButtonItem.enabled)
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
            
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didSelectAsset:)])
            {
                [self.delegate assetsCollectionViewController:self didSelectAsset:asset];
            }
            
        }*/
        
        // Delegate
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didSelectAsset:)])
        {
            [self.delegate assetsCollectionViewController:self didSelectAsset:asset];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewControllerDidFinishSelection:)])
        {
            [self.delegate assetsCollectionViewControllerDidFinishSelection:self];
        }
        
        
        
    }
    
    // Delegate
   
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ALAsset *asset = [self.assets objectAtIndex:indexPath.row];
    
    // Validation
    if (self.allowsMultipleSelection)
    {
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count - 1)];
    }
    else
    {
        
            self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:(self.imagePickerController.selectedAssetURLs.count - 1)];
        
    }
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(assetsCollectionViewController:didDeselectAsset:)]) {
        [self.delegate assetsCollectionViewController:self didDeselectAsset:asset];
    }
}


-(void)deleteTheImageFromTheFirstLibrary:(UIImage*)imageToBeDeleted
{
    NSLog(@"ImageToBeDeleted = %@",imageToBeDeleted);
    
        for(int i=0;i<self.assets.count;i++)
        {
            
            ALAsset *asset = [self.assets objectAtIndex:i];
            
            UIImage *img = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
            
            NSData *imgdata1 = UIImagePNGRepresentation(img);
            NSData *imgdata2 = UIImagePNGRepresentation(imageToBeDeleted);
            
          
            
            if ([imgdata1 isEqualToData:imgdata2])
            {
                NSLog(@"Image found...");
                [self.delegate assetsCollectionViewController:self didDeselectAsset:asset];
                break;
                
            }

            
        }
    
}

-(void)deSelectThePhoto
{


}


-(void)dismissTheLoaderAction
{
    [self hideProgressHUD];
    
}


#pragma mark - Progress Bar Functions User Define
-(void) addingProgressHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}

-(void) hideProgressHUD
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
        });
    });
}



@end
