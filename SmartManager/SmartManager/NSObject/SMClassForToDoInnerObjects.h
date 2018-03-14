//
//  SMClassForToDoInnerObjects.h
//  SmartManager
//
//  Created by Liji Stephen on 05/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMClassForToDoInnerObjects : NSObject

@property(assign)int strRowID;
@property(nonatomic,strong)NSString *strRowName;
@property(assign)BOOL isToday;
@property(assign)BOOL isExpandable;

// Task Details

@property(nonatomic,strong)NSString *taskAuthorName;
@property(nonatomic,strong)NSString *taskAssigneeName;
@property(nonatomic,strong)NSString *taskDetails;
@property(nonatomic,strong)NSString *taskDueDate;
@property(assign)int taskState;
@property(assign)BOOL taskStatus;

@property(nonatomic,strong)NSString *taskTitle;


@end
