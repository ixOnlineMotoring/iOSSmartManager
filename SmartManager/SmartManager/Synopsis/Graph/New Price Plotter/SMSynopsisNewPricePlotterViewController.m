//
//  SMSynopsisNewPricePlotterViewController.m
//  Smart Manager
//
//  Created by Ankit Shrivastava on 06/01/16.
//  Copyright (c) 2016 SmartManager. All rights reserved.
//

#import "SMSynopsisNewPricePlotterViewController.h"
#import "SHLineGraphView.h"
#import "SHPlot.h"
#import "SMWSNewsPricePlotter.h"
#import "SMCustomColor.h"
@interface SMSynopsisNewPricePlotterViewController ()<MBProgressHUDDelegate,UIScrollViewDelegate>
{
    MBProgressHUD *HUD;
    SMNewsPricePlotterXmlObject *objSMNewsPricePlotterXmlObject;
    SHLineGraphView *lineGraph;
    UIPinchGestureRecognizer *GSRView;
    IBOutlet UIScrollView *scrollView;
}
@end

@implementation SMSynopsisNewPricePlotterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    UIPinchGestureRecognizer *twoFingerPinch = [[UIPinchGestureRecognizer alloc]
                                                initWithTarget:self
                                                action:@selector(twoFingerPinch:)];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    
    //[self.view addGestureRecognizer:tapGesture];
    //[self.view addGestureRecognizer:twoFingerPinch];
    GSRView = [[UIPinchGestureRecognizer alloc]init];
    GSRView.scale = 1.00;
    [self getGraphPoints];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      self.navigationItem.titleView = [SMCustomColor setTitle:@"New Price Plotter"];
    scrollView.contentSize = lineGraph.bounds.size;
    scrollView.minimumZoomScale = 1.0f;
    scrollView.maximumZoomScale = 8.0f;
    scrollView.delegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIView *) viewForZoomingInScrollView:(UIScrollView *)scrollView {
    
    return lineGraph;
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView1 withView:(UIView *)view atScale:(CGFloat)scale
{
    
}

- (void)twoFingerPinch:(UIPinchGestureRecognizer *)recognizer
{
    NSLog(@"Pinch scale: %f", GSRView.scale);
    
        CGAffineTransform transform = CGAffineTransformMakeScale(GSRView.scale, GSRView.scale);
        GSRView.scale = recognizer.scale;
        // you can implement any int/float value in context of what scale you want to zoom in or out
        self.view.transform = transform;

    
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
        CGAffineTransform transform = CGAffineTransformMakeScale(1.000, 1.000);
        // you can implement any int/float value in context of what scale you want to zoom in or out
        self.view.transform = transform;
        // handling code
    }
}

-(void) showGraph{
    //initate the graph view
    // = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300)];
    
    lineGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width-8 , 300)];
          //set the main graph area theme attributes
    
    /**
     *  theme attributes dictionary. you can specify graph theme releated attributes in this dictionary. if this property is
     *  nil, then a default theme setting is applied to the graph.
     */
    
    NSDictionary *themeAttributes;
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        themeAttributes = @{
                            kXAxisLabelColorKey : [UIColor whiteColor],
                            kXAxisLabelFontKey : [UIFont fontWithName:FONT_NAME_BOLD size:10],
                            kYAxisLabelColorKey : [UIColor whiteColor],
                            kYAxisLabelFontKey : [UIFont fontWithName:FONT_NAME_BOLD size:10],
                            kYAxisLabelSideMarginsKey : @20,
                            kPlotBackgroundLineColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                            kDotSizeKey : @5
                            };
        
    }
    else
    {
        themeAttributes = @{
                            kXAxisLabelColorKey : [UIColor whiteColor],
                            kXAxisLabelFontKey : [UIFont fontWithName:FONT_NAME_BOLD size:14],
                            kYAxisLabelColorKey : [UIColor whiteColor],
                            kYAxisLabelFontKey : [UIFont fontWithName:FONT_NAME_BOLD size:14],
                            kYAxisLabelSideMarginsKey : @20,
                            kPlotBackgroundLineColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                            kDotSizeKey : @5
                            };
    }
    lineGraph.themeAttributes = themeAttributes;
    
    //set the line graph attributes
    
    /**
     *  the maximum y-value possible in the graph. make sure that the y-value is not in the plotting points is not greater
     *  then this number. otherwise the graph plotting will show wrong results.
     */
    
    NSMutableArray *numbers = [[NSMutableArray alloc] init];
    for(int i=0; i<objSMNewsPricePlotterXmlObject.arrmGraphPoints.count;i++)
    {
        SMNewPricePlotterObject *objSMWSNewsPricePlotter = [objSMNewsPricePlotterXmlObject.arrmGraphPoints objectAtIndex:i];
        [numbers addObject: [NSNumber numberWithInteger: [objSMWSNewsPricePlotter.strValue integerValue]]];
    }
    
    float xmax = -MAXFLOAT;
    float xmin = MAXFLOAT;
    for (NSNumber *num in numbers) {
        float x = num.floatValue;
        if (x < xmin) xmin = x;
        if (x > xmax) xmax = x;
    }
    
    
    
    long long mindigit = xmin;
    long minresult;
    
    if (xmin>100000) {
        minresult =  mindigit / 100000;
        minresult = (minresult)*100000;
    }
    else{
          minresult = 00000;
    }
    
  
       lineGraph.minValueYaxis = minresult;
    
    
    long long digit = xmax;
    long result;
    
    if (xmax>100000) {
        result = digit / 100000;
        result = (result + 1)*100000;
    }
   else
       result = 100000;
    
    
    
    lineGraph.yAxisRange = @(result);
    
    
    lineGraph.YintervalCount = (int)(result-minresult)/50000;
    
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
    
    
    NSMutableArray *arrmXaxis= [[NSMutableArray alloc]init];
    for(int i=0; i<objSMNewsPricePlotterXmlObject.arrmGraphPoints.count;i++)
    {
        NSMutableDictionary *dictmJSON=[[NSMutableDictionary alloc]init];
        SMNewPricePlotterObject *objSMWSNewsPricePlotter = [objSMNewsPricePlotterXmlObject.arrmGraphPoints objectAtIndex:i];
        [dictmJSON setValue:objSMWSNewsPricePlotter.strDate forKey:[NSString stringWithFormat:@"%d",i]];
        [arrmXaxis addObject:dictmJSON];
    }

    lineGraph.xAxisValues = arrmXaxis.mutableCopy;
    
    //create a new plot object that you want to draw on the `_lineGraph`
    SHPlot *plot1 = [[SHPlot alloc] init];
    
    //set the plot attributes
    
    /**
     *  Array of dictionaries, where the key is the same as the one which you specified in the `xAxisValues` in `SHLineGraphView`,
     *  the value is the number which will determine the point location along the y-axis line. make sure the values are not
     *  greater than the `yAxisRange` specified in `SHLineGraphView`.
     */
    
    NSMutableArray *arrmYaxis= [[NSMutableArray alloc]init];
    NSMutableArray *arrmDotsValue = [[NSMutableArray alloc]init];
    
    for(int i=0; i<objSMNewsPricePlotterXmlObject.arrmGraphPoints.count;i++)
    {
        NSMutableDictionary *dictmJSON=[[NSMutableDictionary alloc]init];
        SMNewPricePlotterObject *objSMWSNewsPricePlotter = [objSMNewsPricePlotterXmlObject.arrmGraphPoints objectAtIndex:i];
        [dictmJSON setValue:objSMWSNewsPricePlotter.strValue forKey:[NSString stringWithFormat:@"%d",i]];
        [arrmDotsValue addObject:objSMWSNewsPricePlotter.strValue];
        [arrmYaxis addObject:dictmJSON];
    }
    
     plot1.plottingValues = arrmYaxis.mutableCopy;

    /**
     *  this is an optional array of `NSString` that specifies the labels to show on the particular points. when user clicks on
     *  a particular points, a popover view is shown and will show the particular label on for that point, that is specified
     *  in this array.
     */

  
    plot1.plottingPointsLabels = arrmDotsValue.mutableCopy;
    
    //set plot theme attributes
    
    /**
     *  the dictionary which you can use to assing the theme attributes of the plot. if this property is nil, a default theme
     *  is applied selected and the graph is plotted with those default settings.
     */
    
    NSDictionary *_plotThemeAttributes;
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone)
    {
        _plotThemeAttributes = @{
                                 kPlotFillColorKey : [UIColor clearColor],
                                 kPlotStrokeWidthKey : @2,
                                 kPlotStrokeColorKey : [UIColor colorWithRed:59.0f/255.0f green:147.0f/255.0f blue:224.0f/255.0f alpha:1.0f],
                                 kPlotPointFillColorKey : [UIColor colorWithRed:59.0f/255.0f green:147.0f/255.0f blue:224.0f/255.0f alpha:1.0f],
                                 kPlotPointValueFontKey : [UIFont fontWithName:FONT_NAME_BOLD size:12.0f]
                                 };
        
    }
    else
    {
        _plotThemeAttributes = @{
                                 kPlotFillColorKey : [UIColor clearColor],
                                 kPlotStrokeWidthKey : @2,
                                 kPlotStrokeColorKey : [UIColor colorWithRed:59.0f/255.0f green:147.0f/255.0f blue:224.0f/255.0f alpha:1.0f],
                                 kPlotPointFillColorKey : [UIColor colorWithRed:59.0f/255.0f green:147.0f/255.0f blue:224.0f/255.0f alpha:1.0f],
                                 kPlotPointValueFontKey : [UIFont fontWithName:FONT_NAME_BOLD size:15.0f]
                                 };
        
    }
    plot1.plotThemeAttributes = _plotThemeAttributes;
    [lineGraph addPlot:plot1];
    
    //You can as much `SHPlots` as you can in a `SHLineGraphView`
    
    [lineGraph setupTheView];
    
    [scrollView addSubview:lineGraph];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Web Services
-(void) getGraphPoints{
    
   
    
     //NSMutableURLRequest *requestURL=[SMWebServices getNewPricePlotterWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:@"2010" andVariantID:@"9684"];
    
   NSMutableURLRequest *requestURL=[SMWebServices getNewPricePlotterWithUserHash:[SMGlobalClass sharedInstance].hashValue andYear:self.strYear andVariantID:self.strVariantID];
    
    objSMNewsPricePlotterXmlObject = [[SMNewsPricePlotterXmlObject alloc] init];
    
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    [self addingProgressHUD];
    [HUD show:YES];
    HUD.labelText = KLoaderText;
    
    SMWSNewsPricePlotter  *wsSMWSNewsPricePlotter = [[SMWSNewsPricePlotter alloc]init];
    
    [wsSMWSNewsPricePlotter responseForWebServiceForReuest:requestURL
                                                response:^(SMNewsPricePlotterXmlObject *objSSMNewsPricePlotterXmlObjectResult) {
                                                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                    [self hideProgressHUD];
                                                    switch (objSSMNewsPricePlotterXmlObjectResult.iStatus) {
                                                            
                                                        case kWSCrash:
                                                        {
                                                            [SMAttributeStringFormatObject showAlertWebServicewithMessage:KWSCrashMessage ForViewController:self];
                                                        }
                                                            break;
                                                            
                                                        case kWSNoRecord:
                                                        {
                                                            [SMAttributeStringFormatObject showAlertWebServicewithMessage:KNorecordsFousnt ForViewController:self];
                                                        }
                                                            break;
                                                            
                                                        case kWSSuccess:
                                                        {
                                                            objSMNewsPricePlotterXmlObject = objSSMNewsPricePlotterXmlObjectResult;
                                                            [self showGraph];
                                                        }
                                                            break;
                                                            
                                                        default:
                                                            break;
                                                    }
                                                    
                                                    
                                                }
                                                andError: ^(NSError *error) {
                                                    SMAlert(@"Error", error.localizedDescription);
                                                    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
                                                    [self hideProgressHUD];
                                                }
     ];
    
}


-(void) addingProgressHUD
{
    
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    
    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
}
-(void) hideProgressHUD
{
    [HUD hide:YES];
}

@end


