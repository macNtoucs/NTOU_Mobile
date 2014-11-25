//
//  SearchResultViewController.h
//  library-搜尋結果
//
//  Created by R MAC on 13/5/31.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "PullTableView.h"
@class MainViewController;
@interface SearchResultViewController : UITableViewController  <NSURLConnectionDelegate , NSURLConnectionDataDelegate,PullTableViewDelegate>
{
    PullTableView *storyTable;
}

@property (nonatomic, assign) PullTableView *storyTable;
@property (strong, nonatomic) MainViewController *mainview;
@property (nonatomic,retain) NSMutableArray *data;
@property (strong, nonatomic) NSString *inputtext;
@property (nonatomic) BOOL start;
@property (nonatomic) NSInteger book_count;
@property int Searchpage;
@property (strong, nonatomic) NSString * searchType ;

-(void)search;
@end
