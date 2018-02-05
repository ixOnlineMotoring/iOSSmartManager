//
//  SMObjectLeadPoolXml.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMObjectLeadPoolXml : NSObject
{

}


@property int iStatus;
@property (strong,nonatomic) NSString *strClientName;
@property (strong,nonatomic) NSString *strGroupName;
@property (strong,nonatomic) NSString *strClientActiveLeads;
@property (strong,nonatomic) NSString *strClientLostLeads;
@property (strong,nonatomic) NSString *strGroupActiveLeads;
@property (strong,nonatomic) NSString *strGroupLostLeads;



@end
