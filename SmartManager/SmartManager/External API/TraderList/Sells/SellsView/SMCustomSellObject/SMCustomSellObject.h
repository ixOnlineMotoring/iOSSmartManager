//
//  SMCustomSellObject.h
//  SmartManager
//
//  Created by Ketan Nandha on 07/01/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMCustomSellObject : NSObject

@property (nonatomic) int activeBid;
@property (nonatomic) int biddingEnded;
@property (nonatomic) int availableToTrade;
@property (nonatomic) int notAvailableToTrade;

@property (nonatomic) int loosingBid;
@property (nonatomic) int winningBid;
@property (nonatomic) int wonBid;
@property (nonatomic) int lostBid;

@end
