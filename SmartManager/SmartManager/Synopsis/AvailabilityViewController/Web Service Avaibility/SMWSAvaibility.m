//
//  SMWSAvaibility.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSAvaibility.h"
#import "SMAvaibiltyObject.h"
typedef void(^successResponse)(SMObjectAvaibilityXml *objSMObjectLeadPoolXml);
typedef void(^failureResponse)(NSError *error);

@interface SMWSAvaibility() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSAvaibility
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMObjectAvaibilityXml *objSMObjectAvaibilityXml;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
    SMAvaibiltyObject *objSMAvaibiltyObject;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectAvaibilityXml *objSMObjectAvaibilityXml))successResponse
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
    
    if ([elementName isEqualToString:@"LoadAvailabilityResult"]) {
        objSMObjectAvaibilityXml = [[SMObjectAvaibilityXml alloc] init];
        objSMObjectAvaibilityXml.arrmAvaibility = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"Variant"]) {
        objSMAvaibiltyObject = [[SMAvaibiltyObject alloc]init];
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
    NSLog(@"%@",elementName);
    if ([elementName isEqualToString:@"LoadAvailabilityResult"]) {
        if(self.successCallback){
            if (currentNodeContent.length == 0) {
                objSMObjectAvaibilityXml.iStatus = kWSNoRecord;
            }
            else
                objSMObjectAvaibilityXml.iStatus = kWSSuccess;
            self.successCallback(objSMObjectAvaibilityXml);
        }
    }
    
    if ([elementName isEqualToString:@"VariantName"]) {
        objSMAvaibiltyObject.strVariantName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ClientAvailability"]) {
        objSMAvaibiltyObject.strClientAvailability = currentNodeContent;
    }
    if ([elementName isEqualToString:@"GroupAvailability"]) {
        objSMAvaibiltyObject.strGroupAvailability = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ProvinceAvailability"]) {
        
        objSMAvaibiltyObject.strProvinceAvailability = currentNodeContent;
    }
    if ([elementName isEqualToString:@"NationalAvailability"]) {
        
        objSMAvaibiltyObject.strNationalAvailability = currentNodeContent;
    }
    
    
    if ([elementName isEqualToString:@"GroupName"]) {
        objSMObjectAvaibilityXml.strGroupName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ProvinceName"]) {
        objSMObjectAvaibilityXml.strProvinceName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Variant"]) {
        [objSMObjectAvaibilityXml.arrmAvaibility addObject:objSMAvaibiltyObject];
    }
    
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMObjectAvaibilityXml = [[SMObjectAvaibilityXml alloc] init];
        if(self.successCallback){
            objSMObjectAvaibilityXml.iStatus = kWSCrash;
            self.successCallback(objSMObjectAvaibilityXml);
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
