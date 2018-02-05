//
//  SMMemeberUpdateList.m
//  Smart Manager
//
//  Created by Sandeep on 06/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMMemeberUpdateList.h"

@implementation SMMemeberUpdateList
@synthesize memeberDelegate;
+ (id)sharedManager {
    static SMMemeberUpdateList *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)calledMemeberUpdateListDelegateMethod:(SMTradeMembersObject *)memeberObj andIsUpdate:(BOOL)isUpdate;
{
    if (self.memeberDelegate) {
        if ([self.memeberDelegate respondsToSelector:@selector(updateMemeberListObj:andIsUpdate:)]){
            [self.memeberDelegate updateMemeberListObj:memeberObj andIsUpdate:isUpdate];
        }
    }
}

@end
