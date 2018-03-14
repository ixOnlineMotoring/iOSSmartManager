//
//  SMEditSearchObject.h
//  SmartManager
//
//  Created by Liji Stephen on 06/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMEditSearchObject : NSObject

@property(assign)BOOL activeStatus;
@property(assign)BOOL isDeleted;
@property(assign) int blogPostTypeID;
@property(assign) int blogPostID;
@property(assign) int userID;
@property(nonatomic,strong)NSString *strDetails;
@property(nonatomic,strong)NSString *strCreatedDate;
@property(nonatomic,strong)NSString *strPublishDate;
@property(nonatomic,strong)NSString *strEndDate;
@property(nonatomic,strong)NSString *strTitle;
@property(nonatomic,strong)NSString *imgCount;
@property(nonatomic,strong)NSString *strAuthor;
@property(nonatomic,strong)NSString *strImageURL;

@end
