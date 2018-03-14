//
//  SMSimpleLogicViewController.h
//  Smart Manager
//
//  Created by Ankit Shrivastava on 21/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSynopsisXMLResultObject.h"
@interface SMSimpleLogicViewController : UIViewController
{

    IBOutlet UILabel *lblVehicleName;

    IBOutlet UIView *viewBottom;

    IBOutlet UILabel *lblMileageValue;

    IBOutlet UILabel *lblNewPriceValue;

    IBOutlet UILabel *lblLess10Value;

    IBOutlet UILabel *lblLess5Value;

    IBOutlet UILabel *lblAdd5Value;

    IBOutlet UILabel *lblSuggestedRetailValue;

    IBOutlet UILabel *lblSuggestedTradeValue;

    IBOutlet UILabel *lblAgeValue;
    
    IBOutlet UILabel *lblRedNote;
    

}
@property(nonatomic,strong) SMSynopsisXMLResultObject *objSummary;
@end
