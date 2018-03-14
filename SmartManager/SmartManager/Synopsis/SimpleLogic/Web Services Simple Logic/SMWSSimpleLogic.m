//
//  SMWSLeadPool.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSSimpleLogic.h"

typedef void(^successResponse)(SMObjectSimpleLogicXml *objSMObjectSimpleLogicXml);
typedef void(^failureResponse)(NSError *error);

@interface SMWSSimpleLogic() {
}
@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSSimpleLogic
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMObjectSimpleLogicXml *objSMObjectSimpleLogicXml;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectSimpleLogicXml *objSMObjectSimpleLogicXml))successResponse
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
    
    if ([elementName isEqualToString:@"LoadVehicleRetailDetailsForVariantResponse"]) {
        objSMObjectSimpleLogicXml = [[SMObjectSimpleLogicXml alloc] init];
        //        objSMVINHistoryXmlResultObject.arrmForDetails = [[NSMutableArray alloc] init];
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
   
    if ([elementName isEqualToString:@"LoadVehicleRetailDetailsForVariantResponse"]) {
        if(self.successCallback){
            if (currentNodeContent.length == 0) {
                objSMObjectSimpleLogicXml.iStatus = kWSNoRecord;
            }
            else
                objSMObjectSimpleLogicXml.iStatus = kWSSuccess;
            self.successCallback(objSMObjectSimpleLogicXml);
        }
    }
      
    if ([elementName isEqualToString:@"Age"]) {
        objSMObjectSimpleLogicXml.strAge = currentNodeContent;
        //        objSMVINHistoryXmlResultObject.arrmForDetails = [[NSMutableArray alloc] init];
    }

    if ([elementName isEqualToString:@"Mileage"]) {
        
        
          objSMObjectSimpleLogicXml.strMileage = [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]];
        //        objSMVINHistoryXmlResultObject.arrmForDetails = [[NSMutableArray alloc] init];
    }

    if ([elementName isEqualToString:@"LatestPrice"]) {
         objSMObjectSimpleLogicXml.strLatestPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];
        
        
        //        objSMVINHistoryXmlResultObject.arrmForDetails = [[NSMutableArray alloc] init];
    }

    if ([elementName isEqualToString:@"AgeDepreciation"]) {
        objSMObjectSimpleLogicXml.strAgeDepreciation = currentNodeContent;
      
        //        objSMVINHistoryXmlResultObject.arrmForDetails = [[NSMutableArray alloc] init];
    }

    if ([elementName isEqualToString:@"MileageAdjustment"]) {
        objSMObjectSimpleLogicXml.strMileageAdjustment = [NSString stringWithFormat:@"%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]];        //        objSMVINHistoryXmlResultObject.arrmForDetails = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"Retail"]) {
         objSMObjectSimpleLogicXml.strRetail = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];
        //        objSMVINHistoryXmlResultObject.arrmForDetails = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"Trade"]) {
        objSMObjectSimpleLogicXml.strTrade = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];
        //        objSMVINHistoryXmlResultObject.arrmForDetails = [[NSMutableArray alloc] init];
    }
    
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMObjectSimpleLogicXml = [[SMObjectSimpleLogicXml alloc] init];
        if(self.successCallback){
            objSMObjectSimpleLogicXml.iStatus = kWSCrash;
            self.successCallback(objSMObjectSimpleLogicXml);
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
