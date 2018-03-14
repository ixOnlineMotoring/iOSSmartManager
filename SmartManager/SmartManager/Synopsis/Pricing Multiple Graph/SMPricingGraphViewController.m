//
//  SMPricingGraphViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 22/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMPricingGraphViewController.h"
#import "SMCustomLabelAutolayout.h"
#import "SHLineGraphView.h"
#import "SHPlot.h"

@interface SMPricingGraphViewController ()
{
    IBOutlet UITableView *tblGraph;
    
    IBOutlet UIView *viewHeaderTable;
    IBOutlet UIView *viewTableFooter;
    IBOutlet UILabel *lblTTCode;
    IBOutlet UILabel *lblUpdated;
    IBOutlet UILabel *lblValuationConfidence;
    IBOutlet UILabel *lblSampleSize;
    IBOutlet UILabel *lblTrueTrade;
    IBOutlet UILabel *lblCompany;
    IBOutlet UILabel *lblContact;
    IBOutlet UILabel *lblComments;
    SHLineGraphView *lineGraph;
}
@end

@implementation SMPricingGraphViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self headerview];
    [self footerview];
}

-(void) headerview{
    UIView *headerView = tblGraph.tableHeaderView;
    
    [headerView setNeedsLayout];
    [headerView layoutIfNeeded];
    
    CGFloat height = (lblComments.frame.origin.y + lblComments.frame.size.height + 8.0f);
    CGRect frame = headerView.frame;
    frame.size.height = height;
    headerView.frame = frame;
    tblGraph.tableHeaderView = headerView;
}

-(void) footerview{
    UIView *footerview = tblGraph.tableFooterView;
    
    [footerview setNeedsLayout];
    [footerview layoutIfNeeded];
    
    CGFloat height = (lblContact.frame.origin.y + lblContact.frame.size.height + 8.0f);
    CGRect frame = footerview.frame;
    frame.size.height = height;
    footerview.frame = frame;
    tblGraph.tableFooterView = footerview;
}

- (void)viewDidLoad {
     [super viewDidLoad];
    
    NSString *strComments = @"Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.";
     [[SMAttributeStringFormatObject sharedService]setAttributedTextForPricingwithTitle:@"TT Code:" andwithDetail:@"VWPOH027" forLabel:lblTTCode];
     [[SMAttributeStringFormatObject sharedService]setAttributedTextForPricingwithTitle:@"Updated:" andwithDetail:@"03 May 2004" forLabel:lblUpdated];
     [[SMAttributeStringFormatObject sharedService]setAttributedTextForPricingwithTitle:@"Valuation Confidence:" andwithDetail:@"Medium" forLabel:lblValuationConfidence];
     [[SMAttributeStringFormatObject sharedService]setAttributedTextForPricingwithTitle:@"Sample Size" andwithDetail:@"NA:" forLabel:lblSampleSize];
     [[SMAttributeStringFormatObject sharedService]setAttributedTextForPricingwithTitle:@"Comments:" andwithDetail:strComments forLabel:lblComments];
     [[SMAttributeStringFormatObject sharedService]setAttributedTextForPricingwithTitle:@"" andwithDetail:strComments forLabel:lblTrueTrade];
     [[SMAttributeStringFormatObject sharedService]setAttributedTextForPricingwithTitle:@"Company:" andwithDetail:@"Lorem Ipsum is simply dummy text of the printing and typesetting industry" forLabel:lblCompany];
     [[SMAttributeStringFormatObject sharedService]setAttributedTextForPricingwithTitle:@"Contact:" andwithDetail:@"text ever since the 1500s when an unknown printer took a galley of type and scrambled it to make a type specimen book." forLabel:lblContact];
    
    
    tblGraph.tableHeaderView =  viewHeaderTable;
    tblGraph.tableFooterView = viewTableFooter;
    
    tblGraph.estimatedRowHeight = 300.0f;
    tblGraph.rowHeight = UITableViewAutomaticDimension;
    

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //initate the graph view
 lineGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-8 , 300)];
    
    //set the main graph area theme attributes
    
    /**
     *  theme attributes dictionary. you can specify graph theme releated attributes in this dictionary. if this property is
     *  nil, then a default theme setting is applied to the graph.
     */
    NSDictionary *themeAttributes = @{
                                      kXAxisLabelColorKey : [UIColor blackColor],
                                      kXAxisLabelFontKey : [UIFont fontWithName:FONT_NAME size:10],
                                      kYAxisLabelColorKey : [UIColor blackColor],
                                      kYAxisLabelFontKey : [UIFont fontWithName:FONT_NAME size:10],
                                      kYAxisLabelSideMarginsKey : @20,
                                      kPlotBackgroundLineColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                      kDotSizeKey : @5
                                      };
    lineGraph.themeAttributes = themeAttributes;
    
    //set the line graph attributes
    
    /**
     *  the maximum y-value possible in the graph. make sure that the y-value is not in the plotting points is not greater
     *  then this number. otherwise the graph plotting will show wrong results.
     */
    lineGraph.yAxisRange = @(200000);
    
    /**
     *  y-axis values are calculated according to the yAxisRange passed. so you do not have to pass the explicit labels for
     *  y-axis, but if you want to put any suffix to the calculated y-values, you can mention it here (e.g. K, M, Kg ...)
     */
    
    lineGraph.yAxisSuffix = @"";
    
    /**
     *  an Array of dictionaries specifying the key/value pair where key is the object which will identify a particular
     *  x point on the x-axis line. and the value is the label which you want to show on x-axis against that point on x-axis.
     *  the keys are important here as when plotting the actual points on the graph, you will have to use the same key to
     *  specify the point value for that x-axis point.
     */
    lineGraph.xAxisValues = @[
                              @{ @1 : @"29 Jan 2010" },
                              @{ @2 : @"28 Jan 2010" },
                              @{ @3 : @"29 Jan 2010" },
                              @{ @4 : @"29 Jan 2010" },
                              @{ @5 : @"29 Jan 2010" },
                              @{ @6 : @"29 Jan 2010" },
                              @{ @7 : @"29 Jan 2010" },
                              @{ @8 : @"29 Jan 2010" },
                              @{ @9 : @"29 Jan 2010" },
                              @{ @10 : @"29 Jan 2010" },
                              @{ @11 : @"29 Jan 2010" },
                              
                              ];
    
    //create a new plot object that you want to draw on the `_lineGraph`
    SHPlot *plot1 = [[SHPlot alloc] init];
    
    //set the plot attributes
    
    /**
     *  Array of dictionaries, where the key is the same as the one which you specified in the `xAxisValues` in `SHLineGraphView`,
     *  the value is the number which will determine the point location along the y-axis line. make sure the values are not
     *  greater than the `yAxisRange` specified in `SHLineGraphView`.
     */
    plot1.plottingValues = @[
                             @{ @1 : @155000 },
                             @{ @2 : @155750 },
                             @{ @3 : @155900 },
                             @{ @4 : @156000 },
                             @{ @5 : @156250 },
                             @{ @6 : @156600 },
                             @{ @7 : @156800 },
                             @{ @8 : @156900 },
                             @{ @9 : @157300 },
                             @{ @10 :@158000 },
                             @{ @11 :@155300 },
                             ];
    
    /**
     *  this is an optional array of `NSString` that specifies the labels to show on the particular points. when user clicks on
     *  a particular points, a popover view is shown and will show the particular label on for that point, that is specified
     *  in this array.
     */
    //    NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7" , @"8", @"9", @"10", @"11", @"12"];
    //    plot1.plottingPointsLabels = arr;
    
    //set plot theme attributes
    
    /**
     *  the dictionary which you can use to assing the theme attributes of the plot. if this property is nil, a default theme
     *  is applied selected and the graph is plotted with those default settings.
     */
    
    NSDictionary *_plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor clearColor],
                                           kPlotStrokeWidthKey : @2,
                                           kPlotStrokeColorKey : [UIColor colorWithRed:59.0f/255.0f green:147.0f/255.0f blue:224.0f/255.0f alpha:1.0f],
                                           kPlotPointFillColorKey : [UIColor colorWithRed:59.0f/255.0f green:147.0f/255.0f blue:224.0f/255.0f alpha:1.0f],
                                           kPlotPointValueFontKey : [UIFont fontWithName:FONT_NAME size:18]
                                           };
    
    plot1.plotThemeAttributes = _plotThemeAttributes;
    [lineGraph addPlot:plot1];
    
    
    plot1 = [[SHPlot alloc] init];

    //set the plot attributes
    
    /**
     *  Array of dictionaries, where the key is the same as the one which you specified in the `xAxisValues` in `SHLineGraphView`,
     *  the value is the number which will determine the point location along the y-axis line. make sure the values are not
     *  greater than the `yAxisRange` specified in `SHLineGraphView`.
     */
    plot1.plottingValues = @[
                             @{ @1 : @165000 },
                             @{ @2 : @175750 },
                             @{ @3 : @185900 },
                             @{ @4 : @196000 },
                             @{ @5 : @186250 },
                             @{ @6 : @156600 },
                             @{ @7 : @186800 },
                             @{ @8 : @176900 },
                             @{ @9 : @177300 },
                             @{ @10 :@188000 },
                             @{ @11 :@145300 },
                             ];
    
    /**
     *  this is an optional array of `NSString` that specifies the labels to show on the particular points. when user clicks on
     *  a particular points, a popover view is shown and will show the particular label on for that point, that is specified
     *  in this array.
     */
    //    NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7" , @"8", @"9", @"10", @"11", @"12"];
    //    plot1.plottingPointsLabels = arr;
    
    //set plot theme attributes
    
    /**
     *  the dictionary which you can use to assing the theme attributes of the plot. if this property is nil, a default theme
     *  is applied selected and the graph is plotted with those default settings.
     */
    
   _plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor clearColor],
                                           kPlotStrokeWidthKey : @2,
                                           kPlotStrokeColorKey : [UIColor blackColor],
                                           kPlotPointFillColorKey : [UIColor colorWithRed:59.0f/255.0f green:147.0f/255.0f blue:224.0f/255.0f alpha:1.0f],
                                           kPlotPointValueFontKey : [UIFont fontWithName:FONT_NAME size:18]
                                           };
    
    plot1.plotThemeAttributes = _plotThemeAttributes;
    [lineGraph addPlot:plot1];
    
   
  plot1 = [[SHPlot alloc] init];

    //set the plot attributes
    
    /**
     *  Array of dictionaries, where the key is the same as the one which you specified in the `xAxisValues` in `SHLineGraphView`,
     *  the value is the number which will determine the point location along the y-axis line. make sure the values are not
     *  greater than the `yAxisRange` specified in `SHLineGraphView`.
     */
    plot1.plottingValues = @[
                             @{ @1 : @155550 },
                             @{ @2 : @155580 },
                             @{ @3 : @156900 },
                             @{ @4 : @157000 },
                             @{ @5 : @158250 },
                             @{ @6 : @159600 },
                             @{ @7 : @158800 },
                             @{ @8 : @159900 },
                             @{ @9 : @167300 },
                             @{ @10 :@178000 },
                             @{ @11 :@185300 },
                             ];
    
    /**
     *  this is an optional array of `NSString` that specifies the labels to show on the particular points. when user clicks on
     *  a particular points, a popover view is shown and will show the particular label on for that point, that is specified
     *  in this array.
     */
    //    NSArray *arr = @[@"1", @"2", @"3", @"4", @"5", @"6" , @"7" , @"8", @"9", @"10", @"11", @"12"];
    //    plot1.plottingPointsLabels = arr;
    
    //set plot theme attributes
    
    /**
     *  the dictionary which you can use to assing the theme attributes of the plot. if this property is nil, a default theme
     *  is applied selected and the graph is plotted with those default settings.
     */
    
   _plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor clearColor],
                                           kPlotStrokeWidthKey : @2,
                                           kPlotStrokeColorKey : [UIColor greenColor],
                                           kPlotPointFillColorKey : [UIColor colorWithRed:59.0f/255.0f green:147.0f/255.0f blue:224.0f/255.0f alpha:1.0f],
                                           kPlotPointValueFontKey : [UIFont fontWithName:FONT_NAME size:18]
                                           };
    
    plot1.plotThemeAttributes = _plotThemeAttributes;
    [lineGraph addPlot:plot1];
    

    //You can as much `SHPlots` as you can in a `SHLineGraphView`
    
    [lineGraph setupTheView];
    
    
    
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate and datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 400.0f;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    [cell.contentView addSubview:lineGraph];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
