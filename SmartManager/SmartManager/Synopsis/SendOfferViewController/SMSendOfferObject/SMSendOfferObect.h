//
//  SMSendOfferObect.h
//  Smart Manager
//
//  Created by Ketan Nandha on 07/07/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMSendOfferObect : NSObject

@property(strong,nonatomic)NSString *sellerName;
@property(strong,nonatomic)NSString *sellerSurName;
@property(strong,nonatomic)NSString *sellerCompany;
@property(strong,nonatomic)NSString *sellerEmail;
@property(strong,nonatomic)NSString *sellerMobile;
@property(strong,nonatomic)NSString *sellerMyOffer;
@property(strong,nonatomic)NSString *offerExpiry;
@property(strong,nonatomic)NSString *strOfferExpiryDays;
@property(strong,nonatomic)NSString *strOfferSMSContent;
@property(strong,nonatomic)NSString *strEmailSubjectContent;
@property(strong,nonatomic)NSString *strEmailBodyContent;

@end
