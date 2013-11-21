//
//  R66SwitchViewController.m
//  NTOU_Mobile
//
//  Created by NTOUCS on 13/11/20.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "R66SwitchViewController.h"
#import "R66Layer1ViewController.h"
#import "R66Layer2ViewController.h"

@interface R66SwitchViewController ()
@end

@implementation R66SwitchViewController
@synthesize r66layer1ViewController, r66layer2ViewController;
@synthesize switchButton;


- (void)viewDidLoad
{
    [self detectCurrentTime];
    
    R66Layer1ViewController *layer1ViewController = [[R66Layer1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    R66Layer2ViewController *layer2ViewController = [[R66Layer2ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    if (isWeekday)  // 平常日
    {
        self.r66layer1ViewController = layer1ViewController;
        [self.view insertSubview:r66layer1ViewController.view atIndex:0];
        switchButton = [[UIBarButtonItem alloc] initWithTitle:@"例假日" style:UIBarButtonItemStyleBordered target:self action:@selector(switchView)];
    }
    else            // 假日
    {
        self.r66layer2ViewController = layer2ViewController;
        [self.view insertSubview:r66layer2ViewController.view atIndex:0];
        switchButton = [[UIBarButtonItem alloc] initWithTitle:@"平常日" style:UIBarButtonItemStyleBordered target:self action:@selector(switchView)];
    }
    
    switchButton.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = switchButton;
    [super viewDidLoad];
}

- (void)detectCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"cccc"];
    NSString *currentTime = [formatter stringFromDate:date];
    if ([currentTime isEqualToString:@"Saturday"] || [currentTime isEqualToString:@"Sunday"])
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
            R66Layer2ViewController *layer2ViewController = [[R66Layer2ViewController alloc] initWithStyle:UITableViewStyleGrouped];
            self.r66layer2ViewController = layer2ViewController;
            [layer2ViewController release];
        }
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        switchButton.title = @"平常日";
        [r66layer1ViewController.view removeFromSuperview];
        [self.view insertSubview:r66layer2ViewController.view atIndex:0];
    }
    else
    {
        if (self.r66layer1ViewController == nil)
        {
            R66Layer1ViewController *layer1ViewController = [[R66Layer1ViewController alloc] initWithStyle:UITableViewStyleGrouped];
            self.r66layer1ViewController = layer1ViewController;
            [layer1ViewController release];
        }
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        switchButton.title = @"例假日";
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

