//
//  SMRefreshFilterData.h
//  SmartManager
//
//  Created by Jignesh on 09/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SMFilteringDataDelegates <NSObject>


-(void) gettingMakeListing;


@end

@interface SMRefreshFilterData : NSObject<NSXMLParserDelegate>
{

    //---web service access---
    
    NSMutableString *soapResults;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
    BOOL moduleElementFound;
    BOOL isAuthenticated;
    BOOL isImpersonateFound;
    NSString *AuthenticatedValue;
    
    NSMutableArray *arrOfUserDetails;
    NSMutableArray *arrOfModules;

    
}


-(void) fetchAllMakeListing;

@property(nonatomic,strong)id <SMFilteringDataDelegates> filteringDelegate;

@end
