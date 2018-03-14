//
//  SMWSLeadPool.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 16/06/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import "SMWSGroupID.h"

typedef void(^successResponse)(int iStatus);
typedef void(^failureResponse)(NSError *error);

@interface SMWSGroupID() {
}

@property (copy, nonatomic) successResponse successCallback;
@property (copy, nonatomic) failureResponse failCallback;

@end
@implementation SMWSGroupID
{
    NSXMLParser *xmlParser;
    NSString *element;
    NSMutableString *currentNodeContent;
    NSMutableArray *arrmTemp;
    BOOL isGroupIDFound;
}


- (void)responseForWebServiceForReuest:(NSMutableURLRequest *)requestURL
                              response:(void(^)(int iStatus))successResponse
                              andError:(void(^)(NSError *error))failureResponse{
    
    self.successCallback = successResponse;
    self.failCallback = failureResponse;
    isGroupIDFound = NO;
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
    
    if ([elementName isEqualToString:@"ID"])
    {
        if(self.successCallback){
            if (currentNodeContent.length == 0) {
                self.successCallback(kWSNoRecord);
                [xmlParser abortParsing];
            }
            else{
                [SMGlobalClass sharedInstance].strGroupID = currentNodeContent;
                self.successCallback(kWSSuccess);
                [xmlParser abortParsing];
            }
        }
    }
    
    if ([elementName isEqualToString:@"ID"])
    {
        isGroupIDFound = YES;
    }
    
    
    if ([elementName isEqualToString:@"GetClientCorprateGroupsResponse"]) {
        if(self.successCallback){
            if (!isGroupIDFound) {
                self.successCallback(kWSNOGroupIdFound);
                [parser abortParsing];
            }
        }
    }

    
    if ([elementName isEqualToString:@"s:Fault"]) {
        
        if(self.successCallback){
            self.successCallback(kWSCrash);
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
