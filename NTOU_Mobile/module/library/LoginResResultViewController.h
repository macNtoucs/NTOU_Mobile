//
//  LoginResResultViewController.h
//  library
//
//  Created by apple on 13/7/19.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "accountTableViewController.h"
@class WOLSwitchViewController;
@interface LoginResResultViewController : UITableViewController<UIActionSheetDelegate,UIAlertViewDelegate,loginAndRegisterDelegate>
@property (nonatomic,retain) NSString *fetchURL;
@property (strong, nonatomic) WOLSwitchViewController *switchviewcontroller;
@property (nonatomic,retain) NSString *userAccountId;

-(void)fetchresHistory;
-(void)cleanselectindexs;
- (void)allcancel;
@end
