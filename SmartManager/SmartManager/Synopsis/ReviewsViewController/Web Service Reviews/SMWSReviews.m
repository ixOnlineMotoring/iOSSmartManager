//
//  SMWSReviews.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 24/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSReviews.h"

typedef void(^successResponse)(SMReviewsXmlResultObject *objSMVINHistoryXmlResultObject);
typedef void(^failureResponse)(NSError *error);

@interface SMWSReviews() {
    
    SMReviewsObject *objSMreviews;
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSReviews
{
    NSXMLParser *xmlParser;
    NSString *element;
    SMReviewsXmlResultObject *objSMReviewsXmlResultObject;

    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
}

- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(SMReviewsXmlResultObject *objSMReviewsXmlResultObject))successResponse
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
    
    if ([elementName isEqualToString:@"LoadReviewsForVariantByIDResult"]) {
        objSMReviewsXmlResultObject = [[SMReviewsXmlResultObject alloc] init];
        objSMReviewsXmlResultObject.arrmReviews = [[NSMutableArray alloc] init];
        isOnlyForDetailPageContent = NO;
        
    }
    
    if ([elementName isEqualToString:@"LoadReviewsForModelByIDExcludeVariantByCodeResult"]) {
        
        objSMReviewsXmlResultObject = [[SMReviewsXmlResultObject alloc] init];
        objSMReviewsXmlResultObject.arrmReviews = [[NSMutableArray alloc] init];
        isOnlyForDetailPageContent = YES;
    }
    if ([elementName isEqualToString:@"LoadReviewByIdResult"])
    {
        objSMReviewsXmlResultObject = [[SMReviewsXmlResultObject alloc] init];
        objSMReviewsXmlResultObject.arrmReviews = [[NSMutableArray alloc] init];
        isOnlyForDetailPageContent = YES;
    }
    
    if ([elementName isEqualToString:@"article"]) {
        objSMreviews = [[SMReviewsObject alloc] init];
    }
    if ([elementName isEqualToString:@"images"]) {
        objSMreviews.arrmImages = [[NSMutableArray alloc] init];
    }
    
       currentNodeContent = [NSMutableString stringWithString:@""];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
   // NSLog(@"STRING = %@",string);
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
}

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    
    currentNodeContent = (NSMutableString *) [currentNodeContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
   // NSLog(@"didEndElement elementName : %@ currentNodeContent : %@", elementName,currentNodeContent);
   
    if ([elementName isEqualToString:@"reviewID"]) {
        objSMreviews.reviewID = currentNodeContent.intValue;
    }
    if ([elementName isEqualToString:@"title"]) {
        objSMreviews.strTitle = currentNodeContent;
    }
    if ([elementName isEqualToString:@"type"]) {
        objSMreviews.strType = currentNodeContent;
    }
    if ([elementName isEqualToString:@"date"]) {
        objSMreviews.strDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"source"]) {
        objSMreviews.strSource = currentNodeContent;
    }
    if ([elementName isEqualToString:@"author"]) {
        objSMreviews.strAuthor = currentNodeContent;
    }
    if ([elementName isEqualToString:@"makeName"]) {
        objSMReviewsXmlResultObject.strOtherMakeName = currentNodeContent;
    }
    if ([elementName isEqualToString:@"modelName"]) {
        objSMReviewsXmlResultObject.strOtherModelName = currentNodeContent;
    }
   
    if ([elementName isEqualToString:@"summary"]) {
        objSMreviews.strBody = currentNodeContent;
    }
    if ([elementName isEqualToString:@"body"]) {
        NSMutableString *mutstr = [[NSMutableString alloc] initWithString:@"<font face='OpenSans-Light'><font color='white'>"];
        [mutstr appendString:currentNodeContent];
        objSMreviews.strBody = mutstr.mutableCopy;
        
        if(isOnlyForDetailPageContent)
            objSMreviews.strBody=[[SMCommonClassMethods shareCommonClassManager]flattenHTMLWithOnlyWhiteColor:currentNodeContent];
        
    }
    if ([elementName isEqualToString:@"summary"]) {
        NSMutableString *mutstr = [[NSMutableString alloc] initWithString:@"<font face='OpenSans-Light'><font size='2' color='white'>"];
        [mutstr appendString:currentNodeContent];
        objSMreviews.strBody = mutstr.mutableCopy;
        
        //objSMreviews.strBody=[[SMCommonClassMethods shareCommonClassManager]flattenHTML:currentNodeContent];
        
        
    }
    if ([elementName isEqualToString:@"image"]) {
        [objSMreviews.arrmImages addObject:currentNodeContent];
    }
    
    if ([elementName isEqualToString:@"article"]) {
        [objSMReviewsXmlResultObject.arrmReviews addObject:objSMreviews];
    }
    
    if ([elementName isEqualToString:@"LoadReviewByIdResult"]) {
        if(self.successCallback)
        {
            objSMReviewsXmlResultObject.iStatus = kWSSuccess;
            self.successCallback(objSMReviewsXmlResultObject);
        }
    }
    if ([elementName isEqualToString:@"LoadReviewsForVariantByIDResult"]) {
        if(self.successCallback)
        {
            objSMReviewsXmlResultObject.iStatus = kWSSuccess;
            self.successCallback(objSMReviewsXmlResultObject);
        }
    }
    if ([elementName isEqualToString:@"LoadReviewsForModelByIDExcludeVariantByCodeResult"]) {
        if(self.successCallback)
        {
            objSMReviewsXmlResultObject.iStatus = kWSSuccess;
            self.successCallback(objSMReviewsXmlResultObject);
        }
    }
    
    if ([elementName isEqualToString:@"s:Fault"]) {
        objSMReviewsXmlResultObject = [[SMReviewsXmlResultObject alloc] init];
        if(self.successCallback){
            objSMReviewsXmlResultObject.iStatus = kWSCrash;
            self.successCallback(objSMReviewsXmlResultObject);
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
