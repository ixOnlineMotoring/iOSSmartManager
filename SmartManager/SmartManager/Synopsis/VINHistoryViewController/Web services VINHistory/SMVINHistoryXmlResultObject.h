//
//  SMVINHistoryXmlResultObject.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 02/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMVINHistoryXmlResultObject : NSObject

@property (strong,nonatomic) NSString *strVIN;
@property (strong,nonatomic) NSString *strEngineNo;
@property (strong,nonatomic) NSString *strVehicleName;
@property (strong,nonatomic) NSString *strDepartment;

@property (strong,nonatomic) NSMutableArray *arrmForDetails;
@property int iStatus;
@end
