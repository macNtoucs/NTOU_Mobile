//
//  TPRouteDetailViewController.h
//  bus
//
//  Created by iMac on 12/9/5.
//
//
//
//  SecondLevelViewController.h
//  TaipeiBusSystem
//
//  Created by Ching-Chi Lin on 12/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"
#import "TFHppleElement.h"
//#import "ToolBarController.h"
#import "EGORefreshTableHeaderView.h"
#import "UIKit+NTOUAdditions.h"

@interface KLRouteDetailViewController : UITableViewController<EGORefreshTableHeaderDelegate, UIAlertViewDelegate>
{
    NSString *busName;
    NSString *goBack;
    NSString *departure;
    NSString *destination;
    
    NSMutableArray * stops;
    NSMutableArray * m_waitTimeResult;
    
    //ToolBarController* toolbar;
    UIBarButtonItem *anotherButton;
    EGORefreshTableHeaderView *_refreshHeaderView; // 手動下拉更新
    UIImageView * success;
    NSDate * lastRefresh;
    NSTimer * refreshTimer; // 倒數計時
    BOOL _reloading;
    NSArray *preArray;
    BOOL ISREAL;
    UIActivityIndicatorView *activityIndicator;
    UIAlertView *loadingView;
    
    UILabel *secondsLabel;
}
@property (nonatomic, retain) NSString *busName;
@property (nonatomic, retain) NSString *goBack;
@property (nonatomic, retain) NSString *departure;
@property (nonatomic, retain) NSString *destination;

@property (nonatomic, retain) NSMutableArray * stops;
@property (nonatomic, retain) NSMutableArray * m_waitTimeResult;

//@property (nonatomic, retain) ToolBarController* toolbar;
@property (nonatomic, retain) UIBarButtonItem *anotherButton;
@property (nonatomic, retain) UIImageView * success;
@property (nonatomic, retain) NSDate *lastRefresh;
@property (nonatomic, retain) NSTimer *refreshTimer;
@property (nonatomic, retain) NSArray *preArray;
@property (nonatomic, retain) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) UIAlertView *loadingView;

@property (nonatomic, retain) UILabel *secondsLabel;

- (void) estimateTime; // 抓取公車進站時間
- (void) setter_busName:(NSString *) name andGoBack:(NSInteger) goBack; // 取得公車名稱
- (void) setter_departure:(NSString *)dep andDestination:(NSString *)des;
//- (void) setter_busId:(NSString *) Id; // 取得公車名稱
//- (void) setter_url:(NSString *) inputUrl;

- (void)reloadTableViewDataSource;

@end

