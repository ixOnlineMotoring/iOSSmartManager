//
//  SMCellOfPlusImageCommentPV.h
//  SmartManager
//
//  Created by Sandeep on 07/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCellOfPlusImageCommentPV : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIButton *btnDelete;
@property (strong, nonatomic) IBOutlet UIImageView *imgActualImage;
@property (strong, nonatomic) IBOutlet UIImageView *imgPlusImage;
@property (strong, nonatomic) IBOutlet UIWebView *webVYouTube;

@property (weak, nonatomic) IBOutlet UIImageView *imgViewPlayVideo;



@end
