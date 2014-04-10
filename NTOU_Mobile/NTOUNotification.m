//
//  NTOUNotification.m
//  NTOU_Mobile
//
//  Created by IMAC on 2014/4/10.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "NTOUNotification.h"
#import "AppDelegate.h"
#import "NTOUModule.h"
#import "NTOUConstants.h" 
#define notificationsUserDefaultsKey @"notificationsUserDefaults"
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
    [self initWithModuleName:[string substringToIndex:range.location-1] content:[string substringFromIndex:range.location]];
    return self;
}


- (NSString *) string {
	return [NSString stringWithFormat:@"%@:%@", moduleName, content];
}

@end

@implementation NTOUNotificationHandle


+ (void) updateUI:(Notification *) notification
{
    NSLog(@"%@,%@",notification.moduleName,notification.content);
    NSMutableDictionary *notifications = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:notificationsUserDefaultsKey]];
    if (!notifications) notifications = [[NSMutableDictionary alloc] init];
    NTOU_MobileAppDelegate *appDelegate = (NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray* unReadNotification = nil;
    if ([notification.moduleName isEqualToString:EmergencyTag]){
        [notifications setValue:[notification string] forKey:notification.moduleName];
        for (SpringboardIcon *aButton in [appDelegate.springboardController.grid icons])
            if ([aButton.moduleTag isEqualToString:EmergencyTag]) {
                [aButton setBadgeValue:@"1"];
            }
    }
    else
    {
        unReadNotification = [NSMutableArray arrayWithArray:[notifications objectForKey:notification.moduleName]];
        if (!unReadNotification) unReadNotification = [[NSMutableArray alloc] init];
        [unReadNotification addObject:[notification string]];
        [notifications setObject:unReadNotification forKey:notification.moduleName];
        for (SpringboardIcon *aButton in [appDelegate.springboardController.grid icons])
            if ([aButton.moduleTag isEqualToString:notification.moduleName]) {
                [aButton setBadgeValue:[NSString stringWithFormat:@"%d",[unReadNotification count]]];
            }
    }
    [[NSUserDefaults standardUserDefaults] setObject:notifications forKey:notificationsUserDefaultsKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
