//
//  SMSettings_CustomMsgsViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 05/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSettings_CustomMsgsViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"

@interface SMSettings_CustomMsgsViewController ()

@end

@implementation SMSettings_CustomMsgsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.titleView = [SMCustomColor setTitle:@"Custom Messages"];
    btnSaveCustomMsg.layer.cornerRadius = 4.0;

    txtViewPurchases.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtViewPurchases.layer.borderWidth= 0.8f;
    
    txtViewOffer.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtViewOffer.layer.borderWidth= 0.8f;
    
    txtViewTender.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtViewTender.layer.borderWidth= 0.8f;
    [self addingProgressHUD];
    // Do any additional setup after loading the view from its nib.

    [self webServiceForGetSaveTradeCustomMessages];
}

- (void)textViewDidBeginEditing:(CustomTextView *)textView
{
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 1;
    [scrollView setContentOffset:pt animated:NO];
}

- (BOOL)textView:(CustomTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:scrollView];
    pt = rc.origin;
    pt.x = 0;
    
    pt.y -= 1;
    [scrollView setContentOffset:pt animated:NO];
    
    return YES;
}

- (IBAction)btnSaveMessagedidClicked:(id)sender {

    [self.view endEditing:YES];
    if([self validate])
        [self webServiceForSaveTradeCustomMessages];
}

#pragma mark - WEb Services
-(void)webServiceForSaveTradeCustomMessages{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];


    NSMutableURLRequest *requestURL = [SMWebServices setSaveTradeCustomMessagesWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andPurchase:txtViewPurchases.text andOffer:txtViewOffer.text andTender:txtViewTender.text];

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
-(void)webServiceForGetSaveTradeCustomMessages{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];


    NSMutableURLRequest *requestURL = [SMWebServices getSaveTradeCustomMessagesWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue];

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

    NSLog(@"elementName %@  currentNodeContent %@",elementName,currentNodeContent);

    if([elementName isEqualToString:@"Purchase"])
    {
        txtViewPurchases.text = currentNodeContent;
    }


    if([elementName isEqualToString:@"Offer"])
    {
        txtViewOffer.text = currentNodeContent;
    }


    if([elementName isEqualToString:@"Tender"])
    {
        txtViewTender.text = currentNodeContent;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");
    [self hideProgressHUD];
}
- (BOOL)validate
{
    if (!txtViewPurchases.text.length>0)
    {
        SMAlert(KLoaderTitle, @"Please enter purchases");

        return NO;
    }
    else if (!txtViewOffer.text.length>0)
    {
        SMAlert(KLoaderTitle, @"Please enter offer");

        return NO;
    }
    else if (!txtViewTender.text.length>0)
    {
        SMAlert(KLoaderTitle, @"Please enter tender");

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
