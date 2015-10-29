//
//  RouteDetailViewController.h
//  bus
//  海洋專車：市區公車站牌列表-所經公車路線到站資訊
//  Created by mac_hero on 12/5/18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <libxml/HTMLparser.h>
#import "TFHpple.h"
#import "DepatureViewController.h"
#import "SecondaryGroupedTableViewCell.h"
#import "RequestOperation.h"
@interface RouteDetailViewController : UITableViewController<UIApplicationDelegate,EGORefreshTableHeaderDelegate,UIAlertViewDelegate,RequestOperationDelegate>
{
    NSMutableArray *routeNames;
    NSMutableArray *waitTimes;
    NSURL* waitTime1_103;
    NSURL* waitTime2_103;
    NSURL* waitTime1_104;
    NSURL* waitTime2_104;
    NSURL* waitTime1_108;
    NSURL* waitTime2_108;
    NSURL *station_waitTime1_103;
    NSURL *station_waitTime2_103;
    NSURL *station_waitTime1_104;
    NSURL *station_waitTime2_104;
    NSURL *station_waitTime1_108;
    NSURL *station_waitTime2_108;
    BOOL dir;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    UIBarButtonItem *anotherButton;
    NSTimer * refreshTimer;
    NSDate * lastRefresh;
    UIAlertView *  loadingAlertView;
    NSMutableData* receivedData;
    NSURLConnection *theConncetion;
    NSOperationQueue *queue;
    int theConncetionCount;
    bool updateTimeOnButton;
    BOOL isZhongzheng;
}

- (void) getURL:(NSString* ) inputURL;
- (void) addRoutesURL: (NSString *)_103First
                  and: (NSString *)_103Second
                  and: (NSString *)_104First
                  and: (NSString *)_104Second
                  and: (NSString *)_108First
                  and: (NSString *)_108Second;;
- (void) addStationURL : (NSString *)_103First
                and: (NSString *)_103Second
                and: (NSString *)_104First
                and: (NSString *)_104Second;
-(void)goBackMode:(BOOL)go; //true 往市區
-(void)isZhongzheng:(BOOL)is;

@property (nonatomic, retain) NSURLConnection *theConncetion;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, retain) NSMutableArray *routeNames;
@property (nonatomic, retain) NSMutableArray *waitTimes;
@property (nonatomic , retain) NSMutableArray* waitTime;
@property (nonatomic , retain) NSMutableData* receivedData;
@property (nonatomic ,retain)  NSURL* waitTime1_103;
@property (nonatomic ,retain)  NSURL* waitTime2_103;
@property (nonatomic ,retain)  NSURL* waitTime1_104;
@property (nonatomic ,retain)  NSURL* waitTime2_104;
@property (nonatomic ,retain)  NSURL* waitTime1_108;
@property (nonatomic ,retain)  NSURL* waitTime2_108;
@property (nonatomic ,retain)  NSURL *station_waitTime1_103;
@property (nonatomic ,retain)  NSURL *station_waitTime2_103;
@property (nonatomic ,retain)  NSURL *station_waitTime1_104;
@property (nonatomic ,retain)  NSURL *station_waitTime2_104;
@property (nonatomic, retain) UIBarButtonItem *anotherButton;
@property (nonatomic, retain) NSTimer *refreshTimer;
@property (nonatomic, retain) NSDate *lastRefresh;

@end
