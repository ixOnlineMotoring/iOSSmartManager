//
//  VideoDetail+CoreDataProperties.h
//  Smart Manager
//
//  Created by Ketan Nandha on 10/05/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "VideoDetail+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface VideoDetail (CoreDataProperties)

+ (NSFetchRequest<VideoDetail *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *clientID;
@property (nullable, nonatomic, copy) NSString *memberID;
@property (nullable, nonatomic, copy) NSString *moduleIdentifier;
@property (nullable, nonatomic, copy) NSString *searchable;
@property (nullable, nonatomic, copy) NSString *variantId;
@property (nullable, nonatomic, copy) NSString *videoDescription;
@property (nullable, nonatomic, copy) NSString *videoFullPath;
@property (nullable, nonatomic, copy) NSString *videoTags;
@property (nullable, nonatomic, copy) NSString *videoTitle;
@property (nullable, nonatomic, copy) NSString *youtubeID;

@end

NS_ASSUME_NONNULL_END
