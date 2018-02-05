//
//  SMMemeberUpdateList.h
//  Smart Manager
//
//  Created by Sandeep on 06/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTradeMembersObject.h"

@protocol SMMemeberUpdateListDelegate <NSObject>
@required
- (void)updateMemeberListObj:(SMTradeMembersObject *)memeberObj andIsUpdate:(BOOL)isUpdate;

@end

@interface SMMemeberUpdateList : NSObject
@property (nonatomic, weak)id <SMMemeberUpdateListDelegate> memeberDelegate;
+ (id)sharedManager;
-(void)calledMemeberUpdateListDelegateMethod:(SMTradeMembersObject *)memeberObj andIsUpdate:(BOOL)isUpdate;
@end
