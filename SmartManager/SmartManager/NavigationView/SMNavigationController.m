//
//  SMNavigationController.m
//  SmartManager
//
//  Created by Liji Stephen on 03/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMNavigationController.h"
#import "FGalleryViewController.h"


@interface SMNavigationController ()

@end

@implementation SMNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//-(id)initWithRootViewController:(UIViewController *)rootViewController
//{
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.headerViewController = [[SMViewController alloc]initWithNibName:@"SMViewController" bundle:nil];
    }
    else
    {
        self.headerViewController = [[SMViewController alloc]initWithNibName:@"SMViewController_iPad" bundle:nil];
    }

    self.headerViewController.dropDownDelegate = self;
    self.headerViewController.profilePicBackNavigationDelegate = self;
    // Do any additional setup after loading the view.
}

#pragma mark - Navigation Controller Customizations

-(void)addHeader:(UIViewController *)viewController
{
    self.viewController = viewController;
    [viewController.navigationItem setTitleView:self.headerViewController.view];
    [self.headerViewController.btnDropDown addTarget:viewController action:@selector(showTheDropdown) forControlEvents:UIControlEventTouchUpInside];
    [self.headerViewController.btnLogout addTarget:viewController action:@selector(showHomeScreenOnClickingProfilePic) forControlEvents:UIControlEventTouchUpInside];
}

-(void)customizeNavigationController:(UINavigationController *)navigationController
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]<7.0)
    {
        // [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header_bg"] forBarMetrics:UIBarMetricsDefault];
        
        /*[navigationController.navigationBar setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor],UITextAttributeFont:[UIFont fontWithName:FONT_NAME size:12.0]}];
         
         [[UIBarButtonItem appearance] setTitleTextAttributes:@{UITextAttributeTextColor:[UIColor whiteColor],
         UITextAttributeFont:[UIFont fontWithName:FONT_NAME size:14.0]}
         forState:UIControlStateNormal];*/
    }
    else
    {
        [navigationController.navigationBar setTranslucent:NO];
        [navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        
    }
}

/*
-(NSUInteger)supportedInterfaceOrientations
{
    NSLog(@"supportedInterfaceOrientations = %lu ", (unsigned long)[self.topViewController supportedInterfaceOrientations]);
    
    return [self.topViewController supportedInterfaceOrientations];
}

-(BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // You do not need this method if you are not supporting earlier iOS Versions
    
    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

*/


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
