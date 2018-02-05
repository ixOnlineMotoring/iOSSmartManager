//
//  SMClassForToDoObjects.h
//  SmartManager
//
//  Created by Liji Stephen on 05/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMClassForToDoObjects : NSObject

@property(assign)int strSectionID;
@property(nonatomic,strong)NSString *strSectionName;
@property(nonatomic,strong)NSMutableArray *arrayOfInnerObjects;
@property (nonatomic) BOOL isExpanded;

@property(assign) int iCountOfLeadForEachRow;
@end
