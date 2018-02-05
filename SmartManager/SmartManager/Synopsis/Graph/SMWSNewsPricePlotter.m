//
//  SMWSNewsPricePlotter.m
//  Smart Manager
//
//  Created by Ankit S on 6/30/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSNewsPricePlotter.h"
typedef void(^successResponse)(SMNewsPricePlotterXmlObject *objSMNewsPricePlotterXmlObject);
typedef void(^failureResponse)(NSError *error);

@interface SMWSNewsPricePlotter() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end

@implementation SMWSNewsPricePlotter
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMNewsPricePlotterXmlObject *objSMNewsPricePlotterXmlObject;
    SMNewPricePlotterObject *objSMNewPricePlotterObject;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMNewsPricePlotterXmlObject *objSMNewsPricePlotterXmlObject))successResponse
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
    
    if ([elementName isEqualToString:@"LoadNewPricesByIDResult"]) {
        objSMNewsPricePlotterXmlObject = [[SMNewsPricePlotterXmlObject alloc] init];
        objSMNewsPricePlotterXmlObject.arrmGraphPoints = [[NSMutableArray alloc] init];
    }

    if ([elementName isEqualToString:@"price"]) {
        objSMNewPricePlotterObject = [[SMNewPricePlotterObject alloc] init];
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
    
    if ([elementName isEqualToString:@"LoadNewPricesByIDResult"]) {
        if(self.successCallback)
        {
            if (objSMNewsPricePlotterXmlObject.arrmGraphPoints.count == 0) {
                objSMNewsPricePlotterXmlObject.iStatus = kWSNoRecord;
            }else{
                objSMNewsPricePlotterXmlObject.iStatus = kWSSuccess;
            }
            
            self.successCallback(objSMNewsPricePlotterXmlObject);
        }
    }
    
    if ([elementName isEqualToString:@"price"]) {
        [objSMNewsPricePlotterXmlObject.arrmGraphPoints addObject:objSMNewPricePlotterObject];
    }
    
    if ([elementName isEqualToString:@"value"]) {
        objSMNewPricePlotterObject.strValue = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"date"]) {
        objSMNewPricePlotterObject.strDate = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMNewsPricePlotterXmlObject = [[SMNewsPricePlotterXmlObject alloc] init];
        if(self.successCallback){
            objSMNewsPricePlotterXmlObject.iStatus = kWSCrash;
            self.successCallback(objSMNewsPricePlotterXmlObject);
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
