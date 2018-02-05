//
//  SMConditionOptionsObject.h
//  Smart Manager
//
//  Created by Ketan Nandha on 16/01/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMConditionOptionsObject : NSObject

@property(strong, nonatomic)NSString *optionID;
@property(strong, nonatomic)NSString *optionValue;
@property(assign)BOOL isOptionSelected;

@end
