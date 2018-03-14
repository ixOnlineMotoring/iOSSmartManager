//
//  SMRefreshDLList.h
//  Smart Manager
//
//  Created by Liji Stephen on 07/08/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMRefreshDLDelegate <NSObject>

-(void)refreshDLMethod;

@end

@interface SMRefreshDLList : NSObject
{
    id<SMRefreshDLDelegate>refeshDelegate;
}
@property (strong, nonatomic)id<SMRefreshDLDelegate>refeshDelegate;

//-(void)refreshMethodCall;
@end
