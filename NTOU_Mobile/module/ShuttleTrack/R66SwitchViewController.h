//
//  R66SwitchViewController.h
//  NTOU_Mobile
//
//  Created by NTOUCS on 13/11/20.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class R66Layer1ViewController;
//@class R66Layer2ViewController;
@class R66LeftLayerViewController;
@class R66RightLayerViewController;

@interface R66SwitchViewController : UIViewController <UIGestureRecognizerDelegate>
{
    BOOL isWeekday; // weekday:true  weekend:false
    UIBarButtonItem *switchButton;
    CGFloat screenHeight;
    CGFloat screenWidth;
    UISwipeGestureRecognizer *swipeRecognizer;
    UIPinchGestureRecognizer *pinchRecognizer;
    UIImageView *imageView;
}
//@property (strong, nonatomic) R66Layer1ViewController *r66layer1ViewController;
//@property (strong, nonatomic) R66Layer2ViewController *r66layer2ViewController;
@property (strong, nonatomic) R66LeftLayerViewController *r66layer1ViewController;
@property (strong, nonatomic) R66RightLayerViewController *r66layer2ViewController;
@property (strong, nonatomic) UIBarButtonItem *switchButton;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRecognizer;
@property (strong, nonatomic) UIPinchGestureRecognizer *pinchRecognizer;
@property (strong, nonatomic) UIImageView *imageView;
//- (void)switchView;

@end
