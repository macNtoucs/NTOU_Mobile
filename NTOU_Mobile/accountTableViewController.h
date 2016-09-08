//
//  accountTableViewController.h
//  NTOU_Mobile
//
//  Created by IMAC on 2014/5/14.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

@protocol loginAndRegisterDelegate <NSObject>

@required
- (BOOL) login:(NSString *)title;
- (void) registerDeviceToken:(NSString *)title;
@end

#import <UIKit/UIKit.h>
#import "SecondaryGroupedTableViewCell.h"
#import "UIKit+NTOUAdditions.h"
#import "DefineConstant.h"
#import "MBProgressHUD.h"
#import "ClassDataBase.h"
#import "NTOUNotification.h"
@interface accountTableViewController : UITableViewController<UITextFieldDelegate,UIAlertViewDelegate,MBProgressHUDDelegate>
{
    UITextField* accountDelegate;
    UITextField* passwordDelegate;
    MBProgressHUD *HUD;
    BOOL loginSuccess;
    NSMutableString * buttonTitle;
    NSString * accountStoreKey;
    NSString * passwordStoreKey;
    NSString * loginSuccessStoreKey;
    NSString *explanation;
    id delegate;
}

@property (nonatomic, retain) UITextField* accountDelegate;
@property (nonatomic, retain) UITextField* passwordDelegate;
@property (nonatomic, retain) NSMutableArray * receiveArray;
@property (nonatomic, retain) NSString *accountStoreKey;
@property (nonatomic, retain) NSString *passwordStoreKey;
@property (nonatomic, retain) NSString *loginSuccessStoreKey;
@property (nonatomic, retain) NSString *explanation;
@property (nonatomic, retain) id delegate;
@end
