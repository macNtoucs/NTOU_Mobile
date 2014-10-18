//
//  R66SwitchViewController.m
//  NTOU_Mobile
//
//  Created by NTOUCS on 13/11/20.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "R66SwitchViewController.h"
//#import "R66Layer1ViewController.h"
//#import "R66Layer2ViewController.h"
#import "R66LeftLayerViewController.h"
#import "R66RightLayerViewController.h"

@interface R66SwitchViewController ()
@end

@implementation R66SwitchViewController
@synthesize r66layer1ViewController, r66layer2ViewController, r66routePicViewController;
@synthesize switchButton, swipeRecognizer, pinchRecognizer, imageView, scrollView, alertView;

- (void)viewDidLoad
{
    [self detectCurrentTime];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    NSLog(@"Left & Right Layers");
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenHeight = screenBound.size.height;
    screenWidth = screenBound.size.width;
    
    // ------------------------------------------------------------------------
    NSString *isNextTimeShow;
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"AlertViewShown.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"AlertViewShown" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
    isNextTimeShow = [[NSString alloc] init];
    if (!temp)
        NSLog(@"Error reading plist: %@, format: %d", errorDesc, format);
    else
        isNextTimeShow = [temp objectForKey:@"NextTimeShown"];
    NSLog(@"%@", isNextTimeShow);
    // ------------------------------------------------------------------------
    
    
    if ([isNextTimeShow isEqualToString:@"TRUE"])
    {
        alertView = [[UIAlertView alloc] initWithTitle:@"溫馨提醒" message:@"左右滑動可切換平日與假日" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:@"不再提醒", nil];
    }
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(convertSwipeRecognizer)];
    pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch)];
    
    R66LeftLayerViewController *layer1ViewController = [[R66LeftLayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    R66RightLayerViewController *layer2ViewController = [[R66RightLayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    layer1ViewController.tableView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
    layer2ViewController.tableView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
    
    if (isWeekday)  // 平常日
    {
        self.r66layer1ViewController = layer1ViewController;
        [self.view insertSubview:r66layer1ViewController.view atIndex:0];
        [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    else            // 假日
    {
        self.r66layer2ViewController = layer2ViewController;
        [self.view insertSubview:r66layer2ViewController.view atIndex:0];
        [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    
    switchButton = [[UIBarButtonItem alloc] initWithTitle:@"路線圖" style:UIBarButtonItemStyleBordered target:self action:@selector(showR66RoutePic)];
    switchButton.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = switchButton;
    [self.view addGestureRecognizer:swipeRecognizer];
    [super viewDidLoad];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            NSLog(@"Cancel Button Pressed");
            break;
        case 1:
        {
            // ------------------------------------------------------------------------
            NSString *error;
            NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString *plistPath = [rootPath stringByAppendingPathComponent:@"AlertViewShown.plist"];
            NSDictionary *plistDict = [NSDictionary dictionaryWithObject:@"FALSE" forKey:@"NextTimeShown"];
            NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:plistDict format:NSPropertyListXMLFormat_v1_0 errorDescription:&error];
            if(plistData) {
                [plistData writeToFile:plistPath atomically:YES];
            }
            else {
                NSLog(@"%@", error);
                [error release];
            }
            // ------------------------------------------------------------------------
            break;
        }
        default:
            break;
    }
}

- (void)handlePinch
{
    
    NSLog(@"handlePinch");
    if (pinchRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if ([pinchRecognizer scale] < 1.0f)
            [pinchRecognizer setScale:1.0f];
        CGAffineTransform transform = CGAffineTransformMakeScale([pinchRecognizer scale], [pinchRecognizer scale]);
        imageView.transform = transform;
    }
}

- (void)showR66RoutePic
{
    [UIImageView beginAnimations:nil context:nil];
    [UIImageView setAnimationDuration:0.5];
    [UIImageView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-60)];
    imageView.image = [UIImage imageNamed:@"R66Route.png"];
    
    
    NSLog(@"%@", self.view);
    if ([switchButton.title isEqualToString:@"路線圖"])
    {
        switchButton.title = @"關閉";
        swipeRecognizer.enabled = NO;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-60)];
        scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"global/body-background.png"]];
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        scrollView.bouncesZoom = YES;
        scrollView.clipsToBounds = YES;
        scrollView.contentSize = imageView.frame.size;
        [scrollView addSubview:imageView];
        scrollView.minimumZoomScale = scrollView.frame.size.width/imageView.frame.size.width;
        scrollView.maximumZoomScale = 2.0;
        [scrollView setZoomScale:scrollView.minimumZoomScale];
        [imageView addGestureRecognizer:pinchRecognizer];
        [self.view addSubview:scrollView];
        //[self.view bringSubviewToFront:scrollView];
        
        [UIImageView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    }
    else
    {
        swipeRecognizer.enabled = YES;
        switchButton.title = @"路線圖";
        //[imageView removeFromSuperview];
        [scrollView removeFromSuperview];
        [UIImageView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    }
    [UIImageView commitAnimations];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollViewInside
{
    NSLog(@"viewForZoomingToScollView");
    return self.imageView;
}

- (void)convertSwipeRecognizer
{
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    else
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self switchView];
    NSLog(@"switchLeft");
}

- (void)detectCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"cccc"];
    NSString *currentTime = [formatter stringFromDate:date];
    NSLog(@"%@", currentTime);
    if ([currentTime isEqualToString:@"Saturday"] || [currentTime isEqualToString:@"星期六"] || [currentTime isEqualToString:@"Sunday"] || [currentTime isEqualToString:@"星期日"])
        isWeekday = false;
    else
        isWeekday = true;
}

- (void)switchView
{
    [UIView beginAnimations:@"View Curl" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    if (self.r66layer2ViewController.view.superview == nil)
    {
        if (self.r66layer2ViewController == nil)
        {
            //R66Layer2ViewController *layer2ViewController = [[R66Layer2ViewController alloc] initWithStyle:UITableViewStyleGrouped];
            R66RightLayerViewController *layer2ViewController = [[R66RightLayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
            layer2ViewController.tableView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
            self.r66layer2ViewController = layer2ViewController;
            [layer2ViewController release];
        }
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        switchButton.title = @"路線圖";
        [r66layer1ViewController.view removeFromSuperview];
        [self.view insertSubview:r66layer2ViewController.view atIndex:0];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    }
    else
    {
        if (self.r66layer1ViewController == nil)
        {
            //R66Layer1ViewController *layer1ViewController = [[R66Layer1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
            R66LeftLayerViewController *layer1ViewController = [[R66LeftLayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
            layer1ViewController.tableView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
            self.r66layer1ViewController = layer1ViewController;
            [layer1ViewController release];
        }
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        switchButton.title = @"路線圖";
        [r66layer2ViewController.view removeFromSuperview];
        [self.view insertSubview:r66layer1ViewController.view atIndex:0];
    }
    [UIView commitAnimations];
}

- (void)dealloc
{
    [switchButton release];
    [r66layer1ViewController release];
    [r66layer2ViewController release];
    [super dealloc];
}

@end

