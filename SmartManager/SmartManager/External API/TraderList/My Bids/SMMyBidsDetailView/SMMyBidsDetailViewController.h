//
//  SMMyBidsDetailViewController.h
//  SmartManager
//
//  Created by Ketan Nandha on 27/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelBold.h"
#import "SMVehiclelisting.h"
#import "FGalleryViewController.h"
#import "MBProgressHUD.h"

@interface SMMyBidsDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,FGalleryViewControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource,NSXMLParserDelegate,MBProgressHUDDelegate>
{
    NSMutableArray          *arrayImages;
    NSMutableArray          *arraySliderImages;
    
    FGalleryViewController  *networkGallery;
    NSArray                 *networkCaptions;

    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    MBProgressHUD *HUD;
}
@property (strong, nonatomic) IBOutlet UITableView *tblViewMyBidsList;

@property (nonatomic,strong) IBOutlet UIButton *buttonImageClickable;
@property (nonatomic,strong) IBOutlet UIImageView *imageVehicle;

@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleName;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleMileage;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleColour;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleLocation;
@property (nonatomic,strong) IBOutlet SMCustomLabelBold *lblVehicleAmount;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIView *viewHeaderContainer;
@property (strong, nonatomic) IBOutlet UIView *viewCollectionContainer;

@property (strong, nonatomic) SMVehiclelisting *objectVehicleListing;

-(IBAction)buttonImageClickableDidPressed:(id) sender;

@end
