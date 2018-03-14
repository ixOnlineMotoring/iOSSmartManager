//
//  SMClassForToDoMemberLocationObject.m
//  SmartManager
//
//  Created by Liji Stephen on 11/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMClassForToDoMemberLocationObject.h"

@implementation SMClassForToDoMemberLocationObject

@synthesize strTaskID,strTaskName,strTaskDueDate,isExpandable,isToday,isTaskNew,taskTargetClientID,taskTargetClientName,isTaskOverDue;

-(instancetype)init
{
    
    if (self = [super init])
    {
        self.arrayImages = [[NSMutableArray alloc] init];
        self.taskDetailObject = [[SMClassForToDoInnerObjects alloc]init];

    }
    return self;
}

@end
