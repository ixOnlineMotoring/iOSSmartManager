//
//  SMWSAvaibility.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSVINVerification.h"

typedef void(^successResponse)(SMVINVerificationXml *objSMVINVerificationXml);
typedef void(^failureResponse)(NSError *error);

@interface SMWSVINVerification() {
    BOOL isVehicleConfirmationModelStarted;
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSVINVerification
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMVINVerificationXml *objSMVINVerificationXml;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
   
}

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMVINVerificationXml *objSMSaleHistoryXml))successResponse
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
             isVehicleConfirmationModelStarted = NO;
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
    
    
    if ([elementName isEqualToString:@"LoadTransUnionVINVerificationResult"]) {
        objSMVINVerificationXml = [[SMVINVerificationXml alloc] init];
    }
    if ([elementName isEqualToString:@"VehicleConfirmationModel"]) {
        isVehicleConfirmationModelStarted = YES;
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
    if ([elementName isEqualToString:@"LoadTransUnionVINVerificationResult"]) {
        if(self.successCallback){
            if (currentNodeContent.length == 0) {
                objSMVINVerificationXml.iStatus = kWSCrash;
            }
            else
                objSMVINVerificationXml.iStatus = kWSSuccess;
            self.successCallback(objSMVINVerificationXml);
        }
    }
    
    if ([elementName isEqualToString:@"Error"]) {
        if(self.successCallback){
            objSMVINVerificationXml.iStatus = kWSCrash;
            self.successCallback(objSMVINVerificationXml);
            [parser abortParsing];
        }
    }
    
    if ([elementName isEqualToString:@"TUA_VehicleCodeAndDescriptionID"]) {
        objSMVINVerificationXml.strTUA_VehicleCodeAndDescriptionID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TUA_ConvergedDataID"]) {
        if(isVehicleConfirmationModelStarted){
           objSMVINVerificationXml.strTUA_ConvergedDataIDForVehicle = currentNodeContent;
        }else{
           objSMVINVerificationXml.strTUA_ConvergedDataIDForCode = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"DiscontinuedDate"]) {
        objSMVINVerificationXml.strDiscontinuedDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"IntroductionDate"]) {
        objSMVINVerificationXml.strIntroductionDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ResultCode"]) {
        objSMVINVerificationXml.strResultCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ResultCodeDescription"]) {
        objSMVINVerificationXml.strResultCodeDescription = currentNodeContent;
        if (isVehicleConfirmationModelStarted) {
            if(self.successCallback){
                objSMVINVerificationXml.iStatus = kWSError;
                self.successCallback(objSMVINVerificationXml);
                [parser abortParsing];
            }
        }
    }
    if ([elementName isEqualToString:@"TUA_VehicleConfirmationID"]) {
        objSMVINVerificationXml.strTUA_VehicleConfirmationID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"HPINumber"]) {
        objSMVINVerificationXml.strHPINumber = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchColour"]) {
        objSMVINVerificationXml.strMatchColour = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchModel"]) {
        objSMVINVerificationXml.strMatchModel = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchEngineNumber"]) {
        objSMVINVerificationXml.strMatchEngineNumber = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchManufacturer"]) {
        objSMVINVerificationXml.strMatchManufacturer = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchString"]) {
        objSMVINVerificationXml.strMatchString = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchVehicleRegistration"]) {
        objSMVINVerificationXml.strMatchVehicleRegistration = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchVinorChassis"]) {
        objSMVINVerificationXml.strMatchVinorChassis = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchYear"]) {
        objSMVINVerificationXml.strMatchYear = currentNodeContent;
    }
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMVINVerificationXml = [[SMVINVerificationXml alloc] init];
        if(self.successCallback){
            objSMVINVerificationXml.iStatus = kWSCrash;
            self.successCallback(objSMVINVerificationXml);
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
