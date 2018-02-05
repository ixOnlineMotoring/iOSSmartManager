//
//  SMReviewsViewController.m
//  Smart Manager
//
//  Created by Sandeep on 24/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMReviewsViewController.h"
#import "SMCustomColor.h"
#import "SMReviewsDetailViewController.h"
#import "SMWSReviews.h"
#import "UIImageView+WebCache.h"

@interface SMReviewsViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
   SMReviewsXmlResultObject *objSMReviewsXmlResultObject;
    NSMutableArray *arrayOfReviewsByModels;
    
    NSString *strOtherMakeName;
    NSString *strOtherModelName;
    
}
@end

@implementation SMReviewsViewController

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Reviews"];
    
    [tblReviewsView registerNib:[UINib nibWithNibName: @"SMReviewsTitleViewCell" bundle:nil] forCellReuseIdentifier:@"SMReviewsTitleViewCell"];
    
    [tblReviewsView registerNib:[UINib nibWithNibName: @"SMReviewsViewCell" bundle:nil] forCellReuseIdentifier:@"SMReviewsViewCell"];
    
     [tblReviewsView registerNib:[UINib nibWithNibName: @"SMReviewsViewModelCell" bundle:nil] forCellReuseIdentifier:@"SMReviewsViewModelCell"];
    
    [tblReviewsView registerNib:[UINib nibWithNibName: @"SMReviewsNoArticlesCell" bundle:nil] forCellReuseIdentifier:@"SMReviewsNoArticlesCell"];
    
    [self addingProgressHUD];
    tblReviewsView.estimatedRowHeight = 116.0;
    tblReviewsView.rowHeight = UITableViewAutomaticDimension;
   // [tblReviewsView setSeparatorColor:[UIColor clearColor]];
    tblReviewsView.tableFooterView = [[UIView alloc]init];
    objSMReviewsXmlResultObject = [[SMReviewsXmlResultObject alloc] init];
    objSMReviewsXmlResultObject.arrmReviews = [[NSMutableArray alloc] init];
    arrayOfReviewsByModels = [[NSMutableArray alloc] init];
    [self getLoadReviews];

}
-(void)nextButtonDidClicked{

    SMReviewsDetailViewController *obj = [[SMReviewsDetailViewController alloc]initWithNibName:@"SMReviewsDetailViewController" bundle:nil];

    [self.navigationController pushViewController:obj animated:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    int modelReviewsSectionCount;
    
   // if(arrayOfReviewsByModels.count >0)
        modelReviewsSectionCount = (int)arrayOfReviewsByModels.count +1;
   // else
      //  modelReviewsSectionCount = (int)arrayOfReviewsByModels.count;
    
  //  return (objSMReviewsXmlResultObject.arrmReviews.count+ modelReviewsSectionCount + 1);
    
    if(objSMReviewsXmlResultObject.arrmReviews.count == 0 && arrayOfReviewsByModels.count ==0)
    {
        return (1+1+1+1);
    }
    else if (objSMReviewsXmlResultObject.arrmReviews.count > 0 && arrayOfReviewsByModels.count > 0)
    {
       return (objSMReviewsXmlResultObject.arrmReviews.count+ modelReviewsSectionCount + 1);
    }
    else
    {
        return (objSMReviewsXmlResultObject.arrmReviews.count+ modelReviewsSectionCount + 1 + 1);
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    /*if(indexPath.row-1 ==  objSMReviewsXmlResultObject.arrmReviews.count)
    {
        if(objSMReviewsXmlResultObject.arrmReviews.count == 0)
            return 0.0;
        
        return 37.0;
    }*/
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"SMReviewsTitleViewCell";
    static NSString *cellIdentifier1=@"SMReviewsViewCell";
    static NSString *cellIdentifier2=@"SMReviewsViewModelCell";
    static NSString *cellIdentifier3=@"SMReviewsNoArticlesCell";
    
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        SMReviewsTitleViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:self.strYear andWithSecondText:self.strFriendlyName forLabel:dynamicCell.lblNameHeader];
        dynamicCell.backgroundColor = [UIColor blackColor];
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        dynamicCell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
        cell = dynamicCell;
    }
    else
    {
        
        if([strOtherMakeName length] == 0)
            strOtherMakeName = @"Make?";
        if([strOtherModelName length] == 0)
            strOtherModelName = @"Model?";
        
        if(objSMReviewsXmlResultObject.arrmReviews.count >0 && objSMReviewsXmlResultObject.arrmReviews.count-1 >= indexPath.row-1)
        {
            
            SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            NSLog(@"inDExPath.Row = %ld",(long)indexPath.row);
            
        SMReviewsObject *cellObject = [objSMReviewsXmlResultObject.arrmReviews objectAtIndex:indexPath.row-1];
                
                dynamicCell.lblTitle.text = cellObject.strTitle;
                dynamicCell.lblDate.text = [NSString stringWithFormat:@"%@: %@",cellObject.strType,cellObject.strDate];
            
                dynamicCell.lblDecricription.text = cellObject.strBody;
                
                [dynamicCell.webViewDescription loadHTMLString:cellObject.strBody baseURL:nil];
            
                if (cellObject.arrmImages > 0)
                {
                    [dynamicCell.imgReview setImageWithURL:[NSURL URLWithString:[cellObject.arrmImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
               
                }
            dynamicCell.heightConstraintForWebview.constant = 70.0;
            [dynamicCell.webViewDescription setOpaque:NO];
            [[dynamicCell.webViewDescription scrollView] setContentInset:UIEdgeInsetsMake(-5,0, 0, 0)];
            cell = dynamicCell;
        }
       
        else if(arrayOfReviewsByModels.count > 0 && objSMReviewsXmlResultObject.arrmReviews.count == 0)
        {
            
            if(indexPath.row == 1)
            {
                   SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
                       dynamicCell.lblNoArticles.text = @"There are no model specific articles linked to this vehicle. Please see other articles below.";
                   
                    dynamicCell.backgroundColor = [UIColor blackColor];
                   dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
                   cell = dynamicCell;
               
            }
            else if(indexPath.row-2 ==  objSMReviewsXmlResultObject.arrmReviews.count)
              {
                   SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
                  
                  
                  [[SMAttributeStringFormatObject sharedService] setAttributedTextForVehicleNameWithFirstText:@"Other" andWithSecondText:[NSString stringWithFormat:@"%@ %@",strOtherMakeName,strOtherModelName] andWithThirdText:@"articles" forLabel:dynamicCell.lblOtherMakeModel];
                  
                //  dynamicCell.backgroundColor = [UIColor blackColor];
                  dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
                  dynamicCell.lblTopSeparator.hidden = YES;
                  dynamicCell.lblBottomSeparator.hidden = YES;
                  cell = dynamicCell;
              }
              else
              {
                  SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                  NSLog(@"indexPath.row = %ld",(long)indexPath.row);
                  NSLog(@"NumOfRowsinTable = %ld",(long)[tblReviewsView numberOfRowsInSection:0]);
                  SMReviewsObject *cellObject = [arrayOfReviewsByModels objectAtIndex:(indexPath.row -(objSMReviewsXmlResultObject.arrmReviews.count + 3))];
                  
                  dynamicCell.lblTitle.text = cellObject.strTitle;
                  dynamicCell.lblDate.text = [NSString stringWithFormat:@"%@: %@",cellObject.strType,cellObject.strDate];
                  dynamicCell.lblDecricription.text = cellObject.strBody;
                  
                  [dynamicCell.webViewDescription loadHTMLString:cellObject.strBody baseURL:nil];
                 
                  if (cellObject.arrmImages > 0)
                  {
                      [dynamicCell.imgReview setImageWithURL:[NSURL URLWithString:[cellObject.arrmImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
                      
                  }
                  dynamicCell.heightConstraintForWebview.constant = 74.0;
                  [dynamicCell.webViewDescription setOpaque:NO];
                  [[dynamicCell.webViewDescription scrollView] setContentInset:UIEdgeInsetsMake(-5,0, 0, 0)];
                  cell = dynamicCell;
                  
              }
            
        }
        else if(arrayOfReviewsByModels.count > 0 && objSMReviewsXmlResultObject.arrmReviews.count > 0)
        {
            if(indexPath.row == objSMReviewsXmlResultObject.arrmReviews.count + 1)
            {
                SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
                
                [[SMAttributeStringFormatObject sharedService] setAttributedTextForVehicleNameWithFirstText:@"Other" andWithSecondText:[NSString stringWithFormat:@"%@ %@",strOtherMakeName,strOtherModelName] andWithThirdText:@"articles" forLabel:dynamicCell.lblOtherMakeModel];
                
               // dynamicCell.backgroundColor = [UIColor blackColor];
                dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
                dynamicCell.lblTopSeparator.hidden = YES;
                dynamicCell.lblBottomSeparator.hidden = YES;
                cell = dynamicCell;
            }
            else
            {
                SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
                
                SMReviewsObject *cellObject = [arrayOfReviewsByModels objectAtIndex:(indexPath.row -(objSMReviewsXmlResultObject.arrmReviews.count + 2))];
                
                dynamicCell.lblTitle.text = cellObject.strTitle;
                dynamicCell.lblDate.text = [NSString stringWithFormat:@"%@: %@",cellObject.strType,cellObject.strDate];
                dynamicCell.lblDecricription.text = cellObject.strBody;
                
                [dynamicCell.webViewDescription loadHTMLString:cellObject.strBody baseURL:nil];
                
                if (cellObject.arrmImages > 0)
                {
                    [dynamicCell.imgReview setImageWithURL:[NSURL URLWithString:[cellObject.arrmImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
                    
                }
                dynamicCell.heightConstraintForWebview.constant = 74.0;
                [dynamicCell.webViewDescription setOpaque:NO];
                [[dynamicCell.webViewDescription scrollView] setContentInset:UIEdgeInsetsMake(-5,0, 0, 0)];
                cell = dynamicCell;
                
            }
        
        }
        else if(arrayOfReviewsByModels.count == 0 && objSMReviewsXmlResultObject.arrmReviews.count == 0)
        {
            
            if(indexPath.row == 1)
            {
                SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
                dynamicCell.lblNoArticles.text = @"There are no model specific articles linked to this vehicle. Please see other articles below.";
                
                dynamicCell.backgroundColor = [UIColor blackColor];
                dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell = dynamicCell;
                
            }
            else if(indexPath.row == 2)
            {
                SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
                
                [[SMAttributeStringFormatObject sharedService] setAttributedTextForVehicleNameWithFirstText:@"Other" andWithSecondText:[NSString stringWithFormat:@"%@ %@",strOtherMakeName,strOtherModelName] andWithThirdText:@"articles" forLabel:dynamicCell.lblOtherMakeModel];
                
                //dynamicCell.backgroundColor = [UIColor blackColor];
                dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
                dynamicCell.lblTopSeparator.hidden = YES;
                dynamicCell.lblBottomSeparator.hidden = YES;
                cell = dynamicCell;
            }
            else
            {
                SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
                dynamicCell.lblNoArticles.text = @"There are no other articles available.";
                dynamicCell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
                dynamicCell.backgroundColor = [UIColor blackColor];
                dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell = dynamicCell;
                
            }
            
        }
        else if (arrayOfReviewsByModels.count == 0)
        {
            
              if(indexPath.row == objSMReviewsXmlResultObject.arrmReviews.count + 1)
              {
                  SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier2];
                  
                  [[SMAttributeStringFormatObject sharedService] setAttributedTextForVehicleNameWithFirstText:@"Other" andWithSecondText:[NSString stringWithFormat:@"%@ %@",strOtherMakeName,strOtherModelName] andWithThirdText:@"articles" forLabel:dynamicCell.lblOtherMakeModel];
                  
                  //dynamicCell.backgroundColor = [UIColor blackColor];
                  dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
                  dynamicCell.lblTopSeparator.hidden = YES;
                  dynamicCell.lblBottomSeparator.hidden = YES;
                  cell = dynamicCell;
              }
            else
            {
            
            SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier3];
            dynamicCell.lblNoArticles.text = @"There are no other articles available.";
            dynamicCell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell = dynamicCell;
            }
        
        }
        
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selecTEdIndexpath = %ld",(long)indexPath.row);
    
    SMReviewsDetailViewController *synopsisReviewsDetailViewController;
    
    synopsisReviewsDetailViewController = [[SMReviewsDetailViewController alloc] initWithNibName:@"SMReviewsDetailViewController" bundle:nil];
    
    SMReviewsObject *objReviews;
    
    if(objSMReviewsXmlResultObject.arrmReviews.count >0 && objSMReviewsXmlResultObject.arrmReviews.count-1 >= indexPath.row-1)
    {
         objReviews = [objSMReviewsXmlResultObject.arrmReviews objectAtIndex:indexPath.row-1];
        objReviews.isFromVariantSelection = YES;
        synopsisReviewsDetailViewController.strFriendlyName = self.strFriendlyName;
        synopsisReviewsDetailViewController.strYear = self.strYear;
        synopsisReviewsDetailViewController.objReviews = objReviews;
        [self.navigationController pushViewController:synopsisReviewsDetailViewController animated:YES];
    }
    else if(arrayOfReviewsByModels.count > 0 && objSMReviewsXmlResultObject.arrmReviews.count == 0)
    {
        if(indexPath.row == 1 || indexPath.row == 0)
        {
        
        }
        else if(indexPath.row-2 ==  objSMReviewsXmlResultObject.arrmReviews.count)
        {
        
        }
        else
        {
            objReviews = [arrayOfReviewsByModels objectAtIndex:(indexPath.row -(objSMReviewsXmlResultObject.arrmReviews.count + 3))];
            
            objReviews.isFromVariantSelection = NO;
            
            synopsisReviewsDetailViewController.strFriendlyName = self.strFriendlyName;
            synopsisReviewsDetailViewController.strYear = self.strYear;
            synopsisReviewsDetailViewController.objReviews = objReviews;
            [self.navigationController pushViewController:synopsisReviewsDetailViewController animated:YES];
            
        }
    }
    else if(arrayOfReviewsByModels.count > 0 && objSMReviewsXmlResultObject.arrmReviews.count > 0)
    {
        if(indexPath.row == objSMReviewsXmlResultObject.arrmReviews.count + 1)
        {
        }
        else
        {
            objReviews = [arrayOfReviewsByModels objectAtIndex:(indexPath.row -(objSMReviewsXmlResultObject.arrmReviews.count + 2))];
            
            objReviews.isFromVariantSelection = NO;
            
            synopsisReviewsDetailViewController.strFriendlyName = self.strFriendlyName;
            synopsisReviewsDetailViewController.strYear = self.strYear;
            synopsisReviewsDetailViewController.objReviews = objReviews;
            [self.navigationController pushViewController:synopsisReviewsDetailViewController animated:YES];
        }
    }
    else if(arrayOfReviewsByModels.count == 0 && objSMReviewsXmlResultObject.arrmReviews.count == 0)
    {
    
    
    }
    
    else if (arrayOfReviewsByModels.count == 0)
    {
        
    }
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Web Services
-(void) getLoadReviews{
    
   NSMutableURLRequest *requestURL=[SMWebServices getReviewsWithUserHash:[SMGlobalClass sharedInstance].hashValue andVariantId:self.strVariantID];
    
    
  //  NSMutableURLRequest *requestURL=[SMWebServices getReviewsWithUserHash:[SMGlobalClass sharedInstance].hashValue andVariantId:@"23142"];
   
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSReviews *wsSMWSReviews = [[SMWSReviews alloc]init];
   
    [wsSMWSReviews responseForWebServiceForReuest:requestURL
                                            response:^(SMReviewsXmlResultObject *objSMReviewsXmlResultObjectWS) {
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [objSMReviewsXmlResultObject.arrmReviews addObjectsFromArray:objSMReviewsXmlResultObjectWS.arrmReviews];
                                                NSLog(@"ArrayFromVariant = %lu",(unsigned long)objSMReviewsXmlResultObject.arrmReviews.count);
                                                [self getLoadReviewsByModel];
                                                //[self hideProgressHUD];
                                                
                                                
                                            }
                                            andError: ^(NSError *error) {
                                                SMAlert(@"Error", error.localizedDescription);
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [self hideProgressHUD];
                                            }
     ];
    
}

-(void) getLoadReviewsByModel{
    
    NSMutableURLRequest *requestURL=[SMWebServices getReviewsForModelIDExcludeVariantWithUserHash:[SMGlobalClass sharedInstance].hashValue andModelID:self.strModelID.intValue andVariantId:self.strVariantID.intValue];
    
   // NSMutableURLRequest *requestURL=[SMWebServices getReviewsForModelIDExcludeVariantWithUserHash:[SMGlobalClass sharedInstance].hashValue andModelID:43 andVariantId:9601];
    
       //objSMReviewsXmlResultObject = [[SMReviewsXmlResultObject alloc] init];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSReviews *wsSMWSReviews = [[SMWSReviews alloc]init];
    
    [wsSMWSReviews responseForWebServiceForReuest:requestURL
                                         response:^(SMReviewsXmlResultObject *objSMReviewsXmlResultObjectWS) {
                                             [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                             [self hideProgressHUD];
                                             
                                             strOtherMakeName = objSMReviewsXmlResultObjectWS.strOtherMakeName;
                                             strOtherModelName = objSMReviewsXmlResultObjectWS.strOtherModelName;                                              [arrayOfReviewsByModels addObjectsFromArray:objSMReviewsXmlResultObjectWS.arrmReviews];
                                              NSLog(@"ArrayFromModel1 = %lu",(unsigned long)objSMReviewsXmlResultObjectWS.arrmReviews.count);
                                              NSLog(@"ArrayFromModel2 = %lu",(unsigned long)objSMReviewsXmlResultObject.arrmReviews.count);
                                             
                                             if (arrayOfReviewsByModels.count == 0 && objSMReviewsXmlResultObject.arrmReviews.count == 0) {
                                                // [SMAttributeStringFormatObject showAlertWebServicewithMessage:KNorecordsFousnt ForViewController:self];
                                                 [self hideProgressHUD];
                                             }
                                             else{
                                                 [tblReviewsView reloadData];
                                                 [tblReviewsView setNeedsLayout];
                                                 [tblReviewsView layoutIfNeeded];
                                                 [tblReviewsView reloadData];
                                                 [self hideProgressHUD];
                                             }
                                             
                                         }
                                         andError: ^(NSError *error) {
                                             SMAlert(@"Error", error.localizedDescription);
                                             [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                             [self hideProgressHUD];
                                            
                                         }
     
     
     ];
    //[self hideProgressHUD];
    
}
-(void) addArray{
    
}
-(void) addingProgressHUD
{
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
}

-(void) hideProgressHUD
{
    [HUD hide:YES];
}

-(void)setAttributeStringOnLabel:(UILabel *)lbl andRangeOfString:(NSString*)string{
    
   
    NSRange range1 = [lbl.text rangeOfString:string];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:lbl.text];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:14.0f]}range:range1];
    }
    else
    {
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:14.0f]}range:range1];
    }
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_NAME_BOLD size:14.0f]}range:range1];
   lbl.attributedText = attributedText;
}

@end
