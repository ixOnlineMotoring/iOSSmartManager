//
//  SMSynopsisVINScanViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 18/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSynopsisVINScanViewController.h"
#import "SMCustomerDLScanViewController.h"
#import "SMSynopsisScanDetailViewController.h"
#import "SMCustomColor.h"
#import "SMSavedScanVinViewController.h"
#import "SMSynopsisSummaryViewController.h"
#import "SMSynopsisDoAppraisalViewController.h"

@interface SMSynopsisVINScanViewController ()
{
    
    IBOutlet UIButton *btnScanVIN;
    IBOutlet UIButton *btnSavedVINScans;
    
}
- (IBAction)btnActnScanVINdidClicked:(id)sender;
- (IBAction)btnSavedVINDidClicked:(id)sender;

@end

@implementation SMSynopsisVINScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Scan VIN"];

       
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Button Methods

- (IBAction)btnActnScanVINdidClicked:(id)sender {

    /*SMSynopsisScanDetailViewController *vcSMSynopsisScanDetailViewController = [[SMSynopsisScanDetailViewController alloc] initWithNibName:@"SMSynopsisScanDetailViewController" bundle:nil];
    [self.navigationController pushViewController:vcSMSynopsisScanDetailViewController animated:YES];*/
    SMCustomerDLScanViewController *scanObject = [[SMCustomerDLScanViewController alloc] initWithNibName:@"SMCustomerDLScanViewController" bundle:nil];
    
    scanObject.isComingFromStockAudit = NO;
    scanObject.isComingFromSynopsis = YES;
    scanObject.strFromViewController  = @"SMSynopsisVINScanViewController";
    [self.navigationController pushViewController:scanObject animated:YES];

}

- (IBAction)btnSavedVINDidClicked:(id)sender {
  
    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
       SMSavedScanVinViewController *vcSMSavedScanVinViewController = [[SMSavedScanVinViewController alloc] initWithNibName:@"SMSavedScanVinViewController" bundle:nil];
    
    
    [self.navigationController pushViewController:vcSMSavedScanVinViewController animated:YES];
    }
    else
    {
        SMSavedScanVinViewController *vcSMSavedScanVinViewController = [[SMSavedScanVinViewController alloc] initWithNibName:@"SMSavedScanVinViewController" bundle:nil];
        
        [self.navigationController pushViewController:vcSMSavedScanVinViewController animated:YES];
    }

    /*
     SMSynopsisDoAppraisalViewController *vcSMSynopsisDoAppraisalViewController = [[SMSynopsisDoAppraisalViewController alloc] initWithNibName:@"SMSynopsisDoAppraisalViewController" bundle:nil];
     [self.navigationController pushViewController:vcSMSynopsisDoAppraisalViewController animated:NO];*/
}

-(void)nextButtonDidClicked{
    
    SMSynopsisSummaryViewController *obj = [[SMSynopsisSummaryViewController alloc]initWithNibName:@"SMSynopsisSummaryViewController" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}
@end
