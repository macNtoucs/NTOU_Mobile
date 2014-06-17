//
//  SearchResultViewController.h
//  library
//
//  Created by R MAC on 13/5/31.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@class MainViewController;
@interface SearchResultViewController : UITableViewController  <NSURLConnectionDelegate , NSURLConnectionDataDelegate>

@property (strong, nonatomic) MainViewController *mainview;
@property (nonatomic,retain) NSMutableArray *data;
@property (strong, nonatomic) NSString *inputtext;
@property (strong, nonatomic) TFHpple* sparser;
@property (nonatomic) BOOL start;
@property (nonatomic) NSInteger book_count;
@property int Searchpage;
@property (strong, nonatomic) NSString * searchType ;

-(void)search;
@end
