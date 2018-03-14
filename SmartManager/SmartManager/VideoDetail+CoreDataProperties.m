//
//  VideoDetail+CoreDataProperties.m
//  Smart Manager
//
//  Created by Ketan Nandha on 10/05/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//  This file was automatically generated and should not be edited.
//

#import "VideoDetail+CoreDataProperties.h"

@implementation VideoDetail (CoreDataProperties)

+ (NSFetchRequest<VideoDetail *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"VideoDetail"];
}

@dynamic clientID;
@dynamic memberID;
@dynamic moduleIdentifier;
@dynamic searchable;
@dynamic variantId;
@dynamic videoDescription;
@dynamic videoFullPath;
@dynamic videoTags;
@dynamic videoTitle;
@dynamic youtubeID;

@end
