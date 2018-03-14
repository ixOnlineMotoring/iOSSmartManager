//
//  SMTradeSoldViewController.m
//  Smart Manager
//
//  Created by Sandeep Parmar on 25/11/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMTradeSoldViewController.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMCustomColor.h"
#import "SMTradeDetailSlider.h"
#import "UIImageView+WebCache.h"
#import "SMDetailTableViewCell.h"
#import "SMCommonClassMethods.h"
#import "UIBAlertView.h"
#import "SMAppDelegate.h"
#import "SMCustomDynamicCell.h"
#import "FGalleryViewController.h"

@interface SMTradeSoldViewController ()<FGalleryViewControllerDelegate>
{
    FGalleryViewController      *   networkGallery;
}
@end

@implementation SMTradeSoldViewController

UIImageView *imgViewVehicle;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self addingProgressHUD];
    isSeller = NO;
    isLoadVehicleService = NO;
    uploadRatingCount = 0;
    arrayRateBuyerList = [[NSMutableArray alloc]init];
    arrayListSellerRating = [[NSMutableArray alloc]init];
    
    [tableSold registerNib:[UINib nibWithNibName:@"SMTradeSoldCell" bundle:nil] forCellReuseIdentifier:@"TradeSoldCell"];
    
   // [tableSold registerNib:[UINib nibWithNibName:@"SMTradeSoldCell" bundle:nil] forCellReuseIdentifier:@"Cell"];

    if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
    {
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Won"];
        [self registerNib];
    }
    else
    {
        self.navigationItem.titleView = [SMCustomColor setTitle:@"Sold"];

        // [self wbServiceForGetListBuyerRatingQuestions];
    }
    
    if([self.vehicleObj.strLocation length] == 0)
        self.vehicleObj.strLocation = @"Location?";
    
    [self loadingVechicleDetails];
    

    isMessageSectionExpanded = NO;
    isRateBuyerSectionExpanded = NO;
    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        tableSold.layoutMargins = UIEdgeInsetsZero;
        tableSold.preservesSuperviewLayoutMargins = NO;
    }
    arrayFullImages = [[NSMutableArray alloc]init];


}

#pragma mark - WebService Call

-(void)loadingVechicleDetails
{
    NSLog(@"ssstrUsedVehicleStockID = %d",self.vehicleObj.strUsedVehicleStockID.intValue);
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    isLoadVehicleService = YES;

    NSMutableURLRequest *requestURL = [SMWebServices gettingDetailsVehicleImages:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleId:self.vehicleObj.strUsedVehicleStockID.intValue];

    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];

    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];

         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
             [self hideProgressHUD];
             return;
         }
         else
         {
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}
-(void)webServiceForFetchingQuestionsRatingForSeller
{

    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    isLoadVehicleService = NO;
    [arrayListSellerRating removeAllObjects];

     NSMutableURLRequest *requestURL=[SMWebServices fetchBackTheSellerRatingQuestionsWithUserHash:[SMGlobalClass sharedInstance].hashValue WithBuyerClientID:OwnerID andStockID:self.vehicleObj.strUsedVehicleStockID.intValue andOfferID:self.vehicleObj.strOfferID.intValue andRatingClientID:[SMGlobalClass sharedInstance].strClientID.intValue andRatingMemberID:[SMGlobalClass sharedInstance].strCoreMemberID.intValue];

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
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}

-(void)webServiceForFetchingQuestionsRatingForBuyer
{
    
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    isLoadVehicleService = NO;
    [arrayListSellerRating removeAllObjects];
    
  //  NSMutableURLRequest *requestURL=[SMWebServices fetchBackTheSellerRatingQuestionsWithUserHash:[SMGlobalClass sharedInstance].hashValue WithBuyerClientID:OwnerID andStockID:self.vehicleObj.strUsedVehicleStockID.intValue andOfferID:self.vehicleObj.strOfferID.intValue andRatingClientID:[SMGlobalClass sharedInstance].strClientID.intValue andRatingMemberID:[SMGlobalClass sharedInstance].strCoreMemberID.intValue];
    
     NSMutableURLRequest *requestURL=[SMWebServices fetchBackTheBuyerRatingQuestionsWithUserHash:[SMGlobalClass sharedInstance].hashValue WithBuyerClientID:OwnerID andStockID:self.vehicleObj.strUsedVehicleStockID.intValue andOfferID:self.vehicleObj.strOfferID.intValue andRatingClientID:[SMGlobalClass sharedInstance].strClientID.intValue andRatingMemberID:[SMGlobalClass sharedInstance].strCoreMemberID.intValue];
    
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
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}


-(void)webServiceForMessagesList
{
    [HUD show:YES];
    [HUD setLabelText:KLoaderText];

    NSMutableURLRequest *requestURL = [SMWebServices listMessagesForVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:self.vehicleObj.strUsedVehicleStockID.intValue];

    //  NSMutableURLRequest *requestURL = [SMWebServices listMessagesForVehicleWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:self.vehicleObj.strUsedVehicleStockID.intValue];


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
             arrayOfMessages = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData:data];
             NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];

             NSLog(@"%@",newStr);
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                   withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];

   /* [labelStockNumber      setText:@"Stock Number"];
    [labelVinNumber setText:@"VIN?"];
    [labelRegisterNumber setText:@"Register Number"];
    [labelComment setText:@"No Comment(s) LoadedNo Comment(s) LoadedNo Comment(s) LoadedNo Comment(s) LoadedNo Comment(s) Loaded"];
    [labelExtras setText:@"No Extra(s) Loaded.No Extra(s)No Extra(s) Loaded.No Extra(s)No Extra(s) Loaded.No Extra(s) "];
    [lblOwnerName setText:[NSString stringWithFormat:@"Seller: %@, %@",@"NAME: Bruce",@"Location: South Africa"]];

    [labelComment setFrame:CGRectMake(labelComment.frame.origin.x, labelComment.frame.origin.y,labelComment.frame.size.width, [self heightOfTextForString:labelComment.text andFont:labelComment.font maxSize:CGSizeMake(labelComment.frame.size.width, 500.0f)])];

    [labelExtrasHeading setFrame:CGRectMake(labelExtrasHeading.frame.origin.x,labelComment.frame.origin.y + labelComment.frame.size.height+5,labelExtrasHeading.frame.size.width,[self heightOfTextForString:labelExtrasHeading.text andFont:labelExtrasHeading.font maxSize:CGSizeMake(labelExtrasHeading.frame.size.width, 500.0f)])];

    [labelExtras setFrame:CGRectMake(labelExtras.frame.origin.x,labelExtrasHeading.frame.origin.y + labelExtrasHeading.frame.size.height+5,labelExtras.frame.size.width,[self heightOfTextForString:labelExtras.text andFont:labelExtras.font maxSize:CGSizeMake(labelExtras.frame.size.width, 500.0f)])];


    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self setTableVehicleListTableFooterView:labelExtras.frame.size.height + labelComment.frame.size.height + 150];
    }
    else
    {
        [self setTableVehicleListTableFooterView:labelExtras.frame.size.height + labelComment.frame.size.height + 240];
    }*/

    
}

- (IBAction)buttonImageClickableDidPressed:(id)sender
{
    if ([arrayFullImages count]>0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{

            networkGallery               = [[FGalleryViewController alloc] initWithPhotoSource:self];
            networkGallery.startingIndex = 0;
            SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
            appdelegate.isPresented =  YES;
            [self.navigationController pushViewController:networkGallery animated:YES];
        });
    }
}

-(void) registerNib
{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        [viewCollection registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil]           forCellWithReuseIdentifier:@"Cell"];


    }
    else
    {
        [viewCollection registerNib:[UINib nibWithNibName:@"CollectionCell_iPad" bundle:nil]           forCellWithReuseIdentifier:@"Cell"];

    }
}

-(void)cellForFirstRow:(UITableViewCell*)dynamicCell
{

    /* self.vehicleObj.strVehicleYear = @"2009";
     self.vehicleObj.strVehicleName = @"Mercedes BenZ C200K";
     self.vehicleObj.strVehicleMileage = @"50934 Km";
     self.vehicleObj.strVehicleColor = @"BLACK";
     self.vehicleObj.strLocation = @"Durban";
     self.vehicleObj.strOfferStatus = @"Sold";
     self.vehicleObj.strWinningBid = @"R173 000";
     self.vehicleObj.strMyHighest = @"50000";
     self.vehicleObj.strTotalHighest = @"45000000";
     self.vehicleObj.strVehicleTradePrice = @"55 000";
     self.vehicleObj.strClientName = @"Hoopers Volkswagen";
     self.vehicleObj.strClientName = @"Hoopers Volkswagen";
     self.vehicleObj.strContactperson = @"Daver Johnson";
     self.vehicleObj.strSoldDate = @"18 Sep 2015 15:53";*/



    UILabel *lblVehicleName;
    UILabel *lblVehicleDetails1;
    UILabel *lblVehicleDetails2;
    UILabel *lblWinBeatValue;
    UILabel *lblClientName;
    UILabel *lblContactPerson;

    
    UIButton *btnVehicleBigImage;
    UIImageView *imgViewBuyNow;

    // ------------------------------------------------------------------------------------

    CGFloat heightName = 0.0f;

    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",self.vehicleObj.strVehicleYear,self.vehicleObj.strVehicleName];

    heightName = [self heightForText:strVehicleNameHeight];

    // ------------------------------------------------------------------------------------

    CGFloat heightDetails1 = 0.0f;

    NSString *mileageStr1 = [NSString stringWithFormat:@"%@%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:self.vehicleObj.strVehicleMileage],self.vehicleObj.strVehicleColor];


    NSString *strDetails1Height = [NSString stringWithFormat:@"%@ | %@",mileageStr1,self.vehicleObj.strVehicleColor];

    heightDetails1 = [self heightForText:strDetails1Height];

    // ------------------------------------------------------------------------------------

    CGFloat heightDetails2 = 0.0f;

    NSString *strDetails2Height = [NSString stringWithFormat:@"%@ | %@",self.vehicleObj.strLocation,[NSString stringWithFormat:@"Exp. %@",self.vehicleObj.strVehicleType]];

    heightDetails2 = [self heightForText:strDetails2Height];

    // ------------------------------------------------------------------------------------


    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        imgViewVehicle = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 10.0, 120.0, 110.0)];
        [imgViewVehicle setContentMode:UIViewContentModeScaleAspectFill];
         imgViewVehicle.clipsToBounds = YES;
        btnVehicleBigImage = [[UIButton alloc] initWithFrame:CGRectMake(5.0, 10.0, 120.0, 110.0)];
        [btnVehicleBigImage addTarget:self action:@selector(buttonImageClickableDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        imgViewBuyNow = [[UIImageView alloc] initWithFrame:CGRectMake(5.0, 5.0, 38.0, 36.0)];


        lblVehicleName = [[UILabel alloc] initWithFrame:CGRectMake(132,5,187,heightName)];
        lblVehicleDetails1 = [[UILabel alloc] initWithFrame:CGRectMake(132,lblVehicleName.frame.origin.y + lblVehicleName.frame.size.height + 2.0,187,heightDetails1)];
        lblVehicleDetails2 = [[UILabel alloc] initWithFrame:CGRectMake(132,lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height + 2.0,187,heightDetails2)];

        lblWinBeatValue = [[UILabel alloc] initWithFrame:CGRectMake(132,lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height + 2.0,187,21)];

        if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
        {
            lblClientName = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
            lblContactPerson = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];

        }
        else
        {
            lblClientName = [[UILabel alloc] initWithFrame:CGRectMake(imgViewVehicle.frame.origin.x+imgViewVehicle.frame.size.width - 75,imgViewVehicle.frame.origin.y + imgViewVehicle.frame.size.height + 5.0,290,21)];

            lblContactPerson = [[UILabel alloc] initWithFrame:CGRectMake(128,lblClientName.frame.origin.y + lblClientName.frame.size.height + 3.0,250,21)];

        }
        lblVehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
        lblVehicleDetails1.textColor = [UIColor whiteColor];
        lblVehicleDetails2.textColor = [UIColor whiteColor];
        lblWinBeatValue.textColor = [UIColor whiteColor];
        lblClientName.textColor = [UIColor whiteColor];
        lblContactPerson.textColor = [UIColor whiteColor];

        lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        lblWinBeatValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        lblClientName.font =[UIFont fontWithName:FONT_NAME_BOLD size:14];
        lblContactPerson.font =[UIFont fontWithName:FONT_NAME_BOLD size:11];

    }
    else
    {
        imgViewVehicle = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 6.0, 180.0, 135.0)];
        [imgViewVehicle setContentMode:UIViewContentModeScaleAspectFill];
         imgViewVehicle.clipsToBounds = YES;
        btnVehicleBigImage = [[UIButton alloc] initWithFrame:CGRectMake(2.0, 6.0, 180.0, 135.0)];
        [btnVehicleBigImage addTarget:self action:@selector(buttonImageClickableDidPressed:) forControlEvents:UIControlEventTouchUpInside];
        imgViewBuyNow = [[UIImageView alloc] initWithFrame:CGRectMake(2.0, 6.0, 180.0, 135.0)];

        lblVehicleName = [[UILabel alloc] initWithFrame:CGRectMake(195,2,570,heightName)];
        lblVehicleDetails1 = [[UILabel alloc] initWithFrame:CGRectMake(195,lblVehicleName.frame.origin.y + lblVehicleName.frame.size.height + 5.0,570,heightDetails1)];
        lblVehicleDetails2 = [[UILabel alloc] initWithFrame:CGRectMake(195,lblVehicleDetails1.frame.origin.y + lblVehicleDetails1.frame.size.height + 5.0,570,heightDetails2)];

        lblWinBeatValue = [[UILabel alloc] initWithFrame:CGRectMake(195,lblVehicleDetails2.frame.origin.y + lblVehicleDetails2.frame.size.height + 3.0,250,25)];


        if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
        {
            lblClientName = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
            lblContactPerson = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];

        }
        else
        {
            lblClientName = [[UILabel alloc] initWithFrame:CGRectMake(imgViewVehicle.frame.origin.x+imgViewVehicle.frame.size.width - 75,imgViewVehicle.frame.origin.y + imgViewVehicle.frame.size.height + 5.0,350,25)];

            lblContactPerson = [[UILabel alloc] initWithFrame:CGRectMake(190,lblClientName.frame.origin.y + lblClientName.frame.size.height + 3.0,350,25)];

        }
        lblVehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
        lblVehicleDetails1.textColor = [UIColor whiteColor];
        lblVehicleDetails2.textColor = [UIColor whiteColor];
        lblWinBeatValue.textColor = [UIColor whiteColor];
        lblClientName.textColor = [UIColor whiteColor];
        lblContactPerson.textColor = [UIColor whiteColor];

        lblVehicleName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblVehicleDetails1.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblVehicleDetails2.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblWinBeatValue.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblClientName.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        lblContactPerson.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
    }
    if (arrayFullImages.count == 0) {
        [imgViewVehicle  setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    }else{
        [imgViewVehicle  setImageWithURL:[NSURL URLWithString:[arrayFullImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    }

    lblVehicleName.textColor = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];
    lblVehicleDetails1.textColor = [UIColor whiteColor];
    lblVehicleDetails2.textColor = [UIColor whiteColor];
    lblWinBeatValue.textColor = [UIColor whiteColor];
    lblClientName.textColor = [UIColor whiteColor];
    lblClientName.textColor = [UIColor whiteColor];

    //lblMyBidValue.textColor = [UIColor whiteColor];
    //rowSeparator.backgroundColor = [UIColor lightGrayColor];



    imgViewVehicle.tag = 101;
    lblVehicleName.tag = 102;
    lblVehicleDetails1.tag = 103;
    lblVehicleDetails2.tag = 104;
    //lblMyBidValue.tag = 106;
    lblWinBeatValue.tag = 107;
    imgViewBuyNow.tag = 108;




    if([self.vehicleObj.strVehicleYear length]>0 && [self.vehicleObj.strVehicleName length] )
    {
        [self setAttributedTextForVehicleDetailsWithFirstText:[NSString stringWithFormat:@"%@ ",self.vehicleObj.strVehicleYear] andWithSecondText:self.vehicleObj.strVehicleName forLabel:lblVehicleName];
    }

    lblVehicleDetails1.text = [NSString stringWithFormat:@"%@ | %@",self.vehicleObj.strVehicleMileage,self.vehicleObj.strVehicleColor];

    if([self.vehicleObj.strVehicleType length] == 0 || [self.vehicleObj.strVehicleType isEqualToString:@"(null)"])
    {
        self.vehicleObj.strVehicleType = @"Type?";
    }
    
    if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
    {
        
        [self setAttributedTextWithFirstText:self.vehicleObj.strLocation andWithSecondText:@" | " andWithThirdText:@"Won" andWithColor:[UIColor greenColor] forLabel:lblVehicleDetails2];
         [self setAttributedTextWithFirstText:@"Winning Bid" andWithSecondText:@": " andWithThirdText:self.vehicleObj.strOfferAmount andWithColor:[UIColor colorWithRed:135.0/255.0 green:67.0/255.0 blue:198.0/255.0 alpha:1.0] forLabel:lblWinBeatValue];
    }
    else
    {
        NSLog(@"strVehicleType = %@",self.vehicleObj.strVehicleType);
        
        // WinningPriceIntegerValue =self.vehicleObj.strWinningBid.intValue;
        
       // WinningPriceValue = [NSString stringWithFormat:@"%d",WinningPriceIntegerValue];
        
        [self setAttributedTextWithFirstText:self.vehicleObj.strLocation andWithSecondText:@" | " andWithThirdText:@"Sold" andWithColor:[UIColor redColor] forLabel:lblVehicleDetails2];
        
         [self setAttributedTextWithFirstText:@"Winning Bid" andWithSecondText:@": " andWithThirdText:self.vehicleObj.strWinningBid andWithColor:[UIColor colorWithRed:135.0/255.0 green:67.0/255.0 blue:198.0/255.0 alpha:1.0] forLabel:lblWinBeatValue];
    }

    
    

   

    if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
    {

    }
    else
    {
        lblClientName.text = [NSString stringWithFormat:@"Bought by: %@",self.vehicleObj.strClientName];

        NSString *dateString = [self returnTheExpectedStringForString:self.vehicleObj.strSoldDate];
        
       dateString =[[SMCommonClassMethods shareCommonClassManager] customDateFormatFunctionWithDate:dateString withFormat:3];
       

        lblContactPerson.text = [NSString stringWithFormat:@"%@ | %@",self.vehicleObj.strUser, dateString];
    }
    self.vehicleObj.strVehicleMileageType = [NSString stringWithFormat:@"%@%@",[[self.vehicleObj.strVehicleMileageType substringToIndex:[self.vehicleObj.strVehicleMileageType length] - (self.vehicleObj.strVehicleMileageType >0)]capitalizedString],[[self.vehicleObj.strVehicleMileageType substringFromIndex:[self.vehicleObj.strVehicleMileageType length] -1] lowercaseString]];

   



    // if MyHighestBid is greater than or eqaul to HightestBid then it should be winning or elase it should be beaten


    // making thumb image big by replacing

    /*if ([self.vehicleObj.arrayVehicleImages count]>0)
    {
        self.vehicleObj.strVehicleImageURL = [NSString stringWithFormat:@"%@%@",[[self.vehicleObj.arrayVehicleImages objectAtIndex:0]  substringToIndex:[[self.vehicleObj.arrayVehicleImages objectAtIndex:0] length] -3],@"200"];
    }


    [imgViewVehicle setImageWithURL:[NSURL URLWithString:self.vehicleObj.strVehicleImageURL] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];*/

    // showing BuyItNow Banner image if vehcile is having buyItNow

    self.vehicleObj.isBuyItNow == YES ?[imgViewBuyNow setHidden:NO]:[imgViewBuyNow setHidden:YES];
     imgViewBuyNow.image = [UIImage imageNamed:@"buynow"];

    lblVehicleName.tag = 500;
    lblVehicleDetails1.tag = 501;
    lblVehicleDetails2.tag = 502;
    lblWinBeatValue.tag = 503;
    lblClientName.tag = 504;
    lblContactPerson.tag = 505;

    imgViewVehicle.tag = 506;
    btnVehicleBigImage.tag = 507;
    imgViewBuyNow.tag = 508;

    [dynamicCell.contentView addSubview:imgViewVehicle];
    [dynamicCell.contentView addSubview:btnVehicleBigImage];
    [dynamicCell.contentView addSubview:lblVehicleName];
    [dynamicCell.contentView addSubview:lblVehicleDetails1];
    [dynamicCell.contentView addSubview:lblVehicleDetails2];
    [dynamicCell.contentView addSubview:lblClientName];
    [dynamicCell.contentView addSubview:lblContactPerson];
    [dynamicCell.contentView addSubview:imgViewBuyNow];
    [dynamicCell.contentView addSubview:lblWinBeatValue];

    lblVehicleName.numberOfLines = 0;
    [lblVehicleName sizeToFit];

    lblVehicleDetails1.numberOfLines = 0;
    [lblVehicleDetails1 sizeToFit];


    lblVehicleDetails2.numberOfLines = 0;


    lblVehicleName.backgroundColor = [UIColor blackColor];
    lblVehicleDetails1.backgroundColor = [UIColor blackColor];
    lblVehicleDetails2.backgroundColor = [UIColor blackColor];

    lblWinBeatValue.backgroundColor = [UIColor blackColor];

    if ( [[[UIDevice currentDevice] systemVersion] integerValue] > 7)
    {
        dynamicCell.layoutMargins = UIEdgeInsetsZero;
        dynamicCell.preservesSuperviewLayoutMargins = NO;
    }
    dynamicCell.backgroundColor = [UIColor blackColor];


}

-(void) setTableVehicleListTableFooterView:(CGFloat) newHeight
{
    // setting footer height
    CGRect FooterFrame                       = tableSold.tableFooterView.frame;
    FooterFrame.size.height                  = newHeight;
    viwFooterComments.frame                    = FooterFrame;
    tableSold.tableFooterView                = viwFooterComments;
}


-(CGFloat)heightOfTextForString:(NSString *)aString andFont:(UIFont *)aFont maxSize:(CGSize)aSize
{
    // iOS7

    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        CGSize sizeOfText = [aString boundingRectWithSize: aSize
                                                  options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes: [NSDictionary dictionaryWithObject:aFont
                                                                                       forKey:NSFontAttributeName]
                                                  context: nil].size;

        return ceilf(sizeOfText.height);
    }
    return 0.0;
}

-(void)setAttributedTextWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText andWithThirdText:(NSString*)thirdText andWithColor:(UIColor*)statusColor forLabel:(UILabel*)label
{

    NSLog(@"firstText = %@",firstText);
    NSLog(@"thirdText = %@",thirdText);
    
    if([firstText length]==0 || [firstText isEqualToString:@"(null)"])
    {
        firstText = @"Type?";
    }
    if([thirdText length]==0 || [thirdText isEqualToString:@"(null)"])
    {
        thirdText = @"R?";
    }
    
    UIFont *regularFont;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];

    }
    else
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];

    }
    UIColor *foregroundColorWhite = [UIColor whiteColor];
    // Create the attributes
    NSDictionary *FirstAttribute;
    NSDictionary *SecondAttribute;
    NSDictionary *ThirdAttribute;


    FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                      regularFont, NSFontAttributeName,
                      foregroundColorWhite, NSForegroundColorAttributeName, nil];

    SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                       regularFont, NSFontAttributeName,
                       foregroundColorWhite, NSForegroundColorAttributeName, nil];

    ThirdAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                      regularFont, NSFontAttributeName,
                      statusColor, NSForegroundColorAttributeName, nil];


    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:firstText
                                                                                           attributes:FirstAttribute];



    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:secondText
                                                                                             attributes:SecondAttribute];


    NSMutableAttributedString *attributedThirdText = [[NSMutableAttributedString alloc] initWithString:thirdText
                                                                                            attributes:ThirdAttribute];



    [attributedSecondText appendAttributedString:attributedThirdText];
    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];


}


-(void)setAttributedTextForVehicleDetailsWithFirstText:(NSString*)firstText andWithSecondText:(NSString*)secondText forLabel:(UILabel*)label
{

    UIFont *regularFont;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];

    }
    else
    {
        regularFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];

    }

    UIColor *foregroundColorWhite = [UIColor whiteColor];

    UIColor *foregroundColorBlue = [UIColor colorWithRed:52.0/255.0 green:118.0/255.0 blue:190.0/255.0 alpha:1.0];



    // Create the attributes

    NSDictionary *FirstAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                    regularFont, NSFontAttributeName,
                                    foregroundColorWhite, NSForegroundColorAttributeName, nil];




    NSDictionary *SecondAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorBlue, NSForegroundColorAttributeName, nil];





    NSMutableAttributedString *attributedFirstText= [[NSMutableAttributedString alloc] initWithString:firstText
                                                                                           attributes:FirstAttribute];



    NSMutableAttributedString *attributedSecondText = [[NSMutableAttributedString alloc] initWithString:secondText
                                                                                             attributes:SecondAttribute];






    [attributedFirstText appendAttributedString:attributedSecondText];
    // Set it in our UILabel and we are done!
    [label setAttributedText:attributedFirstText];


}


- (CGFloat)heightForText:(NSString *)bodyText
{

    UIFont *cellFont;
    float textSize =0;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        textSize = 187;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
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


-(CGFloat)returnTheHeightForFirstCell
{
    CGFloat finalDynamicHeight = 0.0f;

    CGFloat heightName = 0.0f;

    // self.vehicleObj = [[SMVehiclelisting alloc] init];

    /*self.vehicleObj.strVehicleYear = @"2009";
     self.vehicleObj.strVehicleName = @"Mercedes BenZ C200K";
     self.vehicleObj.strVehicleMileage = @"50934 Km";
     self.vehicleObj.strVehicleColor = @"BLACK";
     self.vehicleObj.strLocation = @"Durban";
     self.vehicleObj.strOfferStatus = @"Sold";
     self.vehicleObj.strWinningBid = @"R173 000";
     self.vehicleObj.strMyHighest = @"50000";
     self.vehicleObj.strTotalHighest = @"45000000";
     self.vehicleObj.strVehicleTradePrice = @"55 000";
     self.vehicleObj.strClientName = @"Hoopers Volkswagen";
     self.vehicleObj.strClientName = @"Hoopers Volkswagen";
     self.vehicleObj.strContactperson = @"Daver Johnson";
     self.vehicleObj.strSoldDate = @"18 Sep 2015 15:53";*/

    NSString *strVehicleNameHeight = [NSString stringWithFormat:@"%@ %@",self.vehicleObj.strVehicleYear,self.vehicleObj.strVehicleName];

    heightName = [self heightForText:strVehicleNameHeight];

    // NSLog(@"Name height = %f",heightName);

    CGFloat heightDetails1 = 0.0f;

    NSString *mileageStr = [NSString stringWithFormat:@"%@%@",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:self.vehicleObj.strVehicleMileage],self.vehicleObj.strVehicleMileageType];


    NSString *strDetails1Height = [NSString stringWithFormat:@"%@ | %@",mileageStr,self.vehicleObj.strVehicleColor];

    heightDetails1 = [self heightForText:strDetails1Height];

    CGFloat heightDetails2 = 0.0f;

    NSString *strDetails2Height = [NSString stringWithFormat:@"%@ | %@",self.vehicleObj.strVehicleType,[NSString stringWithFormat:@"Exp. %@",self.vehicleObj.strVehicleTeadeTimeLeft]];

    heightDetails2 = [self heightForText:strDetails2Height];


    NSString *strWinningBid = [NSString stringWithFormat:@"Winning Bid:  %@",self.vehicleObj.strWinningBid];

    CGFloat WinningBeat = 0.0f;

    WinningBeat = [self heightForText:strWinningBid];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {

        if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
        {
            finalDynamicHeight = 110.0f;
        }
        else
        {
            finalDynamicHeight = (110.0+ 50.0); // 110 is height of the image
        }

        return finalDynamicHeight+25;
    }
    else
    {
        if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
        {
            finalDynamicHeight = 110.0f;
        }
        else
        {
            finalDynamicHeight = (110.0+ 50.0); // 110 is height of the image
        }

        return finalDynamicHeight+40;


    }






}

- (CGFloat)heightForTextForMessageSection:(NSString *)bodyText
{

    UIFont *cellFont;
    float textSize =0;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        textSize = 160;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
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

-(void)setTheLabelCountText:(int)lblCount
{
    if (lblCount<=0)
    {
        [countLbl setText:@"0"];
    }
    else
    {
        [countLbl setText:[NSString stringWithFormat:@"%d",lblCount]];
    }
    [countLbl sizeToFit];

    float widthWithPadding = countLbl.frame.size.width + 10.0;

    [countLbl setFrame:CGRectMake(countLbl.frame.origin.x, countLbl.frame.origin.y, widthWithPadding, countLbl.frame.size.height)];
}


#pragma mark - UITablewView Datasource Method

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if (tableView==tableSold)
    {
        switch (section)
        {
            case 0:
            {
                if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
                {
                    return 2;
                }
                else
                {
                    return 1;
                }
            }
                break;
            case 1:
            {
                if (isRateBuyerSectionExpanded)
                {
                    NSLog(@"arrayListSellerRating count = %d ",(int)arrayListSellerRating.count+1);
                    return (arrayListSellerRating.count+1);
                }
                return 0;
            }
                break;
            case 2:
            {
                if (isMessageSectionExpanded)
                {
                    if(arrayOfMessages.count == 0)
                        return 0;
                    else
                        return arrayOfMessages.count;
                }
                return 0;
            }
                break;

            default:
                return 0;
                break;
        }
    }

    /*    else if (tableView==self.tableVehicleListing && section == 0)
     {
     switch (section)
     {
     case 0:
     {
     return arrayVehicleListing.count;
     }
     break;

     default:
     break;
     }

     }
     */
    return 0;
}//2 errorrs


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *mainCell;
    if (tableView==tableSold)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                static NSString *cellIdentifier = @"Cell";

                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

                if (!cell)
                {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                }
                else
                {
                    for (UIView *viw in cell.contentView.subviews)
                    {
                        [viw removeFromSuperview];
                    }
                }

                switch (indexPath.row)
                {
                    case 0:
                    {
                        [self cellForFirstRow:cell];
                    }
                        break;

                    case 1:
                    {
                        if (arrayFullImages.count!=0)
                        {
                            [cell.contentView addSubview:viwForCollectionImages];
                        }
                    }
                        break;

                        /*   case 2:
                         if (self.strBidValue.intValue!=0)
                         {
                         [cell.contentView addSubview:self.viewPlacedBid];
                         }
                         break;

                         case 3:
                         if (self.strBidValue.intValue!=0)
                         {
                         [cell.contentView addSubview:self.viewAutomatedBidding];
                         }
                         break;

                         case 4:
                         if (self.buttonAutomatedBidding.selected)
                         {
                         [cell.contentView addSubview:self.viewAutomatedExpanded];
                         }
                         else
                         {
                         if (self.strBuyNowValue.intValue!=0)
                         {
                         [cell.contentView addSubview:self.viewBuyNow];
                         }
                         }
                         break;

                         case 5:
                         if (self.buttonAutomatedBidding.selected)
                         {
                         if (self.strBuyNowValue.intValue!=0)
                         {
                         [cell.contentView addSubview:self.viewBuyNow];
                         }
                         }
                         else
                         {
                         [self.tableVehicleListing removeFromSuperview];
                         [cell.contentView addSubview:self.tableVehicleListing];
                         }
                         break;

                         case 6:
                         {
                         [self.tableVehicleListing removeFromSuperview];
                         [cell.contentView addSubview:self.tableVehicleListing];
                         }
                         break;
                         */

                    default:
                        break;
                }

                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                cell.backgroundColor = [UIColor blackColor];
                mainCell = cell;

            }
                break;

            case 1:
            {
                static NSString *cellIdentifier = @"TradeSoldCell";

                
                SMTradeSoldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

                cell.backgroundColor = [UIColor blackColor];
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

                // this needed to be done cause the first cell of first section was visible in the first cell of second section.
                [[cell.contentView viewWithTag:500]removeFromSuperview];
                [[cell.contentView viewWithTag:501]removeFromSuperview];
                [[cell.contentView viewWithTag:502]removeFromSuperview];
                [[cell.contentView viewWithTag:503]removeFromSuperview];
                [[cell.contentView viewWithTag:504]removeFromSuperview];
                [[cell.contentView viewWithTag:505]removeFromSuperview];
                [[cell.contentView viewWithTag:506]removeFromSuperview];
                [[cell.contentView viewWithTag:507]removeFromSuperview];
                [[cell.contentView viewWithTag:508]removeFromSuperview];

                NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
                
                if(indexPath.row == totalRow -1)
                {
                    //this is the last row in section.

                    cell.lblRateBuyerQuestion.hidden = YES;
                    cell.txtRateBuyerRatting.hidden = YES;
                    cell.lblRatingRate.hidden = YES;
                    cell.buttonSubmit.hidden = NO;
                    [cell.buttonSubmit addTarget:self action:@selector(btnactnSubmit:) forControlEvents:UIControlEventTouchUpInside];
                }
                else
                {
                    SMRateBuyerObject *rateBuyerObjNew = (SMRateBuyerObject *)[arrayListSellerRating objectAtIndex:indexPath.row];

//                    NSPredicate *predicatePages = [NSPredicate predicateWithFormat:@"strRateBuyerRattingID == %d",rateBuyerObjNew.strRateBuyerRattingID];
//                    NSArray *arrayFilteredPages = [arrayRateBuyerList filteredArrayUsingPredicate:predicatePages];
//
//
//                    SMRateBuyerObject *rateBuyerObjValue;
//                    if (arrayFilteredPages.count == 0) {
//
//                    }
//                    else{
//                        rateBuyerObjValue = [arrayFilteredPages objectAtIndex:0];
//                    }
//

                    cell.lblRatingRate.text = @"/12";
                    cell.buttonSubmit.hidden = YES;
                    cell.lblRateBuyerQuestion.hidden = NO;
                    cell.txtRateBuyerRatting.hidden = NO;
                    cell.lblRatingRate.hidden = NO;

                    cell.lblRateBuyerQuestion.frame = [self heightForRateBuyerLabel:cell.lblRateBuyerQuestion string:rateBuyerObjNew.strRateBuyerQuestion];
                    cell.lblRateBuyerQuestion.lineBreakMode = NSLineBreakByWordWrapping;
                    cell.lblRateBuyerQuestion.numberOfLines = 0;
                    cell.lblRateBuyerQuestion.text = rateBuyerObjNew.strRateBuyerQuestion;

                    cell.txtRateBuyerRatting.delegate = self;
                    cell.txtRateBuyerRatting.tag = indexPath.row;
                   

                    cell.txtRateBuyerRatting.text = rateBuyerObjNew.strRateTextFieldValue;

                }

                mainCell = cell;
            }
                break;
            case 2:
            {

                static NSString *cellIdentifier3= @"SMCustomDynamicCell";

                SMCustomDynamicCell     *dynamicCell;
                SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfMessages objectAtIndex:indexPath.row];

                UILabel *lblSellerName;
                UILabel *lblMessageTime;
                UILabel *lblMessage;


                //----------------------------------------------------------------------------------------

                CGFloat heightMessage = 0.0f;


                heightMessage = [self heightForTextForMessageSection:rowObject.strMessage andTextWidthForiPhone:180];


                //----------------------------------------------------------------------------------------

                CGFloat heightName = 0.0f;


                heightName = [self heightForTextForMessageSection:rowObject.strClientName andTextWidthForiPhone:120];


                //----------------------------------------------------------------------------------------


                if (dynamicCell == nil)
                {
                    dynamicCell = [[SMCustomDynamicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier3];

                    dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;

                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
                    {
                        lblSellerName = [[UILabel alloc] initWithFrame:CGRectMake(8,5,120,heightName)];
                        lblMessageTime = [[UILabel alloc] initWithFrame:CGRectMake(8,lblSellerName.frame.origin.y + lblSellerName.frame.size.height + 1.0,lblSellerName.frame.size.width,21)];
                        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(lblSellerName.frame.origin.x + lblSellerName.frame.size.width + 6.0,lblSellerName.frame.origin.y,180,heightMessage)];

                        lblSellerName.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];
                        lblMessageTime.font = [UIFont fontWithName:FONT_NAME_BOLD size:10];
                        lblMessage.font = [UIFont fontWithName:FONT_NAME_BOLD size:14];

                    }
                    else
                    {
                        lblSellerName = [[UILabel alloc] initWithFrame:CGRectMake(8,5,200,25)];
                        lblMessageTime = [[UILabel alloc] initWithFrame:CGRectMake(8,lblSellerName.frame.origin.y + lblSellerName.frame.size.height + 2.0,lblSellerName.frame.size.width,25)];
                        lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(lblSellerName.frame.origin.x + lblSellerName.frame.size.width + 6.0,lblSellerName.frame.origin.y,550,heightMessage)];

                        lblSellerName.font = [UIFont fontWithName:FONT_NAME_BOLD size:18];
                        lblMessageTime.font = [UIFont fontWithName:FONT_NAME_BOLD size:15];
                        lblMessage.font = [UIFont fontWithName:FONT_NAME_BOLD size:18];

                    }


                    lblMessage.textColor = [UIColor whiteColor];
                    lblSellerName.textColor = [UIColor colorWithRed:43.0/255 green:133.0/255 blue:199.0/255 alpha:1.0];
                    lblMessageTime.textColor = [UIColor whiteColor];


                    lblSellerName.tag = 101;
                    lblMessageTime.tag = 102;
                    lblMessage.tag = 103;
                }
                else
                {
                    lblSellerName = (UILabel *)[dynamicCell.contentView viewWithTag:101];
                    lblMessageTime = (UILabel *)[dynamicCell.contentView viewWithTag:102];
                    lblMessage = (UILabel *)[dynamicCell.contentView viewWithTag:103];
                }

                lblSellerName.text = rowObject.strClientName;
                lblMessageTime.text = rowObject.strSoldDate;
                lblMessage.text = rowObject.strMessage;

                [dynamicCell.contentView addSubview:lblSellerName];
                [dynamicCell.contentView addSubview:lblMessageTime];
                [dynamicCell.contentView addSubview:lblMessage];
                dynamicCell.backgroundColor = [UIColor blackColor];
                
                
                lblMessage.numberOfLines = 0;
                [lblMessage sizeToFit];
                
                lblSellerName.numberOfLines = 0;
                [lblSellerName sizeToFit];
                
                mainCell = dynamicCell;
                return mainCell;
                
            }
                break;
                /*    case 3:
                 {
                 static NSString *cellIdentifier = @"Cell";


                 UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

                 if (!cell)
                 {
                 cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                 }
                 else
                 {
                 for (UIView *viw in cell.contentView.subviews)
                 {
                 [viw removeFromSuperview];
                 }
                 }

                 if(indexPath.row == 0)
                 {
                 [cell.contentView addSubview:self.viewHoldingRatingValues];

                 mainCell = cell;
                 }
                 else
                 return nil;
                 }
                 break;
                 */
            default:
                break;
        }

        //return cell;
    }
    /*  else if(tableView==self.tableVehicleListing)
     {
     switch (indexPath.section)
     {
     case 0:
     {
     static NSString  *CellIdentifier = @"Cell";

     SMDetailTableViewCell  *cell = (SMDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

     SMDetailTrade *objectInCellForRow = (SMDetailTrade *) [arrayVehicleListing objectAtIndex:indexPath.row];

     objectInCellForRow.strValue = [[objectInCellForRow.strValue componentsSeparatedByString:@"."] objectAtIndex:0];
     [cell.labelVehicleValue setText:objectInCellForRow.strValue];

     [cell.labelVehicleKey   setText:objectInCellForRow.strKey];
     cell.backgroundColor  = [UIColor clearColor];

     mainCell = cell;
     }
     break;

     default:
     break;
     }

     }
     */
    return mainCell;

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView==tableSold)
    {
        switch (indexPath.section)
        {
            case 0:
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        return [self returnTheHeightForFirstCell];
                    }
                        break;
                    case 1:

                        if (arrayFullImages.count!=0)
                        {
                            return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 70.0f : 80.0f;
                        }
                        else
                        {
                            return 0.0f;
                        }
                        break;
                }
            }
                break;
            case 1:
            {
                if(isRateBuyerSectionExpanded)
                {
                    if (arrayListSellerRating.count == indexPath.row) {

                        return 44.0f;
                    }
                    else{
                        SMRateBuyerObject *rateBuyerObj1 = (SMRateBuyerObject *)[arrayListSellerRating objectAtIndex:indexPath.row];

                        return ([self heightForRateBuyerText:rateBuyerObj1.strRateBuyerQuestion]+19);
                    }
                }
                else
                {
                    return 0;
                }
            }
                break;
            case 2:
            {
                if (isMessageSectionExpanded)
                {

                    SMVehiclelisting *rowObject = (SMVehiclelisting*)[arrayOfMessages objectAtIndex:indexPath.row];

                    //----------------------------------------------------------------------------------------

                    CGFloat heightMessage = 0.0f;


                    heightMessage = [self heightForTextForMessageSection:rowObject.strMessage andTextWidthForiPhone:180];


                    //----------------------------------------------------------------------------------------

                    CGFloat heightName = 0.0f;


                    heightName = [self heightForTextForMessageSection:rowObject.strClientName andTextWidthForiPhone:120];


                    //----------------------------------------------------------------------------------------

                    if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                    {
                        if(heightMessage <= 20)
                            return heightMessage + 35.0;
                        else
                            return heightMessage + 15.0;
                    }
                    else
                    {
                        return heightMessage + 35.0;
                    }
                }
                else
                {
                    return 0;
                }
            }
                break;
            default:
                break;
        }
    }
    return 0;
}

#pragma Header Views

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(tableView == tableSold)
    {
        if(section != 0)
        {
            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                return 40.0f;
            }
            else
            {
                return 60.0f;
            }
        }
        return 0.0f;
    }
    return 0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(tableView == tableSold)
    {
        if(section != 0)
        {
            UIView *headerView = [[UIView alloc] init];
            UIView *headerColorView = [[UIView alloc] init];
            UIButton *sectionLabelBtn =[UIButton buttonWithType:UIButtonTypeCustom];
            [sectionLabelBtn setBackgroundColor:[UIColor clearColor]];
            imageViewArrowForsection = [[UIImageView alloc]init];

            imageViewArrowForsection.contentMode = UIViewContentModeScaleAspectFit;

            if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
                [headerView setFrame:CGRectMake(5, 2, 310, 30)];
                [headerColorView setFrame:CGRectMake(5, 2, 310, 30)];
                sectionLabelBtn.frame = CGRectMake(5, 0, tableView.bounds.size.width,30);
                sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:15.0f];
                [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-37,5,20,20)];
                //[labelReviews setFrame:CGRectMake(180, 3, 100, 25)];
            }
            else
            {
                [headerView setFrame:CGRectMake(5, 5, 758, 40)];
                [headerColorView setFrame:CGRectMake(5, 5, 758, 40)];
                sectionLabelBtn.frame = CGRectMake(7, 5, 758,40);
                sectionLabelBtn.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
                [imageViewArrowForsection setFrame:CGRectMake(tableView.bounds.size.width-34,10,20,20)];
                //[labelReviews setFrame:CGRectMake(728, 3, 200, 25)];
            }

            if(section == 1)
            {if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
            {
                [sectionLabelBtn setTitle:@"Rate Seller" forState:UIControlStateNormal];
            }
            else{
                [sectionLabelBtn setTitle:@"Rate Buyer" forState:UIControlStateNormal];
            }
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                    sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 100, 0.0, 0.0);
                else
                    sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(100.0, 300, 110.0, 0.0);
            }
            else
            {
                [sectionLabelBtn setTitle:@"Messages" forState:UIControlStateNormal];
                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                    sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 100, 2.0, 0.0);
                else
                    sectionLabelBtn.contentEdgeInsets = UIEdgeInsetsMake(0.0, 300, 10.0, 0.0);

            }

            NSLog(@"is second section = %d",isRateBuyerSectionExpanded);
            NSLog(@"is third section = %d",isMessageSectionExpanded);

            if(isRateBuyerSectionExpanded)
            {
                if(section == 1)
                {

                    [UIView animateWithDuration:2 animations:^
                     {
                         {
                             imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                         }
                     }
                                     completion:nil];
                }
            }
            else if(isMessageSectionExpanded)
            {
                if(section == 2)
                {

                    [UIView animateWithDuration:2 animations:^
                     {
                         {
                             imageViewArrowForsection.transform = CGAffineTransformMakeRotation(M_PI/2);
                         }
                     }
                                     completion:nil];
                }
            }

            UIImage *image = [UIImage imageNamed:@"side_Arrow.png"];
            [imageViewArrowForsection setImage:image];


            [headerColorView addSubview:imageViewArrowForsection];

            headerView.backgroundColor = [UIColor blackColor];





            if(section == 2)
            {
                countLbl = [[UILabel alloc]initWithFrame:CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-45,5, 20, 20)];

                countLbl.textColor = [UIColor whiteColor];
                countLbl.textAlignment = NSTextAlignmentCenter;
                countLbl.layer.borderColor = [UIColor whiteColor].CGColor;
                countLbl.layer.borderWidth = 1.0;
                countLbl.layer.masksToBounds = YES;


                //countLbl.text = [NSString stringWithFormat:@"%d",sectionObject.arrayOfInnerObjects.count];

                countLbl.layer.cornerRadius = countLbl.frame.size.width/2;

                [self setTheLabelCountText:(int)arrayOfMessages.count];
                // [self setTheLabelCountText:2];

                if(UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
                {
                    countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width,5, countLbl.frame.size.width, 20);
                    countLbl.font = [UIFont fontWithName:FONT_NAME size:15.0f];
                }
                else
                {
                    countLbl.frame = CGRectMake(headerColorView.frame.size.width-imageViewArrowForsection.frame.size.width-10-countLbl.frame.size.width-10,10, countLbl.frame.size.width, 20);
                    countLbl.font = [UIFont fontWithName:FONT_NAME size:17.0f];
                }

                [headerColorView addSubview:countLbl];

            }

            if(section == 2 || section == 1)
            {
                headerColorView.backgroundColor=[UIColor colorWithRed:115.0/255 green:115.0/255 blue:115.0/255 alpha:1.0];
                [sectionLabelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];



            }

            [sectionLabelBtn addTarget:self action:@selector(btnSectionTitleDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            [sectionLabelBtn setTag:section];
            sectionLabelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

            headerColorView.layer.cornerRadius = 5.0;
            [headerColorView addSubview:sectionLabelBtn];
            [headerView addSubview:headerColorView];
            headerView.layer.cornerRadius = 5.0;
            //headerView.clipsToBounds = YES;

            return headerView;
        }
        return nil;
    }
    else
        return nil;

}
//Sandeep Parmar
- (CGFloat)heightForRateBuyerText:(NSString *)bodyText
{
    UIFont *cellFont;
    CGSize constraintSize;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        constraintSize = CGSizeMake(240, MAXFLOAT);

    }
    else{
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:15];
        constraintSize = CGSizeMake(204, MAXFLOAT);
    }
    CGSize labelSize = [bodyText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat height = labelSize.height + 10;

    return height;
}

-(CGRect)heightForRateBuyerLabel:(UILabel *)label string:(NSString *)string{
    CGRect currentFrame = label.frame;
    CGSize max = CGSizeMake(label.frame.size.width, MAXFLOAT);
    CGSize expected = [string sizeWithFont:label.font constrainedToSize:max lineBreakMode:label.lineBreakMode];
    currentFrame.size.height = expected.height;
    return currentFrame;
}

#pragma mark -  UICollectionView Method

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  arrayFullImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMTradeDetailSlider *sliderCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];

    [sliderCell.imageVehicle   setImageWithURL:[NSURL URLWithString:[arrayFullImages objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    
    [imgViewVehicle setImageWithURL:[NSURL URLWithString:[arrayFullImages objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];

    //    [sliderCell.imageVehicle setImage:[UIImage imageNamed:[arrayTradeSliderDetails objectAtIndex:indexPath.row]]];

    return sliderCell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
//        networkGallery.startingIndex = indexPath.row+1;
        networkGallery.startingIndex = indexPath.row;
        SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
        appdelegate.isPresented =  YES;
        [self.navigationController pushViewController:networkGallery animated:YES];
    });
}

-(IBAction)btnSectionTitleDidClicked:(id)sender
{
    [self.view endEditing:YES];

    UIButton *btn = (UIButton *) sender;

    if(btn.tag == 1)
    {
        isRateBuyerSectionExpanded = !isRateBuyerSectionExpanded;

        if(isRateBuyerSectionExpanded)
            isMessageSectionExpanded = NO;
    }
    else if(btn.tag == 2)
    {

        isMessageSectionExpanded = !isMessageSectionExpanded;

        if(isMessageSectionExpanded)
            isRateBuyerSectionExpanded = NO;
    }

    [tableSold reloadData];

}

- (IBAction)btnactnSubmit:(id)sender{

    [self.view endEditing:YES];


    if (isError) {

    }
    else
    {

        for (SMRateBuyerObject *rateBuyerObjNew in arrayListSellerRating) {
            
            if([rateBuyerObjNew.strRateTextFieldValue isEqualToString:@"0"] || [rateBuyerObjNew.strRateTextFieldValue length] == 0)
            {
                UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Please enter a rating between 1 and 12." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                    if (didCancel)
                    {
                        
                        
                        
                    }
                    
                }];
                
                return;

            }
            
        }

        [self uloadRAtingInformationToServer];
    }

}

-(void)uloadRAtingInformationToServer{

    [HUD show:YES];
    [HUD setLabelText:KLoaderText];
    
    SMRateBuyerObject *rateBuyerObjNew = (SMRateBuyerObject *)[arrayListSellerRating objectAtIndex:uploadRatingCount];

    NSMutableURLRequest *requestURL;

    if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
    {
         requestURL=[SMWebServices setAddSellerRatingWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:self.vehicleObj.strUsedVehicleStockID.intValue andTradeOfferID:self.vehicleObj.strOfferID.intValue andCoreClientID:OwnerID andRatingQuestionID:rateBuyerObjNew.strRateBuyerRattingID.intValue andRatingValue:rateBuyerObjNew.strRateTextFieldValue.intValue];
    }
    else
    {
requestURL=[SMWebServices setAddBuyerRatingWithUserHash:[SMGlobalClass sharedInstance].hashValue andUsedVehicleStockID:self.vehicleObj.strUsedVehicleStockID.intValue andTradeOfferID:self.vehicleObj.strOfferID.intValue andCoreClientID:OwnerID andRatingQuestionID:rateBuyerObjNew.strRateBuyerRattingID.intValue andRatingValue:rateBuyerObjNew.strRateTextFieldValue.intValue];
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
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
         }
     }];
}
#pragma mark -  addingProgressHUD Method
-(void) addingProgressHUD
{
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

#pragma mark - NSXMLParser Delegate Methods
- (void) parser:(NSXMLParser *) parser didStartElement:(NSString *) elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *) qName
     attributes:(NSDictionary *) attributeDict
{
    if ([elementName isEqualToString:@"question"])
    {
        rateBuyerObj = [[SMRateBuyerObject alloc]init];
    }
    if ([elementName isEqualToString:@"message"])
    {
        messageObject = [[SMVehiclelisting alloc]init];
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
    {
        rateBuyerObj.strRateBuyerQuestion = currentNodeContent;

    }
    if ([elementName isEqualToString:@"OwnerName"])
    {
       ownerName = currentNodeContent;
        NSLog(@"entered here 1");
        
    }
    if ([elementName isEqualToString:@"HightestBid"]) // winning Bid price
    {
       // self.vehicleObj.strWinningBid =[[SMCommonClassMethods shareCommonClassManager]priceConvertCurrencyEn_AF:currentNodeContent];
        // NSLog(@"strWinningBidd = %@",self.vehicleObj.strWinningBid);
    }
    if ([elementName isEqualToString:@"Location"])
    {
        ownerLocation = currentNodeContent;
        self.vehicleObj.strLocation = currentNodeContent;
         NSLog(@"entered here 2");
        
    }
    if ([elementName isEqualToString:@"Value"])
    {
        rateBuyerObj.strRateTextFieldValue = currentNodeContent;

    }
    if ([elementName isEqualToString:@"QuestionID"])
    {
        rateBuyerObj.strRateBuyerRattingID = currentNodeContent;
        
    }
    if ([elementName isEqualToString:@"ID"]) {
        rateBuyerObj.strRateBuyerRattingID = currentNodeContent;

    }

    if ([elementName isEqualToString:@"question"])
    {

            [arrayListSellerRating addObject:rateBuyerObj];

    }
    if ([elementName isEqualToString:@"Questions"]) {

        [tableSold reloadData];
    }


    if ([elementName isEqualToString:@"ID"]) {
        vechicleID = [currentNodeContent intValue];
    }
    
    
    if ([elementName isEqualToString:@"OwnerID"]) {
        OwnerID = [currentNodeContent intValue];
    }
    if ([elementName isEqualToString:@"Comments"])
    {
         if([currentNodeContent length] == 0)
             labelComment.text = @"No Comments";
         else
             labelComment.text = currentNodeContent;
    }
    
    if ([elementName isEqualToString:@"Extras"])
    {
        if([currentNodeContent length] == 0)
            labelExtras.text = @"No Extras";
        else
            labelExtras.text = currentNodeContent;

    }
    
    if ([elementName isEqualToString:@"Full"]) {
        
        [arrayFullImages addObject:currentNodeContent];
    }
    if ([elementName isEqualToString:@"SUCCESS"]) {

        if (uploadRatingCount == totalCount)
        {
            UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Rating added successfully." cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
                if (didCancel)
                {
                    
                    return;
                    
                }
                
            }];

            
        }
        else{
            uploadRatingCount++;
            [self uloadRAtingInformationToServer];
        }
    }

    if ([elementName isEqualToString:@"LoadVehicleResponse"])
    {
        [self setTheFooterFrame];
        [tableSold setTableFooterView:viwFooterComments];
        [viewCollection reloadData];

        
    }
    if ([elementName isEqualToString:@"GetRatingQuestionsForSellerResponse"])
    {
    
    }
    if ([elementName isEqualToString:@"VIN"])
    {
        if([currentNodeContent length] == 0)
            strVinNumber = @"VIN?";
        else
        strVinNumber = currentNodeContent;
    }
    if ([elementName isEqualToString:@"RegNumber"])
    {
        if([currentNodeContent length] == 0)
           strRegistrationNumber = @"Reg?";
        else
        strRegistrationNumber = currentNodeContent;
    }
    // Message service parsing :

    if ([elementName isEqualToString:@"Name"])
    {
        messageObject.strClientName  = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Date"])
    {
        messageObject.strSoldDate = currentNodeContent;
    }
    if ([elementName isEqualToString:@"Message"])
    {
        messageObject.strMessage = currentNodeContent;
    }
    if ([elementName isEqualToString:@"message"])
    {
        [arrayOfMessages addObject:messageObject];
    }

}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"reached here...");

    totalCount = (int)arrayListSellerRating.count-1;
    if(isLoadVehicleService)
    {
        if([self.strFromWhichScreen isEqualToString:@"SMTrader_WinningBidsViewController"])
        {
            [self webServiceForFetchingQuestionsRatingForSeller];
            [self webServiceForMessagesList];
            
        }
        else
        {
            NSLog(@"thus calleddd");
            [self webServiceForFetchingQuestionsRatingForBuyer];
            [self webServiceForMessagesList];
            
        }

    }
    [self hideProgressHUD];
    [tableSold reloadData];
    
}

-(void)setTheFooterFrame
{
    [labelComment setFrame:CGRectMake(labelComment.frame.origin.x, labelComment.frame.origin.y,labelComment.frame.size.width, [self heightOfTextForString:labelComment.text andFont:labelComment.font maxSize:CGSizeMake(labelComment.frame.size.width, 500.0f)])];
    
    [labelExtrasHeading setFrame:CGRectMake(labelExtrasHeading.frame.origin.x,labelComment.frame.origin.y + labelComment.frame.size.height+5,labelExtrasHeading.frame.size.width,[self heightOfTextForString:labelExtrasHeading.text andFont:labelExtrasHeading.font maxSize:CGSizeMake(labelExtrasHeading.frame.size.width, 500.0f)])];
    
    [labelExtras setFrame:CGRectMake(labelExtras.frame.origin.x,labelExtrasHeading.frame.origin.y + labelExtrasHeading.frame.size.height+2,labelExtras.frame.size.width,[self heightOfTextForString:labelExtras.text andFont:labelExtras.font maxSize:CGSizeMake(labelExtras.frame.size.width, 500.0f)])];
    
    [labelStockNumber      setText:self.vehicleObj.strStockCode];
    [labelVinNumber setText:strVinNumber];
    [labelRegisterNumber setText:strRegistrationNumber];
    [lblOwnerName setText:[NSString stringWithFormat:@"Seller: %@, %@",ownerName,ownerLocation]];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self setTableVehicleListTableFooterView:labelExtras.frame.size.height + labelComment.frame.size.height + 180];
    }
    else
    {
        [self setTableVehicleListTableFooterView:labelExtras.frame.size.height + labelComment.frame.size.height + 240];
    }


}

-(NSString*)returnTheExpectedStringForString:(NSString*)inputString
{
    inputString = [inputString substringToIndex:16];
    return inputString;
}

#pragma mark  ===============

- (CGFloat)heightForTextForMessageSection:(NSString *)bodyText andTextWidthForiPhone:(float)textWidth
{

    UIFont *cellFont;
    float textSize =0;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:14];
        textSize = textWidth;
    }
    else
    {
        cellFont = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
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

#pragma mark -
#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldBeginEditing:(SMCustomTextField *)textField
{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSLog(@"textFieldDidEndEditing %@ textField Tag %ld",textField.text,(long)textField.tag);

    SMRateBuyerObject *rateBuyerObjNew = (SMRateBuyerObject *)[arrayListSellerRating objectAtIndex:textField.tag];
    rateBuyerObjNew.strRateTextFieldValue = textField.text;
    NSLog(@"");

    if ([textField.text length] == 0)
    {
        isError = YES;
    }
    else if ([textField.text isEqualToString:@"0"])
    {
        isError = YES;
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Please enter a rating between 1 and 12" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel)
            {

                textField.text = @"";
                [textField becomeFirstResponder];

            }
            
        }];
    }
    else if ([textField.text length]>=1 && [textField.text intValue] <=12) {
        SMRateBuyerObject *rateBuyerObjNew = (SMRateBuyerObject *)[arrayListSellerRating objectAtIndex:textField.tag];

        rateBuyerObjNew.strRateTextFieldValue = textField.text;
isError = NO;
    }
    else{
        NSLog(@"Error textField");
        isError = YES;
        UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:@"Please enter a rating between 1 and 12" cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel) {
            if (didCancel)
            {

                textField.text = @"";
                [textField becomeFirstResponder];


            }

        }];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    return YES;    
}

#pragma mark - FGalleryViewController Delegate Method

- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    if(gallery == networkGallery)
    {
        int num;
        
        num = (int)[arrayFullImages count];
        
        return num;
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
    NSString *caption;
    if( gallery == networkGallery )
    {
        caption = [networkCaptions objectAtIndex:index];
    }
    return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    return [arrayFullImages objectAtIndex:index];
}


@end