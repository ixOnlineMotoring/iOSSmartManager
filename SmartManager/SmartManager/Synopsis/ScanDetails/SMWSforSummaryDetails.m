//
//  SMWSforSummaryDetails.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 12/05/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSforSummaryDetails.h"
#import "SMSummaryObject.h"

typedef void(^successResponse)(SMSynopsisXMLResultObject *objSMSynopsisXMLResultObject);
typedef void(^failureResponse)(NSError *error);

@interface SMWSforSummaryDetails() {
   
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;



@end
@implementation SMWSforSummaryDetails
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMSynopsisXMLResultObject *objSMSynopsisResult;
    SMSummaryObject *objSMSummeryObject;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
    NSMutableDictionary *dictmVariantDetails;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMSynopsisXMLResultObject *objSMSynopsisXMLResultObject))successResponse
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
    
    if ([elementName isEqualToString:@"GetSynopsisXmlResponse"]) {
        objSMSynopsisResult = [[SMSynopsisXMLResultObject alloc]init];
        objSMSynopsisResult.arrmDemandSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmAverageAvailableSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmAverageDaysInStockSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmLeadPoolSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmWarrantySummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmSalesSummary = [[NSMutableArray alloc ] init];
        
    }
    
    if ([elementName isEqualToString:@"GetSynopsisByMMCodeXmlResult"]) {
        objSMSynopsisResult = [[SMSynopsisXMLResultObject alloc]init];
        objSMSynopsisResult.arrmDemandSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmAverageAvailableSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmAverageDaysInStockSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmLeadPoolSummary = [[NSMutableArray alloc ] init];
        objSMSynopsisResult.arrmWarrantySummary = [[NSMutableArray alloc ] init];
        
    }

    if ([elementName isEqualToString:@"VariantDetails"])
    {
        dictmVariantDetails = [[NSMutableDictionary alloc] init];
        NSLog(@"Did enter hereg...");
    }
    
    if ([elementName isEqualToString:@"SummaryItem"]) {
        objSMSummeryObject = [[SMSummaryObject alloc]init];
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
    
   // NSLog(@"didEndElement elementName : %@ currentNodeContent : %@", elementName,currentNodeContent);
    
    if ([elementName isEqualToString:@"ImageUrl"]) {
        
        objSMSynopsisResult.strVariantImage = currentNodeContent;
    }
    if ([elementName isEqualToString:@"VIN"]) {
        objSMSynopsisResult.strVINNo = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Year"]) {
        
        objSMSynopsisResult.intYear = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"MakeId"]) {
        objSMSynopsisResult.intMakeId = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"ModelId"]) {
        objSMSynopsisResult.intModelId = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"VariantId"]) {
        objSMSynopsisResult.intVariantId = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"MakeName"]) {
        objSMSynopsisResult.strMakeName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ModelName"]) {
        objSMSynopsisResult.strModelName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"VariantName"]) {
        objSMSynopsisResult.strVariantName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FriendlyName"]) {
        objSMSynopsisResult.strFriendlyName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MMCode"]) {
        objSMSynopsisResult.strMMCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Transmission"]) {
        objSMSynopsisResult.strTransmission = currentNodeContent;
    }
    if ([elementName isEqualToString:@"StartDate"]) {
        objSMSynopsisResult.strStartDate = [self getDateInExpectedFormat:currentNodeContent];
    }
    if ([elementName isEqualToString:@"EndDate"]) {
        objSMSynopsisResult.strEndDate = [self getDateInExpectedFormat:currentNodeContent];
    }
    
    if ([elementName isEqualToString:@"Extras"]) {
        objSMSynopsisResult.strExtras = currentNodeContent;
    }

    if ([elementName isEqualToString:@"Condition"]) {
        objSMSynopsisResult.strCondition = currentNodeContent;
    }

    if ([elementName isEqualToString:@"TradePrice"]) {
        
        
        objSMSynopsisResult.pricingTraderPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
    }
    if ([elementName isEqualToString:@"RetailPrice"]) {
        objSMSynopsisResult.pricingRetailPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        
    }
    if ([elementName isEqualToString:@"PrivateAdvertsPrice"]) {
        objSMSynopsisResult.pricingPrivateAdvertPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        
    }
    if ([elementName isEqualToString:@"SimpleLogicTradePrice"]) {
        objSMSynopsisResult.pricingSLTradePrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        
    }
    if ([elementName isEqualToString:@"SimpleLogicRetailPrice"]) {
        objSMSynopsisResult.pricingSLRetailPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        
    }
    if ([elementName isEqualToString:@"TUATradePrice"]) {
        objSMSynopsisResult.pricingTUATradePrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        
    }
    if ([elementName isEqualToString:@"TUARetailPrice"]) {
        objSMSynopsisResult.pricingTUARetailPrice = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:[NSString stringWithFormat:@"%d",currentNodeContent.intValue]];
        
    }
    if ([elementName isEqualToString:@"TUASearchDateTime"]) {
        objSMSynopsisResult.strTUASearchDateTime = currentNodeContent;
        
    }
    
    
    if ([elementName isEqualToString:@"Gears"]) {
      
        [dictmVariantDetails setObject:currentNodeContent forKey:@"Gears"];

    }
    
    if ([elementName isEqualToString:@"Gearbox"])
    {
       
        [dictmVariantDetails setObject:currentNodeContent forKey:@"Gearbox"];
    }

    if ([elementName isEqualToString:@"Fuel_Type"])
    {
      
        [dictmVariantDetails setObject:currentNodeContent forKey:@"Fuel_Type"];
    }
    if ([elementName isEqualToString:@"Power_KW"])
    {

         [dictmVariantDetails setObject:currentNodeContent forKey:@"Power_KW"];
    }
    if ([elementName isEqualToString:@"Torque_NM"])
    {
      
        [dictmVariantDetails setObject:currentNodeContent forKey:@"Torque_NM"];
    }
    if ([elementName isEqualToString:@"Engine_CC"])
    {
         [dictmVariantDetails setObject:currentNodeContent forKey:@"Engine_CC"];
    }
    if ([elementName isEqualToString:@"Transmission_Type"])
    {
        [dictmVariantDetails setObject:currentNodeContent forKey:@"Transmission_Type"];
    }
    
    if ([elementName isEqualToString:@"VariantDetails"])
    {
    objSMSynopsisResult.strVariantDetails=@"";
    NSString *str;
        
    str = [dictmVariantDetails objectForKey:@"Engine_CC"];
    if (str == nil) {
        
    }
    else{
//         NSString* cleanedString = [str stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
        str = [[str stringByReplacingOccurrencesOfString:@"," withString:@""]
                                   stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];
        str = [[str stringByReplacingOccurrencesOfString:@" " withString:@""]
               stringByTrimmingCharactersInSet: [NSCharacterSet symbolCharacterSet]];

        str = [NSString stringWithFormat:@"%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:str]];
        

        objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"%@cc, ",str];
    }
    
    str = [dictmVariantDetails objectForKey:@"Power_KW"];
        int kWValue = [str intValue];
        
        str = [NSString stringWithFormat:@"%d",kWValue];
        
    if (str == nil || [str isEqualToString:@"0"]) {
        
    }
    else
    {
        objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"%@kW, ",str];
    }
        
    str = [dictmVariantDetails objectForKey:@"Torque_NM"];
        int NmValue = [str intValue];
        
        str = [NSString stringWithFormat:@"%d",NmValue];

        if (str == nil || [str isEqualToString:@"0"]) {
            
        }
        else
        {
            objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"%@Nm, ",str];
        }
   
    str = [dictmVariantDetails objectForKey:@"Fuel_Type"];
    if (str == nil) {
        
    }
    else
    {
        objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"%@, ",str];
    }
        
        str = [dictmVariantDetails objectForKey:@"Transmission_Type"];
        if (str == nil) {
            
        }
        else
        {
            objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"%@, ",str];
        }
        
    str = [dictmVariantDetails objectForKey:@"Gearbox"];
    if (str == nil) {
        
    }
    else
    {
        objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"%@, ",str];
    }
    str = [dictmVariantDetails objectForKey:@"Gears"];
    if (str == nil) {
        
    }
    else
    {
        objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"%@ gears. ",str];
    }
}
    
    if ([elementName isEqualToString:@"Sources"]) {
        objSMSynopsisResult.intSources = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"AverageTradePrice"]) {
        objSMSynopsisResult.floatAverageTradePrice = [currentNodeContent floatValue];
    }
    if ([elementName isEqualToString:@"AveragePrice"]) {
        objSMSynopsisResult.floatAveragePrice = [currentNodeContent floatValue];
    }
    if ([elementName isEqualToString:@"MarketPrice"]) {
        objSMSynopsisResult.floatMarketPrice = [currentNodeContent floatValue];
    }
    if ([elementName isEqualToString:@"Value"]) {
        objSMSummeryObject.intValue = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"Area"]) {
        objSMSummeryObject.strArea = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Type"]) {
        objSMSummeryObject.strType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"SummaryItem"]) {
        [arrmTemp addObject:objSMSummeryObject];
    }
    if ([elementName isEqualToString:@"Kilometers"]) {
        objSMSynopsisResult.strKilometers = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Registration"]) {
        objSMSynopsisResult.strRegNo = currentNodeContent;
    }
    if ([elementName isEqualToString:@"DemandSummary"]) {
        [objSMSynopsisResult.arrmDemandSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"AverageAvailableSummary"]) {
        [objSMSynopsisResult.arrmAverageAvailableSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"AverageDaysInStockSummary"]) {
        [objSMSynopsisResult.arrmAverageDaysInStockSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"SalesSummary"]) {
        [objSMSynopsisResult.arrmSalesSummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"LeadPoolSummary"])
    {
         // if(arrmTemp.count == 0)
        [objSMSynopsisResult.arrmLeadPoolSummary addObjectsFromArray:arrmTemp];
        if(arrmTemp.count > 0)
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"WarrantySummary"]) {
        [objSMSynopsisResult.arrmWarrantySummary addObjectsFromArray:arrmTemp];
        [arrmTemp removeAllObjects];
    }
    if ([elementName isEqualToString:@"ReviewCount"]) {
        objSMSynopsisResult.intReviewCount = [currentNodeContent intValue];
    }
    
    if ([elementName isEqualToString:@"GetSynopsisXmlResponse"]) {
        if(self.successCallback){
            if (currentNodeContent.length == 0) {
                objSMSynopsisResult.iStatus = kWSCrash;
            }
            else
            {
                if ( [objSMSynopsisResult.strStartDate isEqualToString:@"(null)"] ) {
                    objSMSynopsisResult.strStartDate = @"StartDate?";
                }
                if ( [objSMSynopsisResult.strEndDate isEqualToString:@"(null)"] ) {
                    objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"Avail. as new from %@ ",objSMSynopsisResult.strStartDate];
                }
                else{
                    objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"Avail. as new from %@ to %@ ",objSMSynopsisResult.strStartDate,objSMSynopsisResult.strEndDate];
                }
                objSMSynopsisResult.iStatus = kWSSuccess;
            }
            NSLog(@"%@",objSMSynopsisResult.strVINNo);//VIN#?
            
            if ([objSMSynopsisResult.strVINNo isKindOfClass:[NSNull class]] || objSMSynopsisResult.strVINNo == nil  || objSMSynopsisResult.strVINNo.length == 0  ) {
                objSMSynopsisResult.strVINNo = @"No VIN loaded";
            }
              self.successCallback(objSMSynopsisResult);
        }
        
    }
    
    if ([elementName isEqualToString:@"Error"]) {
        if(self.successCallback){
             objSMSynopsisResult.iStatus = kWSCrash;
             self.successCallback(objSMSynopsisResult);
             [parser abortParsing];
        }
       
    }
   
    if ([elementName isEqualToString:@"GetSynopsisByMMCodeXmlResult"]) {
        if(self.successCallback){
            if (currentNodeContent.length == 0) {
                objSMSynopsisResult.iStatus = kWSCrash;
            }
            else
            {
                if ( [objSMSynopsisResult.strStartDate isEqualToString:@"(null)"] ) {
                    objSMSynopsisResult.strStartDate = @"StartDate?";
                }
                if ( [objSMSynopsisResult.strEndDate isEqualToString:@"(null)"] ) {
                    objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"Avail. as new from %@ ",objSMSynopsisResult.strStartDate];
                }
                else{
                    objSMSynopsisResult.strVariantDetails = [objSMSynopsisResult.strVariantDetails stringByAppendingFormat:@"Avail. as new from %@ to %@ ",objSMSynopsisResult.strStartDate,objSMSynopsisResult.strEndDate];
                }
                objSMSynopsisResult.iStatus = kWSSuccess;
            }
            
            NSLog(@"%@",objSMSynopsisResult.strVINNo);
            
            if ([objSMSynopsisResult.strVINNo isKindOfClass:[NSNull class]] || objSMSynopsisResult.strVINNo == nil  || objSMSynopsisResult.strVINNo.length == 0  ) {
                objSMSynopsisResult.strVINNo = @"No VIN loaded";
            }
            self.successCallback(objSMSynopsisResult);
        }
        
    }
    
   if ([elementName isEqualToString:@"s:Fault"]) {
        objSMSynopsisResult = [[SMSynopsisXMLResultObject alloc] init];
        if(self.successCallback){
            objSMSynopsisResult.iStatus = kWSCrash;
            self.successCallback(objSMSynopsisResult);
        }
    }
}

-(NSString*)getDateInExpectedFormat:(NSString*)inputString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
    NSDate *requiredDate1 = [dateFormatter dateFromString:inputString];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"MMM yyyy"];
    NSString *finalDate = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:requiredDate1]];
    return finalDate;
    
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
