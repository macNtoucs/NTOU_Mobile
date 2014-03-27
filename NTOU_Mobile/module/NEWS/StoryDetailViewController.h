//
//  StoryDetailViewController.h
//  NTOU_Mobile
//
//  Created by mac_hero on 13/3/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "StoryListViewController.h"
#import "Announce_API_Key.h"

@interface StoryDetailViewController : UIViewController<UIWebViewDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong) NSDictionary *story;
@property (strong) UIWebView * webView;
@property (strong) UITextView *textView;
@property (strong) UITextView * textSubView;
@property (strong) UITableView * dataTableView;

@end
