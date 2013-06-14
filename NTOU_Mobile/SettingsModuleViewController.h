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
@interface SettingsModuleViewController : UITableViewController<UITextFieldDelegate>
{
    UITextField* accountDelegate;
    UITextField* passwordDelegate;
    
}
@property (nonatomic, retain) UITextField* accountDelegate;
@property (nonatomic, retain) UITextField* passwordDelegate;

+(NSString *) getAccount;
+(NSString *) getPassword;


@end
