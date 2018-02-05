//
//  SMSettings_DisplayViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 03/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSettings_DisplayViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"
#import "SMCustomColor.h"

@interface SMSettings_DisplayViewController ()

@end

@implementation SMSettings_DisplayViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];
     self.navigationItem.titleView = [SMCustomColor setTitle:@"My Trade Advert Displays"];
    btnSaveDisplay.layer.cornerRadius = 4.0;

    [self webServiceForGettingDisplay];
}

#pragma mark - WEb Services

-(void)webServiceForSettingDisplay
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
  
    
     NSMutableURLRequest *requestURL = [SMWebServices setTradeDisplayWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andTradePrice:checkBoxTradePrice.isSelected andDaysInStock:checkBoxDaysinStock.isSelected andAppraisal:checkBoxAppraisal.isSelected];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)webServiceForGettingDisplay
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    NSMutableURLRequest *requestURL = [SMWebServices getTradeDisplayWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue ];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

#pragma mark - NSXMLParser Delegate Methods

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"TradePriceBreakDown"])
    {
        checkBoxTradePrice.selected = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"DaysInStock"])
    {
        checkBoxDaysinStock.selected = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"Appraisal"])
    {
        checkBoxAppraisal.selected = currentNodeContent.boolValue;
    }
    
    if([elementName isEqualToString:@"Message"])
    {
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel)
            {
                
                [self.navigationController popViewControllerAnimated:YES];
                
                return;
                
            }
            
        }];
        
    }

}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
    [self hideProgressHUD];
}

#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.color = [UIColor blackColor];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}

-(void) hideProgressHUD
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
        });
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)checkBoxTradePriceDidClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)checkBoxDaysInStockDidClicked:(UIButton*)sender
{
     sender.selected = !sender.selected;
}

- (IBAction)checkBoxAppraisalDidClicked:(UIButton*)sender
{
     sender.selected = !sender.selected;
}

- (IBAction)btnSaveDisplayDidClicked:(id)sender
{
    [self webServiceForSettingDisplay];
}
@end
