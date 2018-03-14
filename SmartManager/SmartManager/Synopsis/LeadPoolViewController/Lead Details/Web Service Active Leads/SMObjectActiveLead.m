//
//  SMObjectActiveLead.m
//  Smart Manager
//
//  Created by Ankit S on 8/10/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMObjectActiveLead.h"

@implementation SMObjectActiveLead


-(id) init
{
    if(self=[super init])
    {
        self.strLeadID=@"";
        self.strYear=@"";
        self.strNewOrUsed=@"";
        self.strMakeName=@"";
        self.strModelName=@"";
        self.strVariantName=@"";
        self.strProspectName=@"";
        self.strProspectContactNumber=@"";
        self.strProspectEmail=@"";
        self.strSalesPerson=@"";
        self.strLeadAgeInDays=@"";
    }
    return self;
}
@end
