//
//  SMVINVerificationXml.m
//  Smart Manager
//
//  Created by Ankit S on 8/31/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMVINVerificationXml.h"

@implementation SMVINVerificationXml


-(id)init{
    
    if(self=[super init])
    {
        self.strTUA_VehicleCodeAndDescriptionID=@"";
        self.strTUA_ConvergedDataIDForCode=@"";
        self.strDiscontinuedDate=@"";
        self.strIntroductionDate=@"";
        self.strResultCode=@"";
        self.strResultCodeDescription=@"";
        self.strTUA_VehicleConfirmationID=@"";
        self.strTUA_ConvergedDataIDForVehicle=@"";
        self.strMatchColour=@"";
        self.strHPINumber=@"";
        self.strMatchEngineNumber=@"";
        self. strMatchModel=@"";
        self.strMatchString=@"";
        self.strMatchVehicleRegistration=@"";
        self.strMatchVinorChassis=@"";
        self.strMatchYear=@"";
        self.strMatchManufacturer=@"";
        self.str1YearLicenced=@"";
        self.strWarrantyYear=@"";
        self.strLicenceExpiry=@"";
    }
    
    return self;
}
@end
