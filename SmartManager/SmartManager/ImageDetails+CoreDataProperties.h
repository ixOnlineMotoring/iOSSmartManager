//
//  ImageDetails+CoreDataProperties.h
//  Smart Manager
//
//  Created by Ketan Nandha on 16/03/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import "ImageDetails+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface ImageDetails (CoreDataProperties)

+ (NSFetchRequest<ImageDetails *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *imagePath;
@property (nullable, nonatomic, copy) NSString *imagePriority;
@property (nullable, nonatomic, copy) NSString *moduleIdentifier;
@property (nullable, nonatomic, copy) NSString *vehicleStockID;
@property (nullable, nonatomic, copy) NSString *clientID;
@property (nullable, nonatomic, copy) NSString *memberID;
@property (nullable, nonatomic, copy) NSString *imageFileName;
@end

NS_ASSUME_NONNULL_END
