//
//  SMObjectActiveLead.h
//  Smart Manager
//
//  Created by Ankit S on 8/10/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMObjectActiveLead : NSObject


@property (strong,nonatomic) NSString *strLeadID;
@property (strong,nonatomic) NSString *strYear;
@property (strong,nonatomic) NSString *strNewOrUsed;
@property (strong,nonatomic) NSString *strMakeName;
@property (strong,nonatomic) NSString *strModelName;
@property (strong,nonatomic) NSString *strVariantName;
@property (strong,nonatomic) NSString *strProspectName;
@property (strong,nonatomic) NSString *strProspectContactNumber;
@property (strong,nonatomic) NSString *strProspectEmail;
@property (strong,nonatomic) NSString *strSalesPerson;
@property (strong,nonatomic) NSString *strLeadAgeInDays;

@end
