//
//  SMVINLookupObject.m
//  SmartManager
//
//  Created by Priya on 17/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMVINLookupObject.h"

@implementation SMVINLookupObject

@synthesize Entry0 ;
@synthesize Entry1 ;
@synthesize Entry2 ;
@synthesize Entry3;
@synthesize Entry4 ;
@synthesize Registration ;
@synthesize Entry6 ;
@synthesize Shape ;
@synthesize Make ;
@synthesize Model ;
@synthesize Colour ;
@synthesize VIN ;
@synthesize EngineNo ;
@synthesize DateExpires;
@synthesize savedScanID;
@synthesize geoLocationAddress, variant;

-(id) init
{
    if(self=[super init])
    {
        self.Entry0 = @"";
        self.Entry1 = @"";
        self.Entry2 = @"";
        self.Entry3 = @"";
        self.Entry4 = @"";
        self.Registration = @"";
        self.Entry6 = @"";
        self.Shape = @"";
        self.Make = @"";
        self.Model = @"";
        self.Colour = @"";
        self.VIN = @"";
        self.EngineNo = @"";
        self.DateExpires = @"";
        self.savedScanID = @"";
        self.geoLocationAddress = @"";
        self.variant = @"";
        self.Shape = @"";
        self.Model = @"";
        self.Make = @"";
        self.strScannedDate = @"";
        self.strKiloMeters = @"";
        self.strYear = @"";
        self.Entry6 = @"";
        self.Shape = @"";
        self.Make = @"";
        self.strExtras = @"";
        self.Colour = @"";
        self.VIN = @"";
        self.EngineNo = @"";
        self.DateExpires = @"";
        self.savedScanID = @"";
        self.strVariantName = @"";
        self.strLocation = @"";
        self.standR = @"";
        self.oemNo = @"";
        self.regNumber = @"";
        self.internalNote = @"";
        self.trim = @"";
        self.costR = @"";
    }
    return self;
}


@end
