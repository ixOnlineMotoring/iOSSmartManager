//
//  SMNotificationObject.h
//  SmartManager
//
//  Created by Liji Stephen on 11/05/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMNotificationObject : NSObject

@property(assign)int notiLeadID;
@property(nonatomic,strong)NSString *notiUserName;
@property(nonatomic,strong)NSString *notiUserPhone;
@property(nonatomic,strong)NSString *notiUserEmail;
@property(nonatomic,strong)NSString *notiVehicleName;
@property(nonatomic,strong)NSString *notiVehicleColor;
@property(nonatomic,strong)NSString *notiVehicleDist;
@property(nonatomic,strong)NSString *notiTime;


@end
