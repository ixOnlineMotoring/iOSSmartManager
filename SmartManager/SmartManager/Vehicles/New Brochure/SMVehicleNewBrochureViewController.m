//
//  SMVehicleNewBrochureViewController.m
//  Smart Manager
//
//  Created by Ketan Nandha on 22/09/17.
//  Copyright © 2017 SmartManager. All rights reserved.
//

#import "SMVehicleNewBrochureViewController.h"
#import "SMCustomTextField.h"

@interface SMVehicleNewBrochureViewController ()
{
    IBOutlet UIButton *btnShowHideFilter;

    IBOutlet UIImageView *imgArrowShowHide;

    IBOutlet NSLayoutConstraint *heightConstraintForFilterBox;
    
    IBOutlet NSLayoutConstraint *heightConstraintForFilterBoxIphones;
    
    

    IBOutlet SMCustomTextField *txtFieldSearch;

    IBOutlet SMCustomTextField *txtFieldSortBy;
    
    BOOL isFilterToBeHidden;


}

@end

@implementation SMVehicleNewBrochureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    btnShowHideFilter.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    isFilterToBeHidden = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)btnShowHideFilterDidClicked:(id)sender {
    
    isFilterToBeHidden = !isFilterToBeHidden;
    
    if(isFilterToBeHidden)
    {
        [btnShowHideFilter setTitle:@"Show Filter" forState:UIControlStateNormal];
        CGImageRef imageRef   = [[UIImage imageNamed:@"down_arrowT"]CGImage];
        UIImage *rotatedImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationUp];
        [imgArrowShowHide setImage:rotatedImage];
        heightConstraintForFilterBoxIphones.constant = 0;
        
    }
    else
    {
        [btnShowHideFilter setTitle:@"Hide Filter" forState:UIControlStateNormal];
        imgArrowShowHide.transform = CGAffineTransformMakeRotation(M_PI_2);
        heightConstraintForFilterBoxIphones.constant = 82;
    }
    
}
@end
