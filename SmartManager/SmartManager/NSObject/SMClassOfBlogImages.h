//
//  SMClassOfBlogImages.h
//  SmartManager
//
//  Created by Liji Stephen on 07/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMClassOfBlogImages : NSObject

@property(nonatomic,strong) NSString *imageSelected;
@property(nonatomic,strong) NSString *originalImagePath;
@property(nonatomic,strong) NSString *thumbImagePath;
@property(nonatomic,strong) NSString *imageOriginalFileName;
@property(assign) int imagePriorityIndex;
@property(nonatomic,strong) NSString *imageLink;
@property(assign)int imageID;
@property(assign)int blogPostID;
@property(assign)BOOL isImageFromLocal;

@property (nonatomic, assign) BOOL isImageFromCamera;
@property (nonatomic) int imageOriginIndex;

@end
