//
//  SMMyLeadsDetailViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 04/05/15. /// Modification Done By Jignesh
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMMyLeadsDetailViewController.h"
#import "SMLeadsDetailCell.h"
#import "SMClassForToDoObjects.h"
#import  "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"
#import "SMCustomDynamicCell.h"
#import "SMParseXML.h"
#import "SMCustomPopUpTableView.h"
#import "SMDropDownObject.h"
#define ACCEPTABLE_CHARACTERS_Number @"0123456789+"


/* Modification Done By Jignesh


 1. Added Xml Pasrsing Handline By Passing Lead ID
 2. Added Proper Prgma marks
 3. Hight Handling for header not completey need to change
 4. Showing Acutivity Listing adding its ids
 5. UI CHnages

 End - Modification Done By Jignesh*/

// pending works - Suggested by tester



@interface SMMyLeadsDetailViewController ()
{
    NSMutableArray *arrGender;
    NSMutableArray *arrVehicleDept;
    NSMutableArray *arrVehicleType;
    NSMutableArray *arrRace;
    
    int selectedVehicleTypeId;
    int selectedVehicleDeptId;
    int selectedGenderID;
    int selectedRaceID;
    
    
}

@end

@implementation SMMyLeadsDetailViewController
@synthesize leadDetailObject;


#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    selectedActivityID = -1;

    arrayForSections = [[NSMutableArray alloc]init];
    [self populateTheSectionsArray];


   self.leadDetailObject = [[SMLeadDetailObject alloc]init];
    self.leadDetailObject.leadProspectValue = @"";
    self.leadDetailObject.leadPhoneValue = @"";
    self.leadDetailObject.leadEmailValue = @"";
    self.leadDetailObject.leadEnquiredOnValue = @"";
    self.leadDetailObject.leadTimingValue = @"";
    self.leadDetailObject.leadSourceValue = @"";
    self.leadDetailObject.leadDateValue = @"";
    self.leadDetailObject.leadLastUpdateValue = @"";

    [self registerNib];
    [self addingProgressHUD];

    isActivityParsing = NO;
    isTradeInPresent = NO;
    selectedVehicleTypeId = 1;
    

    self.tblViewLeadDetails.separatorStyle = UITableViewCellSeparatorStyleNone;



    self.arrayForActivity = [[NSMutableArray alloc] init];

    [self loadLeadsDetailsForLeadID:self.leadID];
    
    [self populateTheDropDownArrays];
   

}


-(void)populateTheDropDownArrays
{
    dateView.layer.cornerRadius =15.0;
    dateView.clipsToBounds      = YES;
    
    arrVehicleType = [[NSMutableArray alloc]init];
    arrVehicleDept = [[NSMutableArray alloc]init];
    arrRace = [[NSMutableArray alloc]init];
    arrGender = [[NSMutableArray alloc]init];
    
   NSArray *arrGenderTemp = [NSMutableArray arrayWithObjects:@"Male",@"Female", nil];
   NSArray *arrVehicleDeptTemp = [NSMutableArray arrayWithObjects:@"New",@"Used", nil];
   NSArray *arrVehicleTypeTemp = [NSMutableArray arrayWithObjects:@"Cars",@"Motorcycles",@"Trucks",@"Boats",@"Outboard Motors",@"Jetskis",@"Tractors", nil];
  NSArray *arrRaceTemp = [NSMutableArray arrayWithObjects:@"Unknown",@"Black",@"Coloured",@"Indian",@"Oriental",@"White", nil];
    
    for(int i = 0; i<=5; i++)
    {
        SMDropDownObject *Object1 = [[SMDropDownObject alloc] init];
        Object1.strMakeName = [arrRaceTemp objectAtIndex:i];
        Object1.strMakeId = [NSString stringWithFormat:@"%d",i];
        
        [arrRace addObject:Object1];
    
    }
    
    for(int i = 0; i<2; i++)
    {
        SMDropDownObject *Object1 = [[SMDropDownObject alloc] init];
        Object1.strMakeName = [arrGenderTemp objectAtIndex:i];
        Object1.strMakeId = [NSString stringWithFormat:@"%d",i+1];
        
        [arrGender addObject:Object1];
        
    }
    
    for(int i = 0; i<2; i++)
    {
        SMDropDownObject *Object1 = [[SMDropDownObject alloc] init];
        Object1.strMakeName = [arrVehicleDeptTemp objectAtIndex:i];
        Object1.strMakeId = [NSString stringWithFormat:@"%d",i+1];
        
        [arrVehicleDept addObject:Object1];
        
    }
    
    SMDropDownObject *Object1 = [[SMDropDownObject alloc] init];
    Object1.strMakeName = [arrVehicleTypeTemp objectAtIndex:0];
    Object1.strMakeId = [NSString stringWithFormat:@"1"];
    [arrVehicleType addObject:Object1];
    
    SMDropDownObject *Object2 = [[SMDropDownObject alloc] init];
    Object2.strMakeName = [arrVehicleTypeTemp objectAtIndex:1];
    Object2.strMakeId = [NSString stringWithFormat:@"2"];
    [arrVehicleType addObject:Object2];
    
    SMDropDownObject *Object3 = [[SMDropDownObject alloc] init];
    Object3.strMakeName = [arrVehicleTypeTemp objectAtIndex:2];
    Object3.strMakeId = [NSString stringWithFormat:@"3"];
    [arrVehicleType addObject:Object3];
    
    SMDropDownObject *Object4 = [[SMDropDownObject alloc] init];
    Object4.strMakeName = [arrVehicleTypeTemp objectAtIndex:3];
    Object4.strMakeId = [NSString stringWithFormat:@"4"];
    [arrVehicleType addObject:Object4];
    
    SMDropDownObject *Object5 = [[SMDropDownObject alloc] init];
    Object5.strMakeName = [arrVehicleTypeTemp objectAtIndex:4];
    Object5.strMakeId = [NSString stringWithFormat:@"6"];
    [arrVehicleType addObject:Object5];
    
    SMDropDownObject *Object6 = [[SMDropDownObject alloc] init];
    Object6.strMakeName = [arrVehicleTypeTemp objectAtIndex:5];
    Object6.strMakeId = [NSString stringWithFormat:@"7"];
    [arrVehicleType addObject:Object6];
    
    SMDropDownObject *Object7 = [[SMDropDownObject alloc] init];
    Object7.strMakeName = [arrVehicleTypeTemp objectAtIndex:6];
    Object7.strMakeId = [NSString stringWithFormat:@"12"];
    [arrVehicleType addObject:Object7];

}


#pragma mark -
#pragma mark - TextField Delegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag == 30)
    {
    [self.view endEditing:YES];
    [textField resignFirstResponder];
    if (self.arrayForActivity.count == 0)
        [self loadActivity];
    else
        [self loadPopup];
    
    return NO;
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 17:
        {
            [self.view endEditing:YES];
            /*************  your Request *******************************************************/
            [textField resignFirstResponder];
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrVehicleDept withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                textField.text = selectedTextValue;
                selectedVehicleDeptId = selectIDValue;
                
            }];
            
            /*************  your Response *******************************************************/
        }
            break;
        case 18:
        {
            [self.view endEditing:YES];
            /*************  your Request *******************************************************/
            [textField resignFirstResponder];
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrVehicleType withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                textField.text = selectedTextValue;
                selectedVehicleTypeId = selectIDValue;
                
            }];
        }
            break;
        case 19:
        {
            [self.view endEditing:YES];
            /*************  your Request *******************************************************/
            [textField resignFirstResponder];
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrGender withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                textField.text = selectedTextValue;
                selectedGenderID = selectIDValue;
                
            }];
        }
            break;
        case 20:
        {
            [self.view endEditing:YES];
            /*************  your Request *******************************************************/
            [textField resignFirstResponder];
            NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
            SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
            
            
            [popUpView getTheDropDownData:arrRace withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:NO]; // array to be passed for custom popup dropdown
            
            [self.view addSubview:popUpView];
            
            /*************  your Request *******************************************************/
            
            /*************  your Response *******************************************************/
            
            [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
                NSLog(@"selected text = %@",selectedTextValue);
                NSLog(@"selected ID = %d",selectIDValue);
                textField.text = selectedTextValue;
                selectedRaceID = selectIDValue;
                
            }];
        }
            break;
            
         case 12:
        {
            [self.view endEditing:YES];
            [textField resignFirstResponder];
            [self loadPopUpView];
            

        }
            break;
        default:
        {
            //if(textField == self.txtFieldComment)
            {
                
                //for shifting the scroll view up  of the keypad when the textfield is edited.
                
                CGPoint pt;
                CGRect rc = [textField bounds];
                rc = [textField convertRect:rc toView:self.tblViewLeadDetails];
                pt = rc.origin;
                pt.x = 0;
                
                if(textField.tag == 21)
                {
                    pt.y -= 150;
                }
                else
                    pt.y -= 98;
                
                [self.tblViewLeadDetails setContentOffset:pt animated:YES];
                
                
            }
           /* else
            {
               
                    CGRect frame = [self.tblViewLeadDetails convertRect:textField.frame fromView:textField.superview.superview];
                    [self.tblViewLeadDetails setContentOffset:CGPointMake(0, frame.origin.y) animated:YES];
                
            }*/
        }
            break;
    }
    
    
}
    
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return YES;
}

#pragma mark - Table View Delegates And Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    if (tableView == self.tblViewActivity)
    {
        return 1;
    }
    else
    {
        if(isTradeInPresent)
            return  3;

        return 2;

    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView == self.tblViewActivity)
    {
        return self.arrayForActivity.count;
    }
    else
    {
        if(section == 0)
        {
            return 8;
        }

        return 1;

    }

    return 0;

}

- (CGFloat)heightForText:(NSString *)bodyText
{

    UIFont *cellFont;
    float textSize =0;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        textSize = 190;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
        textSize = 570;
    }
    CGSize constraintSize = CGSizeMake(textSize, MAXFLOAT);
    CGRect textRect = [bodyText boundingRectWithSize:constraintSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:cellFont}
                                             context:nil];
    
    CGSize labelSize = textRect.size;
    CGFloat height = labelSize.height;
    
    return height;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.tblViewLeadDetails)
    {
        if (indexPath.section == 0)
        {
            CGFloat height = 0.0f;

            switch (indexPath.row)
            {
                case 0:
                {
                    height = [self heightForText:self.leadDetailObject.leadProspectValue];
                    //NSLog(@"leadDetailObject.leadProspectValue %@",self.leadDetailObject.leadProspectValue);
                }
                    break;
                case 1:
                {
                    height = [self heightForText:self.leadDetailObject.leadPhoneValue];
                }
                    break;
                case 2:
                {
                    NSLog(@"Email Address = %@",self.leadDetailObject.leadEmailValue);
                    if([self.leadDetailObject.leadEmailValue isEqualToString:@"Not Given"] || [self.leadDetailObject.leadEmailValue length]==0 || [self.leadDetailObject.leadEmailValue isEqualToString:@"Email address?"] )
                    {
                        self.leadDetailObject.leadEmailValue = @"Email address?";
                    }
                    else
                    {
                        
                        NSAttributedString *emailAttributedString = [[NSAttributedString alloc]initWithString:self.leadDetailObject.leadEmailValue attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithRed:24.0f/255.0f green:100.0f/255.0f blue:152.0f/255.0f alpha:1.0f],NSFontAttributeName:[UIFont fontWithName:FONT_NAME size:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? FONT_SIZE_iPHone : FONT_SIZE_iPad]}];
                        
                        self.leadDetailObject.leadEmailValue = [emailAttributedString string];

                        
                    }
                    
                    
                    height = [self heightForText:self.leadDetailObject.leadEmailValue];
                }
                    break;
                case 3:
                {
                    height = [self heightForText:self.leadDetailObject.leadEnquiredOnValue];
                }
                    break;
                case 4:
                {
                    height = [self heightForText:self.leadDetailObject.leadTimingValue];
                }
                    break;
                case 5:
                {
                    height = [self heightForText:self.leadDetailObject.leadSourceValue];
                }
                    break;
                case 6:
                {
                    height = [self heightForText:self.leadDetailObject.leadDateValue];
                }
                    break;
                case 7:
                {
                    height = [self heightForText:self.leadDetailObject.leadLastUpdateValue];
                }
                    break;

                default:
                    break;
            }


            return height+10;
        }
        else if (indexPath.section == 1)
        {
            if(isActivitySelectedIsDelivered)
            {
                return 800.0;
            }
            
            return 240.0;
        }
        else if(indexPath.section == 2)
        {
             return 112.0;
        }

       /* SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:indexPath.row];
        if(sectionObject.strSectionID == 1)
        {
             if(isActivitySelectedIsDelivered)
             {
                 return 800.0;
             }
            
            return 240.0;
        }
        else
        {
            return 120.0;
        }*/
        
            
    }
    else
    {

        return 40.0f;
    }


    return 0;

}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (tableView == self.tblViewLeadDetails)
    {
        if (section == 0)
        {
            return @"";
        }
        
        if(section == 1)
            return @"Update Now";
        else
            return @"Trade-in Details";
       

        
    }

    return 0;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    if (tableView == self.tblViewLeadDetails)
    {

        if (section == 0)
        {
            return 0.0;
        }

        if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            return 40.0f;
        }
        else
        {
            return 60.0f;
        }
    }

    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{


    /*  if (tableView == self.tblViewLeadDetails)
     {

     // UIView *headerView = [[UIView alloc] init];
     SMClassForToDoObjects *sectionObject = (SMClassForToDoObjects*)[arrayForSections objectAtIndex:section];

     UILabel *tempLabel = [[UILabel alloc] init];

     tempLabel.backgroundColor=[UIColor clearColor];
     tempLabel.shadowOffset = CGSizeMake(0,2);
     tempLabel.textColor = [UIColor whiteColor]; //here you can change the text color of header.
     tempLabel.text=sectionObject.strSectionName;


     if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
     {
     tempLabel.frame = CGRectMake(7, 0, tableView.bounds.size.width,40 );
     tempLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
     //[headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 40)];

     }
     else
     {
     tempLabel.frame = CGRectMake(7, 0, tableView.bounds.size.width,60 );
     tempLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
     //[headerView setFrame:CGRectMake(0, 0, tableView.bounds.size.width, 60)];

     }

     //[headerView setBackgroundColor:[UIColor grayColor]];
     [self.sectionHeaderView addSubview:tempLabel];


     return self.sectionHeaderView;

     }
     return 0;*/


    if (tableView == self.tblViewLeadDetails)
    {
        
        if(section > 0)
        {
            
            
            
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                
               // self.sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                if(section == 1)
                {
                 [self.sectionLabelBtn setTitle:@"Update Now" forState:UIControlStateNormal];
                    self.sectionHeaderView.clipsToBounds = YES;
                    self.sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                     return self.sectionHeaderView;
                    
                    
                }
                else
                {
                    [btnTradeIb setTitle:@"Trade-in Details" forState:UIControlStateNormal];
                    sectionTradeIn.clipsToBounds = YES;
                     btnTradeIb.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                     return sectionTradeIn;
                    
                   
                }
                
                
            }
            else
            {
                
                self.sectionLabelBtnIpad.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                
                if(section == 1)
                    [self.sectionLabelBtnIpad setTitle:@"Update Now" forState:UIControlStateNormal];
                else
                    [self.sectionLabelBtnIpad setTitle:@"Trade-in Details" forState:UIControlStateNormal];
                
                self.sectionHeaderViewIpad.clipsToBounds = YES;
                return self.sectionHeaderViewIpad;
            }
           
        }
    }
    return 0;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (tableView == self.tblViewActivity)
    {
        static NSString *CellIdentifier = @"Cell";

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }

        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
        }
        else
        {
            cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];

        }
        
        SMLeadListObject *objectATcellForRow = (SMLeadListObject *) [self.arrayForActivity objectAtIndex:indexPath.row];
        cell.textLabel.text = objectATcellForRow.strName;
        cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:13.0];
        cell.layoutMargins = UIEdgeInsetsZero;
        cell.preservesSuperviewLayoutMargins = NO;
        return cell;
    }
    else if (tableView == self.tblViewLeadDetails)
    {
        static NSString *cellIdentifier1= @"SMLeadsDetailCell";
        static NSString *cellIdentifier2= @"SMLeadsTradeInDetailsCell";
        static NSString *cellIdentifier3= @"SMCustomDynamicCell";

        SMLeadsDetailCell     *cell;
        SMCustomDynamicCell     *dynamicCell;
        

        if(indexPath.section == 0)
        {

            UILabel *lblTitle;
            UILabel *lblValue;


            CGFloat height = 0.0f;


            if (dynamicCell == nil)
            {
                dynamicCell = [[SMCustomDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];
                
                dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;

                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                {
                    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(8,4,101,21)];
                    lblValue = [[UILabel alloc] initWithFrame:CGRectMake(124,4,190,height)];
                    lblTitle.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
                    lblValue.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
                    
                   /* txtViewPhone = [[UITextView alloc] initWithFrame:CGRectMake(124,2,190,21)];
                    txtViewPhone.editable = NO;
                    txtViewPhone.dataDetectorTypes = UIDataDetectorTypePhoneNumber;
                    txtViewPhone.backgroundColor = [UIColor clearColor];
                    txtViewPhone.textColor = [UIColor whiteColor];*/
                    

                }
                else
                {
                    lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(8,4,125,25)];
                    lblValue = [[UILabel alloc] initWithFrame:CGRectMake(181,4,570,height)];
                    lblTitle.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
                    lblValue.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPad];
                }

                lblTitle.textColor = [UIColor whiteColor];
                
                lblValue.textColor = [UIColor whiteColor];
                lblTitle.tag = 1001;
                [dynamicCell.contentView addSubview:lblTitle];

                lblValue.tag = 1002;
                [dynamicCell.contentView addSubview:lblValue];
               


            }
            else
            {
                lblTitle = (UILabel *)[dynamicCell.contentView viewWithTag:1001];
                lblValue = (UILabel *)[dynamicCell.contentView viewWithTag:1002];

            }

            
            switch (indexPath.row)
            {
                case 0:
                {
                    lblTitle.text = @"Prospect";
                    lblValue.text = self.leadDetailObject.leadProspectValue;
                }
                    break;
                case 1:
                {
                    
                  self.leadDetailObject.leadPhoneValue =  [self returnOnlyTheNumbersForString:self.leadDetailObject.leadPhoneValue];
                    
                   // NSLog(@"self.leadDetailObject.leadPhoneValue = %@",self.leadDetailObject.leadPhoneValue);
                    
                    if([self.leadDetailObject.leadPhoneValue length]>0)
                    {
                        if([self.leadDetailObject.leadPhoneValue length ]>=10)
                        {
                        NSString* formattedNumber = [self formatPhoneNumber:self.leadDetailObject.leadPhoneValue];
                        NSAttributedString *phoneAttributedString = [[NSAttributedString alloc]initWithString:formattedNumber attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithRed:24.0f/255.0f green:100.0f/255.0f blue:152.0f/255.0f alpha:1.0f],NSFontAttributeName:[UIFont fontWithName:FONT_NAME size:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? FONT_SIZE_iPHone : FONT_SIZE_iPad]}];
                        
                        [lblValue setAttributedText:phoneAttributedString];
                            lblTitle.text = @"Phone";
                        }
                        else
                        {
                            lblValue.text = @"";
                            lblTitle.text = @"Phone";
                        
                        }
                        
                        
                        
                        UITapGestureRecognizer *phoneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(phoneNumberTapHandler:)];
                        phoneTap.view.tag=indexPath.row;
                        dynamicCell.tag=indexPath.row;
                        [dynamicCell addGestureRecognizer:phoneTap];

                        
                        
                    }
                    else
                    {
                        lblTitle.text = @"Phone";
                        self.leadDetailObject.leadPhoneValue = @"Phone number?";
                        lblValue.text = self.leadDetailObject.leadPhoneValue;
                    }
                   
                }
                    break;
                case 2:
                {
                    NSLog(@"email value = %@",self.leadDetailObject.leadEmailValue);
                    
                    lblTitle.text = @"Email";
                    if([self.leadDetailObject.leadEmailValue isEqualToString:@"Not Given"] || [self.leadDetailObject.leadEmailValue length]==0 || [self.leadDetailObject.leadEmailValue isEqualToString:@"Email address?"])
                    {
                        self.leadDetailObject.leadEmailValue = @"Email address?";
                        lblValue.text = self.leadDetailObject.leadEmailValue;
                    }
                    else
                    {
                        NSAttributedString *emailAttributedString = [[NSAttributedString alloc]initWithString:self.leadDetailObject.leadEmailValue attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInt:NSUnderlineStyleSingle],NSForegroundColorAttributeName:[UIColor colorWithRed:24.0f/255.0f green:100.0f/255.0f blue:152.0f/255.0f alpha:1.0f],NSFontAttributeName:[UIFont fontWithName:FONT_NAME size:(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 15.0f : FONT_SIZE_iPad]}];
                        
                        [lblValue setAttributedText:emailAttributedString];
                        
                        UITapGestureRecognizer *emailTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(emailAddressTapHandler:)];
                        emailTap.view.tag=indexPath.row;
                        dynamicCell.tag=indexPath.row;
                        [dynamicCell addGestureRecognizer:emailTap];

                    }
                    
                    
                }
                    break;
                case 3:
                {
                  //  height = [self heightForText:self.leadDetailObject.leadEnquiredOnValue];
                    lblTitle.text = @"Enquired on";
                    lblValue.text = self.leadDetailObject.leadEnquiredOnValue;
                }
                    break;
                case 4:
                {
                    
                    if([self.leadDetailObject.leadTimingValue length] == 0)
                        self.leadDetailObject.leadTimingValue = @"Timing?";
                    
                   // height = [self heightForText:self.leadDetailObject.leadTimingValue];
                    lblTitle.text = @"Timing";
                    lblValue.text = self.leadDetailObject.leadTimingValue;
                    
                    
                }
                    break;
                case 5:
                {
                   // height = [self heightForText:self.leadDetailObject.leadSourceValue];
                    lblTitle.text = @"Source";
                    lblValue.text = self.leadDetailObject.leadSourceValue;
                }
                    break;
                case 6:
                {
                   // height = [self heightForText:self.leadDetailObject.leadDateValue];
                    lblTitle.text = @"Date";
                    lblValue.text = self.leadDetailObject.leadDateValue;
                    
                }
                    break;
                case 7:
                {
                   // height = [self heightForText:self.leadDetailObject.leadLastUpdateValue];
                    lblTitle.text = @"Last update";
                    lblValue.text = self.leadDetailObject.leadLastUpdateValue;
                    
                }
                    break;
                    
                default:
                    break;
            }
            

            lblValue.numberOfLines = 0;
            [lblValue sizeToFit];

//            lblValue.backgroundColor = [UIColor redColor];
            dynamicCell.backgroundColor = [UIColor clearColor];

            return dynamicCell;
        }
        else if(indexPath.section == 1)
        {
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
            cell.backgroundColor            = [UIColor blackColor];
            cell.selectionStyle             = UITableViewCellSelectionStyleNone;
            
            if(isActivitySelectedIsDelivered)
            {
                cell.viewBottomBig.hidden = NO;
                cell.viewBottomSmall.hidden = YES;
                
                cell.txtFieldRace.delegate  = self;
                cell.txtFieldGender.delegate  = self;
                cell.txtFieldVehicleDept.delegate  = self;
                cell.txtFieldVehicleType.delegate  = self;
                cell.txtFieldDate.delegate = self;
                cell.txtFieldAge.delegate = self;
                cell.txtFieldRIncl.delegate = self;
                cell.txtViewComment.delegate = self;
                cell.txtFieldStockNo.delegate = self;
                cell.txtFieldInvoiceNo.delegate = self;
                cell.txtFieldSalesPerson.delegate = self;
                
                
                cell.txtViewCommentsSold.delegate    = self;
                [cell.btnChangeStatusSold setTag:indexPath.row];
                [cell.btnChangeStatusSold addTarget:self action:@selector(buttonChangeStatusDidPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.btnSubmitSold addTarget:self action:@selector(btnSubmitDidClicked:) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                cell.viewBottomBig.hidden = YES;
                cell.viewBottomSmall.hidden = NO;
                
                cell.txtViewComment.delegate    = self;
                cell.txtFieldLeadActivity.delegate  = self;
                
                [cell.buttonChangeStatus setTag:indexPath.row];
                [cell.buttonChangeStatus addTarget:self action:@selector(buttonChangeStatusDidPressed:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.btnSubmit addTarget:self action:@selector(btnSubmitDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            }
           
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
            cell.lblCurrentVehicleValue.text = lblTradeInVehicleName;
            cell.lblYearValue.text = lblTradeInYearModel;
            cell.lblMileageValue.text = lblTradeInMileage;
            
            cell.backgroundColor                = [UIColor blackColor];
            cell.selectionStyle                 = UITableViewCellSelectionStyleNone;

        }


        // chnage status buttonm action
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    if (tableView == self.tblViewActivity)
    {
        SMLeadsDetailCell *cell1 = (SMLeadsDetailCell *)[self.tblViewLeadDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        SMLeadListObject *objectATcellForRowSelction = (SMLeadListObject *) [self.arrayForActivity objectAtIndex:indexPath.row];
        //NSLog(@"objectATcellForRowSelction.strName = %@",objectATcellForRowSelction.strName);
        cell1.txtFieldLeadActivity.text = objectATcellForRowSelction.strName;
        
        if([objectATcellForRowSelction.strName isEqualToString:@"Sold&Delivered"])
            isActivitySelectedIsDelivered = YES;
        else
             isActivitySelectedIsDelivered = NO;
        
        //[cell1.txtFieldLeadActivity setText:objectATcellForRowSelction.strName];

        selectedActivityID = objectATcellForRowSelction.activityID;
        // NSLog(@"slection name ins %@",objectATcellForRowSelction.strName);
        // NSLog(@"slection name ID %d",selectedActivityID);

        [self dismissPopup];
        
        [_tblViewLeadDetails reloadData];
        
        
    }

}


#pragma mark -



-(IBAction)btnSubmitDidClicked:(id)sender
{
    [self.view endEditing:YES];
  
    if ([self validateLead] == YES) {


        [HUD show:YES];
        [HUD setLabelText:KLoaderText];

        SMLeadsDetailCell     *cell = (SMLeadsDetailCell *)[self.tblViewLeadDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        NSDate *dateReceived = [dateFormatter dateFromString:cell.txtFieldDate.text];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'hh:mm:ss"];

         NSString *finalDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateReceived]];

        NSMutableURLRequest *requestURL;
        
         if(isActivitySelectedIsDelivered)
         {
             requestURL=[SMWebServices addNewActivity:[SMGlobalClass sharedInstance].hashValue withClientID:[[SMGlobalClass sharedInstance].strClientID intValue] withLeadId:self.leadID withActivityID:selectedActivityID withChaangeStatus:1 withComment:cell.txtViewCommentsSold.text invoiceNum:cell.txtFieldInvoiceNo.text inVoiceDate:finalDate invoiceAmount:cell.txtFieldRIncl.text.floatValue invoiceTo:cell.txtFieldInvoiceTo.text Salesperson:cell.txtFieldSalesPerson.text stockNum:cell.txtFieldStockNo.text departmentID:selectedVehicleDeptId typeID:selectedVehicleTypeId GenderID:selectedGenderID RaceID:selectedRaceID Age:cell.txtFieldAge.text.intValue];
         }
         else
         {
              requestURL=[SMWebServices addThePhoneOrEmailActivitywithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[[SMGlobalClass sharedInstance].strClientID intValue] withLeadID:self.leadID withActivity:selectedActivityID withChangeStatus:cell.buttonChangeStatus.selected ? 1 :0 andWithComment:cell.txtViewComment.text];
         }


        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];

        [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
         {
             [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];


             if (error!=nil)
             {
                 SMAlert(@"Error", error.localizedDescription);
                 [HUD hide:YES];
             }
             else
             {
                 xmlParser = [[NSXMLParser alloc] initWithData:data];
                 [xmlParser setDelegate: self];
                 [xmlParser parse];
             }
         }];
    }
}

-(BOOL) validateLead
{
    
    
    if(!isActivitySelectedIsDelivered)
    {
        SMLeadsDetailCell *cell = (SMLeadsDetailCell *)[self.tblViewLeadDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
        if (selectedActivityID == -1 )
        {
            SMAlert(KLoaderTitle, @"Please select activity");
            return NO;
        }
        else if([cell.txtViewComment.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please enter comment.");
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        SMLeadsDetailCell *cell = (SMLeadsDetailCell *)[self.tblViewLeadDetails cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];

        if (selectedActivityID == -1 )
        {
            SMAlert(KLoaderTitle, @"Please select activity");
            return NO;
        }
        else if([cell.txtFieldInvoiceNo.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please enter Invoice number");
            return NO;
        }
        else if([cell.txtFieldDate.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please select Date");
            return NO;
        }
        else if([cell.txtFieldRIncl.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please enter Invoice amount");
            return NO;
        }
        else if([cell.txtFieldInvoiceTo.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please enter recepient of invoice");
            return NO;
        }
        else if([cell.txtFieldSalesPerson.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please enter name of Salesperson");
            return NO;
        }
        else if([cell.txtFieldStockNo.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please enter Stock #");
            return NO;
        }
        else if([cell.txtFieldVehicleDept.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please select vehicle department.");
            return NO;
        }
        else if([cell.txtFieldVehicleType.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please select vehicle type.");
            return NO;
        }
        else if([cell.txtFieldGender.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please select Gender.");
            return NO;
        }
        else if([cell.txtFieldRace.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please select Race.");
            return NO;
        }
        else if([cell.txtFieldAge.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please select Age.");
            return NO;
        }
        else if((cell.txtFieldAge.text.intValue < 18 )|| (cell.txtFieldAge.text.intValue  > 90) )
        {
            SMAlert(KLoaderTitle, @"Please select age between 18 to 90");
            return NO;
        }
        else if([cell.txtViewCommentsSold.text length] == 0)
        {
            SMAlert(KLoaderTitle, @"Please enter comment.");
            return NO;
        }
        else
        {
            return YES;
        }
    }
}

#pragma mark - User Define Functions Call
- (void)registerNib
{

    listActiveSpecialsNavigTitle = [[UILabel alloc] initWithFrame:CGRectZero];
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



    [self.tblViewLeadDetails registerNib:[UINib nibWithNibName:@"SMLeadsDetailCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMLeadsDetailCell"];

    [self.tblViewLeadDetails registerNib:[UINib nibWithNibName:@"SMLeadsTradeInDetailsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMLeadsTradeInDetailsCell"];

   // [self.tblViewLeadDetails registerNib:[UINib nibWithNibName:@"SMCustomDynamicCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"SMCustomDynamicCell"];


    self.innerPopUpView.layer.cornerRadius=15.0;
    self.innerPopUpView.clipsToBounds      = YES;
    self.innerPopUpView.layer.borderWidth=1.5;
    self.innerPopUpView.layer.borderColor=[[UIColor blackColor] CGColor];

}

-(void)populateTheSectionsArray
{

    NSArray *arrayOfSectionNames = [[NSArray alloc]initWithObjects:@"Update Now",@"Trade-In Details", nil];

    for(int i=0;i<2;i++)
    {
        SMClassForToDoObjects *sectionObject = [[SMClassForToDoObjects alloc]init];
        sectionObject.strSectionID = i+1;
        sectionObject.strSectionName = [arrayOfSectionNames objectAtIndex:i];
        if(i==0)
            sectionObject.isExpanded = YES;
        [arrayForSections addObject:sectionObject];

    }

}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    svos = self.tblViewLeadDetails.contentOffset;

    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:self.tblViewLeadDetails];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 150;
    [self.tblViewLeadDetails setContentOffset:pt animated:YES];

}


-(void)loadLeadsDetailsForLeadID:(int)leadID
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];


    NSMutableURLRequest *requestURL=[SMWebServices loadTheLeadDetailWithUserHash:[SMGlobalClass sharedInstance].hashValue
                                                                     andClientID:[[SMGlobalClass sharedInstance].strClientID intValue]
                                                                       andLeadID:leadID];


    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];

    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];


         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser parse];
         }
     }];
}


-(void) loadActivity
{

    [self.arrayForActivity removeAllObjects];

    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL=[SMWebServices loadAllActivitieswithusehas:[SMGlobalClass sharedInstance].hashValue withClientID:[[SMGlobalClass sharedInstance].strClientID intValue]withLeadId:self.leadID];


    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];

    [NSURLConnection sendAsynchronousRequest:requestURL queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];


         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser parse];
         }
     }];

}



-(IBAction)buttonChangeStatusDidPressed:(id) sender
{
    UIButton *btn = (UIButton *) sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.tblViewLeadDetails];
    NSIndexPath *indexPath = [self.tblViewLeadDetails indexPathForRowAtPoint:buttonFrameInTableView.origin];

    SMLeadsDetailCell* cell = (SMLeadsDetailCell *)[self.tblViewLeadDetails cellForRowAtIndexPath:indexPath];

    [cell.buttonChangeStatus setSelected:!cell.buttonChangeStatus.selected];

}

#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.color = [UIColor blackColor];
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}

-(void) hideProgressHUD
{
    [HUD hide:YES];
}
#pragma mark -

#pragma mark - xmlParserDelegate
-(void) parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{

    if ([elementName isEqualToString:@"Activities"])
    {
        isActivityOptions = YES;
    }

    if ([elementName isEqualToString:@"Activity"] && isActivityOptions)
    {
        isActivityParsing = YES;
    }
    if ([elementName isEqualToString:@"LeadInfo"])
    {
        isActivityParsing = NO;
        isActivityOptions = NO;
    }
    if ([elementName isEqualToString:@"Lead"])
    {
        //leadDetailObject = [[SMLeadDetailObject alloc]init];


    }
    else if ([elementName isEqualToString:@"TradeIn"])
    {
        
       isTradeInPresent = YES;
    }
    if (isActivityOptions && isActivityParsing)
    {
        leadObject = [[SMLeadListObject alloc] init];
    }

    currentNodeContent = [NSMutableString stringWithString:@""];

}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

/*-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *str = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];

    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}*/

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

    


    if ([elementName isEqualToString:@"Type"])
    {
        if([currentNodeContent isEqualToString:@"New"])
            isTheLeadNew = YES;
        else
            isTheLeadNew = NO;

    }
    if ([elementName isEqualToString:@"Matched"])
    {
        if(currentNodeContent.boolValue == TRUE)
            isTheLeadMatched = YES;
        else
            isTheLeadMatched = NO;

    }
    if ([elementName isEqualToString:@"MMCode"])
    {
        vehicleMMCode = currentNodeContent;

        //self.lblEnquiredValue.text = currentNodeContent;
    }
    if ([elementName isEqualToString:@"FriendlyName"])
    {
        vehicleName = currentNodeContent;

        //self.lblEnquiredValue.text = [NSString stringWithFormat:@"%@ | %@",self.lblEnquiredValue.text,currentNodeContent];

        //[self.lblEnquiredValue sizeToFit];
    }
    if ([elementName isEqualToString:@"UsedVehicleStockID"])
    {
        usedVehicleStockID = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Colour"])
    {
        vehicleColor = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Year"])
    {
        if([currentNodeContent length] > 0)
        {
           if(!isTradeInPresent)
            vehicleYear = currentNodeContent;
        }
        else
        {
           
            vehicleYear = @"Year?";
        }
    }
    if ([elementName isEqualToString:@"StockCode"])
    {
        vehicleStockCode = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Mileage"])
    {
        vehicleMileage = currentNodeContent;
    }
   /* if ([elementName isEqualToString:@"Make"])
    {
        if(![currentNodeContent isEqualToString:@"Unknown"])
        {
            lblTradeInVehicleName = currentNodeContent;
        }
        else
        {
            lblTradeInVehicleName = @"No Name Loaded";
        }
    }*/
 
    /*if ([elementName isEqualToString:@"Model"])
    {
        if(![currentNodeContent isEqualToString:@"Unknown"])
        {
            lblTradeInYearModel = [NSString stringWithFormat:@"%@%@",lblTradeInYearModel,currentNodeContent];
        }
        else
        {
            lblTradeInYearModel = @"No Year Loaded";
        }
    }*/
    /*if ([elementName isEqualToString:@"Mileage"])
    {
        if([currentNodeContent length] > 0)
        {
            lblTradeInMileage = currentNodeContent;
        }
        else
        {
            lblTradeInMileage = @"No Mileage Loaded";
        }
    }*/
    
    if([elementName isEqualToString:@"Lead"])
    {
        if([vehicleName length] == 0)
        {
            self.leadDetailObject.leadEnquiredOnValue = @"Enquired on?";

          
        }

        if(isTheLeadMatched)
        {
            if(isTheLeadNew)
            {
                //if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    if([vehicleName length] == 0)
                    self.leadDetailObject.leadEnquiredOnValue = @"Enquired on?";
                    else
                        self.leadDetailObject.leadEnquiredOnValue = vehicleName;

                }

            }
            else
            {
                //if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    self.leadDetailObject.leadEnquiredOnValue = [NSString stringWithFormat:@"%@ | %@ | %@ | %@ Km | %@ ",vehicleYear,vehicleName,vehicleColor,vehicleMileage,vehicleStockCode];

                    
                }

            }
        }
        else
        {
            {
                self.leadDetailObject.leadEnquiredOnValue = vehicleName;
                self.lblEnquiredValue.text = [NSString stringWithFormat:@"%@",vehicleName];
            }
            

        }

        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            if(![self.leadDetailObject.leadLastUpdateValue isEqualToString: @"N/A"])
            {
                self.leadDetailObject.leadLastUpdateValue =[NSString stringWithFormat:@"%@ | %@ | %@",lastUpdateActivity,lastUpdateUser,lastUpdateDate];

               
            }
        }
        
        [self.tblViewLeadDetails reloadData];


    }


    if ([elementName isEqualToString:@"Name"])
    {
        if (!isActivityParsing)
        {
            if([currentNodeContent length] == 0 || [currentNodeContent isEqualToString:@"Not Given Not Given"])
            {
                self.leadDetailObject.leadProspectValue = @"Prospect?";
            }
            else
            {
                self.leadDetailObject.leadProspectValue = currentNodeContent;
            }

        }
        else
        {
            leadObject.strName = currentNodeContent;

        }
    }
    else if ([elementName isEqualToString:@"MobileNumber"])
    {


        if ([currentNodeContent isEqualToString:@""])
        {

            self.leadDetailObject.leadPhoneValue =  @"N/A";

           
        }
        else
        {
            self.leadDetailObject.leadPhoneValue = currentNodeContent;

        }



    }
    else if ([elementName isEqualToString:@"HomeNumber"])
    {
        {
            if([self.leadDetailObject.leadPhoneValue isEqualToString:@"N/A"])
            {
                if([currentNodeContent length] != 0)
                   self.leadDetailObject.leadPhoneValue = currentNodeContent;
                else
                    self.leadDetailObject.leadPhoneValue = @"N/A";
 
            }
            else
            {
                if ([currentNodeContent isEqualToString:@""] )
                {
                    if([self.leadDetailObject.leadPhoneValue isEqualToString:@"N/A"])
                    self.leadDetailObject.leadPhoneValue = @"N/A";
                    
                }
                

            }
        }
        
    }
    else if ([elementName isEqualToString:@"WorkNumber"])
    {
        {
            if([self.leadDetailObject.leadPhoneValue isEqualToString:@"N/A"])
            {
                if([currentNodeContent length] != 0)
                    self.leadDetailObject.leadPhoneValue = currentNodeContent;
                else
                    self.leadDetailObject.leadPhoneValue = @"N/A";
                
            }
            else
            {
                if ([currentNodeContent isEqualToString:@""] )
                {
                    if([self.leadDetailObject.leadPhoneValue isEqualToString:@"N/A"])
                        self.leadDetailObject.leadPhoneValue = @"N/A";
                    
                }
               
                
            }
        }
        
    }


    else if ([elementName isEqualToString:@"Email"])
    {
        
        self.leadDetailObject.leadEmailValue = currentNodeContent;

    }
   
    else if ([elementName isEqualToString:@"Source"])
    {
        //f (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        self.leadDetailObject.leadSourceValue = currentNodeContent;


    }
    else if ([elementName isEqualToString:@"Submitted"])
    {
            if ([currentNodeContent isEqualToString:@""])
            {
                self.leadDetailObject.leadDateValue = @"No Date Loaded";
            }
            else
            {
                self.leadDetailObject.leadDateValue = currentNodeContent;

            }
       


    }
   
    else if ([elementName isEqualToString:@"Age"])
    {
        NSString *finalTime = [self returnTheRequiredTimeFortheString:currentNodeContent];
        NSLog(@"leadDetailObject.leadDateValue = %@",leadDetailObject.leadDateValue);
        self.leadDetailObject.leadDateValue = [NSString stringWithFormat:@"%@ | %@",self.leadDetailObject.leadDateValue,finalTime];
    }
    else if ([elementName isEqualToString:@"LastUpdate"])
    {

        if ([currentNodeContent isEqualToString:@""])
        {

            self.leadDetailObject.leadLastUpdateValue = @"N/A";

        }

    }
    else if ([elementName isEqualToString:@"Date"])
    {
        NSString *finalTime = [self returnTheRequiredTimeFortheString:currentNodeContent];

        lastUpdateDate = finalTime;

    }

    else if ([elementName isEqualToString:@"User"])
    {
        lastUpdateUser = currentNodeContent;
    }

    if ([elementName isEqualToString:@"ID"] && !isActivityParsing)
    {

        listActiveSpecialsNavigTitle.text = [NSString stringWithFormat:@"Lead %@",currentNodeContent];
        self.navigationItem.titleView = listActiveSpecialsNavigTitle;
        [listActiveSpecialsNavigTitle sizeToFit];
    }

    else if ([elementName isEqualToString:@"ID"] && isActivityParsing )
    {
       

        activityID = [currentNodeContent intValue];
    }

    else if ([elementName isEqualToString:@"Activity"] )
    {
        if( !isActivityParsing)
            lastUpdateActivity = currentNodeContent;
        else
        {
            leadObject.activityID = activityID;
            [self.arrayForActivity addObject:leadObject];

        }

    }

    else if ([elementName isEqualToString:@"ActivityOptionsForLeadResult"])
    {
        [self loadPopup];
    }
    else if ([elementName isEqualToString:@"LoadLeadResult"])
    {
        if([currentNodeContent isEqualToString:@"You are not authorised to see this lead"])
        {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"You are not authorised to see this lead" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }
                
            }];
        
        }
    
    }
    else if ([elementName isEqualToString:@"Status"])
    {
        if ([currentNodeContent isEqualToString:@"Success"])
        {


            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:kLeadUpdateSuccess cancelButtonTitle:@"Ok" otherButtonTitles:nil];

            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel)
                {
                    [self.listRefreshDelegate refreshTheLeadListModule];
                    [self.navigationController popViewControllerAnimated:YES];
                    return;
                }

            }];
        }
        else
            SMAlert(KLoaderTitle, @"Failed,Please Try Again");
    }
    

}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
        if(self.leadDetailObject.leadEnquiredOnValue == nil)
        self.leadDetailObject.leadEnquiredOnValue = @"Enquired on?";
    
    if([self.leadDetailObject.leadPhoneValue isEqualToString:@"N/A"])
          self.leadDetailObject.leadPhoneValue = @"Phone number?";

     //NSLog(@"Phone number on Value = %@",leadDetailObject.leadPhoneValue);
    NSLog(@"email ID = %@",leadDetailObject.leadEmailValue);


    [self hideProgressHUD];

}



-(void)loadPopup
{

    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;


    [self.popUpView setFrame:[UIScreen mainScreen].bounds];
    [self.popUpView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [self.popUpView setAlpha:0.0];


    [[[UIApplication sharedApplication]keyWindow]addSubview:self.popUpView];

    [self.popUpView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [self.popUpView setAlpha:0.75];
         [self.popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
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

              [self.tblViewActivity reloadData];

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




-(IBAction)buttonCancelPopupDidPressed:(id)sender
{
    [self dismissPopup];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(NSString*)returnTheRequiredTimeFortheString:(NSString*)inputString
{


    NSArray *firstar = [inputString componentsSeparatedByString:@":"];


    if([[firstar objectAtIndex:0] intValue] != 0)
    {

        NSString *properStr;

        if([[firstar objectAtIndex:0] intValue] == 1)
            properStr = @"day" ;
        else
            properStr = @"days";


        if([[firstar objectAtIndex:0] intValue]>7)
            return [NSString stringWithFormat:@"%d %@ ago",[[firstar objectAtIndex:0] intValue],properStr];
        else
            return [NSString stringWithFormat:@"%d %@ ago",[[firstar objectAtIndex:0] intValue],properStr];



    }
    else if ([[firstar objectAtIndex:1] intValue] != 0)
    {

        NSString *properStr;

        if([[firstar objectAtIndex:1] intValue] == 1)
            properStr = @"hour" ;
        else
            properStr = @"hours";

        return [NSString stringWithFormat:@"%d %@ ago",[[firstar objectAtIndex:1] intValue],properStr];


    }
    else if ([[firstar objectAtIndex:2] intValue] != 0)
    {

        NSString *properStr;

        if([[firstar objectAtIndex:2] intValue] == 1)
            properStr = @"min" ;
        else
            properStr = @"mins";

        if([[firstar objectAtIndex:2] intValue]>5)
            return [NSString stringWithFormat:@"%d %@ ago",[[firstar objectAtIndex:2] intValue],properStr];
        else
            return [NSString stringWithFormat:@"%d %@ ago",[[firstar objectAtIndex:2] intValue],properStr];

    }
    else
        return @"Just Now";
}



-(NSString*) formatPhoneNumber:(NSString *)phoneNumber
{
    NSLog(@"phoneNumber = %@",phoneNumber);
    NSMutableString *stringts = [NSMutableString stringWithString:phoneNumber];
    if([phoneNumber length] == 10)
    {
        [stringts insertString:@" " atIndex:3];
        [stringts insertString:@" " atIndex:7];
    }
    else
    {
        [stringts insertString:@" " atIndex:3];
        [stringts insertString:@" " atIndex:7];
        [stringts insertString:@" " atIndex:11];
    }
    
    NSString *formattedString = [NSString stringWithString:stringts];
    return formattedString;

}


- (NSString*)returnOnlyTheNumbersForString:(NSString*)givenString
{
    
    NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:ACCEPTABLE_CHARACTERS_Number] invertedSet];
    NSString       *filtered       = [[givenString componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
    
    return filtered;
}

#pragma mark -
#pragma mark - Load/Hide Drop Down For Start Date

-(void)loadPopUpView
{
    [popUpDateView setFrame:[UIScreen mainScreen].bounds];;
    [popUpDateView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [popUpDateView setAlpha:0.0];
   // [self.view addSubview:popUpDateView];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popUpDateView];
    [popUpDateView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [popUpDateView setAlpha:0.75];
         [popUpDateView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [popUpDateView setAlpha:1.0];
              
              [popUpDateView setTransform:CGAffineTransformIdentity];
              
          }
                          completion:^(BOOL finished)
          {
          }];
         
     }];
}

-(void) hidePopUpView
{
    [popUpDateView setAlpha:1.0];
    //[self.view addSubview:popUpDateView];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popUpDateView];
    [UIView animateWithDuration:0.1 animations:^{
        [popUpDateView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [popUpDateView setAlpha:0.3];
              [popUpDateView setTransform:CGAffineTransformMakeScale(0.9,0.9)];
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   
                   [popUpDateView setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [popUpDateView removeFromSuperview];
                   [popUpDateView setTransform:CGAffineTransformIdentity];
               }];
          }];
     }];
}




#pragma mark - TapGestureRecognizer

-(void)phoneNumberTapHandler:(UITapGestureRecognizer *)phoneNumGestureRecog
{
    
    SMParseXML *parseXML = [[SMParseXML alloc]init];
    
   
    
    [parseXML addTheActivityWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[[SMGlobalClass sharedInstance].strClientID intValue] withLeadID:self.leadID withActivity:5 withChangeStatus:1 andWithComment:@"Phone call via Smart Manager App" andWithCallBack:^(BOOL success, NSString *responseString, NSError *error) {
        if(success)
        {
            //NSLog(@"selected phone number = %@",self.leadDetailObject.leadPhoneValue);
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.leadDetailObject.leadPhoneValue]]];
        }
        else
        {
            NSLog(@"Some Error occurred ");
        }
    }];
    
   
}


-(void)emailAddressTapHandler:(UITapGestureRecognizer *)emailAddrsGestureRecog
{
   
    SMParseXML *parseXML = [[SMParseXML alloc]init];
    
    
    
    [parseXML addTheActivityWithUserHash:[SMGlobalClass sharedInstance].hashValue withClientID:[[SMGlobalClass sharedInstance].strClientID intValue] withLeadID:self.leadID withActivity:38 withChangeStatus:1 andWithComment:@"Email sent via Smart Manager App" andWithCallBack:^(BOOL success, NSString *responseString, NSError *error) {
        if(success)
        {
            
            if ([MFMailComposeViewController canSendMail])
            {
                MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
                mail.mailComposeDelegate = self;
                [mail setToRecipients:@[self.leadDetailObject.leadEmailValue]];
                if([self.leadDetailObject.leadEnquiredOnValue isEqualToString:@"Enquired on?"] || [self.leadDetailObject.leadEnquiredOnValue length] == 0)
                {
                    [mail setSubject:[NSString stringWithFormat:@"Response to your enquiry on %@",self.leadDetailObject.leadSourceValue]];
                }
                else
                {
                    [mail setSubject:leadDetailObject.leadEnquiredOnValue];
                }
                
                
                
                [self presentViewController:mail animated:YES completion:NULL];
            }
            else
            {
                SMAlert(KLoaderTitle, kEmailCanNotSend);
                
            }
        }
        else
        {
            NSLog(@"Some Error occurred ");
        }
    }];


}

#pragma mark


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultSent:
            SMAlert(KLoaderTitle, KEmailsentSuccess);
            break;
        case MFMailComposeResultSaved:
            SMAlert(KLoaderTitle, KEmailSavedDrafts);
            break;
        case MFMailComposeResultCancelled:
            SMAlert(KLoaderTitle,KEmailCancel);
            break;
        case MFMailComposeResultFailed:
            SMAlert(KLoaderTitle,KEmailErrorOccured);
            break;
        default:
            SMAlert(KLoaderTitle,KEmailComposedError);
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}



- (IBAction)btnCancelDateDidClicked:(id)sender {
    
    [self hidePopUpView];
}

- (IBAction)btnSetDateDidClicked:(id)sender {
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"dd MMM yyyy"];
    
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:datePickerForTime.date]];
    
    UITextField *txtFieldDate = (UITextField*)[self.view viewWithTag:12];
    [txtFieldDate setText:textDate];
    [self hidePopUpView];
    
    
}
@end
