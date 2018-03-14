//
//  SMReviewsDetailViewController.m
//  Smart Manager
//
//  Created by Sandeep on 24/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMReviewsDetailViewController.h"
#import "SMCustomColor.h"
#import "SMSellCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "FGalleryViewController.h"
#import "SMAppDelegate.h"
#import "SMReviewsViewCell.h"
#import "SMWSReviews.h"
@interface SMReviewsDetailViewController ()<UIWebViewDelegate,FGalleryViewControllerDelegate,UIScrollViewDelegate>
{
     UIWebView *webViewDescription;
     FGalleryViewController  *networkGallery;
}
@end

@implementation SMReviewsDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Review"];

    [tblReviewDetail registerNib:[UINib nibWithNibName: @"SMReviewCollectionTableViewCell" bundle:nil] forCellReuseIdentifier:@"SMReviewCollectionTableViewCell"];

    [tblReviewDetail registerNib:[UINib nibWithNibName: @"SMReviewTitleViewCell" bundle:nil] forCellReuseIdentifier:@"SMReviewTitleViewCell"];
    
    [self addingProgressHUD];
    
    [tblReviewDetail registerNib:[UINib nibWithNibName: @"SMReviewsViewCell" bundle:nil] forCellReuseIdentifier:@"SMReviewsViewCell"];
    tblReviewDetail.estimatedRowHeight = 164.0;
    tblReviewDetail.rowHeight = UITableViewAutomaticDimension;
    tblReviewDetail.tableFooterView = [[UIView alloc]init];
    webViewDescription = [[UIWebView alloc ] initWithFrame:CGRectMake(150.0f,0.0f,self.view.frame.size.width, 300.0f)];
    webViewDescription.delegate = self;
    webViewDescription.scrollView.scrollEnabled           = YES;
    webViewDescription.scrollView.bounces                 = NO;
   
    [webViewDescription setBackgroundColor:[UIColor blackColor]];
    [webViewDescription setOpaque:NO];
    [[webViewDescription scrollView] setContentInset:UIEdgeInsetsMake(-5, -8, 0, 0)];
    //webViewDescription.scalesPageToFit = YES;
    
    if(!self.objReviews.isFromVariantSelection)
    [self getLoadReviewsWithReviewID:self.objReviews.reviewID];
    else
    {
        tblReviewDetail.dataSource = self;
        tblReviewDetail.delegate = self;
       // [webViewDescription loadHTMLString:self.objReviews.strBody baseURL:nil];
        [webViewDescription loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor=\"#000000\" text=\"#FFFFFF\">%@</body></html>", self.objReviews.strBody] baseURL:nil];
        
        
    }


}




//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    webViewDescription = [[UIWebView alloc ] initWithFrame:CGRectMake(150.0f,0.0f,self.view.frame.size.width, 300.0f)];
//    webViewDescription.delegate = self;
//    webViewDescription.scrollView.scrollEnabled           = NO;
//    webViewDescription.scrollView.bounces                 = NO;
//    [webViewDescription loadHTMLString:self.objReviews.strBody baseURL:nil];
//    [webViewDescription setBackgroundColor:[UIColor blackColor]];
//    [webViewDescription setOpaque:NO];
//    [[webViewDescription scrollView] setContentInset:UIEdgeInsetsMake(-5, -8, 0, 0)];
//    [tblReviewDetail reloadData];
//
//}
-(void)nextButtonDidClicked{
    SMVINHistoryViewController *obj = [[SMVINHistoryViewController alloc]initWithNibName:@"SMVINHistoryViewController" bundle:nil];
    [self.navigationController pushViewController:obj animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.row == 2) {
          return webViewDescription.frame.size.height;
    }
    return UITableViewAutomaticDimension;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"SMReviewTitleViewCell";
    static NSString *cellIdentifier1=@"SMReviewCollectionTableViewCell";
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        SMReviewTitleViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        dynamicCell.backgroundColor = [UIColor blackColor];
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        dynamicCell.backgroundColor = [UIColor blackColor];
        [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:self.strYear andWithSecondText:self.strFriendlyName forLabel:dynamicCell.titleLabel];
        cell = dynamicCell;
    }
    else if(indexPath.row == 1){
        SMReviewCollectionTableViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        dynamicCell.backgroundColor = [UIColor blackColor];
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        dynamicCell.backgroundColor = [UIColor blackColor];
        dynamicCell.collectionViewPhotos.delegate = self;
        dynamicCell.collectionViewPhotos.dataSource = self;
        
        
        if(!self.objReviews.isFromVariantSelection)
        {
            if (reviewDetailObj.arrmImages.count == 0) {
                dynamicCell.collectionConstraitHeight.constant = 0.0f;
            }
            else
            {
                [dynamicCell.collectionViewPhotos registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMSellCollectionCell" : @"SMSellCollectionCell_iPad" bundle:nil]            forCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier"];
                dynamicCell.collectionViewPhotos.delegate = self;
                dynamicCell.collectionViewPhotos.dataSource = self;
                dynamicCell.collectionViewPhotos.backgroundColor = [UIColor clearColor];
                UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[dynamicCell.collectionViewPhotos collectionViewLayout];
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                
            }
            dynamicCell.vechiclesNameLabel.text = reviewDetailObj.strTitle;
            dynamicCell.vechiclesShotDescriptionLabel.text = [NSString stringWithFormat:@"%@: %@ | %@ | %@",reviewDetailObj.strType,reviewDetailObj.strDate,reviewDetailObj.strAuthor,reviewDetailObj.strSource];
        }
        else
        {
            if (self.objReviews.arrmImages.count == 0) {
                dynamicCell.collectionConstraitHeight.constant = 0.0f;
            }
            else
            {
                [dynamicCell.collectionViewPhotos registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMSellCollectionCell" : @"SMSellCollectionCell_iPad" bundle:nil]            forCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier"];
                dynamicCell.collectionViewPhotos.delegate = self;
                dynamicCell.collectionViewPhotos.dataSource = self;
                dynamicCell.collectionViewPhotos.backgroundColor = [UIColor clearColor];
                UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)[dynamicCell.collectionViewPhotos collectionViewLayout];
                layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                
            }
            dynamicCell.vechiclesNameLabel.text = self.objReviews.strTitle;
            dynamicCell.vechiclesShotDescriptionLabel.text = [NSString stringWithFormat:@"%@: %@ | %@ | %@",self.objReviews.strType,self.objReviews.strDate,self.objReviews.strAuthor,self.objReviews.strSource];
        }
          cell = dynamicCell;
    }
    else if(indexPath.row == 2){
        SMReviewsViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:@"SMReviewsViewCell"];

        dynamicCell.backgroundColor = [UIColor blackColor];
        dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
        dynamicCell.backgroundColor = [UIColor blackColor];
        [dynamicCell addSubview:webViewDescription];
        cell.backgroundColor = [UIColor blackColor];
        CGRect frame = CGRectMake(8.0f,0.0f,self.view.frame.size.width - 16.0f, webViewDescription.frame.size.height);
        webViewDescription.frame = frame;
     
        cell = dynamicCell;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WEB VIEW Delegate
-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType
{
    return YES;
}


-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect newBounds;
    CGFloat fRowHeight = [[webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"document.body.scrollHeight;"]] floatValue]+12;
    newBounds = webView.bounds;
    newBounds.size.height = webView.scrollView.contentSize.height;
    webView.bounds = newBounds;
    webView.frame = CGRectMake(webView.bounds.origin.x, webView.bounds.origin.y, webView.bounds.size.width, fRowHeight);
    webView.scalesPageToFit = YES;
    webView.contentMode = UIViewContentModeScaleAspectFit;
    webView.scrollView.delegate = self; // set delegate method of UISrollView
    webView.scrollView.maximumZoomScale = 20; // set as you want.
    webView.scrollView.minimumZoomScale = 1; // set as you want.
    [tblReviewDetail reloadData];
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    webViewDescription.scrollView.maximumZoomScale = 20; // set similar to previous.
}

#pragma mark - UICollectionView Delegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(!self.objReviews.isFromVariantSelection)
    {
        if (reviewDetailObj.arrmImages.count > 3) {
            return 3;
        }
        return reviewDetailObj.arrmImages.count;
    }
    else
    {
        if (self.objReviews.arrmImages.count > 3) {
            return 3;
        }
        return self.objReviews.arrmImages.count;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(80.0f,70.0f);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMSellCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier" forIndexPath:indexPath];
    
    if(!self.objReviews.isFromVariantSelection)
    {
        [cell.imageVehicle   setImageWithURL:[NSURL URLWithString:[reviewDetailObj.arrmImages objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    }
    else
    {
        [cell.imageVehicle   setImageWithURL:[NSURL URLWithString:[self.objReviews.arrmImages objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    }
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
                       networkGallery.startingIndex = indexPath.row;
                       SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
                       appdelegate.isPresented =  YES;
                       [self.navigationController pushViewController:networkGallery animated:YES];
                   });
}


#pragma mark - Web Services
-(void) getLoadReviewsWithReviewID:(int)reviewID
{
    NSMutableURLRequest *requestURL=[SMWebServices getReviewDetailsWithUserHash:[SMGlobalClass sharedInstance].hashValue andReviewID:reviewID];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSReviews *wsSMWSReviews = [[SMWSReviews alloc]init];
    
    [wsSMWSReviews responseForWebServiceForReuest:requestURL
                                         response:^(SMReviewsXmlResultObject *objSMReviewsXmlResultObjectWS) {
                                             [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                             
                                             
                                             {
                                                 reviewDetailObj = (SMReviewsObject*)[objSMReviewsXmlResultObjectWS.arrmReviews objectAtIndex:0];
                                                 
                                                 //[webViewDescription loadHTMLString:reviewDetailObj.strBody baseURL:nil];
                                                 
                                                 [webViewDescription loadHTMLString:[NSString stringWithFormat:@"<html><body bgcolor=\"#000000\" text=\"#FFFFFF\">%@</body></html>", reviewDetailObj.strBody] baseURL:nil];
                                                 
                                                 tblReviewDetail.dataSource = self;
                                                 tblReviewDetail.delegate = self;
                                                 [tblReviewDetail reloadData];
                                                 [HUD hide:YES];
                                             }
                                             
                                             
                                         }
                                         andError: ^(NSError *error) {
                                             SMAlert(@"Error", error.localizedDescription);
                                             [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                             [HUD hide:YES];
                                         }
     ];
    
}

-(void) addingProgressHUD
{
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
    
}


#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    if(gallery == networkGallery)
    {
        
        /*if (self.objReviews.arrmImages.count > 3) {
            return 3;
        }*/
        if(!self.objReviews.isFromVariantSelection)
            return (int)reviewDetailObj.arrmImages.count;
        else
           return (int)self.objReviews.arrmImages.count;
    }
    else
        return 0;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
       return @"";
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    if(!self.objReviews.isFromVariantSelection)
        return [reviewDetailObj.arrmImages objectAtIndex:index];
    else
       return [self.objReviews.arrmImages objectAtIndex:index];
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
