//
//  SMLoginViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMLoginViewController.h"
#import "SMWebServices.h"
#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>
#import "SMGlobalClass.h"
#import "SMJoinNowViewController.h"
#import "UITextField+Padding.h"
#import "SMConstants.h"
#import "Fontclass.h"
#import "SDImageCache.h"
#import "SMAppDelegate.h"

@interface SMLoginViewController ()
@end

@implementation SMLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [Fontclass AttributeStringMethodwithFontWithButtonForLogin:self.btnUserImage iconID:573];
    [Fontclass AttributeStringMethodwithFontWithButtonForLogin:self.btnPasswordImage iconID:341];
    [Fontclass AttributeStringMethodwithFontWithButtonForLogin:self.infoImage iconID:305];
    /*[Fontclass AttributeStringMethodwithFontWithButtonForLogin:self.btnUserImage iconID:573];
    [Fontclass AttributeStringMethodwithFontWithButtonForLogin:self.btnPasswordImage iconID:285];
    [Fontclass AttributeStringMethodwithFontWithButtonForLogin:self.infoImage iconID:251];*/
    
    self.viewUsername.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.viewUsername.layer.borderWidth= 0.8f;
    
    self.viewPassword.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.viewPassword.layer.borderWidth= 0.8f;

    self.customAlertBox.layer.cornerRadius = 5.0;
    
    
    
    if(![[SMGlobalClass sharedInstance].strDefaultClientID isEqualToString:@"1"])
        self.imgClientImage.image = [self getImageFromPathImage:@"clientImage.png"];
   
   
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblLoginDetails.font = [UIFont fontWithName:FONT_NAME size:12.0];
        self.btnJoinNow.titleLabel.font = [UIFont fontWithName:FONT_NAME size:15.0];
        self.btnLogin.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0];
        self.lblHeaderTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:25.0];
        
        self.txtFieldUserName.font = [UIFont fontWithName:FONT_NAME size:15.0];
        self.txtFieldPassword.font = [UIFont fontWithName:FONT_NAME size:15.0];
    }
    else
    {
        self.lblLoginDetails.font = [UIFont fontWithName:FONT_NAME_BOLD size:25.0];
        self.btnJoinNow.titleLabel.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.btnLogin.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
        self.lblHeaderTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:35.0];
        self.txtFieldUserName.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.txtFieldPassword.font = [UIFont fontWithName:FONT_NAME size:20.0];
    }
    
    self.btnLogin.layer.cornerRadius = 4.0;
    
//    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 29, 30)];
//    UIImageView *imgView1 = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 17)];
//    imgView1.image = [UIImage imageNamed:@"lockIcon"];
//    
//    [view1 addSubview:imgView1];
//    self.txtFieldPassword.leftView = view1;
//    
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 29, 30)];
//    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 20, 17)];
//    imgView.image = [UIImage imageNamed:@"userIcon"];
//    
//    [view addSubview:imgView];
//    self.txtFieldUserName.leftView = view;
//    
//    [view setBackgroundColor:[UIColor redColor]];
//    [view1 setBackgroundColor:[UIColor brownColor]];
    
    refreshData = [[SMClassForRefreshingData alloc]init];
    refreshData.authenticateDelegate = self;
    
    UITapGestureRecognizer *tappedObject = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapped)];
    
    [tappedObject setCancelsTouchesInView:NO];
    //[self.view addGestureRecognizer:tappedObject];
    
    UIColor *color = [UIColor colorWithRed:110.0f/255.0f green:110.0f/255.0f blue:110.0f/255.0f alpha:0.8];
    self.txtFieldUserName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Username" attributes:@{NSForegroundColorAttributeName:color}];
    
    self.txtFieldPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName:color}];
}

- (void)tapped
{
    [self.txtFieldUserName resignFirstResponder];
    [self.txtFieldPassword resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:NO];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:NO];
  //  [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - textField delegate methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    
    if(textField == self.txtFieldUserName)
        [self.txtFieldPassword becomeFirstResponder];
    
    return YES;
}

#pragma mark - keyboard notifications

-(void)keyboardWillShow
{
    //self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-50, self.view.frame.size.width, self.view.frame.size.height);

}

-(void)keyboardWillHide
{
   // self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+50, self.view.frame.size.width, self.view.frame.size.height);
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginDidClicked:(id)sender
{
    [self.view endEditing:YES];
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] clearDisk];
   
    if (self.txtFieldUserName.text.length == 0)
    {
       
        UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:KLoaderTitle  message:@"Please enter user name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alrt show];
    }
    else if (self.txtFieldPassword.text.length == 0)
    {
    
        UIAlertView *alrt = [[UIAlertView alloc] initWithTitle:KLoaderTitle  message:@"Please enter password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alrt show];
    }
    else
    {
        [self.view endEditing:YES];
        
        [refreshData authenticateWithServerWithUsername:[self encodeString:self.txtFieldUserName.text] andPassword:self.txtFieldPassword.text];
    }
    
}

- (IBAction)btnJoinNowDidClicked:(id)sender
{
    SMJoinNowViewController *joinNowController;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        joinNowController = [[SMJoinNowViewController alloc]initWithNibName:@"SMJoinNowViewController" bundle:nil];
    }
    else
    {
        joinNowController = [[SMJoinNowViewController alloc]initWithNibName:@"SMJoinNowViewController_iPad" bundle:nil];
    }

    [self presentViewController:joinNowController animated:YES completion:NULL];
}

#pragma mark - custom delegate methods implementation

-(void)authenticationFailed
{
    self.lblLoginErrorMessage.text = @"Unknown Username or Password.";
    [self loadPopup];
    self.txtFieldPassword.text = @"";
    self.txtFieldUserName.text = @"";
}
/////////////////////Monami/////////////////
//// Add the Custom Delegate to get pop up after getting failure message
-(void)authenticationFailedDuetoServer:(NSString *)message{
    self.lblLoginErrorMessage.text = message;
    [self loadPopup];

}
////////////////////////End//////////////////
-(void)authenticationSucceeded
{
    prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:self.txtFieldUserName.text forKey:@"UserName"];
    [prefs setValue:self.txtFieldPassword.text forKey:@"Password"];
    [prefs synchronize];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"setTheTopHeaderData" object:nil];
    [self dismissViewControllerAnimated:NO completion:^{
        
    }];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"InitialRefreshForSideMenu" object:[SMGlobalClass sharedInstance].arrayOfModules];
}


-(void)authenticationPartiallyFailed
{
    self.lblLoginErrorMessage.text = @"You do not have access to any modules.";
    [self loadPopup];
}

#pragma mark- load popup
-(void)loadPopup
{
    
    [self.popUpView setFrame:[UIScreen mainScreen].bounds];
    [self.popUpView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.50]];
    [self.popUpView setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.popUpView];
    [self.popUpView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [self.popUpView setAlpha:0.75];
         [self.popUpView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [self.popUpView setAlpha:1.0];
              
              [self.popUpView setTransform:CGAffineTransformIdentity];
          }
                          completion:^(BOOL finished)
          {
          }];
         
     }];
}

#pragma mark - dismiss popup
-(void)dismissPopup
{
    [self.popUpView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:self.popUpView];
    [UIView animateWithDuration:0.1 animations:^{
        [self.popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [self.popUpView setAlpha:0.3];
              [self.popUpView setTransform:CGAffineTransformMakeScale(0.9    ,0.9)];
              
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   
                   [self.popUpView setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [self.popUpView removeFromSuperview];
                   [self.popUpView setTransform:CGAffineTransformIdentity];
                   
                   
               }];
              
          }];
         
     }];
    
}




- (UIImage*)getImageFromPathImage:(NSString*)imageName1
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", imageName1]];

    return [UIImage imageWithContentsOfFile:fullPathOfImage];
}



#pragma mark -

- (IBAction)btnCancelCustomAlertDidClicked:(id)sender
{
    [self dismissPopup];

}


- (IBAction)btnEmailDidClicked:(id)sender
{
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setToRecipients:@[@"support@ix.co.za"]];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:mail animated:YES completion:NULL];
            
        });
    }
    else
    {
        UIAlertView *alertInternal = [[UIAlertView alloc]
                                      initWithTitle: NSLocalizedString(@"Notification", @"")
                                      message: NSLocalizedString(@"You have not configured your e-mail client.", @"")
                                      delegate: nil
                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                      otherButtonTitles:nil];
        [alertInternal show];
    }

    
    
}

- (IBAction)btnPhoneDidClicked:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel:0861292999"]];
}
#pragma mark


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultSent:
            [self showAlert:@"You Sent The Email."];
            break;
        case MFMailComposeResultSaved:
            [self showAlert:@"You Saved A Draft Of This Email."];
            break;
        case MFMailComposeResultCancelled:
            [self showAlert:@"You Cancelled Sending This Email."];
            break;
        case MFMailComposeResultFailed:
            [self showAlert:@"An Error Occurred When Trying To Compose This Email."];
            break;
        default:
            [self showAlert:@"An Error Occurred When Trying To Compose This Email"];
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showAlert:(NSString*)message
{
    SMAlert(KLoaderTitle, message);
}

-(NSString *) encodeString:(NSString *) encodeString
{
    encodeString = [NSString stringWithFormat:@"<![CDATA[%@]]>",encodeString]; // category method call
    return encodeString;
}
@end
