//
//  SMReviewsXmlResultObject.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 24/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMReviewsXmlResultObject.h"

@implementation SMReviewsXmlResultObject
-(id) init
{
    if(self=[super init])
    {
        self.strOtherMakeName = @"";
        self.strOtherModelName = @"";
    }
    return self;
}

@end
