//
//  SMViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 04/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMViewController.h"
#import "Fontclass.h"
#import "SMGlobalClass.h"

@interface SMViewController ()

@end

@implementation SMViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.btnDropDown setBackgroundColor:[UIColor clearColor]];
    
    // fontAwesome ID for User Image is 477

    [Fontclass AttributeStringMethodwithFontWithButton:self.btnLogout iconID:573];
    
    prefs = [NSUserDefaults standardUserDefaults];
             
    impersonateObj = [[SMImpersonateObject alloc]init];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblUserName.font   = [UIFont fontWithName:FONT_NAME size:11.0];
        self.lblClientName.font = [UIFont fontWithName:FONT_NAME size:11.0];
        self.lblCount.font      = [UIFont fontWithName:FONT_NAME_BOLD size:10.0];
    }
    else
    {
        self.lblUserName.font = [UIFont fontWithName:FONT_NAME size:14.0];
        self.lblClientName.font = [UIFont fontWithName:FONT_NAME size:14.0];
        self.lblCount.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    }
    
    self.lblUserName.text   = [prefs valueForKey:@"Name"];
    
    
    self.lblClientName.text = [prefs valueForKey:@"ClientName"];
    self.lblCount.text      = [prefs valueForKey:@"ClientID"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setClientName:) name:@"SetTheSelectedClientNameNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setTheTopHeaderData) name:@"setTheTopHeaderData" object:nil];
    
    
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:NO];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setClientName:(NSNotification *) notification
{
    impersonateObj = [notification object];

    self.lblClientName.text = impersonateObj.impersonateClientName;
    self.lblCount.text = impersonateObj.impersonateClientID;
    
    CGSize fontSize = [self.lblClientName.text sizeWithAttributes:@{NSFontAttributeName:self.lblClientName.font}];
    
    if(fontSize.width<=165)
    {
        self.lblClientName.frame = CGRectMake(self.lblClientName.frame.origin.x, self.lblClientName.frame.origin.y, fontSize.width, self.lblClientName.frame.size.height);
        
        self.lblCount.frame = CGRectMake(self.lblClientName.frame.origin.x+fontSize.width+5.0, self.lblCount.frame.origin.y, self.lblCount.frame.size.width, self.lblCount.frame.size.height);
    }
    else
    {
        self.lblClientName.frame = CGRectMake(self.lblClientName.frame.origin.x, self.lblClientName.frame.origin.y, 165, self.lblClientName.frame.size.height);
        
        self.lblCount.frame = CGRectMake(self.lblClientName.frame.origin.x+self.lblClientName.frame.size.width, self.lblCount.frame.origin.y, self.lblCount.frame.size.width, self.lblCount.frame.size.height);
    }
}

-(void)setTheTopHeaderData
{
    prefs = [NSUserDefaults standardUserDefaults];
    
    self.lblUserName.text = [NSString stringWithFormat:@"%@ %@",[prefs valueForKey:@"Name"],[prefs valueForKey:@"Surname"]];
    
    CGSize fontSizeUserName = [self.lblUserName.text sizeWithAttributes:@{NSFontAttributeName:self.lblUserName.font}];

    if( fontSizeUserName.width<=165)
    {
        self.btnDownArrow.frame = CGRectMake(self.lblUserName.frame.origin.x+fontSizeUserName.width+5.0, self.btnDownArrow.frame.origin.y, self.btnDownArrow.frame.size.width, self.btnDownArrow.frame.size.height);
    }

    self.lblCount.text = [prefs valueForKey:@"ClientID"];
    self.lblClientName.text = [prefs valueForKey:@"ClientName"];
    
    CGSize fontSizeClientName = [self.lblClientName.text sizeWithAttributes:@{NSFontAttributeName:self.lblClientName.font}];

    if(fontSizeClientName.width<=165)
    {
        self.lblClientName.frame = CGRectMake(self.lblClientName.frame.origin.x, self.lblClientName.frame.origin.y, fontSizeClientName.width, self.lblClientName.frame.size.height);

        self.lblCount.frame = CGRectMake(self.lblClientName.frame.origin.x+fontSizeClientName.width+5.0, self.lblCount.frame.origin.y, self.lblCount.frame.size.width, self.lblCount.frame.size.height);
    }
    else
    {
        self.lblClientName.frame = CGRectMake(self.lblClientName.frame.origin.x, self.lblClientName.frame.origin.y, 165, self.lblClientName.frame.size.height);
        
        self.lblCount.frame = CGRectMake(self.lblClientName.frame.origin.x+self.lblClientName.frame.size.width, self.lblCount.frame.origin.y, self.lblCount.frame.size.width, self.lblCount.frame.size.height);
    }
}

// the delegate is not set and called from here.. Its set and called from SMNavigationController class. we call the method by adding a target to the button - selector for the method that need to be implemented in the target class(in this case GridViewController class).

- (IBAction)btnDropDownDidClicked:(id)sender
{
    [self.dropDownDelegate showTheDropdown];
}
- (IBAction)btnLogoLogoutDidClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
