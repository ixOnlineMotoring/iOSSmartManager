//
//  SMWSDemand.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 17/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSDemand.h"

typedef void(^successResponse)(SMObjectDemandXml *objSMObjectDemandXml);
typedef void(^failureResponse)(NSError *error);

@interface SMWSDemand() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSDemand
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMObjectDemandXml *objSMObjectDemandXml;
    SMDemandObject *objDemandObject;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMObjectDemandXml *objSMObjectDemandXml))successResponse
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
    
    if ([elementName isEqualToString:@"LoadDemandForVariantByIDResult"]) {
        objSMObjectDemandXml = [[SMObjectDemandXml alloc] init];
        objSMObjectDemandXml.arrmDemands = [[NSMutableArray alloc] init];
    }
    
    if ([elementName isEqualToString:@"Demand"]) {
        objDemandObject = [[SMDemandObject alloc] init];
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
    
    if ([elementName isEqualToString:@"LoadDemandForVariantByIDResult"]) {
        if(self.successCallback){
            objSMObjectDemandXml.iStatus = kWSSuccess;
            self.successCallback(objSMObjectDemandXml);
        }
    }
    
    
    if ([elementName isEqualToString:@"ClientName"]) {
         objSMObjectDemandXml.strClientName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"VariantName"]) {
        objSMObjectDemandXml.strVariantName =[NSString stringWithFormat:@"%@ (by variant)",currentNodeContent] ;
    }
    if ([elementName isEqualToString:@"ModelName"]) {
        objSMObjectDemandXml.strModelName = [NSString stringWithFormat:@"%@ (by model)",currentNodeContent] ;
    }
    if ([elementName isEqualToString:@"ClientVariantLeadCount"]) {
        objSMObjectDemandXml.strClientVariantLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ClientVariantLeadCountRanking"]) {
        objSMObjectDemandXml.strClientVariantLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"ClientVariantSoldLeadCount"]) {
        objSMObjectDemandXml.strClientVariantSoldLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ClientVariantSoldLeadCountRanking"]) {
        objSMObjectDemandXml.strClientVariantSoldLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"ClientModelLeadCount"]) {
        objSMObjectDemandXml.strClientModelLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ClientModelLeadCountRanking"]) {
        objSMObjectDemandXml.strClientModelLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"ClientModelSoldLeadCount"]) {
        objSMObjectDemandXml.strClientModelSoldLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ClientModelSoldLeadCountRanking"]) {
        objSMObjectDemandXml.strClientModelSoldLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    
    
    if ([elementName isEqualToString:@"CityName"]) {
        objSMObjectDemandXml.strCityName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"CityVariantLeadCount"]) {
        objSMObjectDemandXml.strCityVariantLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"CityVariantLeadCountRanking"]) {
        objSMObjectDemandXml.strCityVariantLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"CityVariantSoldLeadCount"]) {
        objSMObjectDemandXml.strCityVariantSoldLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"CityVariantSoldLeadCountRanking"]) {
        objSMObjectDemandXml.strCityVariantSoldLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"CityModelLeadCount"]) {
        objSMObjectDemandXml.strCityModelLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"CityModelLeadCountRanking"]) {
        objSMObjectDemandXml.strCityModelLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"CityModelSoldLeadCount"]) {
        objSMObjectDemandXml.strCityModelSoldLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"CityModelSoldLeadCountRanking"]) {
        objSMObjectDemandXml.strCityModelSoldLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    
    
    if ([elementName isEqualToString:@"ProvinceName"]) {
        objSMObjectDemandXml.strProvinceName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ProvinceVariantLeadCount"]) {
        objSMObjectDemandXml.strProvinceVariantLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ProvinceVariantLeadCountRanking"]) {
        objSMObjectDemandXml.strProvinceVariantLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"ProvinceVariantSoldLeadCount"]) {
        objSMObjectDemandXml.strProvinceVariantSoldLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ProvinceVariantSoldLeadCountRanking"]) {
        objSMObjectDemandXml.strProvinceVariantLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"ProvinceModelLeadCount"]) {
        objSMObjectDemandXml.strProvinceModelLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ProvinceModelLeadCountRanking"]) {
        objSMObjectDemandXml.strProvinceModelLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"ProvinceModelSoldLeadCount"]) {
        objSMObjectDemandXml.strProvinceModelSoldLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ProvinceModelSoldLeadCountRanking"]) {
        objSMObjectDemandXml.strProvinceModelSoldLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }

    if ([elementName isEqualToString:@"NationalVariantLeadCount"]) {
        objSMObjectDemandXml.strNationalVariantLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"NationalVariantLeadCountRanking"]) {
        objSMObjectDemandXml.strNationalVariantLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"NationalVariantSoldLeadCount"]) {
        objSMObjectDemandXml.strNationalVariantSoldLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"NationalVariantSoldLeadCountRanking"]) {
        objSMObjectDemandXml.strNationalVariantSoldLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"NationalModelLeadCount"]) {
        objSMObjectDemandXml.strNationalModelLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"NationalModelLeadCountRanking"]) {
        objSMObjectDemandXml.strNationalModelLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    if ([elementName isEqualToString:@"NationalModelSoldLeadCount"]) {
        objSMObjectDemandXml.strNationalModelSoldLeadCount = currentNodeContent;
    }
    if ([elementName isEqualToString:@"NationalModelSoldLeadCountRanking"]) {
        objSMObjectDemandXml.strNationalModelSoldLeadCountRanking = [SMAttributeStringFormatObject setRankingPrefix:currentNodeContent];
    }
    
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMObjectDemandXml = [[SMObjectDemandXml alloc] init];
        if(self.successCallback){
            objSMObjectDemandXml.iStatus = kWSCrash;
            self.successCallback(objSMObjectDemandXml);
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
