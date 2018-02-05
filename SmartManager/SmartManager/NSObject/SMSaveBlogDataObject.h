//
//  SMSaveBlogDataObject.h
//  SmartManager
//
//  Created by Liji Stephen on 30/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSaveBlogDataObject : NSObject

@property(nonatomic,strong)NSString *strTitle;
@property(nonatomic,strong)NSString *strAuthorName;
@property(nonatomic,strong)NSString *strPostedDate;
@property(nonatomic,strong)NSString *strExpiryDate;
@property(nonatomic,strong)NSString *strBlogDetails;
@property(nonatomic,strong)NSMutableArray *arrOfImages;


@end
