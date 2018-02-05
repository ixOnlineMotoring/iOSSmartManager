//
//  SMCustomCellForTodayTableViewCell.m
//  SmartManager
//
//  Created by Liji Stephen on 05/11/14.
//  Copyright (c) 2014 SmartManager. All rights reserved.
//

#import "SMCustomCellForTodayTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "SMTradeDetailSlider.h"
#import "SMWebServices.h"
#import "SMGlobalClass.h"

@implementation SMCustomCellForTodayTableViewCell
@synthesize enlargePhotoDelegate;
@synthesize doDoMemberLocationObj;

- (void)awakeFromNib
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        [self.sliderCollection         registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:nil]            forCellWithReuseIdentifier:@"Cell"];
    }
    else
    {
        [self.sliderCollection         registerNib:[UINib nibWithNibName:@"CollectionCell_iPad" bundle:nil]            forCellWithReuseIdentifier:@"Cell"];
    }
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        self.lblNoImagesAvailable.font = [UIFont fontWithName:FONT_NAME_BOLD size:17.0];
        self.btnDone.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
        self.btnNoCanDo.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
        self.btnReject.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
        self.btnAccept.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
        
        self.btnCancelTask.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPHone];
    }
    else
    {
        self.lblNoImagesAvailable.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        self.btnDone.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        self.btnNoCanDo.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        self.btnReject.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        self.btnAccept.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
        
        self.btnCancelTask.titleLabel.font = [UIFont fontWithName:FONT_NAME_BOLD size:FONT_SIZE_iPad];
    }
    self.sliderCollection.layer.borderColor=[[UIColor colorWithRed:24.0/255 green:85.0/255 blue:152.0/255 alpha:1.0]CGColor];
    self.sliderCollection.layer.borderWidth= 0.8f;
    
//    [self getAllTheImages];
    
    self.viewContainingButtons.hidden = YES;
    
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}




#pragma mark -  UICollection View Methods
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(self.doDoMemberLocationObj.arrayImages.count == 0)
    {
        self.sliderCollection.hidden = YES;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.BottomViewToBeShifted.frame = CGRectMake(self.BottomViewToBeShifted.frame.origin.x, 98.0, self.BottomViewToBeShifted.frame.size.width, self.BottomViewToBeShifted.frame.size.height);
            
            self.bottomViewForShifting.frame = CGRectMake(self.bottomViewForShifting.frame.origin.x, 80.0, self.bottomViewForShifting.frame.size.width, self.bottomViewForShifting.frame.size.height);
        }
    }
    else
    {
        self.sliderCollection.hidden = NO;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.BottomViewToBeShifted.frame = CGRectMake(self.BottomViewToBeShifted.frame.origin.x, 157.0, self.BottomViewToBeShifted.frame.size.width, self.BottomViewToBeShifted.frame.size.height);
            
            self.bottomViewForShifting.frame = CGRectMake(self.bottomViewForShifting.frame.origin.x, 140.0, self.bottomViewForShifting.frame.size.width, self.bottomViewForShifting.frame.size.height);
        }
    }
    
    return  self.doDoMemberLocationObj.arrayImages.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SMTradeDetailSlider *sliderCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    SMClassOfBlogImages *imageObject = (SMClassOfBlogImages*)[self.doDoMemberLocationObj.arrayImages objectAtIndex:indexPath.item];
    
    [sliderCell.imageVehicle   setImageWithURL:[NSURL URLWithString:imageObject.thumbImagePath] placeholderImage:[UIImage imageNamed:@"placeholder.jpeg"] success:^(UIImage *image, BOOL cached)
     {
         
     }
                                       failure:^(NSError *error)
     {
         
     }];
    
   // [sliderCell.imageVehicle setImage:[UIImage imageNamed:@"downArrow.jpeg"]];
    
    return sliderCell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    networkGallery = [[FGalleryViewController alloc] initWithPhotoSource:self];
    networkGallery.startingIndex = indexPath.row;
    [enlargePhotoDelegate pushTheViewControllerForEnlargedImageWithObject:networkGallery];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        return (collectionView.tag == 1) ? CGSizeMake(46, 46) : CGSizeMake(46, 46);
    }
    else
    {
       
        
        self.sliderCollection.frame = CGRectMake(self.sliderCollection.frame.origin.x, self.sliderCollection.frame.origin.y, self.sliderCollection.frame.size.width, 55);
        
        return (collectionView.tag == 1) ? CGSizeMake(46, 46) : CGSizeMake(46, 46);
    }
}

#pragma mark collection view cell paddings

//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(10, 3, 0, 3); // top, left, bottom, right
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    
//    return 15.0;
//}

#pragma mark -


#pragma mark - FGalleryViewControllerDelegate Methods
- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery
{
    
    if(gallery == networkGallery)
    {
        int num;
        num = (int)[self.doDoMemberLocationObj.arrayImages count];
        return num;
    }
    return 0;
}


- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index
{
    return FGalleryPhotoSourceTypeNetwork;
}


- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index
{
    NSString *caption;
    if( gallery == networkGallery )
    {
        caption = [networkCaptions objectAtIndex:index];
    }
    return caption;
}



- (NSString*)photoGallery:(FGalleryViewController *)gallery urlForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index
{
   // return [arrayFullImages objectAtIndex:index];
    
    SMClassOfBlogImages *imageObject = (SMClassOfBlogImages*)[self.doDoMemberLocationObj.arrayImages objectAtIndex:index];
    return imageObject.originalImagePath;
    
}
#pragma mark  -



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btnCancelTaskDidClicked:(id)sender {
}

- (IBAction)btnNoCanDoDidClicked:(id)sender {
}

#pragma mark - Web service implementation

-(void)getAllTheImages
{
    
    
    NSMutableURLRequest *requestURL=[SMWebServices getTheNewTaskImagesWithUserHash:[SMGlobalClass sharedInstance].hashValue andTaskID:[SMGlobalClass sharedInstance].selectedTaskId];
    
    
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    
    
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse* response, NSData* data, NSError* error)
     {
         
         
         [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
         
         if (error!=nil)
         {
             
             
             [[[UIAlertView alloc]initWithTitle:@"Error"
                                        message:[error.localizedDescription capitalizedString]
                                       delegate:self cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil]
              show];
             
         }
         else
         {
             
             
             //You create an instance of the NSXMLParser class and then initialize it with the response returned by the web service. As the parser encounters the various items in the XML document, it will fire off several methods, which you need to define next.
             
             
             
             self.doDoMemberLocationObj.arrayImages = [[NSMutableArray alloc]init];
             xmlParser = [[NSXMLParser alloc] initWithData: data];
             [xmlParser setDelegate: self];
             [xmlParser setShouldResolveExternalEntities:YES];
             [xmlParser parse];
             
             
         }
         
         
         
     }];
}


#pragma mark - Parsing delegate methods

// The first method to implement is parser:didStartElement:namespaceURI:qualifiedName:attributes:, which is fired when the start tag of an element is found:

//---when the start of an element is found---

-(void) parser:(NSXMLParser *) parser
didStartElement:(NSString *) elementName
  namespaceURI:(NSString *) namespaceURI
 qualifiedName:(NSString *) qName
    attributes:(NSDictionary *) attributeDict
{
    
    if([elementName isEqualToString:@"Image"])
    {
//         self.lblNoImagesAvailable.hidden = YES;
        self.imageObject = [[SMClassOfBlogImages alloc]init];
         self.imageObject.thumbImagePath = [attributeDict valueForKey:@"Thumb"];
    }
    else
    {
//        self.lblNoImagesAvailable.hidden = NO;
    
    }
    
     currentNodeContent = [NSMutableString stringWithString:@""];
}


//The next method to implement is parser:foundCharacters:, which gets fired when the parser finds the text of an element:

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
    [currentNodeContent appendString:[NSString stringWithFormat:@"%@",[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]];
    
    
    
}


//Finally, when the parser encounters the end of an element, it fires the parser:didEndElement:namespaceURI:qualifiedName: method:

//---when the end of element is found---

-(void)parser:(NSXMLParser *)parser
didEndElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI
qualifiedName:(NSString *)qName
{
    // This is for getting Planner Type List
    
    if([elementName isEqualToString:@"Image"])
    {
        if(self.imageObject!= nil)
        {
            self.imageObject.originalImagePath = currentNodeContent;
        }
        
        [self.doDoMemberLocationObj.arrayImages addObject:self.imageObject];
        
        if (self.doDoMemberLocationObj == nil)
            NSLog(@"Main object is nil");
        
    }
    if([elementName isEqualToString:@"Images"])
    {
        [self.sliderCollection reloadData];
        [self.enlargePhotoDelegate reloadTableView];
    }
    
}


@end


