//
//  SMRefreshDLList.m
//  Smart Manager
//
//  Created by Liji Stephen on 07/08/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMRefreshDLList.h"

@implementation SMRefreshDLList
@synthesize refeshDelegate;

-(void)refreshMethodCall
{
    
    NSLog(@"%@",self.refeshDelegate);
    if ([self.refeshDelegate respondsToSelector:@selector(refreshDLMethod)]) {
        
        
        [self.refeshDelegate refreshDLMethod];
    }
}

@end
