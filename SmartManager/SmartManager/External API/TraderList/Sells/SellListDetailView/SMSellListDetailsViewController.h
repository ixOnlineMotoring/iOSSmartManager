//
//  SMSellListViewController.h
//  SmartManager
//
//  Created by Ketan Nandha on 08/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMVehiclelisting.h"
#import "SMCustomLabelBold.h"
#import "MBProgressHUD.h"
#import "FGalleryViewController.h"

@interface SMSellListDetailsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,MBProgressHUDDelegate,NSXMLParserDelegate,FGalleryViewControllerDelegate>
{
    NSMutableArray      *arrayListVehicles;
    NSMutableArray      *arrayImages;
    NSMutableArray      *arraySliderImages;

    MBProgressHUD       *HUD;
    NSXMLParser         *xmlParser;
    NSMutableString     *currentNodeContent;
    
    FGalleryViewController  *networkGallery;
    NSArray                 *networkCaptions;
}

@property (strong, nonatomic) IBOutlet UITableView *tblViewSellList;

@property (strong, nonatomic) SMVehiclelisting *objectVehicleListing;

@property (strong, nonatomic) IBOutlet UIView *viewHeaderContainer;
@property (strong, nonatomic) IBOutlet UIView *viewCollectionContainer;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) IBOutlet UIImageView *imageVehicle;
@property (nonatomic,strong) IBOutlet UIButton *buttonImageClickable;

@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleName;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleMileage;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleColour;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleLocation;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleAmount;

- (IBAction)buttonImageClickableDidClicked:(id)sender;

@end
