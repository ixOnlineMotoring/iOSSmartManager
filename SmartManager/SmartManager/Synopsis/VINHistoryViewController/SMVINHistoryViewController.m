//
//  SMVINHistoryViewController.m
//  Smart Manager
//
//  Created by Sandeep on 29/12/15.
//  Copyright © 2015 SmartManager. All rights reserved.
//

#import "SMVINHistoryViewController.h"
#import "SMVINHistoryListViewCell.h"
#import "SMVINHistoryViewCell.h"
#import "SMCustomColor.h"
#import "SMWebServices.h"
#import "SMWSVINHistory.h"
#import "MBProgressHUD.h"
@interface SMVINHistoryViewController ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    SMVINHistoryXmlResultObject *objSMVINHistoryXmlResultObject;
}
@end

@implementation SMVINHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.titleView = [SMCustomColor setTitle:@"VIN History"];

    [tblSMVINHistoryView registerNib:[UINib nibWithNibName: @"SMVINHistoryViewCell" bundle:nil] forCellReuseIdentifier:@"SMVINHistoryViewCell"];

    [tblSMVINHistoryView registerNib:[UINib nibWithNibName: @"SMVINHistoryListViewCell" bundle:nil] forCellReuseIdentifier:@"SMVINHistoryListViewCell"];

    tblSMVINHistoryView.estimatedRowHeight = 123.0;
    tblSMVINHistoryView.rowHeight = UITableViewAutomaticDimension;
    tblSMVINHistoryView.tableFooterView = [[UIView alloc]init];
    [self getVinHistory];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return (objSMVINHistoryXmlResultObject.arrmForDetails.count+1);
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier=@"SMVINHistoryViewCell";
    static NSString *cellIdentifier1=@"SMVINHistoryListViewCell";
    UITableViewCell *cell;

    switch (indexPath.row) {
        case 0:{
            SMVINHistoryViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            dynamicCell.backgroundColor = [UIColor blackColor];
        
            dynamicCell.vechiclesNameLabel.font = [UIFont systemFontOfSize:15];

            [[SMAttributeStringFormatObject sharedService]setAttributedTextForVehicleDetailsWithFirstText:self.strYear andWithSecondText:self.strVehicleName forLabel:dynamicCell.vechiclesNameLabel];

            dynamicCell.VINNumberLabel.text = objSMVINHistoryXmlResultObject.strVIN;
            dynamicCell.VINNumberLabel.numberOfLines = 0;
            dynamicCell.VINNumberLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [dynamicCell.VINNumberLabel sizeToFit];

            dynamicCell.engineNumberLabel.text = objSMVINHistoryXmlResultObject.strEngineNo;
            dynamicCell.engineNumberLabel.numberOfLines = 0;
            dynamicCell.engineNumberLabel.lineBreakMode = NSLineBreakByWordWrapping;
            [dynamicCell.engineNumberLabel sizeToFit];
            dynamicCell.separatorInset = UIEdgeInsetsMake(0, 10000, 0, 0);
            cell = dynamicCell;
        }
            break;

        default:{
            SMVINHistoryListViewCell *dynamicCell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            dynamicCell.backgroundColor = [UIColor blackColor];
            dynamicCell.selectionStyle = UITableViewCellSelectionStyleNone;
            dynamicCell.backgroundColor = [UIColor blackColor];
            if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
            {
            dynamicCell.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
            }
            else
            {
            dynamicCell.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
            }
            SMVINHistoryObject *objSMVINHistoryObject1 = [objSMVINHistoryXmlResultObject.arrmForDetails objectAtIndex:(indexPath.row-1)];
            dynamicCell.titleLabel.text = [NSString stringWithFormat:@"%@ | %@ | %@ | %@Km | %@",objSMVINHistoryObject1.strDealer,objSMVINHistoryObject1.strLocation,objSMVINHistoryObject1.strLastSeen,objSMVINHistoryObject1.strMileage,objSMVINHistoryObject1.strPrice];
           
            cell = dynamicCell;
        }
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Web Services
-(void) getVinHistory{
    
    if ([self.strVINNo isEqualToString:@"No VIN loaded"]) {
        self.strVINNo = @"0";
    }
    
    
    NSMutableURLRequest *requestURL=[SMWebServices gettingLoadVINHistory:[SMGlobalClass sharedInstance].hashValue VIN:self.strVINNo];
    objSMVINHistoryXmlResultObject = [[SMVINHistoryXmlResultObject alloc] init];
  
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSVINHistory *wsSMWSVINHistory = [[SMWSVINHistory alloc]init];
    
    [wsSMWSVINHistory responseForWebServiceForReuest:requestURL
                                            response:^(SMVINHistoryXmlResultObject *objSMVINHistoryXmlResultObjectResult) {
                                                [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                [self hideProgressHUD];
                                                switch (objSMVINHistoryXmlResultObjectResult.iStatus) {
                                                        
                                                    case kWSCrash:
                                                    {
                                                        [SMAttributeStringFormatObject showAlertWebServicewithMessage:KWSCrashMessage ForViewController:self];
                                                    }
                                                        break;
                                                        
                                                    case kWSNoRecord:
                                                    {
                                                        [SMAttributeStringFormatObject showAlertWebServicewithMessage:KNorecordsFousnt ForViewController:self];
                                                    }
                                                        break;
                                                        
                                                    case kWSSuccess:
                                                    {
                                                        if (objSMVINHistoryXmlResultObjectResult.arrmForDetails.count == 0) {
                                                          [SMAttributeStringFormatObject showAlertWebServicewithMessage:KNorecordsFousnt ForViewController:self];
                                                        }else{
                                                        objSMVINHistoryXmlResultObject = objSMVINHistoryXmlResultObjectResult;
                                                        [tblSMVINHistoryView reloadData];
                                                        }
                                                    }
                                                        break;
                                                        
                                                    default:
                                                        break;
                                                }
                                }
                                            andError: ^(NSError *error) {
                                                 SMAlert(@"Error", error.localizedDescription);
                                                 [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                 [self hideProgressHUD];
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
-(void) hideProgressHUD
{
    [HUD hide:YES];
}

@end
