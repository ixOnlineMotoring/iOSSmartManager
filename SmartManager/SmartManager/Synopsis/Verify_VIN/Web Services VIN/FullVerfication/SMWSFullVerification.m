//
//  SMWSFullVerification.m
//  Smart Manager
//
//  Created by Ankit S on 8/29/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSFullVerification.h"
#import "SMObjectVerificationDetailAttribute.h"
#import "SMObjectVerificationDetailType.h"
#import "SMVINVerificationXml.h"
typedef void(^successResponse)(SMFullVerificationObjectXML *objSMFullVerificationObjectXML);
typedef void(^failureResponse)(NSError *error);

@interface SMWSFullVerification() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSFullVerification
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMFullVerificationObjectXML *objSMFullVerificationObjectXML;
    
    SMObjectVerificationDetailType *objSMObjectVerificationDetailType;
    SMObjectVerificationDetailAttribute *objSMObjectVerificationDetailAttribute;
    
    BOOL isVehicleConfirmationModelStarted;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
    NSMutableDictionary *dictmAttributesDetails;
    
    NSDictionary *dictWhiteAttribute;
    NSDictionary *dictBlueAttribute;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMFullVerificationObjectXML *objSMFullVerificationObjectXML))successResponse
                              andError:(void(^)(NSError *error))failureResponse{
    
    UIFont *regularFont;
    isVehicleConfirmationModelStarted = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME size:12.0f];
    else
        regularFont = [UIFont fontWithName:FONT_NAME size:15.0f];
    
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorredBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
    
    // Create the attributes
    
    dictBlueAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorredBlue, NSForegroundColorAttributeName, nil];
    
    
    dictWhiteAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorWhite, NSForegroundColorAttributeName, nil];

    
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
#pragma mark - Xml parser delegate
-(void) parser:(NSXMLParser  *)     parser
didStartElement:(NSString    *)     elementName
  namespaceURI:(NSString     *)     namespaceURI
 qualifiedName:(NSString     *)     qName
    attributes:(NSDictionary *)     attributeDict
{
  
    if ([elementName isEqualToString:@"LoadTransUnionFullVerificationResult"]) {
        objSMFullVerificationObjectXML = [[SMFullVerificationObjectXML alloc] init];
        objSMFullVerificationObjectXML.arrmFullVerification = [[NSMutableArray alloc] init];
    }
    
    if ([elementName isEqualToString:@"VehicleConfirmationModel"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml = [[SMVINVerificationXml alloc] init];
    }
    
    if ([elementName isEqualToString:@"HPINumber"]) {
        isVehicleConfirmationModelStarted = NO;
    }
    
#pragma mark - Finance History and Finance
    
    if ([elementName isEqualToString:@"FinanceHistory"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Finance History";
        objSMObjectVerificationDetailType.iIndexSequence = kFinanceHistory;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"FinanceHistoryModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }
    
    if ([elementName isEqualToString:@"Finance"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Currently Finance?";
        objSMObjectVerificationDetailType.iIndexSequence = kCurrentlyFinanced;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
      
    }
    
    if ([elementName isEqualToString:@"FinanceModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }
  
  #pragma mark - Accident History , Alert History , FactoryFittedExtra , IVID History , Mileage History, Registration History and Stolen
    
    if ([elementName isEqualToString:@"AccidentHistory"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Accident History";
        objSMObjectVerificationDetailType.iIndexSequence = kAccidentHistory;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"AccidentHistoryModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }

    
    if ([elementName isEqualToString:@"Alert"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Alert";
        objSMObjectVerificationDetailType.iIndexSequence = kAlert;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"AlertModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }

    if ([elementName isEqualToString:@"FactoryFittedExtra"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Factory Fitted Extra";
        objSMObjectVerificationDetailType.iIndexSequence = kFactoryFittedExtra;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"FactoryFittedExtraModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }
    
    if ([elementName isEqualToString:@"IVIDHistory"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"IVID History";
        objSMObjectVerificationDetailType.iIndexSequence = kIVIDHistory;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"IVIDHistoryModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }
    
    if ([elementName isEqualToString:@"MileageHistory"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Mileage History";
        objSMObjectVerificationDetailType.iIndexSequence = kMileageHistory;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"MileageHistoryModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }
    
    if ([elementName isEqualToString:@"RegistrationHistory"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Registration History";
        objSMObjectVerificationDetailType.iIndexSequence = kRegistrationHistory;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"RegistrationHistoryModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }
    
    if ([elementName isEqualToString:@"Stolen"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Stolen";
        objSMObjectVerificationDetailType.iIndexSequence = kStolen;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"StolenModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }
    
    if ([elementName isEqualToString:@"Vesa"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Vesa Device";
        objSMObjectVerificationDetailType.iIndexSequence = kVesa;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"VesaModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }

    #pragma mark - Enquiries History
    if ([elementName isEqualToString:@"EnquiriesHistory"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Enquiries History";
        objSMObjectVerificationDetailType.iIndexSequence = kEnquiryHistory;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"EnquiriesHistoryModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }
    
#pragma mark - Microdot History
    if ([elementName isEqualToString:@"Microdot"]){
        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
        objSMObjectVerificationDetailType.strTitle = @"Microdot";
        objSMObjectVerificationDetailType.iIndexSequence = kMicrodot;
        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
    }
    
    if ([elementName isEqualToString:@"MicrodotModel"]){
        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
    }

#pragma mark - Vehicle confirmation model
//    if ([elementName isEqualToString:@"Microdot"]){
//        objSMObjectVerificationDetailType = [[SMObjectVerificationDetailType alloc]init];
//        objSMObjectVerificationDetailType.strTitle = @"Microdot";
//        objSMObjectVerificationDetailType.arrmType = [[NSMutableArray alloc]init];
//    }
//    
//    if ([elementName isEqualToString:@"VehicleConfirmationModel"]){
//        objSMObjectVerificationDetailAttribute = [[SMObjectVerificationDetailAttribute alloc]init];
//    }
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
    
    if ([elementName isEqualToString:@"LoadTransUnionFullVerificationResult"]) {
        if(self.successCallback){
            if (currentNodeContent.length == 0) {
                objSMFullVerificationObjectXML.iStatus = kWSNoRecord;
            }
            else{
                // sort the array using priority
                NSArray *sortedArray;
                sortedArray = [objSMFullVerificationObjectXML.arrmFullVerification sortedArrayUsingComparator:^NSComparisonResult(SMObjectVerificationDetailType *a, SMObjectVerificationDetailType *b) {
                    if ( a.iIndexSequence < b.iIndexSequence) {
                        return (NSComparisonResult)NSOrderedAscending;
                    } else if ( a.iIndexSequence > b.iIndexSequence) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    return (NSComparisonResult)NSOrderedSame;
                }];
                [objSMFullVerificationObjectXML.arrmFullVerification removeAllObjects];
                objSMFullVerificationObjectXML.arrmFullVerification = sortedArray.mutableCopy;
                
                objSMFullVerificationObjectXML.iStatus = kWSSuccess;
            }
            self.successCallback(objSMFullVerificationObjectXML);
        }
    }
    
    if ([elementName isEqualToString:@"Error"]) {
        if(self.successCallback){
                objSMFullVerificationObjectXML.iStatus = kWSNoRecord;
                self.successCallback(objSMFullVerificationObjectXML);
                [parser abortParsing];
        }
    }
    
    if ([elementName isEqualToString:@"TUA_VehicleCodeAndDescriptionID"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strTUA_VehicleCodeAndDescriptionID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TUA_ConvergedDataID"]) {
        if(isVehicleConfirmationModelStarted){
            objSMFullVerificationObjectXML.objSMVINVerificationXml.strTUA_ConvergedDataIDForVehicle = currentNodeContent;
        }else{
            objSMFullVerificationObjectXML.objSMVINVerificationXml.strTUA_ConvergedDataIDForCode = currentNodeContent;
        }
    }
    if ([elementName isEqualToString:@"DiscontinuedDate"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strDiscontinuedDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"IntroductionDate"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strIntroductionDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"ResultCode"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strResultCode = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"TUA_VehicleConfirmationID"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strTUA_VehicleConfirmationID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"HPINumber"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strHPINumber = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchColour"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strMatchColour = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchModel"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strMatchModel = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchEngineNumber"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strMatchEngineNumber = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchManufacturer"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strMatchManufacturer = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchString"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strMatchString = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchVehicleRegistration"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strMatchVehicleRegistration = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchVinorChassis"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strMatchVinorChassis = currentNodeContent;
    }
    if ([elementName isEqualToString:@"MatchYear"]) {
        objSMFullVerificationObjectXML.objSMVINVerificationXml.strMatchYear = currentNodeContent;
    }
    
#pragma mark - Finance History and Finance
    
    if ([elementName isEqualToString:@"FinanceHistory"]){
        [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"Finance"]){
        [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"FinanceHistoryModel"]){
        [self setFinalStringFinance:objSMObjectVerificationDetailAttribute];
    }
    
    if ([elementName isEqualToString:@"FinanceModel"]){
        [self setFinalStringFinance:objSMObjectVerificationDetailAttribute];
    }
   
    if ([elementName isEqualToString:@"TUA_FinanceHistoryID"]){
        objSMObjectVerificationDetailAttribute.strTUA_FinanceHistoryID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TUA_ConvergedDataID"]){
        objSMObjectVerificationDetailAttribute.strTUA_ConvergedDataID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"AgreementOrAccountNumber"]){
        objSMObjectVerificationDetailAttribute.strAgreementOrAccountNumber = currentNodeContent;
    }
    if ([elementName isEqualToString:@"AgreementType"]){
        objSMObjectVerificationDetailAttribute.strAgreementType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"EndDate"]){
        objSMObjectVerificationDetailAttribute.strEndDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FinanceHouse"]){
        objSMObjectVerificationDetailAttribute.strFinanceHouse = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"StartDate"]){
        objSMObjectVerificationDetailAttribute.strStartDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TelephoneNumber"]){
        objSMObjectVerificationDetailAttribute.strTelephoneNumber = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"FinanceBranch"]){
        objSMObjectVerificationDetailAttribute.strFinanceBranch = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FinanceProvider"]){
        objSMObjectVerificationDetailAttribute.strFinanceProvider = currentNodeContent;
    }
    if ([elementName isEqualToString:@"TelNumber"]){
        objSMObjectVerificationDetailAttribute.strTelephoneNumber = currentNodeContent;
    }
    
#pragma mark - Accident History , Alert History , FactoryFittedExtra , IVID History , Mileage History, Registration History and Stolen
    
    if ([elementName isEqualToString:@"ResultCodeDescription"]){
        if (isVehicleConfirmationModelStarted) {
            isVehicleConfirmationModelStarted = NO;
            objSMFullVerificationObjectXML.objSMVINVerificationXml.iStatus = kWSError;
            objSMFullVerificationObjectXML.objSMVINVerificationXml.strResultCodeDescription = currentNodeContent;
        }else{
        objSMObjectVerificationDetailAttribute.strResultCodeDescription = currentNodeContent;
        }
    }

    if ([elementName isEqualToString:@"AssessmentDate"]){
        objSMObjectVerificationDetailAttribute.strDate =currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"CertificateNumber"]){
        objSMObjectVerificationDetailAttribute.strCertificateNumber = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"AccidentHistory"]){
        [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"AccidentHistoryModel"]){
         [self setFinalStringAccidentHistory:objSMObjectVerificationDetailAttribute];
    }
    
    if ([elementName isEqualToString:@"Alert"]){
         [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"AlertModel"]){
        [self setFinalStringAlert:objSMObjectVerificationDetailAttribute];
    }
    
    if ([elementName isEqualToString:@"FactoryFittedExtra"]){
       [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"FactoryFittedExtraModel"]){
        [self setFinalStringFactoryFittedExtra:objSMObjectVerificationDetailAttribute];
    }
    
    if ([elementName isEqualToString:@"IVIDHistory"]){
          [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"IVIDHistoryModel"]){
        [self setFinalStringIVIDHistory:objSMObjectVerificationDetailAttribute];
    }
    
    if ([elementName isEqualToString:@"MileageHistory"]){
         [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"MileageHistoryModel"]){
       [self setFinalStringMilageHistory:objSMObjectVerificationDetailAttribute];
    }
    
    if ([elementName isEqualToString:@"RegistrationHistory"]){
         [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"RegistrationHistoryModel"]){
        [self setFinalStringRegistrationHistory:objSMObjectVerificationDetailAttribute];
    }
    
    if ([elementName isEqualToString:@"Stolen"]){
          [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"StolenModel"]){
        [self setFinalStringStolenHistory:objSMObjectVerificationDetailAttribute];
    }
    if ([elementName isEqualToString:@"Vesa"]){
       [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"VesaModel"]){
        [self setFinalStringVesa:objSMObjectVerificationDetailAttribute];
    }
    
#pragma mark - Enquiries History
    
    if ([elementName isEqualToString:@"Source"]){
        objSMObjectVerificationDetailAttribute.strSource = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"TransactionDate"]){
        
        objSMObjectVerificationDetailAttribute.strTransactionDate = currentNodeContent;
        
    }
    
    if ([elementName isEqualToString:@"EnquiriesHistory"]){
        [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"EnquiriesHistoryModel"]){
        [self setFinalStringEnquiriesHistory:objSMObjectVerificationDetailAttribute];
    }

    
#pragma mark - Microdot History
    
    if ([elementName isEqualToString:@"Company"]){
        objSMObjectVerificationDetailAttribute.strCompany = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"ContactNumber"]){
        objSMObjectVerificationDetailAttribute.strContactNumber = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"DateApplied"]){
        objSMObjectVerificationDetailAttribute.strDateApplied = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"ReferenceNumber"]){
        objSMObjectVerificationDetailAttribute.strReferenceNumber = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"Microdot"]){
        [objSMFullVerificationObjectXML.arrmFullVerification addObject:objSMObjectVerificationDetailType];
    }
    
    if ([elementName isEqualToString:@"MicrodotModel"]){
        [self setFinalStringMicroDot:objSMObjectVerificationDetailAttribute];
    }
   
#pragma mark - Vehicle Confirmation
   
if ([elementName isEqualToString:@"s:Fault"]) {
        objSMFullVerificationObjectXML = [[SMFullVerificationObjectXML alloc] init];
        if(self.successCallback){
            objSMFullVerificationObjectXML.iStatus = kWSCrash;
            self.successCallback(objSMFullVerificationObjectXML);
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



-(void)setFinalStringFinance:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
  
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    else
    {
    if (obj.strFinanceHouse.length!=0) {
       [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strFinanceHouse attributes:dictWhiteAttribute]];
       [self addSpace:obj];
    }
    
    if (obj.strFinanceProvider.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strFinanceProvider attributes:dictWhiteAttribute]];
         [self addSpace:obj];
    }
    
    if (obj.strFinanceBranch.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strFinanceBranch attributes:dictWhiteAttribute]];
         [self addSpace:obj];
    }
    
    if (obj.strAgreementType.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strAgreementType attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    
    if (obj.strTelephoneNumber.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:@"Tel: " attributes:dictBlueAttribute]];
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strTelephoneNumber attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    
    if (obj.strStartDate.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:@"From: " attributes:dictBlueAttribute]];
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strStartDate attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }

    if (obj.strEndDate.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:@"to: " attributes:dictBlueAttribute]];
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strEndDate attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }

    }
    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)setFinalStringAccidentHistory:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    else
    {
    if (obj.strDate.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strDate attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    }
    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)setFinalStringAlert:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
 
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }else{
        
    }
    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)setFinalStringFactoryFittedExtra:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
    
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }else{
        
    }
    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)setFinalStringIVIDHistory:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
    
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }else{
        
    }
    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)setFinalStringMilageHistory:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
    
    
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }else{
        if (obj.strDate.length!=0) {
            [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strDate attributes:dictWhiteAttribute]];
            [self addSpace:obj];
        }

    }
    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)setFinalStringRegistrationHistory:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
    
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }else{
        
        if (obj.strDate.length!=0) {
            [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strDate attributes:dictWhiteAttribute]];
            [self addSpace:obj];
        }
 
    }
    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)setFinalStringStolenHistory:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
    
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }else{
        if (obj.strDate.length!=0) {
            [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strDate attributes:dictWhiteAttribute]];
            [self addSpace:obj];
        }
    }
    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)setFinalStringVesa:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
    
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }else{
        if (obj.strDate.length!=0) {
            [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strDate attributes:dictWhiteAttribute]];
            [self addSpace:obj];
        }
        
        if (obj.strCertificateNumber.length!=0) {
            [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strCertificateNumber attributes:dictWhiteAttribute]];
            [self addSpace:obj];
        }
    }
    
   

    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)setFinalStringMicroDot:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
    
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }else{

    if (obj.strCompany.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strCompany attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    
    if (obj.strContactNumber.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strContactNumber attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    
    if (obj.strDateApplied.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strDateApplied attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    
    if (obj.strReferenceNumber.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strReferenceNumber attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    }
    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)setFinalStringEnquiriesHistory:(SMObjectVerificationDetailAttribute *)obj{
    
    obj.strFINAL = [[NSMutableAttributedString alloc]init];
    
    if (obj.strResultCodeDescription.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strResultCodeDescription attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }else{

    if (obj.strSource.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strSource attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    
    if (obj.strTransactionDate.length!=0) {
        [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:obj.strTransactionDate
                                                                             attributes:dictWhiteAttribute]];
        [self addSpace:obj];
    }
    }
        
    [objSMObjectVerificationDetailType.arrmType addObject:objSMObjectVerificationDetailAttribute];
}

-(void)addSpace:(SMObjectVerificationDetailAttribute *)obj{
    [obj.strFINAL appendAttributedString:[[NSAttributedString alloc] initWithString:@"; " attributes:dictWhiteAttribute]];
}
@end
