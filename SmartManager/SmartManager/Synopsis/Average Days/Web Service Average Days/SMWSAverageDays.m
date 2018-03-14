//
//  SMWSAverageDays.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 17/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSAverageDays.h"


typedef void(^successResponse)(SMObjectAverageDaysXml *objSMObjectAverageDaysXml);
typedef void(^failureResponse)(NSError *error);

@interface SMWSAverageDays() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSAverageDays
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMObjectAverageDaysXml *objSMObjectAverageDaysXml;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
    SMObjectAverageDays *objSMObjectAverageDays;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectAverageDaysXml *objSMObjectAverageDaysXml))successResponse
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
    
    if ([elementName isEqualToString:@"LoadAverageDaysInStockResult"]) {
        objSMObjectAverageDaysXml = [[SMObjectAverageDaysXml alloc] init];
        objSMObjectAverageDaysXml.arrmAverageDays = [[NSMutableArray alloc] init];
    }
    
    if ([elementName isEqualToString:@"Variant"]) {
        objSMObjectAverageDays = [[SMObjectAverageDays alloc] init];
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
    
    if ([elementName isEqualToString:@"LoadAverageDaysInStockResult"]) {
        if(self.successCallback){
            if (objSMObjectAverageDaysXml.arrmAverageDays.count ==0) {
                objSMObjectAverageDaysXml.iStatus = kWSNoRecord;
            }
            else
                objSMObjectAverageDaysXml.iStatus = kWSSuccess;
            
            self.successCallback(objSMObjectAverageDaysXml);
        }
    }
   

    
    if ([elementName isEqualToString:@"ClientAverageDays"]) {
        objSMObjectAverageDays.iClientAverageDays = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"ClientTotalStockMovements"]) {
        objSMObjectAverageDays.iClientTotalStockMovements = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"CityAverageDays"]) {
       objSMObjectAverageDays.iCityAverageDays = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"CityTotalStockMovements"]) {
        objSMObjectAverageDays.iCityTotalStockMovements = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"NationalAverageDays"]) {
        objSMObjectAverageDays.iNationalAverageDays = [currentNodeContent intValue];
    }
   
    if ([elementName isEqualToString:@"NationalTotalStockMovements"]) {
        objSMObjectAverageDays.iNationalTotalStockMovements = [currentNodeContent intValue];
    }
    
    if ([elementName isEqualToString:@"VariantName"]) {
        objSMObjectAverageDays.strVariantName = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"Variant"]) {
        [objSMObjectAverageDaysXml.arrmAverageDays addObject:objSMObjectAverageDays];
    }
    if ([elementName isEqualToString:@"CityName"]) {
        objSMObjectAverageDaysXml.strCityName = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMObjectAverageDaysXml = [[SMObjectAverageDaysXml alloc] init];
        if(self.successCallback){
            objSMObjectAverageDaysXml.iStatus = kWSCrash;
            self.successCallback(objSMObjectAverageDaysXml);
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
