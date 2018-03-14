//
//  SMWSAvaibility.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSSaleHistory.h"

typedef void(^successResponse)(SMSaleHistoryXml *objSMSalesHistoryXml);
typedef void(^failureResponse)(NSError *error);

@interface SMWSSaleHistory() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSSaleHistory
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMSaleHistoryXml *objSMSaleHistoryXml;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
    SMObjectSaleHistory *objSMObjectSaleHistory;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMSaleHistoryXml *objSMSalesHistoryXml))successResponse
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
    
    
    if ([elementName isEqualToString:@"LoadSalesHistoryByIDResult"]) {
        objSMSaleHistoryXml = [[SMSaleHistoryXml alloc] init];
        objSMSaleHistoryXml.arrmSalesHistory = [[NSMutableArray alloc] init];
    }
    if ([elementName isEqualToString:@"Variant"]) {
        objSMObjectSaleHistory = [[SMObjectSaleHistory alloc]init];
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
    if ([elementName isEqualToString:@"LoadSalesHistoryByIDResult"]) {
        if(self.successCallback){
            if (currentNodeContent.length == 0) {
                objSMSaleHistoryXml.iStatus = kWSNoRecord;
            }
            else
                objSMSaleHistoryXml.iStatus = kWSSuccess;
            self.successCallback(objSMSaleHistoryXml);
        }
    }
   
    if ([elementName isEqualToString:@"VariantName"]) {
        objSMObjectSaleHistory.strVariantName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SalesCount"]) {
        objSMObjectSaleHistory.strSalesCount  = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Variant"]) {
        [objSMSaleHistoryXml.arrmSalesHistory addObject:objSMObjectSaleHistory];
    }
    if ([elementName isEqualToString:@"AverageSalesPerMonth"]) {
        objSMSaleHistoryXml.strAverageSalesPerMonth = currentNodeContent;
    }
    if ([elementName isEqualToString:@"AverageStockHolding30Days"]) {
        objSMSaleHistoryXml.strAverageStockHolding30Days = currentNodeContent;
    }
    if ([elementName isEqualToString:@"AverageStockHolding45Days"]) {
        objSMSaleHistoryXml.strAverageStockHolding45Days = currentNodeContent;
    }
    if ([elementName isEqualToString:@"AverageStockHolding60Days"]) {
        objSMSaleHistoryXml.strAverageStockHolding60Days = currentNodeContent;
    }
    if ([elementName isEqualToString:@"InStock"]) {
        objSMSaleHistoryXml.strInStock = currentNodeContent;
    }

    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMSaleHistoryXml = [[SMSaleHistoryXml alloc] init];
        if(self.successCallback){
            objSMSaleHistoryXml.iStatus = kWSCrash;
            self.successCallback(objSMSaleHistoryXml);
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
