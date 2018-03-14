//
//  SMParseXML.m
//  Smart Manager
//
//  Created by Tejas on 07/09/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMParseXML.h"
#import "SMWebServices.h"

@implementation SMParseXML

void(^ getTheResponseCallBack)(BOOL success, NSString *successMsg, NSError *error);


-(void)addTheActivityWithUserHash:(NSString*) userHash withClientID:(int)clientID withLeadID:(int)leadID withActivity:(int)activity withChangeStatus:(BOOL)changeStatus andWithComment:(NSString *)comment andWithCallBack:(SMCompetionBlock)callBack
{
    
    getTheResponseCallBack = callBack;
    
    NSLog(@"PARSING STARTED");
    NSMutableURLRequest *requestURL=[SMWebServices addThePhoneOrEmailActivitywithUserHash:userHash withClientID:clientID withLeadID:leadID withActivity:activity withChangeStatus:1 andWithComment:comment];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             //[HUD hide:YES];
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser parse];
         }
     }];
 

}


#pragma mark - xmlParserDelegate
-(void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    
    currentNodeContent = [NSMutableString stringWithString:@""];
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *str = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"AddActivityResult"])
    {
        if ([currentNodeContent isEqualToString:@"Success"])
        {
            NSLog(@"SUCCESS");
            getTheResponseCallBack(YES,@"Success",nil);
        }
        else
        {
            getTheResponseCallBack(NO,@"Fail",nil);
        }
    }
}

@end
