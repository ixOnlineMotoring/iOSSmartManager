//
//  SMCarTouchRecognitionViewController.h
//  Smart Manager
//
//  Created by Prateek Jain on 07/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCarTouchRecognitionViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIImageView *imgViewCar;
    IBOutlet UIView *contentView;
    
    
}

- (IBAction)btnBumperFrontDidClicked:(id)sender;
- (IBAction)btnGrillDidClicked:(id)sender;
- (IBAction)btnLeftHeadLightDidClicked:(id)sender;
- (IBAction)btnRightHeadLightDidClicked:(id)sender;
- (IBAction)btnLeftFenderDidClicked:(id)sender;
- (IBAction)btnRightFenderDidClicked:(id)sender;
- (IBAction)btnBonetDidClicked:(id)sender;
- (IBAction)btnLeftTyreDidClicked:(id)sender;
- (IBAction)btnLeftRimDidClicked:(id)sender;
- (IBAction)btnRightTyreDidClicked:(id)sender;
- (IBAction)btnRightRimDidClicked:(id)sender;
- (IBAction)btnWipersDidClicked:(id)sender;
- (IBAction)btnFrontWindScreenDidClicked:(id)sender;
- (IBAction)btnRightDoorDidClicked:(id)sender;
- (IBAction)btnRightWindowDidClicked:(id)sender;
- (IBAction)btnSunRoofDidClicked:(id)sender;
- (IBAction)btnLeftDoorDidClicked:(id)sender;
- (IBAction)btnLeftWindowDidClicked:(id)sender;
- (IBAction)btnRightRearDoorDidClicked:(id)sender;
- (IBAction)btnRightRearWindowDidClicked:(id)sender;
- (IBAction)btnRoofDidClicked:(id)sender;
- (IBAction)btnLeftRearWindowDidClicked:(id)sender;
- (IBAction)btnLeftRearDoorDidClicked:(id)sender;
- (IBAction)btnRearWindScreenDidClicked:(id)sender;
- (IBAction)btnRightRearTyreDidClicked:(id)sender;
- (IBAction)btnRightRearRimDidClicked:(id)sender;
- (IBAction)btnRightRearFenderDidClicked:(id)sender;
- (IBAction)btnSpareWheelDidClicked:(id)sender;
- (IBAction)btnBootDidClicked:(id)sender;
- (IBAction)btnToolsDidClicked:(id)sender;
- (IBAction)btnRightTailLightDidClicked:(id)sender;
- (IBAction)btnBumperRearDidClicked:(id)sender;
- (IBAction)btnExhaustDidClicked:(id)sender;
- (IBAction)btnLeftTailLightDidClicked:(id)sender;
- (IBAction)btnLeftRearFenderDidClicked:(id)sender;
- (IBAction)btnLeftRearTyreDidClicked:(id)sender;
- (IBAction)btnLeftRearRimDidClicked:(id)sender;






@end
