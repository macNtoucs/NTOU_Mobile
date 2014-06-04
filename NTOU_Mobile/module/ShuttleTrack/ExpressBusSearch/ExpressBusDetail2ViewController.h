//
//  ExpressBusDetailViewController.h
//  NTOU_Mobile
//
//  Created by iMac on 14/4/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKit+NTOUAdditions.h"
#import "EGORefreshTableHeaderView.h"

@interface ExpressBusDetail2ViewController : UITableViewController<EGORefreshTableHeaderDelegate, UIAlertViewDelegate>
{
    NSString * completeRouteName;
    NSString * routeId;
    NSMutableArray * stops;
    NSMutableArray * times;
    UILabel * label;
    CGSize labelsize;
    UITableView *departureTimeTableView;
    
    // alert view
    EGORefreshTableHeaderView *_refreshHeaderView; // 手動下拉更新
    UIImageView * success;
    NSTimer * refreshTimer; // 倒數計時
    BOOL _reloading;
    UIActivityIndicatorView *activityIndicator;
    UIAlertView *loadingView;
}

@property (nonatomic, retain) NSString * completeRouteName;
@property (nonatomic, retain) NSMutableArray * stops;
@property (nonatomic, retain) NSMutableArray * times;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, assign) CGSize labelsize;
@property (nonatomic, retain) UITableView *departureTimeTableView;

@property (nonatomic, retain) UIImageView * success;
@property (nonatomic, retain) NSTimer *refreshTimer;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIAlertView *loadingView;

- (void)setCompleteRouteName:(NSString *)selectedShortRouteName;
- (void)showDepartureTime:(NSString *)selectedShortRouteName;
@end
