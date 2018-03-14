//
//  SMSimilarVehicleXmlObject.h
//  Smart Manager
//
//  Created by Ankit S on 6/30/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMDropDownObject.h"

@interface SMSimilarVehicleXmlObject : NSObject
@property int iStatus;
@property (strong,nonatomic) NSString *strYearYoungerCnt;
@property (strong,nonatomic) NSString *strOtherModelsCnt;
@property (strong,nonatomic) NSString *strYearOlderCnt;
@property (strong,nonatomic) NSMutableArray *arrOfYearYoungerVehicles;
@property (strong,nonatomic) NSMutableArray *arrOfOtherModelVehicles;
@property (strong,nonatomic) NSMutableArray *arrOfYearOlderVehicles;
@property(strong, nonatomic) SMDropDownObject *objIndividualObj; // using the same object to storing values instead of creating new ones everytime.
@end
