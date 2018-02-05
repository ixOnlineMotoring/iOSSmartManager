//
//  SMSettings_ReadinessViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 03/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSettings_ReadinessViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"
#import "SMCustomColor.h"

@interface SMSettings_ReadinessViewController ()

@end

@implementation SMSettings_ReadinessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Trade Readiness Reminders"];
    btnSaveReadiness.layer.cornerRadius = 4.0;
    [self webServiceForGettingReadiness];
    // Do any additional setup after loading the view from its nib.
}
-(void)viewWillAppear:(BOOL)animated
{
   

}

#pragma mark - WEb Services

-(void)webServiceForSettingReadiness
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
   
    
     NSMutableURLRequest *requestURL = [SMWebServices setTradeReadinessWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andNewDay:txtFieldNewVehicles.text.intValue andUsedRetailDay:txtFieldUsedRetail.text.intValue andUsedDemoDay:txtFieldUsedDemos.text.intValue];
    
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

-(void)webServiceForGettingReadiness
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
     DaysPositionNumber = 0;
    
    NSMutableURLRequest *requestURL = [SMWebServices getTradeReadinessWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue ];
    
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
    if ([elementName isEqualToString:@"Days"])
    {
        DaysPositionNumber++;
    }
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    
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

    if ([elementName isEqualToString:@"Days"])
    {

        if(DaysPositionNumber == 1)
            txtFieldNewVehicles.text = currentNodeContent;
        else if (DaysPositionNumber == 2)
            txtFieldUsedRetail.text = currentNodeContent;
        else if(DaysPositionNumber == 3)
            txtFieldUsedDemos.text = currentNodeContent;
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
    [self hideProgressHUD];
}
- (BOOL)validate
{
    if (!txtFieldNewVehicles.text.length>0)
    {
        SMAlert(KLoaderTitle, @"'Please enter new vehicles from day");
        
        return NO;
    }
    else if (!txtFieldUsedRetail.text.length>0)
    {
        SMAlert(KLoaderTitle, @"Please enter used retail");
        
        return NO;
    }
    else if (!txtFieldUsedDemos.text.length>0)
    {
        SMAlert(KLoaderTitle, @"Please enter readiness used demos");
        
        return NO;
    }
    else
        return YES;
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
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnSaveReadinessDidClicked:(id)sender
{
    [self.view endEditing:YES];
    if([self validate])
        [self webServiceForSettingReadiness];
}
@end
