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
@synthesize r66layer1ViewController, r66layer2ViewController;
@synthesize switchButton, swipeRecognizer, pinchRecognizer, imageView;

- (void)viewDidLoad
{
    [self detectCurrentTime];
    NSLog(@"Left & Right Layers");
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenHeight = screenBound.size.height;
    screenWidth = screenBound.size.width;
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(convertSwipeRecognizer)];
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch)];
    [self.view addGestureRecognizer:swipeRecognizer];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    
    
    //R66Layer1ViewController *layer1ViewController = [[R66Layer1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    //R66Layer2ViewController *layer2ViewController = [[R66Layer2ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    R66LeftLayerViewController *layer1ViewController = [[R66LeftLayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    R66RightLayerViewController *layer2ViewController = [[R66RightLayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
    layer1ViewController.tableView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
    layer2ViewController.tableView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
    
    //if (isWeekday)  // 平常日
    /*{
     self.r66layer1ViewController = layer1ViewController;
     [self.view insertSubview:r66layer1ViewController.view atIndex:0];
     switchButton = [[UIBarButtonItem alloc] initWithTitle:@"例假日" style:UIBarButtonItemStyleBordered target:self action:@selector(switchView)];
     }*/
    //else            // 假日
    /*{
     self.r66layer2ViewController = layer2ViewController;
     [self.view insertSubview:r66layer2ViewController.view atIndex:0];
     switchButton = [[UIBarButtonItem alloc] initWithTitle:@"平常日" style:UIBarButtonItemStyleBordered target:self action:@selector(switchView)];
     }*/
    self.r66layer1ViewController = layer1ViewController;
    [self.view insertSubview:r66layer1ViewController.view atIndex:0];
    switchButton = [[UIBarButtonItem alloc] initWithTitle:@"路線圖" style:UIBarButtonItemStyleBordered target:self action:@selector(showR66RoutePic)];
    
    switchButton.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = switchButton;
    [super viewDidLoad];
}

- (void)handlePinch
{
    NSLog(@"handlePinch");
    /*if (pinchRecognizer.state == UIGestureRecognizerStateEnded)
     {
     if ([pinchRecognizer scale] < 1.0f)
     [pinchRecognizer setScale:1.0f];
     CGAffineTransform transform = CGAffineTransformMakeScale([pinchRecognizer scale], [pinchRecognizer scale]);
     imageView.transform = transform;
     }*/
}

- (void)showR66RoutePic
{
    [UIImageView beginAnimations:@"Fade in" context:nil];
    [UIImageView setAnimationDuration:1.0];
    [UIImageView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    NSLog(@"%@", self.view);
    if ([switchButton.title isEqualToString:@"路線圖"])
    {
        swipeRecognizer.enabled = NO;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        screenWidth = screenSize.width;
        screenHeight = screenSize.height;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-60)];
        imageView.image = [UIImage imageNamed:@"R66Route.png"];
        switchButton.title = @"關閉";
        [self.view addSubview:imageView];
        [UIImageView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    }
    else
    {
        swipeRecognizer.enabled = YES;
        switchButton.title = @"路線圖";
        [imageView removeFromSuperview];
        [UIImageView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    }
    [UIImageView commitAnimations];
}

- (void)convertSwipeRecognizer
{
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    else
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    
    /*R66RightLayerViewController *layer2ViewController = [[R66RightLayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
     layer2ViewController.tableView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
     self.r66layer2ViewController = layer2ViewController;
     [layer2ViewController release];
     [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
     switchButton.title = @"平常日";
     [r66layer1ViewController.view removeFromSuperview];
     [self.view insertSubview:r66layer2ViewController.view atIndex:0];*/
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

