//
//  SMVehicleStockAuditList.m
//  SmartManager
//
//  Created by Liji Stephen on 04/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMVehicleStockAuditList.h"
#import "SMCustomButtonBlue.h"
#import "SMCustomButtonGrayColor.h"
#import "SMVehicleAuditedTodayViewController.h"
#import "SMVehicle_StillToAudit_ViewController.h"
#import "SMVehicleAuditHistoryViewController.h"
#import "SMCustomerDLScanViewController.h"

@interface SMVehicleStockAuditList ()

@end

@implementation SMVehicleStockAuditList

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTheTitle];
    self.lblVinDesc.font = [UIFont fontWithName:FONT_NAME size:12.0];
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

- (IBAction)btnScanVINDidClicked:(id)sender
{
    SMCustomerDLScanViewController *scanObject = [[SMCustomerDLScanViewController alloc] initWithNibName:@"SMCustomerDLScanViewController" bundle:nil];
    
    scanObject.isComingFromStockAudit = YES;
    scanObject.isComingFromSynopsis = NO;
    //[self presentViewController:scanObject animated:NO completion:nil];
    [self.navigationController pushViewController:scanObject animated:YES];
 
    
}

- (IBAction)btnAuditedTodayDidClicked:(id)sender
{
    SMVehicleAuditedTodayViewController *auditTodayVC = [[SMVehicleAuditedTodayViewController alloc] initWithNibName:@"SMVehicleAuditedTodayViewController" bundle:nil];
    [self.navigationController pushViewController:auditTodayVC animated:YES];
    
}

- (IBAction)btnStillToAuditDidClicked:(id)sender
{
    
    SMVehicle_StillToAudit_ViewController *stillToAuditVC = [[SMVehicle_StillToAudit_ViewController alloc] initWithNibName:@"SMVehicle_StillToAudit_ViewController" bundle:nil];
    [self.navigationController pushViewController:stillToAuditVC animated:YES];
}

- (IBAction)btnAuditHistoryDidClicked:(id)sender
{
    SMVehicleAuditHistoryViewController *auditHistoryVC = [[SMVehicleAuditHistoryViewController alloc] initWithNibName:@"SMVehicleAuditHistoryViewController" bundle:nil];
    [self.navigationController pushViewController:auditHistoryVC animated:YES];
    
}

- (void)setTheTitle
{
    
    UILabel *listActiveSpecialsNavigTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        listActiveSpecialsNavigTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0f];//SavingsBond
    }
    else
    {
        listActiveSpecialsNavigTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];//SavingsBond
    }
    listActiveSpecialsNavigTitle.backgroundColor = [UIColor clearColor];
    listActiveSpecialsNavigTitle.textColor = [UIColor whiteColor]; // change this color
    listActiveSpecialsNavigTitle.text = @"Stock Audit";
    self.navigationItem.titleView = listActiveSpecialsNavigTitle;
    [listActiveSpecialsNavigTitle sizeToFit];
    
    
}


@end
