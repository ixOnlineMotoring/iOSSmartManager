//
//  SMCustomCellForTodayTableViewCell.h
//  SmartManager
//
//  Created by Liji Stephen on 05/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomTextField.h"
#import "SMDonePlannerButton.h"
#import "FGalleryViewController.h"
#import "SMClassOfBlogImages.h"
#import "SMClassForToDoMemberLocationObject.h"

@protocol pushingViewContollerForEnlargingPhotoDelegate <NSObject>

-(void) pushTheViewControllerForEnlargedImageWithObject:(FGalleryViewController*)galleryObject;

@optional
-(void)reloadTableView;

@end

@interface SMCustomCellForTodayTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate, FGalleryViewControllerDelegate,NSXMLParserDelegate,UITextFieldDelegate>
{

    
    // For Gallery View
    
    NSArray                     *   localCaptions;
    NSArray                     *   localImages;
    NSArray                     *   networkCaptions;
    NSArray                     *   networkImages;
    FGalleryViewController      *   localGallery;
    FGalleryViewController      *   networkGallery;
    
//    NSMutableArray *arrayFullImages;
     NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;

}

@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lblDesc;

@property (strong, nonatomic) IBOutlet SMCustomTextField *txtFieldComments;

@property (strong, nonatomic) IBOutlet SMDonePlannerButton *btnDone;


@property (strong, nonatomic) IBOutlet UILabel *lblDueName;


@property (strong, nonatomic) IBOutlet UILabel *lblDueDesc;


@property (strong, nonatomic) IBOutlet SMDonePlannerButton *btnReject;

@property (strong, nonatomic) IBOutlet SMDonePlannerButton *btnAccept;

@property (strong, nonatomic) IBOutlet UILabel *lblDefaultName;


@property (strong, nonatomic) IBOutlet UILabel *lblCellTitle;

@property (strong, nonatomic) IBOutlet UILabel *lblCellTitleToday;

@property (strong, nonatomic) IBOutlet SMDonePlannerButton *btnCellCollapse;


@property (strong, nonatomic) IBOutlet UILabel *lblNew;


@property (strong, nonatomic) IBOutlet UILabel *lblAuthorName;

@property (strong, nonatomic) IBOutlet UILabel *lblAssigneName;

@property (strong, nonatomic) IBOutlet SMDonePlannerButton *btnNoCanDo;

@property (strong, nonatomic) IBOutlet UILabel *lblDueAuthorName;

@property (strong, nonatomic) IBOutlet UILabel *lblDueAssigneName;

@property (strong, nonatomic) IBOutlet UILabel *lblAuthorNameValue;

@property (strong, nonatomic) IBOutlet UILabel *lblAssigneeNameValue;


@property (strong, nonatomic) IBOutlet UILabel *lblAuthorNameDueValue;

@property (strong, nonatomic) IBOutlet UILabel *lblAssigneeNameDueValue;

@property (strong, nonatomic) IBOutlet UIButton *btnLoadMore;

@property (strong, nonatomic) IBOutlet UIView *viewLineReadMore;

@property (strong, nonatomic) IBOutlet UICollectionView *sliderCollection;


@property (strong, nonatomic) IBOutlet UILabel *lblNoImagesAvailable;

@property (strong, nonatomic) IBOutlet UIView *BottomViewToBeShifted;


@property (nonatomic, weak) id <pushingViewContollerForEnlargingPhotoDelegate> enlargePhotoDelegate;


@property (strong, nonatomic) SMClassOfBlogImages *imageObject;

@property (strong, nonatomic) SMClassForToDoMemberLocationObject *doDoMemberLocationObj;


@property (strong, nonatomic) IBOutlet UIView *bottomViewForShifting;

@property (strong, nonatomic) IBOutlet UIView *viewContainingButtons;


@property (strong, nonatomic) IBOutlet SMDonePlannerButton *btnCancelTask;


- (IBAction)btnCancelTaskDidClicked:(id)sender;

- (IBAction)btnNoCanDoDidClicked:(id)sender;

- (IBAction)btnCellColapseDidClicked:(id)sender;


-(IBAction)btnRejectDidClicked:(UIButton*)sender event:(UIEvent*)event;


- (IBAction)btnAcceptDidClicked:(id)sender;

- (IBAction)btnDoneForCommentsDidClicked:(id)sender;

-(void)getAllTheImages;



@end
