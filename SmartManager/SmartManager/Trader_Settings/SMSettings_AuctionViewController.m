//
//  SMSettings_AuctionViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 04/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMSettings_AuctionViewController.h"
#import "SMCommonClassMethods.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "UIBAlertView.h"
#import "SMCustomColor.h"

typedef enum : NSUInteger
{
    askingPrice = 0,
    bidIncrease,
    buyNowPrice,
    availableFrom,
    availableFor,
    extendBy
    
    
}textFieldSelected;

@interface SMSettings_AuctionViewController ()

@end

@implementation SMSettings_AuctionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addingProgressHUD];
    self.navigationItem.titleView = [SMCustomColor setTitle:@"My Auctions Settings"];
    [self webServiceForGettingAuctions];
    arraySortObject = [[NSMutableArray alloc]init];
    [scrollView addSubview:contentView];
    [scrollView setContentSize:contentView.bounds.size];
    
    btnSaveAuction.layer.cornerRadius = 4.0;

   
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    pickerViewAskingPrice = [[SMCommonClassMethods shareCommonClassManager]getMyRSAPickerViewObj];
    pickerViewBidIncrease = [[SMCommonClassMethods shareCommonClassManager]getMyRSAPickerViewObj];
    pickerViewBuyNowPrice = [[SMCommonClassMethods shareCommonClassManager]getMyRSAPickerViewObj];
    pickerViewAvailableFrom = [[SMCommonClassMethods shareCommonClassManager]getMyRSAPickerViewObj];
    pickerViewAvailableFor = [[SMCommonClassMethods shareCommonClassManager]getMyRSAPickerViewObj];
   
}
#pragma mark - UIKeyboard Notification

- (void)keyboardWasShown:(NSNotification*)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, [self view].bounds.size.height - (keyboardSize.height+2.0));
    
}

- (void)keyboardWasHidden:(NSNotification*)notification
{
    scrollView.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, scrollView.frame.size.width, [self view].bounds.size.height);
    
}
#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(SMCustomTextFieldForDropDown *)textField
{
   
    
    switch (textField.tag)
    {
        case askingPrice:
        {
           // [HUD show:YES];
            //[HUD setLabelText:KLoaderText];
                        NSLog(@"printed.....");
            pickerViewAskingPrice.pickerView.delegate = self;
            pickerViewAskingPrice.pickerView.dataSource = self;
            txtFieldAskingPrice.inputView = pickerViewAskingPrice;
            pickerViewAskingPrice.doneButton.tag = askingPrice;
            [pickerViewAskingPrice.doneButton addTarget:self action:@selector(pickerDoneButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];

            [self populateTheOptionsArrayForType:0];
          //  [HUD hide:YES];
            return YES;

        }
            break;
        case bidIncrease:
        {
           
            pickerViewBidIncrease.pickerView.delegate = self;
            pickerViewBidIncrease.pickerView.dataSource = self;
            txtFieldBidIncrease.inputView = pickerViewBidIncrease;
            pickerViewBidIncrease.doneButton.tag = bidIncrease;
            [pickerViewBidIncrease.doneButton addTarget:self action:@selector(pickerDoneButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self populateTheOptionsArrayForType:1];
           
            return YES;
            
        }
            break;
        case buyNowPrice:
        {
            
            pickerViewBuyNowPrice.pickerView.delegate = self;
            pickerViewBuyNowPrice.pickerView.dataSource = self;
            txtFieldBuyNowPrice.inputView = pickerViewBuyNowPrice;
            pickerViewBuyNowPrice.doneButton.tag = buyNowPrice;
            [pickerViewBuyNowPrice.doneButton addTarget:self action:@selector(pickerDoneButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self populateTheOptionsArrayForType:2];
           
            return YES;
            
        }
        break;
        case availableFrom:
        {
           
            pickerViewAvailableFrom.pickerView.delegate = self;
            pickerViewAvailableFrom.pickerView.dataSource = self;
            txtFieldFrom.inputView = pickerViewAvailableFrom;
            pickerViewAvailableFrom.doneButton.tag = availableFrom;
            [pickerViewAvailableFrom.doneButton addTarget:self action:@selector(pickerDoneButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self populateTheOptionsArrayForType:3];
           
            return YES;
            
        }
        break;
        case availableFor:
        {
           
            pickerViewAvailableFor.pickerView.delegate = self;
            pickerViewAvailableFor.pickerView.dataSource = self;
            txtFieldFor.inputView = pickerViewAvailableFor;
            pickerViewAvailableFor.doneButton.tag = availableFor;
            [pickerViewAvailableFor.doneButton addTarget:self action:@selector(pickerDoneButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self populateTheOptionsArrayForType:4];
            
            return YES;
            
        }
        break;
        case extendBy:
        {
            
            pickerViewExtendBuy = [[SMCommonClassMethods shareCommonClassManager]getMyRSAPickerViewObj];
            pickerViewExtendBuy.pickerView.delegate = self;
            pickerViewExtendBuy.pickerView.dataSource = self;
            txtFieldBidsReceived.inputView = pickerViewExtendBuy;
            pickerViewExtendBuy.doneButton.tag = extendBy;
            [pickerViewExtendBuy.doneButton addTarget:self action:@selector(pickerDoneButtonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self populateTheOptionsArrayForType:5];
            return YES;
            
        }
            break;


            
        default:
            break;
    }
    
    
    return YES;
}

#pragma mark - UITableViewDataSource

-(NSInteger )numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == tblViewOptions)
        return arraySortObject.count;
       return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if(tableView == tblViewOptions)
    {
        static NSString *cellIdentifier= @"Cell";
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if(!cell)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:14.0];
        }
        else
        {
            cell.textLabel.font = [UIFont fontWithName:FONT_NAME size:20.0];
        }
        cell.textLabel.textColor = [UIColor blackColor];
        cell.backgroundColor = [UIColor clearColor];
        
        
        
            cell.accessoryType =UITableViewCellAccessoryNone;
            
            SMDropDownObject *optionsObject = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRowIndex];
            
            cell.textLabel.text = optionsObject.strSortText;
            cell.layoutMargins = UIEdgeInsetsZero;
            cell.preservesSuperviewLayoutMargins = NO;

    
    }
    return cell;
}

#pragma mark - WEb Services

-(void)webServiceForSettingAuctions
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    int availableFromValue;
    if([txtFieldFrom.text isEqualToString:@"First Bid"])
        availableFromValue = 0;
    else if ([txtFieldFrom.text containsString:@"07h"])
        availableFromValue = 1;
    else if ([txtFieldFrom.text containsString:@"08h"])
        availableFromValue = 2;
    else if ([txtFieldFrom.text containsString:@"09h"])
        availableFromValue = 3;
    else if ([txtFieldFrom.text containsString:@"10h"])
        availableFromValue = 4;
    else if ([txtFieldFrom.text containsString:@"11h"])
        availableFromValue = 5;
    else if ([txtFieldFrom.text containsString:@"12h"])
        availableFromValue = 6;
    else if ([txtFieldFrom.text containsString:@"13h"])
        availableFromValue = 7;
    else if ([txtFieldFrom.text containsString:@"14h"])
        availableFromValue = 8;
    else if ([txtFieldFrom.text containsString:@"15h"])
        availableFromValue = 9;
    else if ([txtFieldFrom.text containsString:@"16h"])
        availableFromValue = 10;
    else if ([txtFieldFrom.text containsString:@"17h"])
        availableFromValue = 11;
   /* else
    {
    NSArray *strSeprated=[txtFieldFrom.text componentsSeparatedByString:@"h"];
    NSLog(@"selected value = %@",[strSeprated objectAtIndex:0]);
    if ([[strSeprated objectAtIndex:0] hasPrefix:@"Daily at "])
    {
        NSLog(@"selected value = %@",[[strSeprated objectAtIndex:0] stringByReplacingCharactersInRange:NSMakeRange(0,9) withString:@""]);
        availableFromValue = [[[strSeprated objectAtIndex:0] stringByReplacingCharactersInRange:NSMakeRange(0,9) withString:@""] intValue] *60;
    }
    NSLog(@"final value = %d",availableFromValue);
    }*/
    int availableForValue;
    if([txtFieldFor.text containsString:@"hours"])
    {
        NSArray *strSeprated=[txtFieldFor.text componentsSeparatedByString:@" "];
        availableForValue = [[strSeprated objectAtIndex:0] intValue];
    }
    else if([txtFieldFor.text containsString:@"days"])
    {
        availableForValue = 168; // days is always 7 -> 7*24 = 168
    }
    else if([txtFieldFor.text containsString:@"weeks"])
    {
        availableForValue = 336; // weeks is always 2 -> 14*24 = 336
    }
    else if([txtFieldFor.text containsString:@"month"])
    {
        availableForValue = 720; // month is always 1 -> 30*24 = 720
    }
    else
        availableForValue = 0; // Indefinite
    
    NSMutableURLRequest *requestURL = [SMWebServices setTradeAuctionsWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue andisAcceptBids:checkBox1.isSelected minBidPercent:txtFieldAskingPrice.text.intValue minBidIncrease:txtFieldBidIncrease.text.intValue buyNowPrice:txtFieldBuyNowPrice.text.intValue availableFrom:availableFromValue availableFor:availableForValue noBidsExtend:checkBox2.isSelected extendPeriod:txtFieldBidsReceived.text.intValue];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)webServiceForGettingAuctions
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
   /* int availableFromValue;
    NSArray *strSeprated=[txtFieldFrom.text componentsSeparatedByString:@"h"];
    availableFromValue = [[strSeprated objectAtIndex:0] intValue] *60;
    
    int availableForValue;
    if([txtFieldFor.text containsString:@"hours"])
    {
        NSArray *strSeprated=[txtFieldFor.text componentsSeparatedByString:@" "];
        availableForValue = [[strSeprated objectAtIndex:0] intValue];
    }
    else if([txtFieldFor.text containsString:@"days"])
    {
        availableForValue = 168; // days is always 7 -> 7*24 = 168
    }
    else if([txtFieldFor.text containsString:@"weeks"])
    {
        availableForValue = 336; // weeks is always 2 -> 14*24 = 336
    }
    else if([txtFieldFor.text containsString:@"month"])
    {
        availableForValue = 720; // month is always 1 -> 30*24 = 720
    }
    else
        availableForValue = 0; // Indefinite*/
    
    NSMutableURLRequest *requestURL = [SMWebServices getTradeAuctionsWithUserHash:[SMGlobalClass sharedInstance].hashValue andClientID:[SMGlobalClass sharedInstance].strClientID.intValue ];
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (connectionError!=nil)
         {
             SMAlert(@"Error", connectionError.localizedDescription);
             [HUD hide:YES];
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}



#pragma mark - NSXMLParser Delegate Methods

- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
    if ([elementName isEqualToString:@"Message"])
    {
        //if([currentNodeContent isEqualToString:@"Saved"])
        {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:currentNodeContent cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel)
                {
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    return;
                    
                }
                
            }];
            
        }
    }
    if ([elementName isEqualToString:@"AcceptBids"])
    {
        checkBox1.selected = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"MinBidPercent"])
    {
        txtFieldAskingPrice.text = [NSString stringWithFormat:@"%@ %%",currentNodeContent];;
    }
    if ([elementName isEqualToString:@"MinBidIncrease"])
    {
        txtFieldBidIncrease.text = [NSString stringWithFormat:@"%@ %%",currentNodeContent];;
    }
    if ([elementName isEqualToString:@"BuyNowPrice"])
    {
        txtFieldBuyNowPrice.text = [NSString stringWithFormat:@"%@ %%",currentNodeContent];
    }
    if ([elementName isEqualToString:@"AvailableFrom"])
    {
        if(![currentNodeContent isEqualToString:@"0"])
        {
        int value = currentNodeContent.intValue+6;
        txtFieldFrom.text = [NSString stringWithFormat:@"Daily at %0dh00",value];
        }
        else
           txtFieldFrom.text = @"First Bid";
        
    }
    if ([elementName isEqualToString:@"AvailableFor"])
    {
        if([currentNodeContent isEqualToString:@"168"])
        txtFieldFor.text = @"7 days";
        else if([currentNodeContent isEqualToString:@"336"])
         txtFieldFor.text = @"2 weeks";
        else if([currentNodeContent isEqualToString:@"720"])
            txtFieldFor.text = @"1 month";
         else if([currentNodeContent isEqualToString:@"0"])
         txtFieldFor.text = @"Indefinite";
        else
         txtFieldFor.text = [NSString stringWithFormat:@"%@ hours",currentNodeContent];
    }
    if ([elementName isEqualToString:@"NoBidExtend"])
    {
        checkBox2.selected = currentNodeContent.boolValue;
    }
    if ([elementName isEqualToString:@"ExtendPeriod"])
    {
        txtFieldBidsReceived.text = [NSString stringWithFormat:@"%@ mins",currentNodeContent];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    
    [self hideProgressHUD];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark -
#pragma mark - Load/Hide Drop Down For Make, Model And Variants

-(void)loadpopUpView
{
    
    UIViewController *vc = self.navigationController.viewControllers.lastObject;
    if (vc != self)
        return;
    
    
    [popUpView setFrame:[UIScreen mainScreen].bounds];
    [popUpView setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.25]];
    [popUpView setAlpha:0.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popUpView];
    [popUpView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];
    [UIView animateWithDuration:0.1 animations:^
     {
         [popUpView setAlpha:0.75];
         [popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
         
     }
                     completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.2 animations:^
          {
              [popUpView setAlpha:1.0];
              [popUpView setTransform:CGAffineTransformIdentity];
              
          }
                          completion:^(BOOL finished)
          {
          }];
         
     }];
}

-(void) hidepopUpView
{
    [popUpView setAlpha:1.0];
    [[[UIApplication sharedApplication]keyWindow]addSubview:popUpView];
    [UIView animateWithDuration:0.1 animations:^{
        [popUpView setTransform:CGAffineTransformMakeScale(1.1, 1.1)];
    } completion:^(BOOL finished)
     {
         [UIView animateWithDuration:0.1 animations:^
          {
              [popUpView setAlpha:0.3];
              [popUpView setTransform:CGAffineTransformMakeScale(0.9,0.9)];
          }
                          completion:^(BOOL finished)
          {
              [UIView animateWithDuration:0.05 animations:^
               {
                   [popUpView setAlpha:0.0];
               }
                               completion:^(BOOL finished)
               {
                   [popUpView removeFromSuperview];
                   [popUpView setTransform:CGAffineTransformIdentity];
               }];
          }];
     }];
}


-(void)populateTheOptionsArrayForType:(int)optionType
{
    switch (optionType)
    {
        case askingPrice:
        {
            if(arraySortObject.count > 0)
                [arraySortObject removeAllObjects];
            
            for (int i = 50; i <= 100; i += 5)
            {
                SMDropDownObject *sortObject = [[SMDropDownObject alloc]init];
                sortObject.strSortText = [NSString stringWithFormat:@"%d %%",i];
                [arraySortObject addObject:sortObject];

            }
            NSLog(@"arraycount = %lu",(unsigned long)arraySortObject.count);
        }
        break;
        case bidIncrease:
        {
            if(arraySortObject.count > 0)
                [arraySortObject removeAllObjects];
            
            for (int i = 1; i <= 30; i += 1)
            {
                SMDropDownObject *sortObject = [[SMDropDownObject alloc]init];
                sortObject.strSortText = [NSString stringWithFormat:@"%d %%",i];
                [arraySortObject addObject:sortObject];
                
            }
        }
        break;
        case buyNowPrice:
        {
            if(arraySortObject.count > 0)
                [arraySortObject removeAllObjects];
            
            for (int i = 1; i <= 50; i += 1)
            {
                SMDropDownObject *sortObject = [[SMDropDownObject alloc]init];
                sortObject.strSortText = [NSString stringWithFormat:@"%d %%",i];
                [arraySortObject addObject:sortObject];
                
            }
        }
        break;
        case availableFrom:
        {
            if(arraySortObject.count > 0)
                [arraySortObject removeAllObjects];
            
            for (int i = 6; i <= 17; i += 1)
            {
                SMDropDownObject *sortObject = [[SMDropDownObject alloc]init];
                if(i == 6)
                    sortObject.strSortText = @"First Bid";
                else if(i <10)
                sortObject.strSortText = [NSString stringWithFormat:@"Daily at 0%dh00",i];
                else
                 sortObject.strSortText = [NSString stringWithFormat:@"Daily at %dh00",i];
                
                [arraySortObject addObject:sortObject];
                
            }
        }
        break;
        case availableFor:
        {
            if(arraySortObject.count > 0)
                [arraySortObject removeAllObjects];
            
            NSArray *tempArray = [[NSArray alloc]initWithObjects:@"8 hours",@"12 hours",@"24 hours",@"48 hours",@"7 days",@"2 weeks",@"1 month",@"Indefinite", nil];
            for (int i = 0; i < tempArray.count; i++)
            {
                SMDropDownObject *sortObject = [[SMDropDownObject alloc]init];
                sortObject.strSortText = [tempArray objectAtIndex:i];
                [arraySortObject addObject:sortObject];
                
            }
        }
        break;
        case extendBy:
        {
            if(arraySortObject.count > 0)
                [arraySortObject removeAllObjects];
            
            for (int i = 5; i <= 30; i += 5)
            {
                SMDropDownObject *sortObject = [[SMDropDownObject alloc]init];
                sortObject.strSortText = [NSString stringWithFormat:@"%d mins",i];
                [arraySortObject addObject:sortObject];
                
            }
        }
        break;
            
        default:
            break;
    }
    
    
}

#pragma mark - PickerView dataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}
- (UIView* )pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
         forComponent:(NSInteger)component reusingView:(UIView *)view
{
    
    UILabel *retval = (UILabel*)view;
    if (!retval) {
        retval = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    
    retval.font = [UIFont systemFontOfSize:22];
    retval.textAlignment = NSTextAlignmentCenter;
    
     SMDropDownObject *optionsObject = (SMDropDownObject*)[arraySortObject objectAtIndex:row];
        
        retval.text = optionsObject.strSortText;
        
        return retval;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
      return arraySortObject.count;
}

#pragma mark - PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    selectedRowIndex = row;
}
#pragma mark - PickerView Methods
-(IBAction)pickerDoneButtonDidClicked:(id)sender
{
    
    UIButton *btn = (UIButton*)sender;
    SMDropDownObject *optionsObject = (SMDropDownObject*)[arraySortObject objectAtIndex:selectedRowIndex];
    switch (btn.tag)
    {
            
        case askingPrice:
        {

            txtFieldAskingPrice.text = optionsObject.strSortText;
        }
            break;
        case bidIncrease:
        {
           txtFieldBidIncrease.text = optionsObject.strSortText;
        }
            break;
        case buyNowPrice:
        {
           txtFieldBuyNowPrice.text = optionsObject.strSortText;
        }
            break;
        case availableFrom:
        {
            txtFieldFrom.text = optionsObject.strSortText;
        }
            break;
        case availableFor:
        {
            txtFieldFor.text = optionsObject.strSortText;
        }
            break;
        case extendBy:
        {
            txtFieldBidsReceived.text = optionsObject.strSortText;
        }
            break;
            
        default:
            break;

    }
    [self.view endEditing:YES];
  
}
- (IBAction)checkBoxAutoExtendBidDidClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
}

- (IBAction)checkBoxAcceptBidsDidClciked:(UIButton*)sender
{
    sender.selected = !sender.selected;

}

- (IBAction)btnSaveDidClicked:(id)sender
{
    [self webServiceForSettingAuctions];
}

- (IBAction)btnCancelOptionsDidClicked:(id)sender
{
    [self hidepopUpView];
}
@end
