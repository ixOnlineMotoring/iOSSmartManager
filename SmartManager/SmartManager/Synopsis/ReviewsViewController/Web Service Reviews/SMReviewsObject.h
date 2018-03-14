//
//  SMReviewsObject.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 24/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMReviewsObject : NSObject

@property (strong,nonatomic) NSString *strTitle;
@property (strong,nonatomic) NSString *strDate;
@property (strong,nonatomic) NSString *strBody;
@property (strong,nonatomic) NSString *strType;
@property (strong,nonatomic) NSMutableArray *arrmImages;
@property (strong,nonatomic) NSString *strAuthor;
@property (strong,nonatomic) NSString *strSource;

@property (assign) int reviewID;
@property(assign) BOOL isFromVariantSelection;
@end
