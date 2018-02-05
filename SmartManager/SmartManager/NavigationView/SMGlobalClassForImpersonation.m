//
//  SMGlobalClassForImpersonation.m
//  SmartManager
//
//  Created by Liji Stephen on 21/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMGlobalClassForImpersonation.h"
#import "SMGlobalClass.h"
#import "SMWebServices.h"
@implementation SMGlobalClassForImpersonation

@synthesize strImpersonateString;

static SMGlobalClassForImpersonation *sharedInstance;




+(SMGlobalClassForImpersonation *)sharedInstance
{
    
    @synchronized([SMGlobalClassForImpersonation class]){
        
        if (sharedInstance==nil) {
            sharedInstance=[[self alloc]init];
        }
        
        return sharedInstance;
    }
    
    return nil;
}

-(void)parseTheImpersonateClients
{
   // HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:HUD];
    
    //HUD.delegate = self;
    //HUD.labelText = KLoaderWait;
    //[HUD show:YES];
    
    [SMGlobalClass sharedInstance].arrayOfImpersonateClients = [[NSMutableArray alloc]init];
    
    //    getAllImpersonateClientWithUserHash
    
    NSMutableURLRequest *requestURL=[SMWebServices getAllImpersonateClientWithUserHash:[SMGlobalClass sharedInstance].hashValue];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             [[[UIAlertView alloc]initWithTitle:@"Error"
                                        message:error.localizedDescription
                                       delegate:self cancelButtonTitle:@"Ok"
                              otherButtonTitles:nil, nil]
              show];
            // [HUD hide:YES];
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
    
    //    NSData *data = [self.strImpersonateString dataUsingEncoding:NSUTF8StringEncoding];
    //    xmlParser = [[NSXMLParser alloc] initWithData: data];
    //    [xmlParser setDelegate: self];
    //    [xmlParser setShouldResolveExternalEntities:YES];
    //    [xmlParser parse];
}
#pragma mark - Parsing delegate methods

// The first method to implement is parser:didStartElement:namespaceURI:qualifiedName:attributes:, which is fired when the start tag of an element is found:

//---when the start of an element is found---

-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict
{
       if( [elementName isEqualToString:@"Client"])
    {
        
            self.impersonateClientObj = [[SMImpersonateObject alloc]init];
            self.impersonateClientObj.impersonateClientID = [attributeDict valueForKey:@"id"];
            
        
        
    }
    
    
    
}


//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *) parser foundCharacters:(NSString *)string
{
        if(self.impersonateClientObj!=nil)
        {
            self.impersonateClientObj.impersonateClientName = string;
        }
        
    
}



//Finally, when the parser encounters the end of an element, it fires the parser:didEndElement:namespaceURI:qualifiedName: method:

//---when the end of element is found---

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
        if( [elementName isEqualToString:@"Client"])
        {
            
            [[SMGlobalClass sharedInstance].arrayOfImpersonateClients addObject:self.impersonateClientObj];
            
        }
    
    
    
}

-(void) parserDidEndDocument:(NSXMLParser *)parser
{
   [self.impersonateDelegate sendTheImpersonateClients:[SMGlobalClass sharedInstance].arrayOfImpersonateClients];
}




@end
