//
//  SMVideoInfoViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 07/10/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
#import "SMCustomTextField.h"
#import "CustomTextView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "SMMoviePlayerClass.h"
#import "SMClassOfUploadVideos.h"

@interface SMVideoInfoViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UIScrollView *scrollVieww;
    IBOutlet UIView *viewContentView;
    IBOutlet UIImageView *imgViewVideoThumnail;
    IBOutlet SMCustomLable *lblTitle;
    IBOutlet SMCustomLable *lblTags;
    IBOutlet SMCustomLable *lblDescription;
    IBOutlet SMCustomLable *lblSearchable;
    IBOutlet SMCustomTextField *txtFieldTitle;
    IBOutlet SMCustomTextField *txtFieldTags;
    IBOutlet CustomTextView *txtViewDesc;
    IBOutlet UIButton *btnSaveInfo;
     IBOutlet UIButton *btnIsSearchable;
    
    BOOL isDetailsSaved;
}

typedef void (^SMCompetionBlockVideoInfo)(int indexPath, BOOL isSearchable, NSString *videoTitle, NSString *videoTag,NSString *videoDesc);

+(void)getTheVideoInfoWithCallBack:(SMCompetionBlockVideoInfo)callBackVideoInfo;

@property(assign)BOOL isVideoFromServer;
@property(strong,nonatomic)UIImage *thumbNailImage;
@property(strong,nonatomic)NSString *videoPathURL;
@property(strong,nonatomic)NSString *vehicleName;
@property(assign)BOOL isFromCameraView;
@property(assign)BOOL isFromListPage;
@property(assign)BOOL isFromPhotosNExtrasDetailPage;
@property(assign)BOOL isFromSendBrochureDetailPage;
@property(assign)BOOL isFromAddToStockPage;

@property(assign)int indexpathOfSelectedVideo;
@property(strong,nonatomic)SMClassOfUploadVideos *videoObject;

- (IBAction)btnSearchableDidClicked:(id)sender;

- (IBAction)btnSaveInfoDidClicked:(id)sender;






@end
