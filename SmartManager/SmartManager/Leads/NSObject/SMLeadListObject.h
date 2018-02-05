//
//  SMLeadListObject.h
//  SmartManager
//
//  Created by Liji Stephen on 30/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMLeadListObject : NSObject

@property(assign)int leadID;
@property(nonatomic,strong)NSString *leadMobileNumber;
@property(nonatomic,strong)NSString *leadTitle;
@property(nonatomic,strong)NSString *leadVehicleName;
@property(nonatomic,strong)NSString *leadEmailID;
@property(nonatomic,strong)NSString *leadTime;
@property(assign)BOOL isSeen;
@property(assign)BOOL isRedColorText;;

@property(nonatomic,strong)NSString *leadLastUpdateDate;
@property(nonatomic,strong)NSString *leadLastUpdateAction;
@property(nonatomic,strong)NSMutableArray *arrOfVehicleDetails;


@property(assign)int iCountOfLeadForEachRow;


@property(strong,nonatomic) NSString *strName;
@property(assign) int activityID;


@property(nonatomic,strong)NSString *strLeadMileage;
@property(strong, nonatomic) NSString *strLeadyear;

@end
