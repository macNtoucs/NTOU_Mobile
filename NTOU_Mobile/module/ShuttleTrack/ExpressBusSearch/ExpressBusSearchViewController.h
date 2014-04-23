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
#define LAYER1_BUT_WIDTH    58
#define LAYER1_BUT_HEIGHT   40

@interface ExpressBusSearchViewController : UITableViewController
{
    NSMutableArray * searchResults;
    UISearchBar * searchBar;
    UIView *myKeyboardView;
    UIView *myKeyboardView2;
    UIColor *buttonTintColor;
    NSMutableString *buttonPartBusName;
}

@property (nonatomic, retain) NSMutableArray * searchResults;
@property (nonatomic, retain) UISearchBar * searchBar;
@property (nonatomic, retain) UIView *myKeyboardView;
@property (nonatomic, retain) UIView *myKeyboardView2;
@property (nonatomic, retain) UIColor *buttonTintColor;
@property (nonatomic, retain) NSMutableString *buttonPartBusName;

@end
