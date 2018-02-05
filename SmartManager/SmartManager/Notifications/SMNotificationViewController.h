//
//  SMNotificationViewController.h
//  SmartManager
//
//  Created by Jignesh on 29/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMNotificationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    float sizeFrame;


}


-(IBAction)buttonSectionedPressed:(id)sender;


@property(strong,nonatomic) IBOutlet UITableView *tableNotification;


@property(strong,nonatomic) IBOutlet UIButton   *buttonLeadsReceived;
@property(strong,nonatomic) IBOutlet UIButton   *buttonLeadsUpdateDue;
@property(strong,nonatomic) IBOutlet UIButton   *buttonMessages;

@property(strong,nonatomic) IBOutlet UIView     *viewbuttonLeadsReceived;
@property(strong,nonatomic) IBOutlet UIView     *viewbuttonLeadsUpdateDue;
@property(strong,nonatomic) IBOutlet UIView     *viewbuttonMessages;


@property(strong,nonatomic) IBOutlet UIImageView   *imageArrowbuttonLeadsReceived;
@property(strong,nonatomic) IBOutlet UIImageView   *imageArrowbuttonLeadsUpdateDue;
@property(strong,nonatomic) IBOutlet UIImageView   *imageArrowbuttonMessages;

@end
