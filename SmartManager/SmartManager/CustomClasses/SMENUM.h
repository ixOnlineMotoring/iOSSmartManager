//
//  SMENUM.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#ifndef SMENUM_h
#define SMENUM_h

typedef enum
{
    kWSCrash = 1,
    kWSNoRecord,
    kWSSuccess,
    kWSError,
    kWSNOGroupIdFound,
    kWSNOVINNoFound,
} WebServiceStatus;

typedef enum
{
    kLPClient = 0,
    kLPGroup,
} LeadPool;


typedef enum
{
    kCurrentlyFinanced = 1,
    kFinanceHistory,
    kAlert,
    kIVIDHistory,
    kStolen,
    kMicrodot,
    kVesa,
    kMileageHistory,
    kRegistrationHistory,
    kFactoryFittedExtra,
    kAccidentHistory,
    kEnquiryHistory
} FullVerification;

#endif /* SMENUM_h */
