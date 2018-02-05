//
//  SMWSforSummaryDetails.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 12/05/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSforOEMSpecsDetails.h"

typedef void(^successResponse)(SMOEMSpecsXMLObject *objSMOEMSpecsXMLObject);
typedef void(^failureResponse)(NSError *error);

@interface SMWSforOEMSpecsDetails() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSforOEMSpecsDetails
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMOEMSpecsXMLObject *objSMOEMSpecsXMLObject;
    SMOEMSpecsDetails *objSMOEMSpecsDetails;
    SMOEMSpecsDetailsSpecification *objSMOEMSpecsDetailsSpecification;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMOEMSpecsXMLObject *objSMOEMSpecsXMLObject))successResponse
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
   
    if ([elementName isEqualToString:@"LoadOEMSpecsByIDResult"]) {
        objSMOEMSpecsXMLObject = [[SMOEMSpecsXMLObject alloc] init];
        objSMOEMSpecsXMLObject.arrmForDetails = [[NSMutableArray alloc] init];
    }
    
    if( [elementName isEqualToString:@"category"])
    {
        objSMOEMSpecsDetails = [[SMOEMSpecsDetails alloc] init];
        objSMOEMSpecsDetails.strOEMDetailsTitle  = [attributeDict valueForKey:@"name"];
        objSMOEMSpecsDetails.arrmOEMDetails = [[NSMutableArray alloc] init];
    }
    
    if( [elementName isEqualToString:@"Spec"])
    {
        objSMOEMSpecsDetailsSpecification = [[SMOEMSpecsDetailsSpecification alloc] init];
        objSMOEMSpecsDetailsSpecification.strSpecsTitle  = [attributeDict valueForKey:@"name"];
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
    
     if ([elementName isEqualToString:@"LoadOEMSpecsByIDResult"]) {
         if(self.successCallback){
             if (currentNodeContent.length == 0) {
                 objSMOEMSpecsXMLObject.iStatus = kWSNoRecord;
             }
             else{
                  objSMOEMSpecsXMLObject.iStatus = kWSSuccess;
             }
                  self.successCallback(objSMOEMSpecsXMLObject);
             }
         }
         
    if ([elementName isEqualToString:@"Disclaimer"]) {
        objSMOEMSpecsXMLObject.strDisclaimer = currentNodeContent;
        NSLog(@"%@", currentNodeContent);
    }
    
    if ([elementName isEqualToString:@"Spec"]) {
        objSMOEMSpecsDetailsSpecification.strSpecsValue  = currentNodeContent;
        [objSMOEMSpecsDetails.arrmOEMDetails addObject:objSMOEMSpecsDetailsSpecification];
    }
    
    if( [elementName isEqualToString:@"category"])
    {
        [objSMOEMSpecsXMLObject.arrmForDetails addObject:objSMOEMSpecsDetails];
    }
    
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMOEMSpecsXMLObject = [[SMOEMSpecsXMLObject alloc] init];
        if(self.successCallback){
            objSMOEMSpecsXMLObject.iStatus = kWSCrash;
            self.successCallback(objSMOEMSpecsXMLObject);
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
