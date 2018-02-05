//
//  SMPreviewBlogViewController.m
//  SmartManager
//
//  Created by Liji Stephen on 29/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMPreviewBlogViewController.h"
#import "SMPreviewImageCell.h"
#import "SMCustomColor.h"

@interface SMPreviewBlogViewController ()

@end

@implementation SMPreviewBlogViewController

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
    
    self.navigationItem.titleView = [SMCustomColor setTitle:@"Preview Blog"];
    
    self.tblViewPreviewBlog.tableHeaderView = self.viewHeaderView;
    self.tblViewPreviewBlog.tableFooterView = self.viewFooterView;
    
    self.lblTitle.text = self.previewBlogObj.strTitle;
    
    
    [self setAttributedTextWithName:self.previewBlogObj.strAuthorName andWithPostedOnDate:self.previewBlogObj.strPostedDate andExpiresOn:([self.previewBlogObj.strExpiryDate length]==0)?@"Never Ends":self.previewBlogObj.strExpiryDate forLabel:self.lblName];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"postNotificationForLoadingGalleryImages" object:self.previewBlogObj.arrOfImages
     ];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblTitle.font = [UIFont fontWithName:FONT_NAME size:20.0];
        self.lblDetails.font = [UIFont fontWithName:FONT_NAME size:15.0];
    }
    else
    {
        self.lblTitle.font = [UIFont fontWithName:FONT_NAME size:25.0];
        self.lblDetails.font = [UIFont fontWithName:FONT_NAME size:22.0];
    }
    
    UIBarButtonItem *saveButton;
    
    if(self.isFromEditBlog)
    {
        saveButton =[[UIBarButtonItem alloc]initWithTitle:@"Update" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    }
    else
    {
        saveButton =[[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveButtonAction)];
    }
    
    [[UIButton appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleColor:[UIColor colorWithRed:82.0f/255.0f green:82.0f/255.0f blue:102.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    [self registerNib];
}


-(void)viewWillAppear:(BOOL)animated
{
    self.lblDetails.text = self.previewBlogObj.strBlogDetails;
    [self.lblDetails sizeToFit];

}


- (void)registerNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblViewPreviewBlog registerNib:[UINib nibWithNibName:@"SMPreviewImageCell" bundle:nil] forCellReuseIdentifier:@"SMPreviewImageCell"];
    }
    else
    {
        [self.tblViewPreviewBlog registerNib:[UINib nibWithNibName:@"SMPreviewImageCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMPreviewImageCell"];
    }
}

#pragma  mark - TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.previewBlogObj.arrOfImages.count>0)
    return 233.0;
    
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier= @"SMPreviewImageCell";
        
    SMPreviewImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.arrayOfGalleryImages = self.previewBlogObj.arrOfImages;
    [cell.tblViewOfPhotos reloadData];
    
    return cell;
}

#pragma mark - Set Attributed Text

- (void)setAttributedTextWithName:(NSString*)name andWithPostedOnDate:(NSString*)postedDate andExpiresOn:(NSString*)expiryDate forLabel:(UILabel*)label
{
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=6.0)
    {
        UIFont *regularFont;
        
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
        {
            regularFont = [UIFont fontWithName:FONT_NAME size:14.0];
        }
        else
        {
            regularFont = [UIFont fontWithName:FONT_NAME size:20.0];
        }
       // UIFont *regularFont = [UIFont boldSystemFontOfSize:11.0];
        UIColor *foregroundColorGrey = [UIColor grayColor];
        UIColor *foregroundColorBlue = [UIColor colorWithRed:68.0/255.0 green:138.0/255.0 blue:199.0/208.0 alpha:1.0];
        
        // Create the attributes
        
        NSDictionary *ByAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                     regularFont, NSFontAttributeName,
                                     foregroundColorGrey, NSForegroundColorAttributeName, nil];
        
        NSDictionary *PostedStringAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                           regularFont, NSFontAttributeName,
                                           foregroundColorGrey, NSForegroundColorAttributeName, nil];
        
        NSDictionary *NameAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                        regularFont, NSFontAttributeName,
                                        foregroundColorBlue, NSForegroundColorAttributeName, nil];
        
        NSDictionary *NeverEndsAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                       regularFont, NSFontAttributeName,
                                       foregroundColorBlue, NSForegroundColorAttributeName, nil];
        
        NSDictionary *NotNeverEndsAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                            regularFont, NSFontAttributeName,
                                            foregroundColorBlue, NSForegroundColorAttributeName, nil];
        
        NSDictionary *PostedOnAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                           regularFont, NSFontAttributeName,
                                           foregroundColorBlue, NSForegroundColorAttributeName, nil];
        
        NSDictionary *ExpiresOnAttribute = [NSDictionary dictionaryWithObjectsAndKeys:
                                           regularFont, NSFontAttributeName,
                                           foregroundColorGrey, NSForegroundColorAttributeName, nil];
        
        NSMutableAttributedString *attributedTextForBy = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"By"] attributes:ByAttribute];
        
        NSMutableAttributedString *attributedTextForName;
        NSMutableAttributedString *attributedTextForPostedOnString;
        
        if ([name length]==0)
        {
            attributedTextForName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",name] attributes:NameAttribute];
            
            attributedTextForPostedOnString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Posted On "] attributes:PostedStringAttribute];
        }
        else
        {
            attributedTextForName = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",name] attributes:NameAttribute];
            
            attributedTextForPostedOnString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" | Posted On "] attributes:PostedStringAttribute];
        }
        
        NSMutableAttributedString *attributedTextForPostDate = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",postedDate] attributes:PostedOnAttribute];
        
        NSMutableAttributedString *attributedTextForExpiryDate = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"| Expires On"] attributes:ExpiresOnAttribute];
        
        NSMutableAttributedString *attributedTextForNeverEnds = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",expiryDate] attributes:NeverEndsAttribute];
        
        NSMutableAttributedString *attributedTextForNotNeverEnds = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",expiryDate] attributes:NotNeverEndsAttribute];

        if([expiryDate isEqualToString:@"Never Ends"])
        {
            [attributedTextForExpiryDate appendAttributedString:attributedTextForNeverEnds];
        }
        else
        {
            [attributedTextForExpiryDate appendAttributedString:attributedTextForNotNeverEnds];
        }
        
        [attributedTextForPostDate appendAttributedString:attributedTextForExpiryDate];
        [attributedTextForPostedOnString appendAttributedString:attributedTextForPostDate];
        
        [attributedTextForName appendAttributedString:attributedTextForPostedOnString];
        
        [attributedTextForBy appendAttributedString:attributedTextForName];
        // Set it in our UILabel and we are done!
        
        if([name length] == 0)
            [label setAttributedText:attributedTextForPostedOnString];
        else
            [label setAttributedText:attributedTextForBy];
    }
}

#pragma mark - Custom methods

-(void)saveButtonAction
{
    
    [self.previewDelegate SaveTheBlogFromPreview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
