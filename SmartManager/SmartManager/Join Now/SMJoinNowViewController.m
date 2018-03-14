//
//  SMJoinNowViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 08/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMJoinNowViewController.h"
#import "Fontclass.h"

@interface SMJoinNowViewController ()

@end

@implementation SMJoinNowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Fontclass AttributeStringMethodwithFontWithButtonForLogin:self.infoImage iconID:305];

    self.viewRectangle.layer.borderColor = [[UIColor colorWithRed:24.0/255 green:100.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.viewRectangle.layer.borderWidth= 0.8f;
    self.viewRectangle.layer.cornerRadius = 3.0;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblSmartManager.font = [UIFont fontWithName:FONT_NAME_BOLD size:25.0];
        self.btnPhone.titleLabel.font = [UIFont fontWithName:FONT_NAME size:15.0];
        self.btnEmailAddress.titleLabel.font = [UIFont fontWithName:FONT_NAME size:15.0];
        self.btnCancel.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblJoinNow.font = [UIFont fontWithName:FONT_NAME size:15.0];
    }
    else
    {
        self.lblSmartManager.font = [UIFont fontWithName:FONT_NAME_BOLD size:35.0];
        self.btnPhone.titleLabel.font = [UIFont fontWithName:FONT_NAME size:25.0];
        self.btnEmailAddress.titleLabel.font = [UIFont fontWithName:FONT_NAME size:25.0];
        self.btnCancel.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lblJoinNow.font = [UIFont fontWithName:FONT_NAME size:20.0];
    }
    
    NSAttributedString *emailAttributedString = [[NSAttributedString alloc]initWithString:@"support@ix.co.za" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithRed:24.0f/255.0f green:100.0f/255.0f blue:152.0f/255.0f alpha:1.0f],NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 15.0f : 25.0f]}];
    
    NSAttributedString *phoneAttributedString = [[NSAttributedString alloc]initWithString:@"0861 292 999" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithRed:24.0f/255.0f green:100.0f/255.0f blue:152.0f/255.0f alpha:1.0f],NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 15.0f : 25.0f]}];
    
    [self.btnEmailAddress setAttributedTitle:emailAttributedString forState:UIControlStateNormal];
    [self.btnPhone setAttributedTitle:phoneAttributedString forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)btnCancelDidClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)btnPhoneDidClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0861292999"]];
}
- (IBAction)btnEmailAddressDidClicked:(id)sender
{
    NSAttributedString *emailAttributedString = [[NSAttributedString alloc]initWithString:@"support@ix.co.za" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithRed:127.0f/255.0f green:127.0f/255.0f blue:127.0f/255.0f alpha:1.0f],NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 15.0f : 25.0f]}];
    
    [self.btnEmailAddress setAttributedTitle:emailAttributedString forState:UIControlStateNormal];

    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setToRecipients:@[@"support@ix.co.za"]];
        
        [self presentViewController:mail animated:YES completion:NULL];
    }
    else
    {
        SMAlert(KLoaderTitle, kEmailCanNotSend);

    }
}

#pragma mark


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            SMAlert(KLoaderTitle, KEmailsentSuccess);
            break;
        case MFMailComposeResultSaved:
            SMAlert(KLoaderTitle, KEmailSavedDrafts);
            break;
        case MFMailComposeResultCancelled:
            SMAlert(KLoaderTitle,KEmailCancel);
            break;
        case MFMailComposeResultFailed:
            SMAlert(KLoaderTitle,KEmailErrorOccured);
            break;
        default:
            SMAlert(KLoaderTitle,KEmailComposedError);
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
