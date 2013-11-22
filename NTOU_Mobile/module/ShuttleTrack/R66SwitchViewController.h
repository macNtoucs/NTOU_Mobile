//
//  R66SwitchViewController.h
//  NTOU_Mobile
//
//  Created by NTOUCS on 13/11/20.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class R66Layer1ViewController;
@class R66Layer2ViewController;

@interface R66SwitchViewController : UIViewController <UIGestureRecognizerDelegate>
{
    BOOL isWeekday; // weekday:true  weekend:false
    UIBarButtonItem *switchButton;
    CGFloat screenHeight;
    CGFloat screenWidth;
}
@property (strong, nonatomic) R66Layer1ViewController *r66layer1ViewController;
@property (strong, nonatomic) R66Layer2ViewController *r66layer2ViewController;
@property (strong, nonatomic) UIBarButtonItem *switchButton;

//- (void)switchView;

@end
