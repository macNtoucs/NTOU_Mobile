//
//  APpDelegate+ModuleList.h
//  NTOU_Mobile
//
//  Created by R MAC on 13/3/7.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//


#import "AppDelegate.h"
#import "NTOUUIConstants.h"
#import "NTOUConstants.h"
@interface NTOU_MobileAppDelegate (ModuleListAdditions)

#pragma mark class methods
+ (NTOUModule *)moduleForTag:(NSString *)aTag;

#pragma mark Basics
- (NSMutableArray *)createModules;
- (NTOUModule *)moduleForTag:(NSString *)aTag;

- (void)showModuleForTag:(NSString *)tag;

#pragma mark Preferences
- (NSArray *)defaultModuleOrder;
- (void)registerDefaultModuleOrder;
- (void)loadSavedModuleOrder;
- (void)saveModulesState;

@end

