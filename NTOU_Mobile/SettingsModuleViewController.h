//
//  SettingsModuleViewController.h
//  NTOU_Mobile
//
//  Created by mac_hero on 13/6/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "accountTableViewController.h"
@interface SettingsModuleViewController : UITableViewController<loginAndRegisterDelegate>
{
    NSMutableArray * receiveArray;
}

@property (nonatomic, retain) NSMutableArray * receiveArray;

//API

//取得moodle帳號、密碼、是否已登入成功
+(NSString *) getMoodleAccount;
+(NSString *) getMoodlePassword;
+(BOOL) getMoodleLoginSuccess;

//取得圖書館帳號、密碼、是否已登入成功
+(NSString *) getLibraryAccount;
+(NSString *) getLibraryPassword;
+(BOOL) getLibraryLoginSuccess;

@end
