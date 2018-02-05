//
//  SMFullVerificationObjectXML.h
//  Smart Manager
//
//  Created by Ankit S on 8/29/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMVINVerificationXml.h"
@interface SMFullVerificationObjectXML : NSObject
@property int iStatus;
@property (strong,nonatomic) NSMutableArray *arrmFullVerification;
@property (strong,nonatomic) SMVINVerificationXml *objSMVINVerificationXml;
@end
