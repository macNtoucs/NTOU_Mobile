//
//  APpDelegate+ModuleList.m
//  NTOU_Mobile
//
//  Created by R MAC on 13/3/7.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "AppDelegate+ModuleList.h"
#import "NTOUModule.h"
#import "ShuttleModule.h"
#import "EmergencyModule.h"
#import	"CMModule.h"
#import "PeopleModule.h"
#import "AboutModule.h"
#import "ScheduleModule.h"

#import "InformationModule.h"

#import "NewsModule.h"
#import "StellarModule.h"
#import "SettingModule.h"
#import "LibraryModule.h"
#import "OtherLinkModule.h"
/*#import "NewsModule.h"



#import "PeopleModule.h"
#import	"CMModule.h"
#import "EmergencyModule.h"
#import "MobileWebModule.h"
#import "SettingsModule.h"
#import "AboutModule.h"
#import "CalendarModule.h"
#import "ToursModule.h"
#import "LibrariesModule.h"
#import "NTOUMobileServerConfiguration.h"
#import "QRReaderModule.h"
#import "FacilitiesModule.h"
#import "LinksModule.h"
#import "NTOU_LifeViewController.h"
*/
// #import your module's header here

@implementation NTOU_MobileAppDelegate (ModuleListAdditions)
#pragma mark class methods
+ (NTOUModule *)moduleForTag:(NSString *)aTag {
	NTOU_MobileAppDelegate *delegate = ((NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate]);
	return [delegate moduleForTag:aTag];
}

#pragma mark Basics
- (NSMutableArray *)createModules {
    // The order of this array is the default module order
    NSMutableArray *result = [NSMutableArray array];
    
    // add your NTOUModule subclass here by duplicating this line
    //[result addObject:[[[YourNTOUModuleSubclass alloc] init] autorelease]];
    
    [result addObject:[[[NewsModule alloc] init] autorelease]];//最新消息
    [result addObject:[[[CMModule alloc] init] autorelease]];//校園導覽
    [result addObject:[[[ShuttleModule alloc] init] autorelease]];//交通資訊
    [result addObject:[[[PeopleModule alloc] init] autorelease]];//生活圈
    
    [result addObject:[[[StellarModule alloc] init] autorelease]];//個人課程
    
    //[result addObject:[[[InformationModule alloc] init] autorelease]];//個人資訊
    
    [result addObject:[[[LibraryModule alloc] init] autorelease]];//圖書館
    [result addObject:[[[ScheduleModule alloc] init] autorelease]];//行事曆
    [result addObject:[[[EmergencyModule alloc] init] autorelease]];//緊急聯絡
    
    [result addObject:[[[SettingModule alloc] init] autorelease]];//設定
    [result addObject:[[[AboutModule alloc] init] autorelease]];//關於
    [result addObject:[[[OtherLinkModule alloc] init] autorelease]];//其他連結
    
    
	
    
    //[result addObject:[[[CalendarModule alloc] init] autorelease]];
	
    // [result addObject:[[[ToursModule alloc] init] autorelease]];
    
    //[result addObject:[[[FreshmenModuel alloc] init] autorelease]];
    
    //  [result addObject:[[[FacilitiesModule alloc] init] autorelease]];
    //[result addObject:[[[QRReaderModule alloc] init] autorelease]];
    // [result addObject:[[[LinksModule alloc] init] autorelease]];
    
    
    
    return result;
}

- (NTOUModule *)moduleForTag:(NSString *)aTag {
    for (NTOUModule *aModule in self.modules) {
        if ([aModule.tag isEqual:aTag]) {
            return aModule;
        }
    }
    return nil;
}

- (void)showModuleForTag:(NSString *)tag {
    [self.springboardController pushModuleWithTag:tag];
}

#pragma mark Preferences
- (NSArray *)defaultModuleOrder {
    NSMutableArray *moduleNames = [NSMutableArray arrayWithCapacity:[self.modules count]];
    for (NTOUModule *aModule in self.modules) {
        [moduleNames addObject:aModule.tag];
    }
	return moduleNames;
}

- (void)registerDefaultModuleOrder {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *moduleNames = [self defaultModuleOrder];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          moduleNames, NTOUModuleTabOrderKey, nil];
    // Register defaults -- only has an effect if this is the first time this app has run on the device
    [defaults registerDefaults:dict];
    [defaults synchronize];
}

- (void)loadSavedModuleOrder {
	// In 3.0, there is no module order customization.
	BOOL wipeSavedOrder = (TRUE);
    NSArray *savedModuleOrder = [[NSUserDefaults standardUserDefaults] objectForKey:NTOUModuleTabOrderKey];
    NSMutableArray *oldModules = [[self.modules mutableCopy] autorelease];
    NSMutableArray *newModules = [NSMutableArray arrayWithCapacity:[self.modules count]];
	if (wipeSavedOrder) {
		savedModuleOrder = [self defaultModuleOrder];
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:NTOUEventsModuleInSortOrderKey];
	}
    for (NSString *aTag in savedModuleOrder) {
        NTOUModule *aModule = [self moduleForTag:aTag];
        if (aModule) {
            [oldModules removeObject:aModule];
            [newModules addObject:aModule];
        }
    }
    [newModules addObjectsFromArray:oldModules]; // in case modules have been added
    self.modules = [[newModules copy] autorelease]; // immutable copy
}

- (void)saveModulesState {
	NSMutableDictionary *modulesSavedState = [NSMutableDictionary dictionary];
    for (NTOUModule *aModule in self.modules) {
		if (aModule.currentPath && aModule.currentQuery) {
			[modulesSavedState setObject:[NSDictionary dictionaryWithObjectsAndKeys:aModule.currentPath, @"path", aModule.currentQuery, @"query", nil] forKey:aModule.tag];
		}
	}
	[[NSUserDefaults standardUserDefaults] setObject:modulesSavedState forKey:NTOUModulesSavedStateKey];
}
@end
