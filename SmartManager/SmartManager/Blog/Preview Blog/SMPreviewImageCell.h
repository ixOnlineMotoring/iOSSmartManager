//
//  SMPreviewImageCell.h
//  SmartManager
//
//  Created by Liji Stephen on 29/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMPreviewImageCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) IBOutlet UITableView *tblViewOfPhotos;

@property (strong, nonatomic)   NSMutableArray *arrayOfGalleryImages;

@end
