//
//  SMCustomerScanDetailViewController.h
//  SmartManager
//
//  Created by Jignesh on 03/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCustomLable.h"
#import "SMCustomTextField.h"
#import "SMToolBarCustomField.h"
#import "SMCustomButtonBlue.h"
#import "MBProgressHUD.h"
#import "SMCustomerDetailsDLScanObj.h"
#import "SMCustomerVehicleClassObj.h"
#import "SMAppDelegate.h"

@protocol refreshDLList <NSObject>

-(void)refreshTheDLList;

@end

@interface SMCustomerScanDetailViewController : UIViewController
                                                <UITableViewDataSource,
                                                 UITableViewDelegate,
                                                 UITextFieldDelegate,
                                                 SMToolBarCustomFieldDelegate,NSXMLParserDelegate,MBProgressHUDDelegate>


{
    MBProgressHUD *HUD;

    
    NSMutableArray *arrayOfVehicleClass;
    NSXMLParser *xmlParser;
    NSOperationQueue *downloadingQueue;
    NSMutableString *currentNodeContent;

    NSString *custSurName;
    NSString *custClasses;
    NSDateComponents *dateComponents;
    
    BOOL isIndividualVehicleClassDone;
    NSString *tempDriverRestrictionStr;
    
    int ScanID;
}

@property (nonatomic, weak) id <refreshDLList> refreshDLListDelegate;

-(IBAction)buttonSave:(id)sender;


@property(strong, nonatomic) IBOutlet UITableView            *tableForCustomerInformations;
@property(strong, nonatomic) IBOutlet UIView                 *viewHeaderInformations;
@property(strong, nonatomic) IBOutlet UIView                 *viewFooterInformations;
@property(strong, nonatomic) IBOutlet UITextField            *textFieldsEmailAddress;
@property(strong, nonatomic) IBOutlet SMCustomTextField   *textFieldPhoneNumber;
@property(strong, nonatomic) IBOutlet SMCustomLable          *labelPhoneNumber;
@property(strong, nonatomic) IBOutlet SMCustomLable          *labelEmailNumber;
@property(strong, nonatomic) IBOutlet SMCustomButtonBlue     *buttonSave;

@property (strong, nonatomic) SMCustomerDetailsDLScanObj *custDetailsObj;
@property (strong, nonatomic) SMCustomerVehicleClassObj *vehicleClassObj;
@property (strong, nonatomic) NSMutableArray *arrayOfVehicleClass;
@property (assign)BOOL isFromDLListScreen;


@property (strong, nonatomic) IBOutlet UIView *viewContainingPhoto;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblName;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblID;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblCustomerName;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblCustomerID;

@property (strong, nonatomic) IBOutlet UIImageView *imgCustomer;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblDOB;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblAge;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblGender;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblRestrictions;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblCertificate;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblDOBValue;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblAgeValue;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblGenderValue;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblRestrictionsValue;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblCertificateValue;

@property (strong, nonatomic) IBOutlet UIView *viewContainingCertificate;


// **************************************** iPad ****************************************

@property(strong, nonatomic) IBOutlet UIView   *viewHeaderInformations_iPad;

@property (strong, nonatomic) IBOutlet UIView *viewContainingPhoto_iPad;


@property (strong, nonatomic) IBOutlet SMCustomLable *lblName_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblID_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblCustomerName_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblCustomerID_iPad;

@property (strong, nonatomic) IBOutlet UIImageView *imgCustomer_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblDOB_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblAge_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblGender_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblRestrictions_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblCertificate_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblDOBValue_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblAgeValue_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblGenderValue_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblRestrictionsValue_iPad;

@property (strong, nonatomic) IBOutlet SMCustomLable *lblCertificateValue_iPad;

@property (strong, nonatomic) IBOutlet UIView *viewContainingCertificate_iPad;


@end
