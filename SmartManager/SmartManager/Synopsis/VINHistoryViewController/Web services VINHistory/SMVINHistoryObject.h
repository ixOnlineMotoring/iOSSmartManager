//
//  SMVINHistoryObject.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 02/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMVINHistoryObject : NSObject

@property (strong,nonatomic) NSString *strLastSeen;
@property (strong,nonatomic) NSString *strDealer;
@property (strong,nonatomic) NSString *strLocation;
@property (strong,nonatomic) NSString *strMileage;
@property (strong,nonatomic) NSString *strPrice;

@end
