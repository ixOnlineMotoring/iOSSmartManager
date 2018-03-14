//
//  SMNotificationViewController.m
//  SmartManager
//
//  Created by Jignesh on 29/04/15.
//  Copyright (c) 2015 SmartManager. All rights reserved.
//

#import "SMNotificationViewController.h"
#import "SMNotificationTableViewCell.h"
@interface SMNotificationViewController ()

@end

typedef enum : NSUInteger {
    kLeadsReceivedTag,
    kUpdateDuesTag,
    kMessageTag,
} kActionTag;

@implementation SMNotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableNotification registerNib:[UINib nibWithNibName:@"SMNotificationTableViewCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    
    NSArray *stringsArray = [NSArray arrayWithObjects:
                             @"string 1",
                             @"String 21",
                             @"string 12",
                             @"String 11",
                             @"String 02", nil];
    static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch | NSNumericSearch |
    NSWidthInsensitiveSearch | NSForcedOrderingSearch;
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSComparator finderSort = ^(id string1, id string2) {
        NSRange string1Range = NSMakeRange(0, [string1 length]);
        return [string1 compare:string2 options:comparisonOptions range:string1Range locale:currentLocale];
    };
    NSLog(@"finderSort: %@", [stringsArray sortedArrayUsingComparator:finderSort]);

    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




#pragma mark - 


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString     *CellIdentifier = @"Cell";
    SMNotificationTableViewCell  *cell = (SMNotificationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    sizeFrame = 0.0f;

    cell.lblVehicleDetails.text = @"Ford Volkswagen Audi Honda city | White Red Black | 23 000Km | cars.co.za";
  // cell.lblVehicleDetails.text = @"Ford Volkswagen Audi Honda city";
   // cell.lblVehicleDetails.text = @"Ford Volkswagen Audi Honda city gh ghgh ghghgh ghghgfht trytrytry rtyrt rtyrtyt tyr hfghdfghfhghghgh ghghfrtrtrtdsdrere frgtrtrtrt 6u6u6u uy utyuty uy yuy uytuytu yj    gfhty ttytytryrtyrtyrty h trytryrtyrt rtyrtyrtyrty ";
    
    [cell.lblVehicleDetails sizeToFit];
    
    CGFloat height = cell.lblVehicleDetails.frame.size.height;
    
     //cell.lblUserName.frame = CGRectMake(cell.lblUserName.frame.origin.x, sizeFrame, cell.lblLeadID.frame.size.width, cell.lblLeadID.frame.size.height);
    
    
    cell.lblVehicleDetails.frame = CGRectMake(cell.lblVehicleDetails.frame.origin.x, cell.lblUserPhone.frame.origin.y + cell.lblUserPhone.frame.size.height+5.0, cell.lblVehicleDetails.frame.size.width, height);
    
    sizeFrame = ceilf(cell.lblVehicleDetails.frame.origin.y + height);
   
    cell.lblLeadID.frame = CGRectMake(cell.lblLeadID.frame.origin.x, sizeFrame+5.0, cell.lblLeadID.frame.size.width, cell.lblLeadID.frame.size.height);
    
     cell.lblTime.frame = CGRectMake(cell.lblTime.frame.origin.x, cell.lblLeadID.frame.origin.y + cell.lblLeadID.frame.size.height+5.0, cell.lblTime.frame.size.width, cell.lblTime.frame.size.height);
    
    sizeFrame = sizeFrame + cell.lblLeadID.frame.size.height + cell.lblTime.frame.size.height + cell.lblUserEmail.frame.size.height + cell.lblUserName.frame.size.height ;
    
    sizeFrame = sizeFrame - 31.0;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    switch (section)
    {
        case 0:
             return self.buttonLeadsReceived.selected? 1 : 0;
             break;
        case 1:
            return self.buttonLeadsUpdateDue.selected? 2 :0;
            break;
        case 2:
            return self.buttonMessages.selected? 3:0;
            break;
        default:
            return 0;
            break;
    }
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        return sizeFrame;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) ? 40.0f : 60.0f;

    
    
//    switch (section)
//    {
//        case 0:
//            return self.viewbuttonLeadsReceived.frame.size.height;
//            break;
//        case 1:
//            return self.viewbuttonLeadsUpdateDue.frame.size.height;
//            break;
//        case 2:
//            return self.viewbuttonMessages.frame.size.height;
//            break;
//        default:
//            return 0;
//            break;
//    }


}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view  =[[UIView alloc] init];
    
    [view setBackgroundColor:[UIColor blackColor]];
    return view;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    
    
    switch (section)
    {
        case 0:
            {
                if (self.buttonLeadsReceived.selected) {
                  self.imageArrowbuttonLeadsReceived.transform  = CGAffineTransformMakeRotation(M_PI/2);
                }
                else
                {
                 self.imageArrowbuttonLeadsReceived.transform  = CGAffineTransformMakeRotation(2*M_PI);
                }
                
                [self.buttonLeadsReceived setTag:kLeadsReceivedTag];
                return self.viewbuttonLeadsReceived;
            }
            break;
        case 1:
            {
                if(self.buttonLeadsUpdateDue.selected)
                {
                 self.imageArrowbuttonLeadsUpdateDue.transform  = CGAffineTransformMakeRotation(M_PI/2);
                }
                else
                {
                 self.imageArrowbuttonLeadsUpdateDue.transform  = CGAffineTransformMakeRotation(2*M_PI);
                    
                }
               
                [self.buttonLeadsUpdateDue setTag:kUpdateDuesTag];
                return self.viewbuttonLeadsUpdateDue;
            }
            break;
        case 2:
            {
                if (self.buttonMessages.selected) {
                    self.imageArrowbuttonMessages.transform  = CGAffineTransformMakeRotation(M_PI/2);
                }
                else
                {
                
                    self.imageArrowbuttonMessages.transform  = CGAffineTransformMakeRotation(2*M_PI);
                }
                
                [self.buttonMessages setTag:kMessageTag];
                return self.viewbuttonMessages;
            }
            break;
        default:
            return 0;
            break;
    }

}


#pragma mark -


-(IBAction)buttonSectionedPressed:(id)sender
{

    UIButton *button = (UIButton *) sender;
    NSLog(@"Received Tag is %ld",(long)button.tag);
    
    switch (button.tag)
    {
        case kLeadsReceivedTag:
            {
                self.buttonLeadsReceived.selected = !self.buttonLeadsReceived.selected;
                [self.tableNotification reloadData];
            }
            break;
        case kUpdateDuesTag:
            {
                self.buttonLeadsUpdateDue.selected = !self.buttonLeadsUpdateDue.selected;
                [self.tableNotification reloadData];

            }
            break;
        case kMessageTag:
            {
        
                self.buttonMessages.selected  = !self.buttonMessages.selected;
                [self.tableNotification reloadData];

            }
        default:
            break;
    }
    
}


-(CGSize)getTheHeightOfTheText:(NSString*)inputText
{
    UIFont *aFont = [UIFont fontWithName:FONT_NAME size:15.0];
    
    CGSize labelSizeName = [inputText sizeWithFont:aFont constrainedToSize:CGSizeMake(253, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    
    return labelSizeName;

}

/*- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    static CGFloat lastY = 0;
    
    CGFloat currentY = scrollView.contentOffset.y;
    CGFloat headerHeight = 50.0;
    
    NSLog(@"lastY = %f",lastY);
    NSLog(@"currentY = %f",currentY);
    
    
    if ((lastY <= headerHeight) && (currentY > headerHeight)) {
        NSLog(@" ******* Header view just disappeared");
    }
    
    if ((lastY > headerHeight) && (currentY <= headerHeight)) {
        NSLog(@" ******* Header view just appeared");
    }
    
    lastY = currentY;
}
*/



@end
