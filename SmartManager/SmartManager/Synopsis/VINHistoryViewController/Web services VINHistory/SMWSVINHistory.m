//
//  SMWSVINHistory.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 02/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSVINHistory.h"


typedef void(^successResponse)(SMVINHistoryXmlResultObject *objSMVINHistoryXmlResultObject);
typedef void(^failureResponse)(NSError *error);

@interface SMWSVINHistory() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSVINHistory
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMVINHistoryXmlResultObject *objSMVINHistoryXmlResultObject;
    SMVINHistoryObject *objSMVINHistoryObject;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMVINHistoryXmlResultObject *objSMVINHistoryXmlResultObject))successResponse
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
    
    if ([elementName isEqualToString:@"LoadVINHistoryResult"]) {
        objSMVINHistoryXmlResultObject = [[SMVINHistoryXmlResultObject alloc] init];
        objSMVINHistoryXmlResultObject.arrmForDetails = [[NSMutableArray alloc] init];
    }
    
    
    if( [elementName isEqualToString:@"History"])
    {
        objSMVINHistoryObject = [[SMVINHistoryObject alloc] init];
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
    
    NSLog(@"didEndElement elementName : %@ currentNodeContent : %@", elementName,currentNodeContent);
    
    if ([elementName isEqualToString:@"LoadVINHistoryResult"]) {
        if(self.successCallback)
        {
            objSMVINHistoryXmlResultObject.iStatus = kWSSuccess;
            self.successCallback(objSMVINHistoryXmlResultObject);
        }
    }
    
    if( [elementName isEqualToString:@"EngineNo"])
    {
        objSMVINHistoryXmlResultObject.strEngineNo = currentNodeContent;
    }
    if( [elementName isEqualToString:@"Department"])
    {
        objSMVINHistoryXmlResultObject.strDepartment = currentNodeContent;
    }
    if( [elementName isEqualToString:@"VIN"])
    {
        objSMVINHistoryXmlResultObject.strVIN = currentNodeContent;
    }
    if( [elementName isEqualToString:@"Vehicle"])
    {
        objSMVINHistoryXmlResultObject.strVehicleName = currentNodeContent;
    }
    if( [elementName isEqualToString:@"LastSeen"])
    {
         objSMVINHistoryObject.strLastSeen = currentNodeContent;
    }
    if( [elementName isEqualToString:@"Dealer"])
    {
          objSMVINHistoryObject.strDealer = currentNodeContent;
    }
    if( [elementName isEqualToString:@"Location"])
    {
          objSMVINHistoryObject.strLocation = currentNodeContent;
    }
    if( [elementName isEqualToString:@"Mileage"])
    {
                
        objSMVINHistoryObject.strMileage = [[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent];
        
        //[self.labelVehicleMileage   setText:[NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:currentNodeContent]]];
        

    } if( [elementName isEqualToString:@"Price"])
    {
      
        objSMVINHistoryObject.strPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:currentNodeContent];
    }
    if( [elementName isEqualToString:@"History"])
    {
        [objSMVINHistoryXmlResultObject.arrmForDetails addObject:objSMVINHistoryObject];
    }
    
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMVINHistoryXmlResultObject = [[SMVINHistoryXmlResultObject alloc] init];
        if(self.successCallback){
            objSMVINHistoryXmlResultObject.iStatus = kWSCrash;
            self.successCallback(objSMVINHistoryXmlResultObject);
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
