//
//  SMBlogPostTypeObject.h
//  SmartManager
//
//  Created by Liji Stephen on 22/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMBlogPostTypeObject : NSObject

@property(nonatomic,strong)NSString *blogPostType;
@property(assign) int blogPostTypeID;
@property(nonatomic,strong)NSString *activeStatus;

@end
