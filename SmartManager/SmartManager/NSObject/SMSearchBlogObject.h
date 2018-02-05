//
//  SMSearchBlogObject.h
//  SmartManager
//
//  Created by Liji Stephen on 02/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSearchBlogObject : NSObject

@property(nonatomic,strong)NSString *strTitle;
@property(assign) int blogPostTypeID;
@property(assign) int totalSearchedBlogPostCount;
@property(nonatomic,strong)NSString *strBlogPostType;
@property(nonatomic,strong)NSString *strDetails;
@property(nonatomic,strong)NSString *strCreatedDate;
@property(nonatomic,strong)NSString *strPublishDate;
@property(nonatomic,strong)NSString *strEndDate;
@property(nonatomic,strong)NSString *strName;
@property(nonatomic,strong)NSString *imgCount;
@property(nonatomic,strong)NSString *strImageURL;
@property(nonatomic,strong)NSString *strRemainingDaysCount;
@property(assign)int iTotal;

@end
