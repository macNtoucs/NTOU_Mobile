//
//  LoginOutResultViewController.h
//  library -個人圖書館-借出記錄
//
//  Created by apple on 13/7/21.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "accountTableViewController.h"
@class WOLSwitchViewController;
@interface LoginOutResultViewController : UITableViewController<UIActionSheetDelegate,UIAlertViewDelegate,loginAndRegisterDelegate>
@property (nonatomic,retain) NSString *fetchURL;
@property (strong, nonatomic) WOLSwitchViewController *switchviewcontroller;
@property (nonatomic,retain) NSString *userAccountId;

- (void)showActionToolbar:(BOOL)show;
-(void)fetchoutHistory;
-(void)cleanselectindexs;
- (void)allcancel;


@end
