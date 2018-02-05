//
//  MGProgressObject.m
//  Menu2Go
//
//  Created by Prateek on 1/2/14.
//  Copyright (c) 2014 Menu2Go. All rights reserved.
//

#import "MGProgressObject.h"
#import "SMAppDelegate.h"
static MGProgressObject *sharedInstance;

@implementation MGProgressObject

@synthesize HUD;

+(MGProgressObject *)sharedInstance{
    
    @synchronized([MGProgressObject class]){
        
        if (sharedInstance==nil) {
            sharedInstance=[[self alloc]init];
            
        }
        
        return sharedInstance;
    }
    
    return nil;
}

-(id)init
{
    self.HUD = [[MBProgressHUD alloc] init];
    self.HUD.opacity = 1.0;
    self.HUD.color = [UIColor blackColor];
    return self;
}

-(void)showProgressHUDWithText:(NSString*)text
{
    SMAppDelegate *appDelegate = (SMAppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate.window.rootViewController.view addSubview:[MGProgressObject sharedInstance].HUD];
    
    [MGProgressObject sharedInstance].HUD.labelText = text;
    [[MGProgressObject sharedInstance].HUD show:YES];
}

-(void)hideProgressHUD
{
    [[MGProgressObject sharedInstance].HUD hide:YES];
}

@end