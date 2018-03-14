//
//  SMNewsPricePlotterXmlObject.h
//  Smart Manager
//
//  Created by Ankit S on 6/30/16.
//  Copyright © 2016 SmartManager. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMNewPricePlotterObject.h"
@interface SMNewsPricePlotterXmlObject : NSObject
@property int iStatus;
@property (strong,nonatomic) NSMutableArray *arrmGraphPoints;
@end
