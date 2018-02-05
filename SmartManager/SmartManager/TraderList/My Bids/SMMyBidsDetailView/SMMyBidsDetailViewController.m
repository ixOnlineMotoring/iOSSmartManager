//
//  SMMyBidsDetailViewController.m
//  SmartManager
//
//  Created by Ketan Nandha on 27/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMMyBidsDetailViewController.h"
#import "SMCustomColor.h"
#import "UIImageView+WebCache.h"
#import "SMSellCollectionCell.h"
#import "SMSellListDetailCell.h"
#import "SMCommonClassMethods.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"
#import "SMAppDelegate.h"


@interface SMMyBidsDetailViewController ()

@end

@implementation SMMyBidsDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];

    [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                   withObject:(__bridge id)((void*)UIInterfaceOrientationPortrait)];

    // used for setting Navigation Title
    self.navigationItem.titleView = [SMCustomColor setTitle:self.objectVehicleListing.strVehicleName];
    
    self.lblVehicleName.text = [NSString stringWithFormat:@"%@ %@",self.objectVehicleListing.strVehicleYear, self.objectVehicleListing.strVehicleName];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:self.lblVehicleName.text];
    NSRange fullRange = NSMakeRange(0, 4);
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
    [self.lblVehicleName setAttributedText:string];
    
    [self.lblVehicleAmount setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.objectVehicleListing.strVehiclePrice]];
    
    self.lblVehicleMileage.text   = [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:self.objectVehicleListing.strVehicleMileage]];
    self.lblVehicleColour.text    = self.objectVehicleListing.strVehicleColor;
    self.lblVehicleLocation.text  = self.objectVehicleListing.strLocation;
    
    
    self.lblVehicleNameN.text = [NSString stringWithFormat:@"%@ %@",self.objectVehicleListing.strVehicleYear, self.objectVehicleListing.strVehicleName];
    
    NSMutableAttributedString *stringN = [[NSMutableAttributedString alloc] initWithString:self.lblVehicleNameN.text];
    [stringN addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:fullRange];
    [self.lblVehicleNameN setAttributedText:string];
    
    [self.lblVehicleAmountN setText:[[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.objectVehicleListing.strVehiclePrice]];
    
    self.lblVehicleMileageN.text   = [NSString stringWithFormat:@"%@ Km",[[SMCommonClassMethods shareCommonClassManager] mileageConvertEn_AF:self.objectVehicleListing.strVehicleMileage]];
    self.lblVehicleColourN.text    = self.objectVehicleListing.strVehicleColor;
    self.lblVehicleLocationN.text  = self.objectVehicleListing.strLocation;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self addingProgressHUD];
    
    [self registerNib];
    
    [self webServiceLoadVehicle];
}

- (void)registerNib
{
    [self.collectionView registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMSellCollectionCell" : @"SMSellCollectionCell_iPad" bundle:nil]            forCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier"];
    
    [self.tblViewMyBidsList registerNib:[UINib nibWithNibName:UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ? @"SMSellListDetailCell" : @"SMSellListDetailCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMSellListDetailCellIdentifier"];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (arraySliderImages.count==0) ? 2 : 3;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row)
    {
        case 0:
            
            if(arrayImages.count == 0)
            {
                [self.viewHeaderContainerNoImage removeFromSuperview];
                [cell.contentView addSubview:self.viewHeaderContainerNoImage];

            }
            else
            {
                [self.viewHeaderContainer removeFromSuperview];
                [cell.contentView addSubview:self.viewHeaderContainer];

            }
            break;
            
        case 1:
            if (arraySliderImages.count==0)
            {
                SMSellListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSellListDetailCellIdentifier" forIndexPath:indexPath];
                
                cell.lblVehicle1.text   = self.objectVehicleListing.strVehicleType;
                cell.lblVehicle2.text   = self.objectVehicleListing.strStockCode;
                cell.lblVehicle3.text   = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.objectVehicleListing.strOfferAmount];
                cell.lblVehicle4.text   = self.objectVehicleListing.strOfferID;
                cell.lblVehicle5.text   = self.objectVehicleListing.strOfferStatus;
                cell.lblVehicle6.text   = self.objectVehicleListing.strSource;
                
                cell.backgroundColor = [UIColor blackColor];
                
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
                
                return cell;
            }
            else
            {
                [cell.contentView addSubview:self.viewCollectionContainer];
            }
            break;
            
        case 2:
        {
            SMSellListDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SMSellListDetailCellIdentifier" forIndexPath:indexPath];
            
            cell.lblVehicle1.text   = self.objectVehicleListing.strVehicleType;
            cell.lblVehicle2.text   = self.objectVehicleListing.strStockCode;
            cell.lblVehicle3.text   = [[SMCommonClassMethods shareCommonClassManager] priceConvertCurrencyEn_AF:self.objectVehicleListing.strOfferAmount];
            cell.lblVehicle4.text   = self.objectVehicleListing.strOfferID;
            cell.lblVehicle5.text   = self.objectVehicleListing.strOfferStatus;
            cell.lblVehicle6.text   = self.objectVehicleListing.strSource;
            
            cell.backgroundColor = [UIColor blackColor];
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        }
            break;
    }
    
    cell.backgroundColor = [UIColor blackColor];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
        case 0:
            return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 100.0f : 130.0f;
            break;
            
        case 1:
            if (arraySliderImages.count==0)
                return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 185.0f : 250.0f;
            else
                return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 62.0f : 85.0f;
            break;
 
        case 2:
            return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 185.0f : 250.0f;
            break;
    }
    
    return 0;
}

#pragma mark - UITableView Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [arraySliderImages count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMSellCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SMSellCollectionCellIdentifier" forIndexPath:indexPath];
    
    [cell.imageVehicle   setImageWithURL:[NSURL URLWithString:[arraySliderImages objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];

    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
                       networkGallery.startingIndex = indexPath.row+1;
                       SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
                       appdelegate.isPresented =  YES;
                       [self.navigationController pushViewController:networkGallery animated:YES];
                   });
}

#pragma mark -

#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    if(gallery == networkGallery)
    {
        int num;

        num = (int)[arrayImages count];
        
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
    if( gallery == networkGallery)
    {
        caption = [networkCaptions objectAtIndex:index];
    }
    return caption;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
    return [arrayImages objectAtIndex:index];
}

#pragma mark - Make Image to large on header cell button click

-(IBAction)buttonImageClickableDidPressed:(id) sender
{
    if (arrayImages.count>0)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            networkGallery               = [[FGalleryViewController alloc] initWithPhotoSource:self];
            networkGallery.startingIndex = [sender tag];
            SMAppDelegate *appdelegate = (SMAppDelegate *)[[UIApplication sharedApplication]delegate];
            appdelegate.isPresented =  YES;

            [self.navigationController pushViewController:networkGallery animated:YES];
        });
    }
}

#pragma mark - webServiceLoadVehicle

-(void)webServiceLoadVehicle
{
    NSMutableURLRequest *requestURL = [SMWebServices gettingDetailsVehicleImages:[SMGlobalClass sharedInstance].hashValue withClientID:[SMGlobalClass sharedInstance].strClientID.intValue withVehicleId:self.objectVehicleListing.strUsedVehicleStockID.intValue];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             SMAlert(@"Error", error.localizedDescription);
//             [self hideProgressHUD];
             return;
         }
         else
         {
             arrayImages        = [[NSMutableArray alloc]init];
             arraySliderImages  = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
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

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    NSString *string = [[NSString alloc]initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Full"])
    {
        [arrayImages addObject:currentNodeContent];
        [arraySliderImages addObject:currentNodeContent];
        
        [self.imageVehicle setImageWithURL:[NSURL URLWithString:[arrayImages objectAtIndex:0]] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
    }
    if ([elementName isEqualToString:@"LoadVehicleResponse"])
    {
        if (arraySliderImages.count>0)
        {
            [arraySliderImages removeObjectAtIndex:0];
        }
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //        [self hideProgressHUD];
    [self.tblViewMyBidsList reloadData];
    [self.collectionView reloadData];
}

#pragma mark - ProgressBar Method

-(void) addingProgressHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
}

-(void) hideProgressHUD
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUD hide:YES];
    });
}

#pragma mark - Memory warning

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
