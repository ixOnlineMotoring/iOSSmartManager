//
//  SMSearchBlogGalleryImageCell.h
//  SmartManager
//
//  Created by Liji Stephen on 02/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SMSearchBlogGalleryDelegate <NSObject>


-(void)passTheIndexOfSelectedCell:(int)index;

@end


@interface SMSearchBlogGalleryImageCell : UITableViewCell<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblViewSlider;
@property (strong, nonatomic) id <SMSearchBlogGalleryDelegate>delegate;

@property(strong,nonatomic) NSMutableArray *arrOfSearchResultObjects;




@end
