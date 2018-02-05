//
//  SMSaveAppraisalsViewController.m
//  Smart Manager
//
//  Created by Sandeep on 21/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMSaveAppraisalsViewController.h"
#import "SMCustomColor.h"
#import "SMCustomPopUpPickerView.h"
@interface SMSaveAppraisalsViewController ()
{
   NSMutableArray *arrmForYear;
    
    IBOutlet UIView *dateView;
    IBOutlet UIView *popupView;
    IBOutlet UIDatePicker *datePickerForTime;
    int selectedType;
    SMSaveAppraisalsView *objSMSaveAppraisalsView;
}
@end

@implementation SMSaveAppraisalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  arrmForYear = [[NSMutableArray alloc ] initWithObjects:@"2014",@"2015",@"2016",@"2017", nil];
 self.navigationItem.titleView = [SMCustomColor setTitle:@"Saved Appraisals"];

    NSArray *arraySMSaveAppraisalsView = [[NSBundle mainBundle]loadNibNamed:@"SMSaveAppraisalsView" owner:self options:nil];
    objSMSaveAppraisalsView = [arraySMSaveAppraisalsView objectAtIndex:0];
    objSMSaveAppraisalsView.txtFieldStartDate.delegate = self;
    objSMSaveAppraisalsView.txtFieldEndDate.delegate = self;
    objSMSaveAppraisalsView.txtFieldCustomerSurname.delegate = self;

    objSMSaveAppraisalsView.txtFieldStartDate.tag = 101;
    objSMSaveAppraisalsView.txtFieldEndDate.tag = 102;

    [tblSMSaveAppraisals registerNib:[UINib nibWithNibName: @"SMSaveAppraisalsViewCell" bundle:nil] forCellReuseIdentifier:@"SMSaveAppraisalsViewCell"];

    tblSMSaveAppraisals.tableHeaderView = objSMSaveAppraisalsView;
    tblSMSaveAppraisals.estimatedRowHeight = 121.0;
    tblSMSaveAppraisals.rowHeight = UITableViewAutomaticDimension;
    tblSMSaveAppraisals.tableFooterView = [[UIView alloc]init];

   
}
-(void)nextButtonDidClicked{

    SMSendOfferViewController *obj = [[SMSendOfferViewController alloc]initWithNibName:@"SMSendOfferViewController" bundle:nil];

    [self.navigationController pushViewController:obj animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
//    {
//        return 121;
//    }
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"SMSaveAppraisalsViewCell";
    SMSaveAppraisalsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    SMVehiclelisting *rowObject = [[SMVehiclelisting alloc]init];
    rowObject.strVehicleYear = @"2010";
    rowObject.strVehicleName = @"Volkswagen Polo 1.4 Comfortline";
    rowObject.strVehicleColor = @"24000 km";
    rowObject.strStockCode = @"Freddy Basson";
    rowObject.strVehicleRegNo = @"Red";
    if(rowObject.strVehicleAge.length == 0)
        rowObject.strVehicleAge = @"24 Dec 2014";

    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dynamicCell.vehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
    dynamicCell.lblVehicleDetails1.textColor = [UIColor whiteColor];

    dynamicCell.lblVehicleDetails2.textColor = [UIColor whiteColor];
    dynamicCell.vehicleName.tag = 101;
    dynamicCell.lblVehicleDetails1.tag = 103;
    dynamicCell.lblVehicleDetails2.tag = 104;

    [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:rowObject.strVehicleYear andWithSecondText:rowObject.strVehicleName forLabel:dynamicCell.vehicleName];

    dynamicCell.lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@ | %@",rowObject.strVehicleRegNo,rowObject.strVehicleColor, rowObject.strStockCode];

    dynamicCell.lblVehicleDetails2.text = [NSString stringWithFormat:@"%@",rowObject.strVehicleAge];

    dynamicCell.vehicleName.numberOfLines = 0;
    [dynamicCell.vehicleName sizeToFit];

    dynamicCell.lblVehicleDetails1.numberOfLines = 0;
    [dynamicCell.lblVehicleDetails1 sizeToFit];


    dynamicCell.lblVehicleDetails2.numberOfLines = 0;
    [dynamicCell.lblVehicleDetails2 sizeToFit];

    dynamicCell.vehicleName.backgroundColor = [UIColor blackColor];
    dynamicCell.lblVehicleDetails1.backgroundColor = [UIColor blackColor];
    dynamicCell.lblVehicleDetails2.backgroundColor = [UIColor blackColor];
    dynamicCell.backgroundColor = [UIColor blackColor];
    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
    dynamicCell.backgroundColor = [UIColor blackColor];
    return dynamicCell;
}
#pragma mark - Set Attributed Text

-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{
    UIFont *regularFont;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    else
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];

    UIColor *foregroundColorWhite = [UIColor whiteColor];
    UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];

    // Create the attributes

    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];




    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];





    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",firstText]
                                                                                           attributes:FirstAttribute];



    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",secondText]
                                                                                             attributes:SecondAttribute];





    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Text Field Delegate


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    
    if(textField.tag == 101)
    {  [self.view endEditing:YES];
        /*************  your Request *******************************************************/
        [textField resignFirstResponder];
       
        
        selectedType = 0;
         [self loadPopUpView];
        
//        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpPickerView" owner:self options:nil];
//        SMCustomPopUpPickerView *popUpView = [arrLoadNib objectAtIndex:0];
//        [popUpView getThePickerDropDownData:arrmForYear withPreviosSelectedYearAs:selectedYear]; // array to be passed for custom popup dropdown
//        [self.view addSubview:popUpView];
//        
//        /*************  your Request *******************************************************/
//        
//        /*************  your Response *******************************************************/
//        
//        [SMCustomPopUpPickerView getTheSelectedPickerDataInfoWithCallBack:^(NSString *selectedTextValue)
//         {
//             NSLog(@"selected text = %@",selectedTextValue);
//             selectedYear = selectedTextValue;
//             textField.text = selectedTextValue;
//             
//         }];
        
        /*************  your Response *******************************************************/
        
    }
    
    
    if(textField.tag == 102)
    {  [self.view endEditing:YES];
        /*************  your Request *******************************************************/
        [textField resignFirstResponder];
        
        selectedType = 1;
        [self loadPopUpView];
        
        //        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpPickerView" owner:self options:nil];
        //        SMCustomPopUpPickerView *popUpView = [arrLoadNib objectAtIndex:0];
        //        [popUpView getThePickerDropDownData:arrmForYear withPreviosSelectedYearAs:selectedYear]; // array to be passed for custom popup dropdown
        //        [self.view addSubview:popUpView];
        //
        //        /*************  your Request *******************************************************/
        //
        //        /*************  your Response *******************************************************/
        //
        //        [SMCustomPopUpPickerView getTheSelectedPickerDataInfoWithCallBack:^(NSString *selectedTextValue)
        //         {
        //             NSLog(@"selected text = %@",selectedTextValue);
        //             selectedYear = selectedTextValue;
        //             textField.text = selectedTextValue;
        //
        //         }];
        
        /*************  your Response *******************************************************/
        
    }
    

    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
}


-(void)loadPopUpView
{
    [popupView setFrame:[UIScreen mainScreen].bounds];
    [popupView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [popupView setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popupView];
    [popupView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [popupView setAlpha:0.75];
         [popupView setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [popupView setAlpha:1.0];
              
              [popupView setTransform:CGAffineTransformIdentity];
              
          }
                          completion:^(BOOL finished)
          {
          }];
         
     }];
}

-(void) hidePopUpView
{
    [popupView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popupView];
    [UIView animateWithDuration:0.1 animations:^{
        [popupView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [popupView setAlpha:0.3];
              [popupView setTransform:CGAffineTransformMakeScale(0.9,0.9)];
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   
                   [popupView setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [popupView removeFromSuperview];
                   [popupView setTransform:CGAffineTransformIdentity];
               }];
          }];
     }];
}
- (IBAction)buttonCancelDidPressed:(id)sender {
    [self hidePopUpView];
}

-(IBAction)buttonDoneDidPrssed:(id) sender
{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datePickerForTime.date]];
    
    
    switch (selectedType)
    {
        case 0:
        {
            
            [objSMSaveAppraisalsView.txtFieldStartDate setText:textDate];
            
        }
            break;
        case 1:
        {
            
            [objSMSaveAppraisalsView.txtFieldEndDate   setText:textDate];
        }
            break;
        default:
            break;
    }
    [self hidePopUpView];
}

@end
