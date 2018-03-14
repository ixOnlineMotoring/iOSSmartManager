//
//  SMMessageHeaderObject.h
//  Smart Manager
//
//  Created by Prateek Jain on 05/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMMessageHeaderObject : NSObject

@property (strong, nonatomic)NSString *strDetails1;
@property (strong, nonatomic)NSString *strDetails2;
@property (assign)BOOL isSectionExpanded;
@property (strong, nonatomic)NSMutableArray *arrayOfInnerMessages;
@property (strong,nonatomic) NSString *strComments;

@end
