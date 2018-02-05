//
//  SMWSLeadPool.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSLeadPool.h"

typedef void(^successResponse)(SMObjectLeadPoolXml *objSMObjectLeadPoolXml);
typedef void(^failureResponse)(NSError *error);

@interface SMWSLeadPool() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSLeadPool
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMObjectLeadPoolXml *objSMObjectLeadPoolXmlResultObject;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectLeadPoolXml *objSMObjectLeadPoolXml))successResponse
                              andError:(void(^)(NSError *error))failureResponse{
    
    self.successCallback = successResponse;
    self.failCallback = failureResponse;
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             self.failCallback(error);
             
         }
         else
         {
             arrmTemp = [[NSMutableArray alloc] init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             
             [xmlParser setDelegate:self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
 }

#pragma mark - xml parser delegate
-(void) parser:(NSXMLParser  *)     parser
didStartElement:(NSString    *)     elementName
  namespaceURI:(NSString     *)     namespaceURI
 qualifiedName:(NSString     *)     qName
    attributes:(NSDictionary *)     attributeDict
{
  
    if ([elementName isEqualToString:@"LoadLeadPoolSummaryResponse"]) {
        objSMObjectLeadPoolXmlResultObject = [[SMObjectLeadPoolXml alloc] init];
//        objSMVINHistoryXmlResultObject.arrmForDetails = [[NSMutableArray alloc] init];
    }
    
      currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"STRING = %@",string);
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
}
/*
 <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
 <s:Body>
 <LoadLeadPoolSummaryResponse xmlns="http://tempuri.org/">
 <LoadLeadPoolSummaryResult>
 <LeadPoolSummary xmlns="">
 <ClientName>Netwin Info</ClientName>
 <GroupName>Netwin Test Group</GroupName>
 <ClientActiveLeads>0</ClientActiveLeads>
 <ClientLostLeads>0</ClientLostLeads>
 <GroupActiveLeads>0</GroupActiveLeads>
 <>0</GroupLostLeads>
 </LeadPoolSummary>
 </LoadLeadPoolSummaryResult>
 </LoadLeadPoolSummaryResponse>
 </s:Body>
 </s:Envelope> */

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    currentNodeContent = (NSMutableString *) [currentNodeContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([elementName isEqualToString:@"LoadLeadPoolSummaryResponse"]) {
        if(self.successCallback){
            if (currentNodeContent.length == 0) {
                objSMObjectLeadPoolXmlResultObject.iStatus = kWSNoRecord;
            }
            else
                objSMObjectLeadPoolXmlResultObject.iStatus = kWSSuccess;
            self.successCallback(objSMObjectLeadPoolXmlResultObject);
        }
    }
    
    if ([elementName isEqualToString:@"ClientName"]) {
        objSMObjectLeadPoolXmlResultObject.strClientName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"GroupName"]) {
         objSMObjectLeadPoolXmlResultObject.strGroupName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ClientActiveLeads"]) {
         objSMObjectLeadPoolXmlResultObject.strClientActiveLeads = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ClientLostLeads"]) {
         objSMObjectLeadPoolXmlResultObject.strClientLostLeads = currentNodeContent;
    }
    if ([elementName isEqualToString:@"GroupActiveLeads"]) {
         objSMObjectLeadPoolXmlResultObject.strGroupActiveLeads = currentNodeContent;
    }
    if ([elementName isEqualToString:@"GroupLostLeads"]) {
         objSMObjectLeadPoolXmlResultObject.strGroupLostLeads = currentNodeContent;
    }
   
    if ([elementName isEqualToString:@"s:Fault"]) {
         objSMObjectLeadPoolXmlResultObject = [[SMObjectLeadPoolXml alloc] init];
            if(self.successCallback){
                 objSMObjectLeadPoolXmlResultObject.iStatus = kWSCrash;
                 self.successCallback(objSMObjectLeadPoolXmlResultObject);
            }
     }
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
    if ( parser.parserError != nil) {
        if(self.failCallback)
            self.failCallback( parser.parserError);
        
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError;
{
}


@end
