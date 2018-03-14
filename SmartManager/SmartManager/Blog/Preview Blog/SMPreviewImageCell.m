//
//  SMPreviewImageCell.m
//  SmartManager
//
//  Created by Liji Stephen on 29/09/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMPreviewImageCell.h"
#import "SMPreviewGalleryImageCell.h"
#import "SMClassOfBlogImages.h"
#import "UIImageView+WebCache.h"
#import "SMWebServices.h"

@implementation SMPreviewImageCell

@synthesize arrayOfGalleryImages;
- (void)awakeFromNib
{
    // Initialization code
    
      [self.tblViewOfPhotos.layer setAffineTransform:CGAffineTransformMakeRotation(-M_PI_2)];
      //self.tblViewOfPhotos.backgroundColor = [UIColor lightGrayColor];
//      [self setFrameForTableViewOfImages];
    
      [self.tblViewOfPhotos registerNib:[UINib nibWithNibName:@"SMPreviewGalleryImageCell" bundle:nil] forCellReuseIdentifier:@"SMPreviewGalleryImageCell"];
    
    self.tblViewOfPhotos.dataSource = self;
    self.tblViewOfPhotos.delegate = self;
    arrayOfGalleryImages = [[NSMutableArray alloc]init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadTheGalleryImages:) name:@"postNotificationForLoadingGalleryImages" object:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



#pragma  mark - TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [arrayOfGalleryImages count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 310.0;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *cellIdentifier= @"SMPreviewGalleryImageCell";
    
    SMPreviewGalleryImageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    SMClassOfBlogImages *imageObject = (SMClassOfBlogImages*)[arrayOfGalleryImages objectAtIndex:indexPath.row];
    
    if(imageObject.isImageFromLocal)
    {
        cell.imgGalleryImage.image = [self loadImage:[NSString stringWithFormat:@"%@.jpg", imageObject.imageSelected]];
    }
    else
    {
        
        [cell.imgGalleryImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[SMWebServices blogImageUrl],imageObject.originalImagePath]]];
        
        
    }
    
    
    //cell.backgroundColor = [UIColor greenColor];
    
    return cell;
    
}

#pragma mark - method for loading image from the documents directory

- (UIImage*)loadImage:(NSString*)imageName1
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentDirectory = [paths objectAtIndex:0];
    
    NSString *fullPathOfImage = [documentDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName1]];
    
    return [UIImage imageWithContentsOfFile:fullPathOfImage];
    
}

-(void)loadTheGalleryImages:(NSNotification *) notification
{
    arrayOfGalleryImages = [notification object];
    
    
    [self.tblViewOfPhotos reloadData];
    
}




@end
