//
//  SMListActiveSpecialsCellTableViewCell.m
//  SmartManager
//
//  Created by Sandeep on 20/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMListActiveSpecialsCell.h"

@implementation SMListActiveSpecialsCell

@synthesize imgViewActive;
@synthesize lblVehicleName;
@synthesize lblVehicleDetail;

@synthesize lblColor;
@synthesize lblRegistration;
@synthesize lblMileage;
@synthesize lblDaysRemaning;
//@synthesize lblActive;

@synthesize lblNormal;
@synthesize lblSpecial;
@synthesize lblSave;

@synthesize lblNormalPrice;
@synthesize lblSpecialPrice;
@synthesize lblSavePrice;

@synthesize lblCreated;
@synthesize lblFrom;
@synthesize lblTo;
@synthesize lblCreatedDate;
@synthesize lblFromDate;
@synthesize lblToDate;

@synthesize btnEnd;
@synthesize btnEdit;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
