//
//  SMSearchBlogGalleryImageCell.m
//  SmartManager
//
//  Created by Liji Stephen on 02/10/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMSearchBlogGalleryImageCell.h"
#import "SMSearchBlogTableViewSliderCell.h"
#import "SMSearchBlogObject.h"
#import "UIImageView+WebCache.h"
#import "SMWebServices.h"

@implementation SMSearchBlogGalleryImageCell

- (void)awakeFromNib
{
    // Initialization code
    
    [self.tblViewSlider.layer setAffineTransform:CGAffineTransformMakeRotation(-M_PI_2)];
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.tblViewSlider registerNib:[UINib nibWithNibName:@"SMSearchBlogTableViewSliderCell" bundle:nil] forCellReuseIdentifier:@"SMSearchBlogTableViewSliderCell"];
    }
    else
    {
        [self.tblViewSlider registerNib:[UINib nibWithNibName:@"SMSearchBlogTableViewSliderCell_iPad" bundle:nil] forCellReuseIdentifier:@"SMSearchBlogTableViewSliderCell"];
    }
}

#pragma  mark - TableView Delegate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrOfSearchResultObjects count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return 310.0;
    }
    else
    {
        return 758.0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier= @"SMSearchBlogTableViewSliderCell";
    
    SMSearchBlogTableViewSliderCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    SMSearchBlogObject *searchResultObj = (SMSearchBlogObject*)[self.arrOfSearchResultObjects objectAtIndex:indexPath.row];
    
   searchResultObj.strImageURL = [searchResultObj.strImageURL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    cell.lblTitle.text = searchResultObj.strTitle;
    cell.lblDetails.text = searchResultObj.strDetails;
    cell.lblType.text = [NSString stringWithFormat:@"Type: %@",searchResultObj.strBlogPostType];
    cell.lblImageCount.text = [NSString stringWithFormat:@"Images: %@",searchResultObj.imgCount];
    cell.lblCreatedBy.text = [NSString stringWithFormat:@"Created: %@ by %@",[self sendTheAppropriateDateFormatFromTheString:searchResultObj.strCreatedDate andIsUTC:NO], searchResultObj.strName];
    
    if([[self sendTheAppropriateDateFormatFromTheString:searchResultObj.strEndDate andIsUTC:YES] isEqualToString:@"31 Dec 1899"] || [[self sendTheAppropriateDateFormatFromTheString:searchResultObj.strEndDate andIsUTC:YES] isEqualToString:@"01 Jan 1900"])
    {
        cell.lblActiveDate.text = [NSString stringWithFormat:@"%@ to %@",[self sendTheAppropriateDateFormatFromTheString:searchResultObj.strPublishDate andIsUTC:NO],@"Ends Never"];
    }
    else
    {
        cell.lblActiveDate.text = [NSString stringWithFormat:@"%@ to %@",[self sendTheAppropriateDateFormatFromTheString:searchResultObj.strPublishDate andIsUTC:NO],[self sendTheAppropriateDateFormatFromTheString:searchResultObj.strEndDate andIsUTC:NO]];
    }
    
      if(indexPath.row == self.arrOfSearchResultObjects.count-1)
      {
          NSLog(@"searchResultObj.imgCount = %@",searchResultObj.imgCount);
            if([searchResultObj.imgCount isEqualToString:@"0"])
            {
                [cell.imgViewCarImage   setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
                
                //cell.imgViewCarImage.image = nil;
            
            }
          
          else
            [cell.imgViewCarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[SMWebServices blogImageUrl],searchResultObj.strImageURL]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
                
      }
      else
      {
          if([searchResultObj.imgCount isEqualToString:@"0"])
          {
              [cell.imgViewCarImage   setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
          }
          else
          {
              [cell.imgViewCarImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[SMWebServices blogImageUrl],searchResultObj.strImageURL]]placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"]];
          }
          
      }
    
          
    
    if ([searchResultObj.strRemainingDaysCount rangeOfString:@"day(s)"].location == NSNotFound)
    {
       cell.lblDaysRemaining.text = [NSString stringWithFormat:@"Time Remaining: %@",searchResultObj.strRemainingDaysCount];
    }
    else
    {
        cell.lblDaysRemaining.text = [NSString stringWithFormat:@"Days Remaining: %@",searchResultObj.strRemainingDaysCount];
    }
    
    
    [cell setBackgroundColor:[UIColor blackColor]];

    /*if (self.arrOfSearchResultObjects.count-1 == indexPath.row)
    {
        NSLog(@".iTotal = %d",searchResultObj.iTotal);
        if (self.arrOfSearchResultObjects.count != searchResultObj.iTotal)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"LoadTheNextSrarchListingBlogs" object:nil];
        }
    }*/
    
    return cell;    
}


-(NSString*)convertTheGivenStringIntoRequiredFormat:(NSString*)givenDateString andIsUTC:(BOOL)isUTC
{
    // to convert the date string in proper format
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:s.ZZZ"];
    
    NSDate *requiredDate1 = [dateFormatter dateFromString:givenDateString];
    
    NSDateFormatter *dateFormatter1 = [[NSDateFormatter alloc] init];
    [dateFormatter1 setDateFormat:@"dd MMM yyyy"];
    if (isUTC)
    {
        [dateFormatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    }
    NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter1 stringFromDate:requiredDate1]];
    return textDate;
    
}

-(NSString*)dateConsideringTimezoneMilisecFromString:(NSString*)strDate andIsUTC:(BOOL)isUTC
{
    @try {
        NSRange range = [strDate rangeOfString:@":" options: NSBackwardsSearch];
        NSString *dateFirst = [strDate substringToIndex:(range.location)];
        NSString *dateSecond = [strDate substringFromIndex:(range.location+1)];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SZ"];
        NSDate *dateReceived = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@%@",dateFirst,dateSecond]];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        if (isUTC)
        {
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        }
        
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateReceived]];
       
        return textDate;
    }
    @catch (NSException *exception) {
        return @"";
    }
}

-(NSString*)dateConsideringTimezoneFromString:(NSString*)strDate andIsUTC:(BOOL)isUTC
{
    @try {
        /*NSRange range = [strDate rangeOfString:@":" options: NSBackwardsSearch];
        NSString *dateFirst = [strDate substringToIndex:(range.location)];
        NSString *dateSecond = [strDate substringFromIndex:(range.location+1)];*/
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"dd MMM yyyy 'T' HH:mm"];
        //[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
       // NSDate *dateReceived = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@%@",dateFirst,dateSecond]];
        
         NSDate *dateReceived = [dateFormatter dateFromString:strDate];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        

       
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        if (isUTC)
        {
            [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        }
        
        NSString *textDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:dateReceived]];
        
        return textDate;
        
        
        
    }
    @catch (NSException *exception) {
        return @"";
    }
}

-(NSString*)sendTheAppropriateDateFormatFromTheString:(NSString*)strDate andIsUTC:(BOOL)isUTC
{
    if ([strDate rangeOfString:@"."].location == NSNotFound)
    {
        NSString *dateStr = [strDate substringToIndex:11];
        return dateStr;
        
        return [self dateConsideringTimezoneFromString:strDate andIsUTC:isUTC];
    }
    else
    {
        return [self dateConsideringTimezoneMilisecFromString:strDate andIsUTC:isUTC];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - custom methods

#pragma mark - scrollView delegate methods.
-(void)scrollViewDidEndDecelerating:(UITableView *)tableView
{
    
    CGPoint point = self.tblViewSlider.frame.origin;
    point.x += self.tblViewSlider.frame.size.width / 2;
    point.y += self.tblViewSlider.frame.size.height / 2;
    point = [self.tblViewSlider convertPoint:point fromView:self.tblViewSlider.superview];
    
    NSIndexPath *middleIndexPath = [self.tblViewSlider indexPathForRowAtPoint:point] ;
    
    
    [self.delegate passTheIndexOfSelectedCell:(int)middleIndexPath.row];
}


@end
