//
//  SMGlobalClass.h
//  SmartManager
//
//  Created by Liji Stephen on 08/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Reachability.h"
@interface SMGlobalClass : NSObject<NSURLSessionDelegate,NSURLSessionTaskDelegate>
{
     NSMutableArray *arrmStoredImages;
}

+(SMGlobalClass *)sharedInstance;
@property (retain, nonatomic)  Reachability* reach;
@property (nonatomic, strong) NSString *strIdentity;

@property (nonatomic, strong) NSString *strName;
@property (nonatomic, strong) NSString *strSurName;
@property (nonatomic, strong) NSString *strMemberID;
@property (nonatomic, strong) NSString *strClient;
@property (nonatomic, strong) NSString *strClientName;
@property (nonatomic, strong)NSString *strClientID;
@property (nonatomic, strong)NSString *strGroupID;
@property (nonatomic, strong)NSString *strDefaultClientID;
@property (nonatomic, strong)NSString *hashValue;
@property (nonatomic, strong) NSString *strCoreMemberID;
@property (nonatomic, strong) NSString *strPushNotificationUserID;
@property (nonatomic, strong) NSString *strHoldPreviousSearchString;// the previosly selected search string for the Vehicle in stock screen custom search popup.

@property (nonatomic,strong)NSIndexPath *indexpathForTaskDetails;
@property (nonatomic,strong)UIImage *imageThumbnailForVideo;
@property (assign)int selectedTaskId;
@property (assign)int totalImageSelected;

@property(assign)double googleLatitude;
@property(assign)double googleLongitude;

@property (assign)int photoExistingCount;
@property (assign)int receivedBlogPostID;
@property (assign)int selectedRowForCustomPopup;
@property (assign)BOOL isTheSortFirstAttemptForCustomPopup;
@property (assign)BOOL isTaskOverDue;
@property (assign)BOOL isListModule;
@property (assign)BOOL isFromCamera;
@property (assign)BOOL wasSmallImageSelected;
@property (assign)BOOL isBrochureFlag;
////////////////////////////Monami/////////////////////////////
@property (assign)BOOL isFromEbrochure;
////////////////////////// END ///////////////////////////////
@property (nonatomic,strong) NSIndexPath *indexpathOfSmallPhoto;
@property (nonatomic,strong) NSMutableArray *arrayOfModules;
@property (nonatomic,strong)NSMutableArray *arrayOfImpersonateClients;
@property (nonatomic,strong)NSMutableArray *filteredArrayForDashBoard;
@property (nonatomic,strong)NSMutableArray *filteredArrayForBottomBar;
@property (nonatomic,strong)NSMutableArray *arrayOfVideosToBeDeleted;
@property (nonatomic,strong)NSMutableArray *arrayOfImagesToBeDeleted;
@property (nonatomic,strong)NSMutableArray *arrayOfClientImages;

@property(nonatomic,strong)NSMutableArray *arrayOfMemberImages;
@property(nonatomic,strong)NSMutableArray *arrOfReviewsWithVariantModel;

@property(nonatomic,strong)NSString *Base64String_CustomerDLScan;

////////////Monami////////////////////////////////////

@property (assign)BOOL isTapOnCancel;

//////////////////////// END//////////////////

- (void)saveImage:(UIImage*)image imageName:(NSString*)imageName;
- (void)saveImageWithoutExtension:(UIImage*)image imageName:(NSString*)imageName;
- (NSString*)getImageFromImageName:(NSString*)imageName;
-(UIImage *)generateVideoThumbnailImage:(NSString *)url;
- (UIImage *)scaleAndRotateImage:(UIImage *)image;
-(MPMoviePlayerViewController *)allocMoviePlayerView:(NSString *)moviePath;
-(void) carryOutTheBackgroundUploadingofStoredVideos;
@property (assign)int videosTotalCount;
- (NSString *)saveVideo:(NSString *)videoURLs;
@end
