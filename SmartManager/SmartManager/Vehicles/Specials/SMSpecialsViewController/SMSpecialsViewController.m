//
//  SMSpecialsViewController.m
//  SmartManager
//
//  Created by Sandeep on 19/11/14. // Modifications By Jignesh K
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMSpecialsViewController.h"
#import "SMCustomColor.h"

@interface SMSpecialsViewController ()

@end

@implementation SMSpecialsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Specials"];

    self.btnCreateSpecial.layer.cornerRadius        = 4.0f;
    self.btnListActiveSpecials.layer.cornerRadius   = 4.0f;
    self.btnListExpiredSpedials.layer.cornerRadius  = 4.0f;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.btnCreateSpecial.titleLabel           setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14.0f]];
        [self.btnListActiveSpecials.titleLabel      setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14.0f]];
        [self.btnListExpiredSpedials.titleLabel     setFont:[UIFont fontWithName:FONT_NAME_BOLD size:14.0f]];
        [self.lblDetail                             setFont:[UIFont fontWithName:FONT_NAME size:13.0f]];
    }
    else
    {
        [self.btnCreateSpecial.titleLabel           setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0f]];
        [self.btnListActiveSpecials.titleLabel      setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0f]];
        [self.btnListExpiredSpedials.titleLabel     setFont:[UIFont fontWithName:FONT_NAME_BOLD size:20.0f]];
        [self.lblDetail                             setFont:[UIFont fontWithName:FONT_NAME size:20.0f]];
    }
}

- (IBAction)createSpecialDidClick:(id)sender
{
    __block SMCreateSpecialViewController *createSpecialObj;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        createSpecialObj = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
        [[SMCreateSpecialViewController alloc]initWithNibName:@"SMCreateSpecialViewController" bundle:nil] :
        [[SMCreateSpecialViewController alloc]initWithNibName:@"SMCreateSpecialViewController_iPad" bundle:nil];
        [self.navigationController pushViewController:createSpecialObj animated:YES];
    });
}

- (IBAction)listActiveSpecialsDidClick:(id)sender {
    
   __block SMListActiveSpecialsViewController *listActiveSpecialsObj;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        listActiveSpecialsObj = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
        [[SMListActiveSpecialsViewController alloc]initWithNibName:@"SMListActiveSpecialsViewController" bundle:nil] :
        [[SMListActiveSpecialsViewController alloc]initWithNibName:@"SMListActiveSpecialsViewController_iPad" bundle:nil];
        [self.navigationController pushViewController:listActiveSpecialsObj animated:YES];
    });
}

- (IBAction)listExpiredSpecialsDidClick:(id)sender
{
    __block SMListExpiredSpecialsViewController *listActiveSpecialsObj;

    dispatch_async(dispatch_get_main_queue(), ^{
        listActiveSpecialsObj = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
        [[SMListExpiredSpecialsViewController alloc]initWithNibName:@"SMListExpiredSpecialsViewController" bundle:nil] :
        [[SMListExpiredSpecialsViewController alloc]initWithNibName:@"SMListExpiredSpecialsViewController_iPad" bundle:nil];
        listActiveSpecialsObj.isFromUnPublished = NO;
        [self.navigationController pushViewController:listActiveSpecialsObj animated:YES];
    });
}

- (IBAction)btnListUnPublishedDidClicked:(id)sender {
    
    __block SMListExpiredSpecialsViewController *listActiveSpecialsObj;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        listActiveSpecialsObj = (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ?
        [[SMListExpiredSpecialsViewController alloc]initWithNibName:@"SMListExpiredSpecialsViewController" bundle:nil] :
        [[SMListExpiredSpecialsViewController alloc]initWithNibName:@"SMListExpiredSpecialsViewController_iPad" bundle:nil];
        listActiveSpecialsObj.isFromUnPublished = YES;
        [self.navigationController pushViewController:listActiveSpecialsObj animated:YES];
    });
    
}

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
