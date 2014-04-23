//
//  NTOUNotification.m
//  NTOU_Mobile
//
//  Created by IMAC on 2014/4/10.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "NTOUNotification.h"


@implementation Notification
@synthesize moduleName,content;

- (id) initWithModuleName: (NSString *)aModuleName content: (NSString *)aContent
{
    self = [super init];
	if (self) {
		moduleName = [aModuleName retain];
		content = [aContent retain];
	}
    return self;
}

- (id) initWithModuleDictionary:(NSDictionary *)apnsDictionary
{
    [self initWithModuleName:[apnsDictionary objectForKey:@"moduleName"] content:[apnsDictionary objectForKey:@"content"]];
    return self;
}

- (id) initWithString:(NSString *) string
{
    NSRange range = [string rangeOfString:@":"];
    [self initWithModuleName:[string substringToIndex:range.location-1] content:[string substringFromIndex:range.location+1]];
    return self;
}


- (NSString *) string {
	return [NSString stringWithFormat:@"%@:%@", moduleName, content];
}

@end

@implementation NTOUNotificationHandle

+ (NSMutableDictionary *) getNotifications
{
    NSMutableDictionary *notifications = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:notificationsUserDefaultsKey]];
    if (!notifications) notifications = [[NSMutableDictionary alloc] init];
    return notifications;
}

+ (void)storeNotifications:(NSMutableDictionary *) notifications
{
    [[NSUserDefaults standardUserDefaults] setObject:notifications forKey:notificationsUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)modifyBadge
{
    NSMutableDictionary *notifications = [self getNotifications];
    int count = 0;
    for ( id notifi in [notifications allValues]) {
        if ([notifi isKindOfClass:[NSString class]])
            count++;
        else if ([notifi isKindOfClass:[NSArray class]])
        {
            count += [notifi count];
        }
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = count;
}

+ (void) deleteUnreadNotificationAndModifyBadge:(NSMutableDictionary *)notifications
{
    [notifications removeObjectForKey:EmergencyTag];
    [self storeNotifications:notifications];
    [self modifyBadge];
}

+ (NSString *) getEmergencyNotificationAndDelete
{
    NSMutableDictionary *notifications = [self getNotifications];
    if ([notifications objectForKey:EmergencyTag]) {
        NSString *emergencyNotification = [NSString stringWithString:[notifications objectForKey:EmergencyTag]];
        [self deleteUnreadNotificationAndModifyBadge:notifications];
        return emergencyNotification;
    }
    return nil;
}

+ (void) setBadgeValue:(NSString *)badge forModule:(NSString *) module
{
    NTOU_MobileAppDelegate *appDelegate = (NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    for (SpringboardIcon *aButton in [appDelegate.springboardController.grid icons])
        if ([aButton.moduleTag isEqualToString:module]) {
            [aButton setBadgeValue:badge];
        }
}

+ (void)setAllBadge
{
    NTOU_MobileAppDelegate *appDelegate = (NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *notifications = [self getNotifications];
    NSMutableArray* unReadNotification = nil;
    for (SpringboardIcon *aButton in [appDelegate.springboardController.grid icons])
    {
        unReadNotification = [notifications objectForKey:aButton.moduleTag];
        if (unReadNotification && [unReadNotification isKindOfClass:[NSString class]])
            [aButton setBadgeValue:@"1"];
        else if (unReadNotification)
            [aButton setBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)[unReadNotification count]]];
    }
    [self modifyBadge];
}

+ (void) updateUI:(Notification *) notification
{
    NSLog(@"%@,%@",notification.moduleName,notification.content);
    NSMutableDictionary *notifications = [self getNotifications];
    
    NSMutableArray* unReadNotification = nil;
    if ([notification.moduleName isEqualToString:EmergencyTag]){
        [notifications setValue:[notification string] forKey:notification.moduleName];
        [self setBadgeValue:@"1" forModule:EmergencyTag];
        NTOU_MobileAppDelegate *appDelegate = (NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
        for (NTOUModule *aModule in appDelegate.modules)
            if ([aModule.tag isEqual:EmergencyTag])
                [aModule handleNotification:notification shouldOpen:YES];        
    }
    else
    {
        unReadNotification = [NSMutableArray arrayWithArray:[notifications objectForKey:notification.moduleName]];
        if (!unReadNotification) unReadNotification = [[NSMutableArray alloc] init];
        [unReadNotification addObject:[notification string]];
        [notifications setObject:unReadNotification forKey:notification.moduleName];
        [self setBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)[unReadNotification count]] forModule:notification.moduleName];
    }
    [self storeNotifications:notifications];
    [self modifyBadge];
}
@end
