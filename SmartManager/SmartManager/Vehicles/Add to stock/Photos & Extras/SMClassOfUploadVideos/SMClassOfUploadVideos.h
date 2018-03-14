//
//  SMClassOfUploadVideos.h
//  SmartManager
//
//  Created by Sandeep on 17/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SMClassOfUploadVideos : NSObject

@property (nonatomic, assign) BOOL isVideoFromLocal;
@property (nonatomic, copy) NSString *localYouTubeURL;
@property (nonatomic, strong) UIImage *thumnailImage;
@property (nonatomic, assign)BOOL isUploaded;
@property (nonatomic, copy) NSString *videoThumbnailImageURL;
@property(nonatomic, copy)NSString *videoTitle;
@property(nonatomic, copy)NSString *videoTags;
@property(nonatomic, copy)NSString *videoDescription;
@property (nonatomic, assign)BOOL isSearchable;
@property (nonatomic, strong) NSString *youTubeID;
@property (assign) int videoLinkID;
@property (nonatomic, strong) NSString *videoFullPath;

@end
