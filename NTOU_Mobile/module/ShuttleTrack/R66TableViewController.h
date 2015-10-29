//
//  R66TableViewController.h
//  NTOU_Mobile
//
//  Created by 蘇琍 on 2015/2/5.
//  Copyright (c) 2015年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondaryGroupedTableViewCell.h"
@class R66RoutePicViewController;


@interface R66TableViewController : UITableViewController
{
    BOOL isWeekday; // weekday:true  weekend:false
    NSInteger weekState;
    NSArray *weekend_marine;
    NSArray *weekend_qidu;
    NSArray *weekday_marine;
    NSArray *weekday_qidu;
    NSArray **weekpointer_qidu;
    NSArray **weekpointer_marine;
    UIButton *weekdayButton;
    UIButton *weekendButton;
    CGFloat screenHeight;
    CGFloat screenWidth;
    UISwipeGestureRecognizer *swipeRecognizer;
}
@property (nonatomic, retain) NSArray *weekday_marine;
@property (nonatomic, retain) NSArray *weekday_qidu;
@property (nonatomic, retain) NSArray *weekend_marine;
@property (nonatomic, retain) NSArray *weekend_qidu;
@property (strong, nonatomic) UIButton *weekdayButton;
@property (strong, nonatomic) UIButton *weekendButton;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRecognizer;



- (void)buttonPressed:(id)sender;
@end
