//
//  StoryListViewController.h
//  NTOU_Mobile
//
//  Created by mac_hero on 13/3/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavScrollerView.h"
#import "Announce_API.h"
#import "StoryDetailViewController.h"

typedef enum {
    NewsCategoryIdAnnounce = 0,
    NewsCategoryIdSymposium = 1,
    NewsCategoryIdArt = 2,
    NewsCategoryIdLecture = 3,
    NewsCategoryIdDocument = 999,
    NewsCategoryIdInformation = 4,
} NewsCategoryId;


@interface StoryListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NavScrollerDelegate,Announce_API_Delegate>
{
    NSArray *navButtons;
    UITableView *storyTable;
    NavScrollerView *navScrollView;
    UIView *activityView;
    NSIndexPath *tempTableSelection;
    BOOL lastRequestSucceeded;
    NSInteger activeCategoryId;
    NSDictionary *catchData;
    Announce_API* connect;
    NSMutableArray* tableDisplayData[6];
    NSInteger pageCount[6];
    BOOL endCatchData[6];
}

@property (nonatomic, assign) NSInteger activeCategoryId;
@property (nonatomic, retain) NSDictionary *catchData;
@property (nonatomic, retain) Announce_API* connect;
@end
