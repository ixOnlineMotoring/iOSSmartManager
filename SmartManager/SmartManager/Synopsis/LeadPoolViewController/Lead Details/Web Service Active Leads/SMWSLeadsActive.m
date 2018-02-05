//
//  SMWSDemand.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 17/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSLeadsActive.h"

typedef void(^successResponse)(SMObjectLeadsActiveXml *objSMObjectLeadsActiveXml);
typedef void(^failureResponse)(NSError *error);

@interface SMWSLeadsActive() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSLeadsActive
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMObjectLeadsActiveXml *objSMObjectLeadsActiveXml;
    SMObjectActiveLead *objSMObjectActiveLead;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectLeadsActiveXml *objSMObjectLeadsActiveXml))successResponse
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
  
    
    if ([elementName isEqualToString:@"LoadLeadPoolDetailForClientResult"]) {
        objSMObjectLeadsActiveXml = [[SMObjectLeadsActiveXml alloc] init];
        objSMObjectLeadsActiveXml.arrmActiveLeads = [[NSMutableArray alloc] init];
    }
    
    if ([elementName isEqualToString:@"LoadLeadPoolDetailForGroupExcludeClientResult"]) {
        objSMObjectLeadsActiveXml = [[SMObjectLeadsActiveXml alloc] init];
        objSMObjectLeadsActiveXml.arrmActiveLeads = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"Lead"]) {
        objSMObjectActiveLead = [[SMObjectActiveLead alloc] init];
    }
    currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@"STRING = %@",string);
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    currentNodeContent = (NSMutableString *) [currentNodeContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
 
    if ([elementName isEqualToString:@"LoadLeadPoolDetailForClientResult"]) {
        if(self.successCallback){
            if (objSMObjectLeadsActiveXml.arrmActiveLeads.count == 0) {
                objSMObjectLeadsActiveXml.iStatus = kWSNoRecord;
            }
            else
                objSMObjectLeadsActiveXml.iStatus = kWSSuccess;
            self.successCallback(objSMObjectLeadsActiveXml);
        }
    }
    if ([elementName isEqualToString:@"LoadLeadPoolDetailForGroupExcludeClientResult"]) {
        if(self.successCallback){
            if (objSMObjectLeadsActiveXml.arrmActiveLeads.count == 0) {
                objSMObjectLeadsActiveXml.iStatus = kWSNoRecord;
            }
            else
                objSMObjectLeadsActiveXml.iStatus = kWSSuccess;
            self.successCallback(objSMObjectLeadsActiveXml);
        }
    }
   

    
    if ([elementName isEqualToString:@"LeadID"]) {
       objSMObjectActiveLead.strLeadID = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"Year"]) {
        objSMObjectActiveLead.strYear = currentNodeContent;
    }
    if ([elementName isEqualToString:@"NewOrUsed"]) {
       objSMObjectActiveLead.strNewOrUsed = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MakeName"]) {
        objSMObjectActiveLead.strMakeName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ModelName"]) {
        objSMObjectActiveLead.strModelName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"VariantName"]) {
        objSMObjectActiveLead.strVariantName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ProspectName"]) {
        objSMObjectActiveLead.strProspectName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ProspectContactNumber"]) {
       
        objSMObjectActiveLead.strProspectContactNumber =  [SMAttributeStringFormatObject formatPhoneNumber:currentNodeContent];
    }
    if ([elementName isEqualToString:@"ProspectEmail"]) {
        objSMObjectActiveLead.strProspectEmail = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SalesPerson"]) {
        objSMObjectActiveLead.strSalesPerson = currentNodeContent;
    }
    if ([elementName isEqualToString:@"LeadAgeInDays"]) {
        objSMObjectActiveLead.strLeadAgeInDays = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Lead"]) {
        [objSMObjectLeadsActiveXml.arrmActiveLeads addObject:objSMObjectActiveLead];
    }
    
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMObjectLeadsActiveXml = [[SMObjectLeadsActiveXml alloc] init];
        if(self.successCallback){
            objSMObjectLeadsActiveXml.iStatus = kWSCrash;
            self.successCallback(objSMObjectLeadsActiveXml);
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
