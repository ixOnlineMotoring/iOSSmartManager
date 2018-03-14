//
//  SMPhotosAndExtrasTableViewCell.m
//  SmartManager
//
//  Created by Sandeep on 03/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMPhotosAndExtrasTableViewCell.h"

@implementation SMPhotosAndExtrasTableViewCell
@synthesize lblVehicleName;
@synthesize lblRegistration;
@synthesize lblColour;
@synthesize lblStockCode;
@synthesize lblTradePrice;
@synthesize lblVehicleType;
@synthesize lblRetailPrice;
@synthesize lblMileage;
@synthesize lblRemaingDaysCount;
@synthesize lblExtras;
@synthesize lblComments;
@synthesize lblPhotos;
@synthesize lblPhotoCount;
@synthesize lblVideos;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    self.backgroundColor=[UIColor blackColor];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblRegistration.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblColour.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        
        self.lblStockCode.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblVehicleName.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblVehicleType.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblRetailPrice.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblTradePrice.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblMileage.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        self.lblRemaingDaysCount.font=[UIFont fontWithName:FONT_NAME_BOLD size:14.0f];
        
       // self.lblPhotoCount.font=[UIFont fontWithName:FONT_NAME_BOLD size:10.0f];
       // self.lblExtras.font=[UIFont fontWithName:FONT_NAME size:10.0f];
       // self.lblComments.font=[UIFont fontWithName:FONT_NAME size:10.0f];
       // self.lblPhotos.font=[UIFont fontWithName:FONT_NAME size:10.0f];
       // self.lblVideos.font=[UIFont fontWithName:FONT_NAME size:10.0f];
        
        self.lblExtrasImage.font=[UIFont fontWithName:FONT_NAME size:14.0f];
        self.lblCommentsImage.font=[UIFont fontWithName:FONT_NAME size:14.0f];
        //self.lblVideosImage.font=[UIFont fontWithName:FONT_NAME_BOLD size:10.0f];
    }
    else
    {
        self.lblRegistration.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.lblColour.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        
        self.lblStockCode.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.lblVehicleName.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        //self.lblPrice.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.lblMileage.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.lblRemaingDaysCount.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        
        self.lblPhotoCount.font=[UIFont fontWithName:FONT_NAME_BOLD size:20.0f];
        self.lblExtras.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblComments.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblPhotos.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblVideos.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        
        self.lblExtrasImage.font=[UIFont fontWithName:FONT_NAME size:20.0f];
        self.lblCommentsImage.font=[UIFont fontWithName:FONT_NAME size:20.0f];
       // self.lblVideosImage.font=[UIFont fontWithName:FONT_NAME size:20.0f];
    }
}

@end
