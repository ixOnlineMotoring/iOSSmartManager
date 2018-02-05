//
//  SMReviewsObject.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 24/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMReviewsObject.h"

@implementation SMReviewsObject
-(id) init
{
    if(self=[super init])
    {
        self.strDate = @"";
        self.strBody = @"";
        self.strType = @"";
        self.strTitle = @"";
        self.strAuthor = @"";
        self.strSource = @"";
        
        
    }
    return self;
}
@end
