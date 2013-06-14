//
//  SettingModule.m
//  NTOU_Mobile
//
//  Created by mac_hero on 13/6/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "SettingModule.h"

@implementation SettingModule
@synthesize SettingsModuleView;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = SettingsTag;
        self.shortName = @"設定";
        self.longName = @"settings";
        self.iconName = @"settings";
    }
    return self;
}

- (void)loadModuleHomeController
{
    [self setModuleHomeController:[[[SettingsModuleViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease]];
}

- (void)dealloc {
    [super dealloc];
}


@end
