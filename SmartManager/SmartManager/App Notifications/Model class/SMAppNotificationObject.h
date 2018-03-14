//
//  SMAppNotificationObject.h
//  Smart Manager
//
//  Created by Ketan Nandha on 07/02/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMAppNotificationObject : NSObject

@property(nonatomic,strong) NSString *strMessageID;
@property(nonatomic,strong) NSString *strMessage;
@property(nonatomic,strong) NSString *strHeading;
@property(nonatomic,strong) NSString *strSentDate;
@property(nonatomic,strong) NSString *strSource;
@property(nonatomic,strong) NSString *strIdentity;
@property(nonatomic,strong) NSString *strIsRead;


@end
