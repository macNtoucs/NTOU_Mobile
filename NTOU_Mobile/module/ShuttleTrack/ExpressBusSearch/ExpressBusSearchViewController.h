//
//  ExpressBusSearchViewController.h
//  NTOU_Mobile
//
//  Created by iMac on 14/4/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIKit+NTOUAdditions.h"
#import "ExpressBusDetailViewController.h"

@interface ExpressBusSearchViewController : UITableViewController
{
    NSMutableArray * searchResults;
    UISearchBar * searchBar;
}

@property (nonatomic, retain) NSMutableArray * searchResults;
@property (nonatomic, retain) UISearchBar * searchBar;
@end
