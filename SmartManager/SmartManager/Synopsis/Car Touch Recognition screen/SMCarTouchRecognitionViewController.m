//
//  SMCarTouchRecognitionViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 07/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMCarTouchRecognitionViewController.h"
#import "SMCarTouchRecognitionDetailViewController.h"
#import "UIBAlertView.h"


@interface SMCarTouchRecognitionViewController ()
{
    NSString *strCarPartSelected;

}

@end

@implementation SMCarTouchRecognitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.navigationItem.titleView = [SMCustomColor setTitle:@"Select Recon Item / Area"];
    //scrollView.contentSize  = imgViewCar.image.size;
  //  imgViewCar.image = [UIImage imageNamed:@"splat"];
    imgViewCar.contentMode = UIViewContentModeScaleToFill;
    imgViewCar.backgroundColor = [UIColor clearColor];
    imgViewCar.userInteractionEnabled = YES;
    //[scrollView addSubview:imgViewCar];
    scrollView.contentSize = contentView.bounds.size;
    scrollView.minimumZoomScale = 1.0f;
    scrollView.maximumZoomScale = 8.0f;
    scrollView.delegate = self;

   
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //scrollView.contentSize  = CGSizeMake(self.view.bounds.size.width,imgViewCar.frame.origin.y + imgViewCar.frame.size.height + 100.0f);

}
-(void)viewWillDisappear:(BOOL)animated
{
    scrollView.zoomScale = .37;

}


- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return contentView;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView1 withView:(UIView *)view atScale:(CGFloat)scale
{
   
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)alertTheUserAndNavigateToNewScreenWithArea:(NSString*)selectedArea
{
    UIBAlertView *alert = [[UIBAlertView alloc] initWithTitle:KLoaderTitle message:[NSString stringWithFormat:@" You selected %@. Is this correct? ",selectedArea] cancelButtonTitle:nil otherButtonTitles:@"No",@"Yes",nil];
    [alert showWithDismissHandler:^(NSInteger selectedIndex, NSString *selectedTitle, BOOL didCancel)
     {
         
         switch (selectedIndex)
         {
             case 1:
             {
                 SMCarTouchRecognitionDetailViewController *carTouchDetailViewController;
                 
                 carTouchDetailViewController = [[SMCarTouchRecognitionDetailViewController alloc] initWithNibName:@"SMCarTouchRecognitionDetailViewController" bundle:nil];
                 carTouchDetailViewController.selectedCarArea = selectedArea;
                 carTouchDetailViewController.selectedCarPartNumber = strCarPartSelected;
                 [self.navigationController pushViewController:carTouchDetailViewController animated:YES];
             }
                 break;
             default:
                 break;
         }
     }];

}


- (IBAction)btnBumperFrontDidClicked:(id)sender
{
    
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Bumper Front"];
    strCarPartSelected = @"1";
    
}

- (IBAction)btnGrillDidClicked:(id)sender
{
   [self alertTheUserAndNavigateToNewScreenWithArea:@"Grill"];
    strCarPartSelected = @"2";
}

- (IBAction)btnLeftHeadLightDidClicked:(id)sender
{
   [self alertTheUserAndNavigateToNewScreenWithArea:@"Headlight LF"];
    strCarPartSelected = @"3";
}

- (IBAction)btnRightHeadLightDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Headlight RF"];
    strCarPartSelected = @"4";
}

- (IBAction)btnLeftFenderDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Fender LF"];
    strCarPartSelected = @"5";
}

- (IBAction)btnRightFenderDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Fender RF"];
    strCarPartSelected = @"6";
}

- (IBAction)btnBonetDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Bonet"];
    strCarPartSelected = @"7";
}

- (IBAction)btnLeftTyreDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Tyre LF"];
    strCarPartSelected = @"8";
}

- (IBAction)btnLeftRimDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Rim LF"];
    strCarPartSelected = @"10";
}

- (IBAction)btnRightTyreDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Tyre RF"];
    strCarPartSelected = @"9";
}

- (IBAction)btnRightRimDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Rim RF"];
    strCarPartSelected = @"11";
}

- (IBAction)btnWipersDidClicked:(id)sender
{
     [self alertTheUserAndNavigateToNewScreenWithArea:@"Wipers"];
    strCarPartSelected = @"12";
}

- (IBAction)btnFrontWindScreenDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Windscreen Front"];
    strCarPartSelected = @"13";
}

- (IBAction)btnRightDoorDidClicked:(id)sender
{
     [self alertTheUserAndNavigateToNewScreenWithArea:@"Door RF"];
    strCarPartSelected = @"15";
}

- (IBAction)btnRightWindowDidClicked:(id)sender
{
     [self alertTheUserAndNavigateToNewScreenWithArea:@"Window RF"];
    strCarPartSelected = @"17";
}

- (IBAction)btnSunRoofDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Sunroof"];
    strCarPartSelected = @"18";
}

- (IBAction)btnLeftDoorDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Door LF"];
    strCarPartSelected = @"14";
}

- (IBAction)btnLeftWindowDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Window LF"];
    strCarPartSelected = @"16";
}

- (IBAction)btnRightRearDoorDidClicked:(id)sender
{
     [self alertTheUserAndNavigateToNewScreenWithArea:@"Door RR"];
    strCarPartSelected = @"22";
}

- (IBAction)btnRightRearWindowDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Window RR"];
    strCarPartSelected = @"20";
}

- (IBAction)btnRoofDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Roof"];
    strCarPartSelected = @"23";
}

- (IBAction)btnLeftRearWindowDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Window LR"];
    strCarPartSelected = @"19";
}

- (IBAction)btnLeftRearDoorDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Door LR"];
    strCarPartSelected = @"21";
}

- (IBAction)btnRearWindScreenDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Windscreen Rear"];
    strCarPartSelected = @"24";
}

- (IBAction)btnRightRearTyreDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Tyre RR"];
    strCarPartSelected = @"26";
}

- (IBAction)btnRightRearRimDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Rim RR"];
    strCarPartSelected = @"28";
}

- (IBAction)btnRightRearFenderDidClicked:(id)sender
{
     [self alertTheUserAndNavigateToNewScreenWithArea:@"Fender RR"];
    strCarPartSelected = @"33";
}

- (IBAction)btnSpareWheelDidClicked:(id)sender
{
     [self alertTheUserAndNavigateToNewScreenWithArea:@"Spare Wheel"];
    strCarPartSelected = @"30";
}

- (IBAction)btnBootDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Boot"];
    strCarPartSelected = @"31";
}

- (IBAction)btnToolsDidClicked:(id)sender
{
     [self alertTheUserAndNavigateToNewScreenWithArea:@"Tools"];
    strCarPartSelected = @"29";
}

- (IBAction)btnRightTailLightDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Taillight RR"];
    strCarPartSelected = @"35";
}

- (IBAction)btnBumperRearDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Bumper Rear"];
    strCarPartSelected = @"36";
}

- (IBAction)btnExhaustDidClicked:(id)sender
{
     [self alertTheUserAndNavigateToNewScreenWithArea:@"Exhaust"];
    strCarPartSelected = @"37";
}

- (IBAction)btnLeftTailLightDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Taillight LR"];
    strCarPartSelected = @"34";
}

- (IBAction)btnLeftRearFenderDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Fender LR"];
    strCarPartSelected = @"32";
}

- (IBAction)btnLeftRearTyreDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Tyre LR"];
    strCarPartSelected = @"25";
}

- (IBAction)btnLeftRearRimDidClicked:(id)sender
{
    [self alertTheUserAndNavigateToNewScreenWithArea:@"Rim LR"];
    strCarPartSelected = @"27";
}


@end
