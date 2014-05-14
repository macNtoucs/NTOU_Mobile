//
//  SettingsModuleViewController.h
//  NTOU_Mobile
//
//  Created by mac_hero on 13/6/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecondaryGroupedTableViewCell.h"
#import "UIKit+NTOUAdditions.h"
#import "DefineConstant.h"
#import "MBProgressHUD.h"
#import "ClassDataBase.h"
@interface SettingsModuleViewController : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    UITextField* accountDelegate;
    UITextField* passwordDelegate;
    MBProgressHUD *HUD;
    BOOL loginSuccess;
    NSMutableString * buttonTitle;
    NSMutableArray * receiveArray;
}
@property (nonatomic, retain) UITextField* accountDelegate;
@property (nonatomic, retain) UITextField* passwordDelegate;
@property (nonatomic, retain) NSMutableArray * receiveArray;

+(NSString *) getAccount;
+(NSString *) getPassword;
+(BOOL) getLoginSuccess;

@end
