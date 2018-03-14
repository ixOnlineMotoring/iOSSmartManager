//
//  SMPreviewBlogViewController.h
//  SmartManager
//
//  Created by Liji Stephen on 29/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMSaveBlogDataObject.h"

@protocol SMSaveTheBlogFromPreviewDelegate <NSObject>


-(void)SaveTheBlogFromPreview;

@end

@interface SMPreviewBlogViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UIView *viewHeaderView;

@property (strong, nonatomic) IBOutlet UIView *viewFooterView;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (strong, nonatomic) IBOutlet UILabel *lblName;

@property (strong, nonatomic) IBOutlet UILabel *lblDetails;

@property (strong, nonatomic) IBOutlet UITableView *tblViewPreviewBlog;

@property(assign)BOOL isFromEditBlog;

@property(strong,nonatomic)SMSaveBlogDataObject *previewBlogObj;

@property (strong,nonatomic) id<SMSaveTheBlogFromPreviewDelegate> previewDelegate;

@end
