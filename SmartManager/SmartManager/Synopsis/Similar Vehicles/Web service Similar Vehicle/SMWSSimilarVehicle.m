//
//  SMWSSimilarVehicle.m
//  Smart Manager
//
//  Created by Ankit S on 6/30/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSSimilarVehicle.h"
#import "SMDropDownObject.h"

typedef void(^successResponse)(SMSimilarVehicleXmlObject *objSMSimilarVehicleXmlObject);
typedef void(^failureResponse)(NSError *error);

@interface SMWSSimilarVehicle()
{
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end

@implementation SMWSSimilarVehicle
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMSimilarVehicleXmlObject *objSMSimilarVehicleXmlObject;
    
    SMDropDownObject *objYearYounger;
    SMDropDownObject *objSameYear;
    SMDropDownObject *objYearOlder;
    
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
    
    BOOL isYearYounger;
    BOOL isSameYear;
    BOOL isYearOlder;
    
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMSimilarVehicleXmlObject *objSMSimilarVehicleXmlObject))successResponse
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
    
    if ([elementName isEqualToString:@"LoadSimilarVehiclesByIDResult"]) {
        objSMSimilarVehicleXmlObject = [[SMSimilarVehicleXmlObject alloc] init];
        objSMSimilarVehicleXmlObject.arrOfYearOlderVehicles = [[NSMutableArray alloc] init];
        objSMSimilarVehicleXmlObject.arrOfOtherModelVehicles = [[NSMutableArray alloc] init];
        objSMSimilarVehicleXmlObject.arrOfYearYoungerVehicles = [[NSMutableArray alloc] init];
    }
    
    /*if( [elementName isEqualToString:@"SimilarVehicles"])
    {
        objSMSimilarVehicleXmlObject.strYearOlderCnt = [attributeDict valueForKey:@"YearYoungerCount"];
        objSMSimilarVehicleXmlObject.strOtherModelsCnt = [attributeDict valueForKey:@"SameYearCount"];
        objSMSimilarVehicleXmlObject.strYearOlderCnt = [attributeDict valueForKey:@"YearOlderCount"];

    }*/
    
    if( [elementName isEqualToString:@"YearYounger"])
    {
        objYearYounger = [[SMDropDownObject alloc] init];
        isYearYounger = YES;isSameYear = NO;isYearOlder = NO;
    }
    if( [elementName isEqualToString:@"SameYear"])
    {
        objSameYear = [[SMDropDownObject alloc] init];
        isYearYounger = NO;isSameYear = YES;isYearOlder = NO;
    }
    if( [elementName isEqualToString:@"YearOlder"])
    {
        objYearOlder = [[SMDropDownObject alloc] init];
        isYearYounger = NO;isSameYear = NO;isYearOlder = YES;
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
    
    //NSLog(@"didEndElement elementName : %@ currentNodeContent : %@", elementName,currentNodeContent);
    
    if( [elementName isEqualToString:@"VariantID"])
    {
        if(isYearYounger)
        {
            objYearYounger.strMakeId = currentNodeContent;
        }
        if(isSameYear)
        {
            objSameYear.strMakeId = currentNodeContent;
        }
        if(isYearOlder)
        {
            objYearOlder.strMakeId = currentNodeContent;
        }
        
    }
    if( [elementName isEqualToString:@"Description"])
    {
        if(isYearYounger)
        {
            objYearYounger.strMakeName = currentNodeContent;
        }
        if(isSameYear)
        {
            objSameYear.strMakeName = currentNodeContent;
        }
        if(isYearOlder)
        {
            objYearOlder.strMakeName = currentNodeContent;
        }
    }
    if( [elementName isEqualToString:@"Year"])
    {
        if(isYearYounger)
        {
            objYearYounger.strMinYear = currentNodeContent;
        }
        if(isSameYear)
        {
            objSameYear.strMinYear = currentNodeContent;
        }
        if(isYearOlder)
        {
            objYearOlder.strMinYear = currentNodeContent;
        }
    }
    if( [elementName isEqualToString:@"VariantName"])
    {
        if(isYearYounger)
        {
            objYearYounger.strMakeName = currentNodeContent;
        }
        if(isSameYear)
        {
            objSameYear.strMakeName = currentNodeContent;
        }
        if(isYearOlder)
        {
            objYearOlder.strMakeName = currentNodeContent;
        }
    }
    if( [elementName isEqualToString:@"Transmission"])
    {
        if(isYearYounger)
        {
            objYearYounger.strModelId = currentNodeContent;
        }
        if(isSameYear)
        {
            objSameYear.strModelId = currentNodeContent;
        }
        if(isYearOlder)
        {
            objYearOlder.strModelId = currentNodeContent;
        }
    }
    if( [elementName isEqualToString:@"FuelType"])
    {
        if(isYearYounger)
        {
            objYearYounger.strStockId = currentNodeContent;
        }
        if(isSameYear)
        {
            objSameYear.strStockId = currentNodeContent;
        }
        if(isYearOlder)
        {
            objYearOlder.strStockId = currentNodeContent;
        }
    }
    
    if( [elementName isEqualToString:@"YearYounger"])
    {
        [objSMSimilarVehicleXmlObject.arrOfYearYoungerVehicles addObject:objYearYounger];
    }
    if( [elementName isEqualToString:@"SameYear"])
    {
        [objSMSimilarVehicleXmlObject.arrOfOtherModelVehicles addObject:objSameYear];
    }
    if( [elementName isEqualToString:@"YearOlder"])
    {
        [objSMSimilarVehicleXmlObject.arrOfYearOlderVehicles addObject:objYearOlder];
    }
    if( [elementName isEqualToString:@"YearYoungerCount"])
    {
        
        objSMSimilarVehicleXmlObject.strYearOlderCnt = currentNodeContent;
    }
    if( [elementName isEqualToString:@"SameYearCount"])
    {
        
        objSMSimilarVehicleXmlObject.strOtherModelsCnt = currentNodeContent;
    }
    if( [elementName isEqualToString:@"YearOlderCount"])
    {
        objSMSimilarVehicleXmlObject.strYearOlderCnt = currentNodeContent;
    }
    
    
    if ([elementName isEqualToString:@"LoadSimilarVehiclesByIDResult"]) {
        if(self.successCallback)
        {
            objSMSimilarVehicleXmlObject.iStatus = kWSSuccess;
            self.successCallback(objSMSimilarVehicleXmlObject);
        }
    }
    
    
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMSimilarVehicleXmlObject = [[SMSimilarVehicleXmlObject alloc] init];
        if(self.successCallback){
            objSMSimilarVehicleXmlObject.iStatus = kWSCrash;
            self.successCallback(objSMSimilarVehicleXmlObject);
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
