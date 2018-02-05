//
//  SMGlobalClassForImpersonation.h
//  SmartManager
//
//  Created by Liji Stephen on 21/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMImpersonateObject.h"
#import "MBProgressHUD.h"

@protocol impersonateClientsDelegate <NSObject>

-(void) sendTheImpersonateClients:(NSMutableArray*)arrayOfImpersonateClients;

@end



@interface SMGlobalClassForImpersonation : NSObject<NSXMLParserDelegate,MBProgressHUDDelegate>
{
    NSMutableString *soapResults;
    NSXMLParser *xmlParser;
    MBProgressHUD *HUD;
}

+(SMGlobalClassForImpersonation *)sharedInstance;
-(void)parseTheImpersonateClients;

@property (nonatomic, strong)NSString *strImpersonateString;
//@property (nonatomic, strong) NSMutableArray *arrayOfImpersonateObj;
@property (nonatomic, strong) SMImpersonateObject *impersonateClientObj;

@property (nonatomic, weak) id <impersonateClientsDelegate> impersonateDelegate;


@end
