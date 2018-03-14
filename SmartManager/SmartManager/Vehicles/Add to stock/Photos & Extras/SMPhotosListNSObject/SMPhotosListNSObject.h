//
//  SMPhotosListNSObject.h
//  SmartManager
//
//  Created by Sandeep on 12/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface SMPhotosListNSObject : NSObject

@property (assign, nonatomic) int uciID;
@property (assign, nonatomic) int imageID;
@property (assign, nonatomic) int imagePriority;
@property (copy, nonatomic) NSString *imageTypeName;
@property (copy, nonatomic) NSString *imagePath;
@property (copy, nonatomic) NSString *imageLink;
@property (strong, nonatomic) NSString *OriginalImageLink;
@property (copy, nonatomic) NSString *imageSize;
@property (copy, nonatomic) NSString *imageRes;
@property (assign, nonatomic) int imageType;
@property (assign, nonatomic) int ImageDPI;
@property (nonatomic, strong) NSString *strimageName;
@property (nonatomic, assign) BOOL isImageFromLocal;
@property (nonatomic, assign) BOOL isImageFromCamera;

@property (nonatomic, assign) int imagePriorityIndex;

@property (copy, nonatomic) NSString *comments;
@property (copy, nonatomic) NSString *extras;

@property(strong, nonatomic) NSString *strSpecialID;
@property(nonatomic) int  isLinkImagePriorityD;
@property(strong, nonatomic) NSString *strSpecialImageID;

@property (nonatomic, strong) ALAsset *imageAsset;
@property (nonatomic) int imageOriginIndex;


@property(strong, nonatomic) NSString *strAUTOSpecialImageID;
@property(strong, nonatomic) NSString *strOriginalFileName;
@property(strong, nonatomic) NSString *strPriority;
@property(strong, nonatomic) NSString *strAUTOSpecialID;
@property(strong, nonatomic) NSString *strIsSpecials;
@property(strong, nonatomic) NSString *strExtensionFromCloud;
@property(strong, nonatomic) UIImage *imgThumbnailFromCloud;
@property(strong, nonatomic) UIImage *nameOfFile;
@property(strong, nonatomic) NSData *dataFromiCloudFile;
@property(strong,nonatomic)  NSURL *urlFromCloud;
@end
