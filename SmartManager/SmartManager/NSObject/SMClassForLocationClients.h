//
//  SMClassForLocationClients.h
//  SmartManager
//
//  Created by Liji Stephen on 28/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMClassForLocationClients : NSObject

@property(assign)int locClientID;
@property(nonatomic,strong)NSString *locClientName;
@property(assign)BOOL isClientAlreadyAvailable;

@end
