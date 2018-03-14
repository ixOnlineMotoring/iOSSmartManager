//
//  SMPricing_ValuationViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 20/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLabelAutolayout.h"
#import "SMSynopsisXMLResultObject.h"
#import "MBProgressHUD.h"

@interface SMPricing_ValuationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,MBProgressHUDDelegate,NSURLSessionDelegate,NSURLSessionTaskDelegate>
{

    IBOutlet NSLayoutConstraint *lblCostApplyHeightConstraint;
    
    IBOutlet SMCustomLabelAutolayout *lblCostsMayApply;
    
    NSMutableString *currentNodeContent;
    
    NSXMLParser *xmlParser;

}
@property(nonatomic,strong) NSString *strVehicleYear;
@property(nonatomic,strong) NSString *strVehicleVariant;
@property(nonatomic,strong) NSString *strVehicleName;
@property(nonatomic,strong) NSString *strVehicleDetails;
@property(nonatomic,strong) SMSynopsisXMLResultObject *objSummary;

@property BOOL isValuation;
@end
