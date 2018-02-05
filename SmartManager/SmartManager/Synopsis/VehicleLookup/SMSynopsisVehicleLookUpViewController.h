//
//  SMSynopsisVehicleLookUpViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 19/12/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SMLoadVehiclesObject.h"

@interface SMSynopsisVehicleLookUpViewController : UIViewController<UITextFieldDelegate,MBProgressHUDDelegate,NSXMLParserDelegate,UIGestureRecognizerDelegate>
{
    
    NSMutableString *currentNodeContent;
    //---web service access---
    NSMutableString *soapResults;
    //---xml parsing---
    NSXMLParser *xmlParser;
    
    int selectedMakeId;
    int selectedModelId;
    int selectedVariantId;
    
    NSString *selectedYear;
    BOOL isTxtKiloMetersSelected;
}



@end
