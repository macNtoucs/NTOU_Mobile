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
typedef enum {
    NewsCategoryIdAnnounce = 0,
    NewsCategoryIdSymposium = 1,
    NewsCategoryIdArt = 2,
    NewsCategoryIdLecture = 3,
    NewsCategoryIdDocument = 4,
    NewsCategoryIdInformation = 5,
} NewsCategoryId;


@interface StoryListViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NavScrollerDelegate>
{
    NSArray *navButtons;
    UITableView *storyTable;
    NavScrollerView *navScrollView;
    UIView *activityView;
    NSIndexPath *tempTableSelection;
    BOOL lastRequestSucceeded;
    NSInteger activeCategoryId;
    NSDictionary *catchData;
    NSMutableArray* tableDisplayData[6];
}

@property (nonatomic, assign) NSInteger activeCategoryId;
@property (nonatomic, retain) NSDictionary *catchData;
@end
