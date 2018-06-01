//
//  QBImagePickerController.m
//  QBImagePickerController
//
//  Created by Tanaka Katsuma on 2013/12/30.
//  Copyright (c) 2013年 Katsuma Tanaka. All rights reserved.
//

#import "QBImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

// Views
#import "QBImagePickerGroupCell.h"
#import "SECollectionViewFlowLayout.h"

// ViewControllers
#import "QBAssetsCollectionViewController.h"
#import "SMGlobalClass.h"

ALAssetsFilter * ALAssetsFilterFromQBImagePickerControllerFilterType(QBImagePickerControllerFilterType type) {
    switch (type) {
        case QBImagePickerControllerFilterTypeNone:
            return [ALAssetsFilter allAssets];
            break;
            
        case QBImagePickerControllerFilterTypePhotos:
            return [ALAssetsFilter allPhotos];
            break;
            
        case QBImagePickerControllerFilterTypeVideos:
            return [ALAssetsFilter allVideos];
            break;
    }
}

@interface QBImagePickerController () <QBAssetsCollectionViewControllerDelegate>

@property (nonatomic, strong, readwrite) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, copy, readwrite) NSArray *assetsGroups;
@property (nonatomic, strong,readwrite) NSMutableSet *selectedAssetURLs;

@end

@implementation QBImagePickerController

QBAssetsCollectionViewController *assetsCollectionViewController;

+ (BOOL)isAccessible
{
    return ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] &&
            [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]);
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        // Property settings
        self.selectedAssetURLs = [NSMutableSet set];
        
        self.groupTypes = @[
                            @(ALAssetsGroupSavedPhotos),
                            @(ALAssetsGroupAlbum)
                            ];
        self.filterType = QBImagePickerControllerFilterTypeNone;
        self.showsCancelButton = YES;
        
        // View settings
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        // Create assets library instance
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        self.assetsLibrary = assetsLibrary;
        
        // Register cell classes
        [self.tableView registerClass:[QBImagePickerGroupCell class] forCellReuseIdentifier:@"GroupCell"];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    // View controller settings
    self.title = NSLocalizedStringFromTable(@"", @"QBImagePickerController", nil);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load assets groups
    
    [self loadAssetsGroupsWithTypes:self.groupTypes
                         completion:^(NSArray *assetsGroups) {
                             self.assetsGroups = assetsGroups;
                             
                             [self.tableView reloadData];
                         }];
    
    // Validation
    if(self.maximumNumberOfSelection == 0)
        self.navigationItem.rightBarButtonItem.enabled = 0;
    else
        self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];

    
    
    
}


#pragma mark - Accessors

- (void)setShowsCancelButton:(BOOL)showsCancelButton
{
    _showsCancelButton = showsCancelButton;
    
    // Show/hide cancel button
    if (showsCancelButton) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:NO];
    } else {
        [self.navigationItem setLeftBarButtonItem:nil animated:NO];
    }
}

- (void)setAllowsMultipleSelection:(BOOL)allowsMultipleSelection
{
    _allowsMultipleSelection = allowsMultipleSelection;
    
    // Show/hide done button
    if (allowsMultipleSelection) {
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        [self.navigationItem setRightBarButtonItem:doneButton animated:NO];
    } else {
        [self.navigationItem setRightBarButtonItem:nil animated:NO];
    }
}


#pragma mark - Actions

- (void)done:(id)sender
{
    NSLog(@"self.selectedAssetURLs = %@",self.selectedAssetURLs);
    
    if(self.selectedAssetURLs.count == 0)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self  dismissTheLoaderAction];
        return;
    }
    else
    [self passSelectedAssetsToDelegate];
}

- (void)cancel:(id)sender
{
   
    NSArray *myArray = [self.selectedAssetURLs allObjects];
    
    for(int i = 0;i< myArray.count;i++)
    {
    
    NSURL *selectedAssetURL = [myArray objectAtIndex:i];
    [self.assetsLibrary assetForURL:selectedAssetURL
                        resultBlock:^(ALAsset *asset) {
                            [self assetsCollectionViewController:assetsCollectionViewController didDeselectAsset:asset];
                        } failureBlock:^(NSError *error) {
                            NSLog(@"Error: %@", [error localizedDescription]);
                        }];
    }
    
    
    // Delegate
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancelled:)]) {
        [self.delegate imagePickerControllerDidCancelled:self];
    }
}


#pragma mark - Validating Selections

- (BOOL)validateNumberOfSelections:(NSUInteger)numberOfSelections
{
    // Check the number of selected assets
    NSUInteger minimumNumberOfSelection = MAX(1, self.minimumNumberOfSelection);
    BOOL qualifiesMinimumNumberOfSelection = (numberOfSelections >= minimumNumberOfSelection);
    
    BOOL qualifiesMaximumNumberOfSelection = YES;
    if (minimumNumberOfSelection <= self.maximumNumberOfSelection) {
        qualifiesMaximumNumberOfSelection = (numberOfSelections <= self.maximumNumberOfSelection);
    }
    
    return (qualifiesMinimumNumberOfSelection && qualifiesMaximumNumberOfSelection);
}


#pragma mark - Managing Assets

- (void)loadAssetsGroupsWithTypes:(NSArray *)types completion:(void (^)(NSArray *assetsGroups))completion
{
    __block NSMutableArray *assetsGroups = [NSMutableArray array];
    __block NSUInteger numberOfFinishedTypes = 0;
    
    for (NSNumber *type in types) {
        __weak typeof(self) weakSelf = self;
        
        [self.assetsLibrary enumerateGroupsWithTypes:[type unsignedIntegerValue]
                                          usingBlock:^(ALAssetsGroup *assetsGroup, BOOL *stop) {
                                              if (assetsGroup) {
                                                  // Filter the assets group
                                                  [assetsGroup setAssetsFilter:ALAssetsFilterFromQBImagePickerControllerFilterType(weakSelf.filterType)];
                                                  
                                                  if (assetsGroup.numberOfAssets > 0) {
                                                      // Add assets group
                                                      [assetsGroups addObject:assetsGroup];
                                                  }
                                              } else {
                                                  numberOfFinishedTypes++;
                                              }
                                              
                                              // Check if the loading finished
                                              if (numberOfFinishedTypes == types.count) {
                                                  // Sort assets groups
                                                  NSArray *sortedAssetsGroups = [self sortAssetsGroups:(NSArray *)assetsGroups typesOrder:types];
                                                  
                                                  // Call completion block
                                                  if (completion) {
                                                      completion(sortedAssetsGroups);
                                                  }
                                              }
                                          } failureBlock:^(NSError *error) {
                                              NSLog(@"Error: %@", [error localizedDescription]);
                                          }];
    }
}

- (NSArray *)sortAssetsGroups:(NSArray *)assetsGroups typesOrder:(NSArray *)typesOrder
{
    NSMutableArray *sortedAssetsGroups = [NSMutableArray array];
    
    for (ALAssetsGroup *assetsGroup in assetsGroups) {
        if (sortedAssetsGroups.count == 0) {
            [sortedAssetsGroups addObject:assetsGroup];
            continue;
        }
        
        ALAssetsGroupType assetsGroupType = [[assetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
        NSUInteger indexOfAssetsGroupType = [typesOrder indexOfObject:@(assetsGroupType)];
        
        for (NSInteger i = 0; i <= sortedAssetsGroups.count; i++) {
            if (i == sortedAssetsGroups.count) {
                [sortedAssetsGroups addObject:assetsGroup];
                break;
            }
            
            ALAssetsGroup *sortedAssetsGroup = [sortedAssetsGroups objectAtIndex:i];
            ALAssetsGroupType sortedAssetsGroupType = [[sortedAssetsGroup valueForProperty:ALAssetsGroupPropertyType] unsignedIntegerValue];
            NSUInteger indexOfSortedAssetsGroupType = [typesOrder indexOfObject:@(sortedAssetsGroupType)];
            
            if (indexOfAssetsGroupType < indexOfSortedAssetsGroupType) {
                [sortedAssetsGroups insertObject:assetsGroup atIndex:i];
                break;
            }
        }
    }
    
    return [sortedAssetsGroups copy];
}

- (void)loadItem:(NSURL *)url withSuccessBlock:(void (^)(void))successBlock andFailureBlock:(void (^)(void))failureBlock {
    
    [self.assetsLibrary assetForURL:url
             resultBlock:^(ALAsset *asset)
     {
         if (asset)
         {
             //////////////////////////////////////////////////////
             // SUCCESS POINT #1 - asset is what we are looking for
             //////////////////////////////////////////////////////
             successBlock();
         }
         else
         {
             // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
             
             [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                    usingBlock:^(ALAssetsGroup *group, BOOL *stop)
              {
                  [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                      if([result.defaultRepresentation.url isEqual:url])
                      {
                          ///////////////////////////////////////////////////////
                          // SUCCESS POINT #2 - result is what we are looking for
                          ///////////////////////////////////////////////////////
                          successBlock();
                          *stop = YES;
                      }
                  }];
              }
              
                                  failureBlock:^(NSError *error)
              {
                  NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                  failureBlock();
                  
              }];
         }
         
     }
            failureBlock:^(NSError *error)
     {
         NSLog(@"Error: Cannot load asset - %@", [error localizedDescription]);
         failureBlock();
     }
     ];
}



- (void)passSelectedAssetsToDelegate
{
   
    
    
    // Load assets from URLs
    __block NSMutableArray *assets = [NSMutableArray array];
    for (NSURL *selectedAssetURL in self.selectedAssetURLs) {
        __weak typeof(self) weakSelf = self;
        
        //NSLog(@"selectedAssetURL:%@",selectedAssetURL);
        [self.assetsLibrary assetForURL:selectedAssetURL
                            resultBlock:^(ALAsset *asset)
                            {
                                // Add asset
                                NSLog(@"assett:%@",asset);
                                
                                if (asset)
                                {
                                    [assets addObject:asset];
                                }
                                else
                                {
                                    // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                                    
                                    [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                                                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                                     {
                                         // hiii
                                         if(group == nil)
                                         {
                                             return ;
                                         }
                                         
                                         [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                             if([result.defaultRepresentation.url isEqual:selectedAssetURL])
                                             {
                                                 NSLog(@"this caleed");
                                                [assets addObject:result];
                                                 *stop = YES;
                                             }
                                         }];
                                     }
                                     
                                    failureBlock:^(NSError *error)
                                     {
                                         NSLog(@"Error: Cannot load asset from photo stream - %@", [error localizedDescription]);
                                        
                                         
                                     }];
                                }

                                
                                // Check if the loading finished
                                if (assets.count == weakSelf.selectedAssetURLs.count) {
                                    // Delegate
                                    if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didSelectAssets:)]) {
                                        [self.delegate imagePickerController:self didSelectAssets:[assets copy]];
                                    }
                                }
                            }
                           failureBlock:^(NSError *error)
                            {
                                NSLog(@"Error: %@", [error localizedDescription]);
                            }];
    }
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.assetsGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QBImagePickerGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
    
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    cell.assetsGroup = assetsGroup;
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 86.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    assetsCollectionViewController = [[QBAssetsCollectionViewController alloc] initWithCollectionViewLayout:[SECollectionViewFlowLayout layoutWithAutoSelectRows:YES panToDeselect:YES autoSelectCellsBetweenTouches:NO]];
    assetsCollectionViewController.imagePickerController = self;
    assetsCollectionViewController.filterType = self.filterType;
    assetsCollectionViewController.allowsMultipleSelection = self.allowsMultipleSelection;
    assetsCollectionViewController.minimumNumberOfSelection = self.minimumNumberOfSelection;
    assetsCollectionViewController.maximumNumberOfSelection = self.maximumNumberOfSelection;
    
    ALAssetsGroup *assetsGroup = [self.assetsGroups objectAtIndex:indexPath.row];
    assetsCollectionViewController.delegate = self;
    assetsCollectionViewController.assetsGroup = assetsGroup;
    
    for (NSURL *assetURL in self.selectedAssetURLs) {
        [assetsCollectionViewController selectAssetHavingURL:assetURL];
    }
    
    [self.navigationController pushViewController:assetsCollectionViewController animated:YES];
}


#pragma mark - QBAssetsCollectionViewControllerDelegate

- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didSelectAsset:(ALAsset *)asset
{
    if (self.allowsMultipleSelection)
    {
        
        // Validation
        
       
        
        if(self.maximumNumberOfSelection == 0)
            self.navigationItem.rightBarButtonItem.enabled = 0;
        else

            self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];
        
        
        // Add asset URL
        
        
            NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
            if(![SMGlobalClass sharedInstance].wasSmallImageSelected)
            {
              [self.selectedAssetURLs addObject:assetURL];
            }
        
        
    }
    else
    {
        // Delegate
        
        // Add asset URL
        
        [self.selectedAssetURLs removeAllObjects];
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        if(![SMGlobalClass sharedInstance].wasSmallImageSelected)
        {
            [self.selectedAssetURLs addObject:assetURL];
        }
        
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didSelectAsset:)])
        {
            [self.delegate imagePickerController:self didSelectAsset:asset];
        }
    }
}
//**************************************************************
- (void)assetsCollectionViewController:(QBAssetsCollectionViewController *)assetsCollectionViewController didDeselectAsset:(ALAsset *)asset
{
    if (self.allowsMultipleSelection) {
        // Remove asset URL
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        
        //////////////// Monami issue resolved for image removed while tap on cancel for gallery ///////////
        
        
        if([SMGlobalClass sharedInstance].isTapOnCancel == NO){
        [self.selectedAssetURLs removeObject:assetURL];
                                                              }
        //////////////// END ///////////////////////////////
        // Validation
        if(self.maximumNumberOfSelection == 0)
            self.navigationItem.rightBarButtonItem.enabled = 0;
        else
            self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];
        
    }
    else
    {
        // Remove asset URL
        NSURL *assetURL = [asset valueForProperty:ALAssetPropertyAssetURL];
        [self.selectedAssetURLs removeObject:assetURL];
        
        // Validation
        if(self.maximumNumberOfSelection == 0)
            self.navigationItem.rightBarButtonItem.enabled = 0;
        else
            self.navigationItem.rightBarButtonItem.enabled = [self validateNumberOfSelections:self.selectedAssetURLs.count];
        
    }
}

- (void)assetsCollectionViewControllerDidFinishSelection:(QBAssetsCollectionViewController *)assetsCollectionViewController
{
    // Change Required
    
    if(self.selectedAssetURLs.count == 0)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
        [self  dismissTheLoaderAction];
        return;
    }
    else
        [self passSelectedAssetsToDelegate];
}

-(void)deleteTheImageFromTheFirstLibrary:(UIImage*)image
{
    [assetsCollectionViewController deleteTheImageFromTheFirstLibrary:image];
}

-(void)dismissTheLoaderAction
{
    [assetsCollectionViewController dismissTheLoaderAction];

}

-(void)deleteTheImageFromTheFirstLibraryWithIndex:(int)index
{

    NSArray *myArray = [self.selectedAssetURLs allObjects];
    
    NSLog(@"selected index = %d",index);
    
    NSURL *selectedAssetURL = [myArray objectAtIndex:index];
    [self.assetsLibrary assetForURL:selectedAssetURL
                        resultBlock:^(ALAsset *asset) {
                            [self assetsCollectionViewController:assetsCollectionViewController didDeselectAsset:asset];
                        } failureBlock:^(NSError *error) {
                            NSLog(@"Error: %@", [error localizedDescription]);
                        }];
    
}

-(void)deSelectAllTheSelectedPhotosWhenCancelAction
{
    
    NSArray *myArray = [self.selectedAssetURLs allObjects];
    
    for(int i=0;i< myArray.count;i++)
    {
    
    NSURL *selectedAssetURL = [myArray objectAtIndex:i];
    [self.assetsLibrary assetForURL:selectedAssetURL
                        resultBlock:^(ALAsset *asset) {
                            [self assetsCollectionViewController:assetsCollectionViewController didDeselectAsset:asset];
                        } failureBlock:^(NSError *error) {
                            NSLog(@"Error: %@", [error localizedDescription]);
                        }];
    }
    
}

@end
