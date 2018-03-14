//
//  SMCustomerDetailsDLScanObj.m
//  SmartManager
//
//  Created by Liji Stephen on 09/07/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMCustomerDetailsDLScanObj.h"

@implementation SMCustomerDetailsDLScanObj

@synthesize custAge,custCertificateNo,custClasses,custDOB,custGender,custIssuedDate,customerID,customerName,custRestriction,custPhoto;
@synthesize custEmailAddress,custPhoneNumber,custScanID;

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        self.arrayDriverVehicleClasses = [[NSMutableArray alloc] init];
    }
    
    return self;
}


@end
