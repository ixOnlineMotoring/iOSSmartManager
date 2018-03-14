//
//  SMSellsViewController.h
//  SmartManager
//
//  Created by Ketan Nandha on 10/12/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMVehiclelisting.h"
#import "SMCustomSellObject.h"
#import "SMClassForToDoObjects.h"

@interface SMSellsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate>
{
    NSMutableArray *arrayForSections;
    UIImageView *imageViewArrowForsection;
    UILabel *countLbl;
    NSXMLParser *xmlParser;
    NSMutableString *currentNodeContent;
    SMVehiclelisting *objectVehicleListing;
    SMCustomSellObject *objCustomSell;
    SMClassForToDoObjects *sectionObject;
    
    int currentIndex;
    int previousIndex;
    
    int iAvailable;
    int iNotAvailable;
    int iBidEnded;
    int iActiveBids;
    
    int iTotalBidEnded;
    int iTotalActiveBids;
    int iTotalAvailable;
    int iTotalNotAvailable;
    
    NSMutableArray *tempDataArray;
    int totalRecordCount;
}
@property (strong, nonatomic) IBOutlet UITableView *tblViewSells;

@property(nonatomic,strong) NSMutableArray *arrayGetCount;
@property(nonatomic,strong) NSMutableArray *arrayBidEnded;
@property(nonatomic,strong) NSMutableArray *arrayBidReceived;
@property(nonatomic,strong) NSMutableArray *arrayAvailbaleTrader;
@property(nonatomic,strong) NSMutableArray *arrayNotAvailbaleTrader;

@end
