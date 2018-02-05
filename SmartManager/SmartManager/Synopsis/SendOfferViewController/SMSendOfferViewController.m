//
//  SMSendOfferViewController.m
//  Smart Manager
//
//  Created by Sandeep on 22/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMSendOfferViewController.h"
#import "SMCustomColor.h"
#import "SMSaveAndSendViewCell.h"
#import "SMSendOfferObect.h"
#import "SMDropDownObject.h"
#import "SMSMSynopsisTableHeaderCell.h"
#import "UIImageView+WebCache.h"

@interface SMSendOfferViewController ()<UITextFieldDelegate>
{
    int numOfDynamicRows;
    SMSendOfferObect *sellerInfoObject;
    BOOL isSellerEmail;
    BOOL isSMSElement;
    NSArray *arrDays;
    NSMutableArray *arrmExpiryDays;
    NSMutableArray *arrmSubjectToText;
    CGFloat oldTableViewHeight;
    
}

@end

@implementation SMSendOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.titleView = [SMCustomColor setTitle:@"Send Offer"];

    [tblSMSendOffer registerNib:[UINib nibWithNibName: @"SMSendOfferCell" bundle:nil] forCellReuseIdentifier:@"SMSendOfferCell"];

    [tblSMSendOffer registerNib:[UINib nibWithNibName: @"SMViewMessageCell" bundle:nil] forCellReuseIdentifier:@"SMViewMessageCell"];

     [tblSMSendOffer registerNib:[UINib nibWithNibName: @"SMSaveAndSendViewCell" bundle:nil] forCellReuseIdentifier:@"SMSaveAndSendViewCell"];
    
     [tblSMSendOffer registerNib:[UINib nibWithNibName: @"SMSendOfferSubjectToCell" bundle:nil] forCellReuseIdentifier:@"SMSendOfferSubjectToCell"];
    
     [tblSMSendOffer registerNib:[UINib nibWithNibName: @"SMSendOfferExpiresInCell" bundle:nil] forCellReuseIdentifier:@"SMSendOfferExpiresInCell"];

     [tblSMSendOffer registerNib:[UINib nibWithNibName: @"SMSendOfferPlusButtonCell" bundle:nil] forCellReuseIdentifier:@"SMSendOfferPlusButtonCell"];
    
    [tblSMSendOffer registerNib:[UINib nibWithNibName: @"SMSMSynopsisTableHeaderCell" bundle:nil] forCellReuseIdentifier:@"SMSMSynopsisTableHeaderCell"];

    arrmSubjectToText = [[NSMutableArray alloc] init];
    [arrmSubjectToText addObject:@""];
    tblSMSendOffer.estimatedRowHeight = 300;
    tblSMSendOffer.rowHeight = UITableViewAutomaticDimension;
    tblSMSendOffer.tableFooterView = [[UIView alloc]init];
    [self addingProgressHUD];
    NSArray *arraySMTableSectionView1 = [[NSBundle mainBundle]loadNibNamed:@"SMTableSectionView" owner:self options:nil];
    section0View = [arraySMTableSectionView1 objectAtIndex:0];
    section0View.imgArrowDown.transform = CGAffineTransformMakeRotation(M_PI_2);

    [section0View.sectionButton setTitle:@"View Message" forState:UIControlStateNormal];
    [section0View.sectionButton addTarget:self action:@selector(expandTableSectionDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    isExpandViewMessage = YES;
    numOfDynamicRows = 1;
    [self webserviceCallForFetchingSellerDetails];
    


}
-(void)nextButtonDidClicked{

    SMLeadPoolViewController *obj = [[SMLeadPoolViewController alloc]initWithNibName:@"SMLeadPoolViewController" bundle:nil];

    [self.navigationController pushViewController:obj animated:YES];
}

-(IBAction)expandTableSectionDidClicked:(id)sender{

    isExpandViewMessage = !isExpandViewMessage;

    if (isExpandViewMessage) {
        section0View.imgArrowDown.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    else{
        section0View.imgArrowDown.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }
    [tblSMSendOffer reloadData];

}

# pragma mark - TextField methods

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    

    UITextField *txtFieldExpiresIn = [self.view viewWithTag:1001];
    
       if(textField == txtFieldExpiresIn)
       {
           [self.view endEditing:YES];
        NSArray *arrLoadNib = [[NSBundle mainBundle]loadNibNamed:@"SMCustomPopUpTableView" owner:self options:nil];
        SMCustomPopUpTableView *popUpView = [arrLoadNib objectAtIndex:0];
        
        [popUpView getTheDropDownData:arrmExpiryDays withVariant:NO andIsPagination:NO ifSort:NO andIsFirstTimeSort:YES]; // array to be passed for custom popup dropdown
        
        [self.view addSubview:popUpView];
        
        [SMCustomPopUpTableView getTheSelectedDataInfoWithCallBack:^(NSString *selectedTextValue, int selectIDValue, int minYear, int maxYear) {
            NSLog(@"selected text = %@",selectedTextValue);
            NSLog(@"selected ID = %d",selectIDValue);
            textField.text = selectedTextValue;
            sellerInfoObject.offerExpiry = selectedTextValue;
            //selectedMakeId = selectIDValue;
        }];
       }
    
  

}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.tag < 1000)
    {
        [arrmSubjectToText replaceObjectAtIndex:textField.tag withObject:textField.text];
    }
    
    SMSendOfferCell *sellerInfoCell = (SMSendOfferCell*)[tblSMSendOffer cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    
    if(textField == sellerInfoCell.txtName)
        sellerInfoObject.sellerName = textField.text;
    else if(textField == sellerInfoCell.txtSurname)
        sellerInfoObject.sellerSurName = textField.text;
    else if(textField == sellerInfoCell.txtCompany)
        sellerInfoObject.sellerCompany = textField.text;
    else if(textField == sellerInfoCell.txtEmail)
        sellerInfoObject.sellerEmail = textField.text;
    else if(textField == sellerInfoCell.txtMobile)
        sellerInfoObject.sellerMobile = textField.text;
    else if(textField == sellerInfoCell.txtMyOffer)
        sellerInfoObject.sellerMyOffer = textField.text;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    switch (section) {
        case 2:
        {
            return numOfDynamicRows;
        }
            break;
        case 5:
        {
            if(!isExpandViewMessage){
                return 0;
            }
             return 1;
        }
            break;

        default:
            break;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

   if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone){
        switch (indexPath.section) {
            case 0:
            {
                return UITableViewAutomaticDimension;
                
            }
                break;
            case 1:
            {
                return 467.0f;

            }
            break;
            case 2:
            {
                return 47.0;
                
            }
                break;
            case 3:
            {
                return 77.0f;
                
            }
                break;
            case 4:
            {
                return 44.0f;
                
            }
                break;
            case 5:
            {
                return UITableViewAutomaticDimension;
            }
            break;
            case 6:
            {
                return UITableViewAutomaticDimension;
            }
            break;
            default:
                break;
        }

        
    }
    else
    {
        switch (indexPath.section) {
            case 0:
            {
                return 783.0f;
                
            }
                break;
            case 1:{
                return UITableViewAutomaticDimension;
            }
                break;
            case 2:{
                return 204.0f;//195 iphone
            }
                break;
            default:
                break;
        }
        

        
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 5:{
            return section0View.frame.size.height;
        }
            break;
        default:
            break;
    }
    return 0.0f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    switch (section) {
        case 5:{
            return section0View;
        }
            break;
       
        default:
            break;
    }
    return nil;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"SMSendOfferCell";
    static NSString *cellIdentifier1=@"SMViewMessageCell";
    static NSString *cellIdentifier2=@"SMSaveAndSendViewCell";
    static NSString *cellIdentifier3=@"SMSendOfferSubjectToCell";
    static NSString *cellIdentifier4=@"SMSendOfferExpiresInCell";
    static NSString *cellIdentifier5=@"SMSendOfferPlusButtonCell";
    static NSString *cellIdentifier6=@"SMSMSynopsisTableHeaderCell";

    UITableViewCell *cell;

    switch (indexPath.section) {
        case 0:{
            SMSMSynopsisTableHeaderCell *cellObj=[tableView dequeueReusableCellWithIdentifier:cellIdentifier6];
            [cellObj.btnVehicleImage addTarget:self action:@selector(btnImageGalleryDidClicked) forControlEvents:UIControlEventTouchUpInside];
            [self setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear] andWithSecondText:self.objSMSynopsisResult.strFriendlyName forLabel:cellObj.vechicleName];
            
            
            cellObj.vechicleDesciption.text = self.objSMSynopsisResult.strVariantDetails;
            
            [cellObj.vechicleImage setImageWithURL:[NSURL URLWithString:self.objSMSynopsisResult.strVariantImage] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
            
            cellObj.vechicleImage.backgroundColor = [UIColor clearColor];
            cellObj.vechicleName.numberOfLines = 0;
            
            cellObj.vechicleDesciption.numberOfLines = 0;
            
            cell = cellObj;
        }
            break;
        case 1:
        {
            SMSendOfferCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.vechiclesVINOrChassisNOLabel.text = self.objSMSynopsisResult.strVINNo;
            dynamicCell.vechiclesRegistrationNOLabel.text = self.objSMSynopsisResult.strRegNo;
            dynamicCell.vechiclesMileageLabel.text = self.objSMSynopsisResult.strKilometers;
            dynamicCell.txtName.delegate = self;dynamicCell.txtSurname.delegate = self;dynamicCell.txtCompany.delegate = self;dynamicCell.txtEmail.delegate = self;dynamicCell.txtMobile.delegate = self;
            dynamicCell.txtMyOffer.delegate = self;
           
            dynamicCell.txtName.text = sellerInfoObject.sellerName;
            dynamicCell.txtSurname.text = sellerInfoObject.sellerSurName;
            dynamicCell.txtCompany.text = sellerInfoObject.sellerCompany;
            dynamicCell.txtEmail.text = sellerInfoObject.sellerEmail;
            dynamicCell.txtMobile.text = sellerInfoObject.sellerMobile;
            cell = dynamicCell;
        }
        break;
        case 2:
        {
            SMSendOfferCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            [dynamicCell.btnDelete addTarget:self action:@selector(btnDeleteDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            dynamicCell.txtFieldSubjectTo.delegate = self;
            dynamicCell.btnDelete.tag = indexPath.row;
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            dynamicCell.txtFieldSubjectTo.tag = indexPath.row+1;
             dynamicCell.txtFieldSubjectTo.text = [arrmSubjectToText objectAtIndex:indexPath.row];
            return dynamicCell;
        }
        break;
        case 3:
        {
            SMSendOfferCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier5];
            [dynamicCell.btnPlus addTarget:self action:@selector(btnPlusDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return dynamicCell;
        }
            break;
        case 4:
        {
           SMSendOfferCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier4];
            dynamicCell.txtFieldExpiresIn.delegate = self;
            dynamicCell.txtFieldExpiresIn.tag = 1001;
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return dynamicCell;
        }
            break;
        case 5:{
            SMViewMessageCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];

//            dynamicCell.layoutMargins = UIEdgeInsetsZero;
//            dynamicCell.preservesSuperviewLayoutMargins = NO;
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            
            dynamicCell.lblSMSContent.text = sellerInfoObject.strOfferSMSContent;
            dynamicCell.lblSubjectContent.text = [NSString stringWithFormat:@"Subject: %@ \n\nBody: %@",sellerInfoObject.strEmailSubjectContent,sellerInfoObject.strEmailBodyContent];

            cell = dynamicCell;

        }
            break;
        case 6:{

            SMSaveAndSendViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];

//            dynamicCell.layoutMargins = UIEdgeInsetsZero;
//            dynamicCell.preservesSuperviewLayoutMargins = NO;
            dynamicCell.backgroundColor = [UIColor blackColor];

            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            [dynamicCell.btnSaveAndSendOffer addTarget:self action:@selector(btnSaveAndSendOfferDidClicked:) forControlEvents:UIControlEventTouchUpInside];
           // dynamicCell.txt
            dynamicCell.backgroundColor = [UIColor blackColor];
           
            cell = dynamicCell;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Webservice integration

-(void) webserviceCallForFetchingSellerDetails
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    
     NSMutableURLRequest * requestURL = [SMWebServices sendOfferGetDetailsWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:self.objSMSynopsisResult.intYear andMakeID:self.objSMSynopsisResult.intMakeId andModelID:self.objSMSynopsisResult.intModelId andVariantID:self.objSMSynopsisResult.intVariantId andAppraisalID:self.objSMSynopsisResult.appraisalID.intValue andSendOfferID:1 andVinNum:self.objSMSynopsisResult.strVINNo];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            if (error!=nil)
                                            {
                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                    // Do something...
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        SMAlert(@"Error", error.localizedDescription);
                                                        [self hideProgressHUD];
                                                        return;
                                                    });
                                                });
                                                
                                            }
                                            else
                                            {
                                                
                                                xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}

-(void) webserviceCallForSavingAndSendingOfferWithSubjectArray:(NSMutableArray*) subjectArray{
    
    
    SMSaveAndSendViewCell *contactDetailsCell = (SMSaveAndSendViewCell*)[tblSMSendOffer cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:6]];
    
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    
    NSMutableURLRequest * requestURL = [SMWebServices saveAndSendOfferWith:[SMGlobalClass sharedInstance].hashValue andYear:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intYear] andMakeID:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intMakeId] andModelID:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intModelId] andVariantId:[NSString stringWithFormat:@"%d",self.objSMSynopsisResult.intVariantId] andSellerName:sellerInfoObject.sellerName andSellerSurname:sellerInfoObject.sellerSurName andCompany:sellerInfoObject.sellerCompany andEmailID:sellerInfoObject.sellerEmail andMobileNum:sellerInfoObject.sellerMobile andOffer:sellerInfoObject.sellerMyOffer andExpiresIn:sellerInfoObject.offerExpiry andSubjectArray:subjectArray andSMSNumbers:contactDetailsCell.txtFieldSMS.text andSMSFlag:[NSString stringWithFormat:@"%d",contactDetailsCell.btnCheckBoxSms.isSelected] andEmailIDs:contactDetailsCell.txtFieldEmailCopyTo.text andEmailSendOfferFlag:[NSString stringWithFormat:@"%d",contactDetailsCell.btnCheckBoxEmail.isSelected] andEmailSendCopyFlag:[NSString stringWithFormat:@"%d",contactDetailsCell.btnCheckboxEmailCopyTo.isSelected] andAppraisalID:@"1" andClientID:[SMGlobalClass sharedInstance].strClientID andVinNum:self.objSMSynopsisResult.strVINNo];
    
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            if (error!=nil)
                                            {
                                                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                                                    // Do something...
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        SMAlert(@"Error", error.localizedDescription);
                                                        [self hideProgressHUD];
                                                        return;
                                                    });
                                                });
                                                
                                            }
                                            else
                                            {
                                                
                                                xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}


#pragma mark - NSXMLParser Delegate Methods

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    if ([elementName isEqualToString:@"SendOfferViewMessageResult"])
    {
        sellerInfoObject = [[SMSendOfferObect alloc]init];
        
    }
    else if ([elementName isEqualToString:@"SellerInfo"])
    {
        isSellerEmail = YES;
        
    }
    else if ([elementName isEqualToString:@"OfferExpiresIn"])
    {
        isSellerEmail = NO;
    }
    else if ([elementName isEqualToString:@"SMS"])
    {
        isSMSElement = YES;
    }
    else if ([elementName isEqualToString:@"Subject"])
    {
        isSMSElement = NO;
    }
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Name"])
        sellerInfoObject.sellerName = currentNodeContent;
    else if ([elementName isEqualToString:@"Surname"])
        sellerInfoObject.sellerSurName = currentNodeContent;
    else if ([elementName isEqualToString:@"Company"])
        sellerInfoObject.sellerCompany = currentNodeContent;
    else if ([elementName isEqualToString:@"Email"] && isSellerEmail)
        sellerInfoObject.sellerEmail = currentNodeContent;
    else if ([elementName isEqualToString:@"Subject"] && !isSellerEmail)
    {
        sellerInfoObject.strEmailSubjectContent = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Body"] && isSMSElement)
    {
        sellerInfoObject.strOfferSMSContent = currentNodeContent;
    }
    else if ([elementName isEqualToString:@"Subject"])
        sellerInfoObject.strEmailSubjectContent = currentNodeContent;
   else if ([elementName isEqualToString:@"Body"] && !isSMSElement)
   {
       sellerInfoObject.strEmailBodyContent = currentNodeContent;
   }
    else if ([elementName isEqualToString:@"Mobile"])
        sellerInfoObject.sellerMobile = currentNodeContent;
    else if ([elementName isEqualToString:@"Days"])
    {
        arrDays = [currentNodeContent componentsSeparatedByString:@","];
        arrmExpiryDays = [[NSMutableArray alloc] init];
        for(int i=0;i<arrDays.count;i++)
        {
            SMDropDownObject *objCondition = [[SMDropDownObject alloc] init];
            objCondition.strMakeId = [NSString stringWithFormat:@"%d",i+1];
            objCondition.strMakeName = [arrDays objectAtIndex:i];
            [arrmExpiryDays addObject:objCondition];
        }
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    dispatch_async(dispatch_get_main_queue(), ^{
        // Do stuff to UI
        [tblSMSendOffer reloadData];
        //oldTableViewHeight = tblSMSendOffer.contentSize.height;

        [HUD hide:YES];
    });
    
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

-(IBAction)btnPlusDidClicked:(UIButton *)sender{
    numOfDynamicRows++;
     [arrmSubjectToText addObject:@""];
    [tblSMSendOffer reloadData];
    // Put your scroll position to where it was before
   // CGFloat newTableViewHeight = tblSMSendOffer.contentSize.height;
   // tblSMSendOffer.contentOffset = CGPointMake(0, newTableViewHeight - oldTableViewHeight);

}

-(IBAction)btnDeleteDidClicked:(UIButton *)sender{

    numOfDynamicRows--;
    [arrmSubjectToText removeObjectAtIndex:[sender tag]];
    [tblSMSendOffer reloadData];
    // Put your scroll position to where it was before
   // CGFloat newTableViewHeight = tblSMSendOffer.contentSize.height;
   // tblSMSendOffer.contentOffset = CGPointMake(0, newTableViewHeight - oldTableViewHeight);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)btnSaveAndSendOfferDidClicked:(UIButton *)sender{

    if([self validateOffer] == YES)
    {
        [self webserviceCallForSavingAndSendingOfferWithSubjectArray:arrmSubjectToText];
    }
   

}

-(BOOL) validateOffer
{
    SMSendOfferCell *sellerInfoCell = (SMSendOfferCell*)[tblSMSendOffer cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    
    SMSendOfferCell *expiresInCell = (SMSendOfferCell*)[tblSMSendOffer cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:4]];
    
    UITextField *txtFieldExpiresIn = [self.view viewWithTag:1001];
    
    SMSaveAndSendViewCell *contactDetailsCell = (SMSaveAndSendViewCell*)[tblSMSendOffer cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:6]];
    
    if(sellerInfoObject.sellerName.length == 0)
    {
        SMAlert(KLoaderTitle, @"Please enter Seller's Name");
        [sellerInfoCell.txtName becomeFirstResponder];
        return NO;
    }
    else if (sellerInfoObject.sellerSurName.length==0)
    {
        SMAlert(KLoaderTitle, @"Please select Seller's Surname");
        [sellerInfoCell.txtSurname becomeFirstResponder];
        return NO;
        
    }
    else  if (sellerInfoObject.sellerCompany.length==0)
    {
        SMAlert(KLoaderTitle, @"Please enter the Company");
        [sellerInfoCell.txtCompany becomeFirstResponder];
        return NO;
    }
    else  if (sellerInfoObject.sellerEmail.length==0)
    {
        SMAlert(KLoaderTitle,@"Please enter the Email address");
        [sellerInfoCell.txtEmail becomeFirstResponder];
        return NO;
    }
    else  if (sellerInfoObject.sellerMobile.length==0)
    {
        SMAlert(KLoaderTitle,@"Please enter the Mobile number");
        [sellerInfoCell.txtMobile becomeFirstResponder];
        return NO;
    }
    else  if (txtFieldExpiresIn.text.length==0)
    {
        SMAlert(KLoaderTitle,@"Please enter the expiry for the offer");
        [sellerInfoCell.txtMobile becomeFirstResponder];
        return NO;
    }
   /* else  if (contactDetailsCell.txtFieldSMS.text.length==0)
    {
        SMAlert(KLoaderTitle,@"Please enter the SMS");
        [contactDetailsCell.txtFieldSMS becomeFirstResponder];
        return NO;
    }*/
    else
    {
        return YES;
    }
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
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            [HUD hide:YES];
        });
    });
}


@end
