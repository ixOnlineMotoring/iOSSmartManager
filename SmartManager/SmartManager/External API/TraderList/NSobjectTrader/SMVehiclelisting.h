//
//  SMVehiclelisting.h
//  SmartManager
//
//  Created by Jignesh on 10/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMVehiclelisting : NSObject

@property(nonatomic, strong) NSString *strVehicleName;
@property(nonatomic, strong) NSString *strVehicleColor;
@property(nonatomic, strong) NSString *strVehicleMakeName;
@property(nonatomic, strong) NSString *strVehiclePrice;
@property(nonatomic, strong) NSString *strVehicleTradePrice;
@property(nonatomic, strong) NSString *strVehicleMileage;
@property(nonatomic, strong) NSString *strLocation;
@property(nonatomic, strong) NSString *strVehicleMileageType;
@property(nonatomic, strong) NSString *strVehicleTeadeTimeLeft;
@property(nonatomic, strong) NSString *strVehicleID;
@property(nonatomic, strong) NSString *strVehicleImageURL;
@property(nonatomic, strong) NSString *strVehicleYear;
@property(nonatomic, strong) NSString *strVehicleCurrentBid; // this will be this highest bid on vehicle
@property(nonatomic)         BOOL      isBuyItNow;

@property(nonatomic, strong) NSMutableArray *arrayVehicleImages;

@property(assign) int mileageForSoring;
@property(assign)int timeLeftForSorting;
@property(assign)int priceForSorting;

@property(nonatomic, strong) NSString *strMyHighest;
@property(nonatomic, strong) NSString *strTotalHighest;

@property(assign) int intAutobidCap;

@property(nonatomic, strong) NSString *strUsedVehicleStockID;
//@property(nonatomic, strong) NSString *strAskingPrice;
@property(nonatomic, strong) NSString *strBiddingClosed;
@property(nonatomic, strong) NSString *strStockCode;
@property(nonatomic, strong) NSString *strVehicleType;
@property(nonatomic)         BOOL      isTrade;
@property(nonatomic, strong) NSString *strOfferAmount;
@property(nonatomic, strong) NSString *strOfferClient;
@property(nonatomic, strong) NSString *strOfferMember;
@property(nonatomic, strong) NSString *strOfferDate;
@property(nonatomic, strong) NSString *strOfferID;
@property(nonatomic, strong) NSString *strStatusWhen;
@property(nonatomic, strong) NSString *strStatusWho;
@property(nonatomic)         BOOL      hasOffers;
@property(nonatomic, strong) NSString *strOfferStart;
@property(nonatomic, strong) NSString *strOfferEnd;
@property(nonatomic, strong) NSString *strOfferStatus;
@property(nonatomic, strong) NSString *strSource;

@property(nonatomic, strong) NSString *strSoldDate;

@property(nonatomic) int intClientID;
@property(nonatomic, strong) NSString *strClientName;
@property(nonatomic, strong) NSString *strAmount;
@property(nonatomic, strong) NSString *strUser;
@property(nonatomic, strong) NSString *strBidDate;
@property(nonatomic, strong) NSString *strVehicleAge;

@property(nonatomic, strong) NSString *strTradeClosed;
@property(nonatomic, strong) NSString *strDealershipID;
@property(nonatomic, strong) NSString *strImageID;
@property(nonatomic, strong) NSString *strProvince;
@property(nonatomic, strong) NSString *strMDC;

@end
