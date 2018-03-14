//
//  SMClassForToDoMemberLocationObject.h
//  SmartManager
//
//  Created by Liji Stephen on 11/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMClassForToDoInnerObjects.h"


@interface SMClassForToDoMemberLocationObject : NSObject

@property(assign)int strTaskID;
@property(nonatomic,strong)NSString *strTaskName;
@property(nonatomic,strong)NSString *strTaskDueDate;
@property(assign)BOOL isTaskNew;
@property(assign)BOOL isTaskOverDue;
@property(assign)BOOL isToday;
@property(assign)BOOL isExpandable;
@property(assign)int taskTargetClientID;
@property(nonatomic,strong)NSString *taskTargetClientName;

@property (nonatomic, strong) NSMutableArray *arrayImages;
@property (strong, nonatomic) SMClassForToDoInnerObjects *taskDetailObject;


@end
