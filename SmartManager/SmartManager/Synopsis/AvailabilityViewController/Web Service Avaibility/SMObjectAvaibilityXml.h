//
//  SMObjectAvaibilityXml.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMObjectAvaibilityXml : NSObject
@property int iStatus;
@property (strong,nonatomic) NSMutableArray *arrmAvaibility;
@property(strong,nonatomic) NSString *strProvinceName;
@property(strong,nonatomic) NSString *strGroupName;
@end
