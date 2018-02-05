//
//  SMObjectAverageDaysXml.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 17/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMObjectAverageDaysXml : NSObject
@property int iStatus;
@property(strong,nonatomic) NSString *strCityName;
@property(strong,nonatomic) NSMutableArray *arrmAverageDays;
@end
