//
//  SMGridModuleData.h
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMGridModuleData : NSObject

@property(nonatomic,strong)NSString *moduleName;
@property(assign)BOOL isQuickLink;
@property(assign)BOOL isAlertPresent;
@property(nonatomic,strong) NSMutableArray *arrayOfPages;

@end
