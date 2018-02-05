//
//  SMReviewsXmlResultObject.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 24/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMReviewsObject.h"
@interface SMReviewsXmlResultObject : NSObject
@property int iStatus;
@property (strong,nonatomic) NSString *strOtherMakeName;
@property (strong,nonatomic) NSString *strOtherModelName;
@property (strong,nonatomic) NSMutableArray *arrmReviews;
@end
