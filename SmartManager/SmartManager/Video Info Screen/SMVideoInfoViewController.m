//
//  SMVideoInfoViewController.m
//  Smart Manager
//
//  Created by Prateek Jain on 07/10/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMVideoInfoViewController.h"
#import "SMCommentVideosPhotosAddViewController.h"
#import "SMAddToStockViewController.h"
#import "SMStockVehicleDetailController.h"
@interface SMVideoInfoViewController ()

@end

@implementation SMVideoInfoViewController

void(^ getTheVideoInfoResponseCallBack)(int indexPath,BOOL isSearchable, NSString *videoTitle, NSString *videoTag,NSString *videoDesc);

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILabel *labelNavigationTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        labelNavigationTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:14.0];
    }
    else
    {
        labelNavigationTitle.font = [UIFont fontWithName:FONT_NAME_BOLD size:20.0];
    }
   
    labelNavigationTitle.backgroundColor = [UIColor clearColor];
    labelNavigationTitle.textColor = [UIColor whiteColor]; // change this color
    labelNavigationTitle.text =@"Video Info";
    self.navigationItem.titleView = labelNavigationTitle;
    [labelNavigationTitle sizeToFit];
    imgViewVideoThumnail.userInteractionEnabled = YES;
     btnSaveInfo.layer.cornerRadius=4.0f;
    txtViewDesc.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    txtViewDesc.layer.borderWidth= 0.8f;
    txtViewDesc.font = [UIFont fontWithName:FONT_NAME size:FONT_SIZE_iPHone];
    if(self.isVideoFromServer == YES)
    {
        
        txtFieldTags.userInteractionEnabled = NO;
        txtFieldTitle.userInteractionEnabled = NO;
        txtViewDesc.userInteractionEnabled = NO;
        btnSaveInfo.hidden = YES;
        /*txtFieldTitle.text = self.videoObject.videoTitle;
        txtFieldTags.text = self.videoObject.videoTags;
        txtViewDesc.text = self.videoObject.videoDescription;*/
        txtFieldTitle.text = self.vehicleName;
        txtFieldTags.text = self.vehicleName;
        txtViewDesc.text = self.vehicleName;
        btnIsSearchable.selected = self.videoObject.isSearchable;
        NSLog(@"BtnIsSearchable = %d",btnIsSearchable.isSelected);
        imgViewVideoThumnail.image = self.videoObject.thumnailImage;
        UITapGestureRecognizer *youTubevideoPlayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(youTubeVideoPlayTapHandler:)];
        [imgViewVideoThumnail addGestureRecognizer:youTubevideoPlayTap];
        
    }
    else
    {
            /*if(self.isFromListPage)
            {
                txtFieldTitle.text = self.videoObject.videoTitle;
                txtFieldTags.text = self.videoObject.videoTags;
                txtViewDesc.text = self.videoObject.videoDescription;
            }
            else*/
            {
                txtFieldTitle.text = self.vehicleName;
                txtFieldTags.text = self.vehicleName;
                txtViewDesc.text = self.vehicleName;
            }
        
        if(self.isFromSendBrochureDetailPage)
            btnIsSearchable.selected = NO;
        else
            btnIsSearchable.selected = YES;

        if(self.isFromCameraView)
        {
            imgViewVideoThumnail.image = self.thumbNailImage;
            
        }
        else
        {
            imgViewVideoThumnail.image = self.videoObject.thumnailImage;
        }
        
        UITapGestureRecognizer *videoPlayTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoPlayTapHandler:)];
        [imgViewVideoThumnail addGestureRecognizer:videoPlayTap];

    }
    
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    isDetailsSaved = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(pushBackToMainViewController)];
    
}

-(void)pushBackToMainViewController
{
    if(isDetailsSaved)
    {
        NSLog(@"isFromPhotosNExtrasDetailPage  =%d",self.isFromPhotosNExtrasDetailPage);
        NSLog(@"isFromSendBrochureDetailPage  =%d",self.isFromSendBrochureDetailPage);
        
        if(self.isFromPhotosNExtrasDetailPage && !self.isFromSendBrochureDetailPage)
        {
            SMCommentVideosPhotosAddViewController *mainView;
            for (UINavigationController *view in self.navigationController.viewControllers)
            {
                NSLog(@"Entered here....");
                //when found, do the same thing to find the MasterViewController under the nav controller
                if ([view isKindOfClass:[SMCommentVideosPhotosAddViewController class]])
                {
                    mainView = (SMCommentVideosPhotosAddViewController*)view;
                    
                }
            }
            
            [self.navigationController popToViewController:mainView animated:YES];
        }
        else if(!self.isFromPhotosNExtrasDetailPage && !self.isFromSendBrochureDetailPage)
        {
            SMAddToStockViewController *addToStockView;
            for (UINavigationController *view in self.navigationController.viewControllers)
            {
                //when found, do the same thing to find the MasterViewController under the nav controller
                if ([view isKindOfClass:[SMAddToStockViewController class]])
                {
                    addToStockView = (SMAddToStockViewController*)view;
                    
                }
            }
            
            [self.navigationController popToViewController:addToStockView animated:YES];
        }
        else
        {
            SMStockVehicleDetailController *sendBrochureView;
            for (UINavigationController *view in self.navigationController.viewControllers)
            {
                //when found, do the same thing to find the MasterViewController under the nav controller
                if ([view isKindOfClass:[SMStockVehicleDetailController class]])
                {
                    sendBrochureView = (SMStockVehicleDetailController*)view;
                    
                }
            }
            
            [self.navigationController popToViewController:sendBrochureView animated:YES];

        }
    }
    else if(self.isVideoFromServer)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        
        NSString *alertMsg = @"You have not saved the information. Are you sure you want to continue? ";
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Smart Manager" message:alertMsg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        alert.tag=101;
        [alert show];
    }
    
}

#pragma mark - PlayVideoTapGestureMethod
-(void)videoPlayTapHandler:(UITapGestureRecognizer *)videoPlayerGestureRecog
{
    NSLog(@"self.videoPathURL = %@",self.videoPathURL);
    
    MPMoviePlayerViewController *moviePlayeObj=[SMMoviePlayerClass allocMoviePlayerView:self.videoPathURL];
    
    [self presentViewController:moviePlayeObj animated:YES completion:^{}];
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlaybackStateDidChange:)
                                                 name:MPMoviePlayerPlaybackStateDidChangeNotification
                                               object:moviePlayeObj];
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayeObj];
}

#pragma mark - VideoPlayerNotification
-(void)moviePlaybackStateDidChange:(NSNotification *)notification
{
    MPMoviePlayerViewController *moviePlayerViewController = [notification object];
    
    if (moviePlayerViewController.moviePlayer.loadState == MPMovieLoadStatePlayable &&
        moviePlayerViewController.moviePlayer.playbackState != MPMoviePlaybackStatePlaying)
    {
        [moviePlayerViewController.moviePlayer play];
    }
    
    // Register to receive a notification when the movie has finished playing.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:moviePlayerViewController];
    moviePlayerViewController = nil;
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    MPMoviePlayerViewController *moviePlayerViewController = [notification object];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayerViewController];
    [self dismissMoviePlayerViewControllerAnimated];
    moviePlayerViewController = nil;
}

-(void)youTubeVideoPlayTapHandler:(UITapGestureRecognizer *)youtubeVideoPlayerGestureRecog
{
    NSLog(@"self.videoObject.localYouTubeURLLL = %@",self.videoObject.localYouTubeURL);
    if ( [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:self.videoObject.localYouTubeURL]] )
    {
        NSLog(@"Y entered here ???");
         [[UIApplication sharedApplication]openURL:[NSURL URLWithString:self.videoObject.localYouTubeURL]];
    }
    
  
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField delegate

-(BOOL)textFieldShouldReturn:(SMCustomTextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark -

#pragma mark -

-(void)textFieldDidBeginEditing:(SMCustomTextField *)textField
{
        CGPoint pt;
        CGRect rc = [textField bounds];
        rc = [textField convertRect:rc toView:scrollVieww];
        pt = rc.origin;
        pt.x = 0;
        pt.y -= 1;
        [scrollVieww setContentOffset:pt animated:NO];
        
}



#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    CGPoint pt;
    CGRect rc = [textView bounds];
    rc = [textView convertRect:rc toView:scrollVieww];
    pt = rc.origin;
    pt.x = 0;
    pt.y -= 1;
    [scrollVieww setContentOffset:pt animated:YES];
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
    CGPoint pt;
    [scrollVieww setContentOffset:pt animated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (IBAction)btnSearchableDidClicked:(UIButton*)sender
{
    sender.selected = !sender.selected;
}
+(void)getTheVideoInfoWithCallBack:(SMCompetionBlockVideoInfo)callBackVideoInfo
{
    getTheVideoInfoResponseCallBack = callBackVideoInfo;
}
- (IBAction)btnSaveInfoDidClicked:(id)sender
{
    if([self validateVideoInfo])
    {
        getTheVideoInfoResponseCallBack(self.indexpathOfSelectedVideo,btnIsSearchable.isSelected,txtFieldTitle.text,txtFieldTags.text,txtViewDesc.text);
        
        isDetailsSaved = YES;
         [self pushBackToMainViewController];
    }
   
    
}
-(BOOL)validateVideoInfo
{
    
    if(txtFieldTitle.text.length == 0)
    {
        SMAlert(KLoaderTitle, @"Please enter the title");
        [txtFieldTitle becomeFirstResponder];
        return NO;
    }
    else if (txtFieldTags.text.length==0)
    {
        SMAlert(KLoaderTitle, @"Please enter the tag");
        [txtFieldTags becomeFirstResponder];
        return NO;
        
    }
    else  if (txtViewDesc.text.length==0)
    {
        SMAlert(KLoaderTitle, @"Please enter the description");
        [txtViewDesc becomeFirstResponder];
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag== 101)
    {
         if(buttonIndex == 1)
         {
             if(self.isFromPhotosNExtrasDetailPage && !self.isFromSendBrochureDetailPage)
             {
                 SMCommentVideosPhotosAddViewController *mainView;
                 for (UINavigationController *view in self.navigationController.viewControllers)
                 {
                     //when found, do the same thing to find the MasterViewController under the nav controller
                     if ([view isKindOfClass:[SMCommentVideosPhotosAddViewController class]])
                     {
                         mainView = (SMCommentVideosPhotosAddViewController*)view;
                         
                     }
                 }
                 
                 [self.navigationController popToViewController:mainView animated:YES];
             }
             else if(!self.isFromPhotosNExtrasDetailPage && !self.isFromSendBrochureDetailPage)
             {
                 SMAddToStockViewController *addToStockView;
                 for (UINavigationController *view in self.navigationController.viewControllers)
                 {
                     //when found, do the same thing to find the MasterViewController under the nav controller
                     if ([view isKindOfClass:[SMAddToStockViewController class]])
                     {
                         addToStockView = (SMAddToStockViewController*)view;
                         
                     }
                 }
                 
                 [self.navigationController popToViewController:addToStockView animated:YES];
             }
             else
             {
                 SMStockVehicleDetailController *sendBrochureView;
                 for (UINavigationController *view in self.navigationController.viewControllers)
                 {
                     //when found, do the same thing to find the MasterViewController under the nav controller
                     if ([view isKindOfClass:[SMStockVehicleDetailController class]])
                     {
                         sendBrochureView = (SMStockVehicleDetailController*)view;
                         
                     }
                 }
                 
                 [self.navigationController popToViewController:sendBrochureView animated:YES];
                 
             }
         }
    }
}

@end
