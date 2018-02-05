//
//  SMExteriorReconditioningViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 11/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMExteriorReconditioningViewController.h"
#import "SMExteriorReconditioningViewCell.h"
#import "CustomTextView.h"
#import "SMExteriorReconditioning.h"
#import "SMCarTouchRecognitionViewController.h"
@interface SMExteriorReconditioningViewController ()
{
    
    IBOutlet UILabel *lblTotal;
    IBOutlet UITableView *tblExteriorReconditioning;
    IBOutlet UIView *viewHeaderTable;
    IBOutlet UIView *viewFooterTable;
    IBOutlet CustomTextView *txtViewComments;
   
    NSMutableArray *arrmExteriorReconditioning;
    int intTotal;
    int selectedDeleteBtnIndex;
    NSString *strExtriorForDeletetion;
    BOOL isDeleteWEbserviceResponse;
   __block SMExteriorReconditioning *exteriorObj;
}
- (IBAction)btnSaveDidClicked:(id)sender;
- (IBAction)btnAddDidClicked:(id)sender;
@end

@implementation SMExteriorReconditioningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    intTotal = 0;
    selectedDeleteBtnIndex = 0;
    isDeleteWEbserviceResponse = NO;
     self.navigationItem.titleView = [SMCustomColor setTitle:@"   Exterior Reconditioning"];
    [self addingProgressHUD];
    lblTotal.text   = [NSString stringWithFormat:@"R %d",intTotal];
     arrmExteriorReconditioning = [[NSMutableArray alloc] init];
        [self setTableProperties];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
   if(arrmExteriorReconditioning == nil)
        arrmExteriorReconditioning = [[NSMutableArray alloc] init];
    [self webserviceCallForLoadingExterior];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setTableProperties{
    [tblExteriorReconditioning registerNib:[UINib nibWithNibName:@"SMExteriorReconditioningViewCell" bundle:nil] forCellReuseIdentifier:@"SMExteriorReconditioningViewCell"];
    
    tblExteriorReconditioning.tableHeaderView = viewHeaderTable;
    tblExteriorReconditioning.estimatedRowHeight = 45.0f;
    tblExteriorReconditioning.rowHeight = UITableViewAutomaticDimension;
    tblExteriorReconditioning.tableFooterView = viewFooterTable;
}

#pragma mark - Table View Delegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrmExteriorReconditioning.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SMExteriorReconditioningViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"SMExteriorReconditioningViewCell"];
    cell.backgroundColor = [UIColor blackColor];
    cell.selectionStyle= UITableViewCellSelectionStyleNone;
    
    SMExteriorReconditioning *objExterior = (SMExteriorReconditioning *)[arrmExteriorReconditioning objectAtIndex:indexPath.row];
    
    NSString *isRepair;
    
    if(objExterior.isRepairSelected)
        isRepair = @"Repair";
    else
        isRepair = @"Replace";
    
    cell.lblDetails.text = [NSString stringWithFormat:@"%@ - %@",objExterior.strExteriorType,isRepair];
    cell.lblPrice.text   = [NSString stringWithFormat:@"R %d",objExterior.strPriceValue.intValue];
    cell.btnDetete.tag   = indexPath.row;
    cell.btnCheckBox.tag = indexPath.row;
    [cell.btnCheckBox setSelected:objExterior.isPriceSelected];
   
    [cell.btnCheckBox addTarget:self action:@selector(btnCheckBoxDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnDetete addTarget:self action:@selector(btnDeteteDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell layoutIfNeeded];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


- (IBAction)btnAddDidClicked:(id)sender
{
    
    SMCarTouchRecognitionViewController *synopsisScanViewController;
    
    CGRect sizeNew =[UIScreen mainScreen].bounds;
    
    int height = sizeNew.size.height;
    
    switch (height) {
        case 480:
        {
            synopsisScanViewController = [[SMCarTouchRecognitionViewController alloc] initWithNibName:@"SMCarTouchRecognitionViewController_4s" bundle:nil];
            
        }
            break;
        case 568:
        {
            synopsisScanViewController = [[SMCarTouchRecognitionViewController alloc] initWithNibName:@"SMCarTouchRecognitionViewController" bundle:nil];
            
            
        }
            break;
        case 667:
        {
            synopsisScanViewController = [[SMCarTouchRecognitionViewController alloc] initWithNibName:@"SMCarTouchRecognitionViewController_6" bundle:nil];
        }
            break;
        case 736:
        {
            synopsisScanViewController = [[SMCarTouchRecognitionViewController alloc] initWithNibName:@"SMCarTouchRecognitionViewController_6plus" bundle:nil];
        }
            break;
        case 1024:
        {
            synopsisScanViewController = [[SMCarTouchRecognitionViewController alloc] initWithNibName:@"SMCarTouchRecognitionViewController_iPad" bundle:nil];
        }
        default:
            break;
    }
    
    
    
    [self.navigationController pushViewController:synopsisScanViewController animated:YES];

}

-(void)calculateTotalwithCheckBoxNo:(NSInteger) checkBoxSelected{
    
    

}


- (IBAction)btnCheckBoxDidClicked:(UIButton *)sender {
    SMExteriorReconditioning *objExterior = [[SMExteriorReconditioning alloc]init];
    objExterior = (SMExteriorReconditioning *)[arrmExteriorReconditioning objectAtIndex:sender.tag];
    objExterior.isPriceSelected = !objExterior.isPriceSelected;
    if(objExterior.isPriceSelected)
        intTotal = intTotal + objExterior.intPrice;
    else
        intTotal = intTotal - objExterior.intPrice;
    
    lblTotal.text   = [NSString stringWithFormat:@"R %d",intTotal];

    [self calculateTotalwithCheckBoxNo:sender.tag];
    sender.selected = !sender.selected;
    
    
}

- (IBAction)btnDeteteDidClicked:(UIButton *)sender {
    
     SMExteriorReconditioning * objExterior = (SMExteriorReconditioning *)[arrmExteriorReconditioning objectAtIndex:sender.tag];
    
    strExtriorForDeletetion = objExterior.strExteriorType;
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:KLoaderTitle
                                 message:[NSString stringWithFormat:@"Are you sure you want to delete %@ ?",strExtriorForDeletetion]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"No"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {}];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Yes"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   dispatch_async(dispatch_get_main_queue(), ^{
                                       [HUD show:YES];
                                       HUD.labelText = KLoaderText;
                                       
                                   });
                                   
                                   //Handle your yes please button action here
                                   
                                   selectedDeleteBtnIndex = (int)[sender tag];
                                   intTotal = intTotal - objExterior.intPrice;
                                   
                                   if(intTotal < 0)
                                       intTotal = 0;
                                   lblTotal.text   = [NSString stringWithFormat:@"R %d",intTotal];
                                   [self webserviceCallForDeletingExteriorWithExteriorTypeID:objExterior.strExteriorTypeID];
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
   
    
}

- (IBAction)btnSaveDidClicked:(id)sender {

    [self.view endEditing:YES];
    [self webserviceCallForSavingSelectedExterior];
    
}

-(void) webserviceCallForSavingSelectedExterior
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
     NSMutableURLRequest * requestURL = [SMWebServices saveSelectedExteriorReconditioning:[SMGlobalClass sharedInstance].hashValue andERArray:arrmExteriorReconditioning andAppraisalID:self.objSummary.appraisalID andClientID:[SMGlobalClass sharedInstance].strClientID andVinNum:self.objSummary.strVINNo andComments:txtViewComments.text];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            NSLog(@"Response = %@",response.description);
                                            NSLog(@"error = %@",error.description);
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
                                                isDeleteWEbserviceResponse = NO;
                                                xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}

-(void) webserviceCallForLoadingExterior
{
    NSURLSession *dataTaskSession ;
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    NSMutableURLRequest * requestURL = [SMWebServices loadExterior:[SMGlobalClass sharedInstance].hashValue andAppraisalID:self.objSummary.appraisalID andVin:self.objSummary.strVINNo];
    
    
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
                                            if(arrmExteriorReconditioning.count > 0)
                                                [arrmExteriorReconditioning removeAllObjects];
                                                isDeleteWEbserviceResponse = NO;
                                                xmlParser = [[NSXMLParser alloc] initWithData:data];
                                                [xmlParser setDelegate:self];
                                                [xmlParser setShouldResolveExternalEntities:YES];
                                                [xmlParser parse];
                                            }
                                        }];
    
    [uploadTask resume];
    
}

-(void) webserviceCallForDeletingExteriorWithExteriorTypeID:(NSString*) exteriorTypeID
{
    NSURLSession *dataTaskSession ;
    
    NSMutableURLRequest * requestURL = [SMWebServices deleteSelectedExteriorReconditioning:[SMGlobalClass sharedInstance].hashValue andExteriorTypeID:exteriorTypeID andAppraisalID:self.objSummary.appraisalID andClientID:[SMGlobalClass sharedInstance].strClientID andVIN:self.objSummary.strVINNo];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPMaximumConnectionsPerHost = 1;
    dataTaskSession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    
    NSURLSessionDataTask *uploadTask = [dataTaskSession dataTaskWithRequest:requestURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
                                        {
                                            NSLog(@"Response = %@",response.description);
                                            NSLog(@"error = %@",error.description);
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
                                                isDeleteWEbserviceResponse = YES;
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
    if ([elementName isEqualToString:@"Item"])
    {
       exteriorObj = [[SMExteriorReconditioning alloc] init];
    }
    
    
    currentNodeContent = [NSMutableString stringWithString:@""];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"Repair"])
        exteriorObj.isRepairSelected = currentNodeContent.boolValue;
    else if ([elementName isEqualToString:@"Value"])
    {
        exteriorObj.strPriceValue = currentNodeContent;
        exteriorObj.intPrice = currentNodeContent.intValue;
    }
    else if ([elementName isEqualToString:@"ExteriorType"])
        exteriorObj.strExteriorType = currentNodeContent;
    else if ([elementName isEqualToString:@"ExteriorValueId"])
        exteriorObj.strExteriorTypeID = currentNodeContent;
    else if ([elementName isEqualToString:@"Selected"])
        exteriorObj.isPriceSelected = currentNodeContent.boolValue;
    else if ([elementName isEqualToString:@"Item"])
        [arrmExteriorReconditioning addObject:exteriorObj];
    else if ([elementName isEqualToString:@"PassOrFailed"])
    {
        NSString *alertMsg;
        
        if(isDeleteWEbserviceResponse)
            alertMsg = [NSString stringWithFormat:@"%@ deleted successfully.",strExtriorForDeletetion];
        else
           alertMsg = @"Exterior Reconditioning saved successfully.";
        
        if([currentNodeContent isEqualToString:@"true"])
        {
           if(!isDeleteWEbserviceResponse)
           {    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
           }
          else
          {
              
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:KLoaderTitle message:alertMsg preferredStyle:UIAlertControllerStyleAlert];
                      [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                      [self presentViewController:alertController animated:YES completion:nil];
              
            dispatch_async(dispatch_get_main_queue(), ^{
                      [arrmExteriorReconditioning removeObjectAtIndex:selectedDeleteBtnIndex];
                      [tblExteriorReconditioning reloadData];
                  });
                  
        }
        
        }
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    NSLog(@"ArrayCNT = %lu",(unsigned long)arrmExteriorReconditioning.count);
     dispatch_async(dispatch_get_main_queue(), ^{
        // Do stuff to UI
        [tblExteriorReconditioning reloadData];
        [HUD hide:YES];
     });
    
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
