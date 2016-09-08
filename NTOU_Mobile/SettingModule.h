//
//  SettingModule.h
//  NTOU_Mobile
//
//  Created by mac_hero on 13/6/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "NTOUModule.h"
#import "SettingsModuleViewController.h"
#import "NTOUConstants.h"
#import "NTOUModule+Protected.h"
@interface SettingModule : NTOUModule
{
    SettingsModuleViewController * SettingsModuleView;

}
@property (nonatomic, retain) SettingsModuleViewController * SettingsModuleView;
@end
