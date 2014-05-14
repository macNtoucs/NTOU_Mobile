//
//  ExpressBusDetailViewController.h
//  NTOU_Mobile
//
//  Created by iMac on 14/4/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKit+NTOUAdditions.h"

@interface ExpressBusDetailViewController : UITableViewController
{
    NSString * completeRouteName;
    NSString * routeId;
    NSMutableArray * stops;
    NSMutableArray * times;
    UILabel * label;
    CGSize labelsize;
    UITableView *departureTimeTableView;
}

@property (nonatomic, retain) NSString * completeRouteName;
@property (nonatomic, retain) NSMutableArray * stops;
@property (nonatomic, retain) NSMutableArray * times;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, assign) CGSize labelsize;
@property (nonatomic, retain) UITableView *departureTimeTableView;

- (void)setCompleteRouteName:(NSString *)selectedShortRouteName;
- (void)showDepartureTime:(NSString *)selectedShortRouteName;
@end
