//
//  SMInteriorReconditioningObject.h
//  Smart Manager
//
//  Created by Ketan Nandha on 30/12/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMInteriorReconditioningObject : NSObject

@property(nonatomic, strong)NSString *strInteriorReconditioningValue;
@property(nonatomic, strong)NSString *strReconditioningTypeID;

@property(nonatomic, strong)NSString *strTitle;
@property(nonatomic, strong)NSString *isCheckBoxSelected;
@property(nonatomic, strong)NSString *strValue;
@property(nonatomic,strong)NSMutableArray *arrmOptions;
@property(assign)BOOL isEmptyInputFieldAdded;
@end
