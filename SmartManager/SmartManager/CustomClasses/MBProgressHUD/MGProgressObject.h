//
//  MGProgressObject.h
//  Menu2Go
//
//  Created by Prateek on 1/2/14.
//  Copyright (c) 2014 Menu2Go. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MGProgressObject : NSObject
{
    
}

@property (nonatomic, strong) MBProgressHUD *HUD;

+(MGProgressObject*)sharedInstance;

-(void)showProgressHUDWithText:(NSString*)text;
-(void)hideProgressHUD;

@end