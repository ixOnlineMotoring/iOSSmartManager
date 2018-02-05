//
//  SMClassOfPhotoAndVideoImages.h
//  SmartManager
//
//  Created by Sandeep on 10/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMClassOfPhotoAndVideoImages : NSObject

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *strimageName;
@property (nonatomic, assign) BOOL isImageFromLocal;
@property (nonatomic, assign) BOOL isPrioritiesChanged;
@property (nonatomic, assign) int imagePriorityIndex;
@property (nonatomic, assign) int imageID;
@property (nonatomic, assign) int newPriorityID;
@property (nonatomic, strong) NSString *strImageLink;
@end
