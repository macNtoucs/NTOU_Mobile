//
//  NTOUNotification.h
//  NTOU_Mobile
//
//  Created by IMAC on 2014/4/10.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "NTOUModule.h"
#import "NTOUConstants.h"
#define notificationsUserDefaultsKey @"notificationsUserDefaults"
@interface Notification : NSObject
{
	NSString *moduleName;
	NSString *content;
}

@property (nonatomic, retain) NSString *moduleName;
@property (nonatomic, retain) NSString *content;

- (id) initWithModuleName: (NSString *)aModuleName content: (NSString *)aContent;
- (id) initWithModuleDictionary:(NSDictionary *)apnsDictionary;
- (id) initWithString:(NSString *) string;
- (NSString *) string;

@end

@interface NTOUNotificationHandle : NSObject

+ (NSMutableDictionary *) getNotifications;
+ (void)storeNotifications:(NSMutableDictionary *) notifications;

+ (void) deleteUnreadNotificationAndModifyBadge:(NSMutableDictionary *)notifications modules:(NSString *)tag;
+ (NSString *) getEmergencyNotificationAndDelete;
+ (void) setBadgeValue:(NSString *)badge forModule:(NSString *) module;
+ (void) updateUI:(Notification *) notification;
+ (void) setAllBadge;

+ (void) sendDevicePushSetting:(NSMutableArray *) receiveArray;
+(NSMutableArray *) getDevicePushSettingArray;

+ (void) sendRegisterDevice:(NSString *) studentID;
@end
