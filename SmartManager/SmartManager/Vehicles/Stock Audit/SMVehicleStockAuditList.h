//
//  SMVehicleStockAuditList.h
//  SmartManager
//
//  Created by Liji Stephen on 04/06/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomButtonBlue.h"
#import "SMCustomButtonGrayColor.h"

@interface SMVehicleStockAuditList : UIViewController

@property (strong, nonatomic) IBOutlet SMCustomButtonBlue *btnScanVIN;

@property (strong, nonatomic) IBOutlet UILabel *lblVinDesc;

@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnAuditedToday;

@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnStillToAudit;

@property (strong, nonatomic) IBOutlet SMCustomButtonGrayColor *btnAuditHistory;

- (IBAction)btnScanVINDidClicked:(id)sender;

- (IBAction)btnAuditedTodayDidClicked:(id)sender;

- (IBAction)btnStillToAuditDidClicked:(id)sender;


- (IBAction)btnAuditHistoryDidClicked:(id)sender;

@end
