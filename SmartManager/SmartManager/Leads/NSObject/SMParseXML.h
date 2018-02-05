//
//  SMParseXML.h
//  Smart Manager
//
//  Created by Tejas on 07/09/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMParseXML : NSObject<NSXMLParserDelegate>
{
    NSXMLParser     *xmlParser;
    NSMutableString *currentNodeContent;


}

typedef void(^SMCompetionBlock)(BOOL success, NSString *responseString, NSError *error);


-(void)addTheActivityWithUserHash:(NSString*) userHash withClientID:(int)clientID withLeadID:(int)leadID withActivity:(int)activity withChangeStatus:(BOOL)changeStatus andWithComment:(NSString *)comment andWithCallBack:(SMCompetionBlock)callBack;


@end

