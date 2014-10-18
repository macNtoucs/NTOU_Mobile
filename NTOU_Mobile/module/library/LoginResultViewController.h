//
//  LoginResultViewController.h
//  library
//
//  Created by apple on 13/7/5.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "accountTableViewController.h"
#import "PullTableView.h"
@class WOLSwitchViewController;
@interface LoginResultViewController : UITableViewController<loginAndRegisterDelegate,PullTableViewDelegate>
{
    PullTableView *storyTable;
}

@property (nonatomic, assign) PullTableView *storyTable;
@property int page;
-(void)fetchHistory;
@end
