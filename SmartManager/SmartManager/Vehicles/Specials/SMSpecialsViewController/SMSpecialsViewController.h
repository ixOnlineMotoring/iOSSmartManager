//
//  SMSpecialsViewController.h
//  SmartManager
//
//  Created by Sandeep on 19/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMCreateSpecialViewController.h"
#import "SMListActiveSpecialsViewController.h"
#import "SMListExpiredSpecialsViewController.h"
#import "SMCustomLable.h"
@interface SMSpecialsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnCreateSpecial;
@property (weak, nonatomic) IBOutlet UIButton *btnListActiveSpecials;
@property (weak, nonatomic) IBOutlet UIButton *btnListExpiredSpedials;
- (IBAction)createSpecialDidClick:(id)sender;
- (IBAction)listActiveSpecialsDidClick:(id)sender;
- (IBAction)listExpiredSpecialsDidClick:(id)sender;

- (IBAction)btnListUnPublishedDidClicked:(id)sender;



@property (weak, nonatomic)   IBOutlet SMCustomLable *lblDetail;

@end
