//
//  LoginResultViewController.h
//  library
//
//  Created by apple on 13/7/5.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "accountTableViewController.h"
@class WOLSwitchViewController;
@interface LoginResultViewController : UITableViewController<loginAndRegisterDelegate>
@property int page;
-(void)fetchHistory;
@end
