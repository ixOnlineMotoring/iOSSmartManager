//
//  ImageDetails+CoreDataProperties.m
//  Smart Manager
//
//  Created by Ketan Nandha on 16/03/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import "ImageDetails+CoreDataProperties.h"

@implementation ImageDetails (CoreDataProperties)

+ (NSFetchRequest<ImageDetails *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"ImageDetails"];
}

@dynamic imagePath;
@dynamic imagePriority;
@dynamic moduleIdentifier;
@dynamic vehicleStockID;
@dynamic clientID;
@dynamic memberID;
@dynamic imageFileName;

@end
