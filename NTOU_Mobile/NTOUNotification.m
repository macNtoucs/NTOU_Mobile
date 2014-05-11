//
//  NTOUNotification.m
//  NTOU_Mobile
//
//  Created by IMAC on 2014/4/10.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "NTOUNotification.h"
#import "ClassDataBase.h"

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
        else
            [aButton setBadgeValue:nil];
    }
    [self modifyBadge];
}

+ (void) updateUI:(Notification *) notification
{
    NSLog(@"%@,%@",notification.moduleName,notification.content);
    NSMutableDictionary *notifications = [self getNotifications];
    
    NSMutableArray* unReadNotification = nil;
    if ([notification.moduleName isEqualToString:EmergencyTag]){  //緊急聯絡
        [notifications setValue:[notification string] forKey:notification.moduleName];
        [self setBadgeValue:@"1" forModule:EmergencyTag];
    }
    else        //功課表
    {
        ClassDataBase* dataBase = [ClassDataBase sharedData];
        if (![dataBase searchCourseIDFormCourseName:notification.content]) //若通知不存在抓取下來的功課表，則不放入未讀推播
            return;
        
        unReadNotification = [NSMutableArray arrayWithArray:[notifications objectForKey:notification.moduleName]];
        if (!unReadNotification) unReadNotification = [[NSMutableArray alloc] init];
        [unReadNotification addObject:[notification string]];
        [notifications setObject:unReadNotification forKey:notification.moduleName];
        [self setBadgeValue:[NSString stringWithFormat:@"%lu",(unsigned long)[unReadNotification count]] forModule:notification.moduleName];
    }
    [self storeNotifications:notifications];
    [self modifyBadge];
    
    NTOU_MobileAppDelegate *appDelegate = (NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    for (NTOUModule *aModule in appDelegate.modules)
        if ([aModule.tag isEqual:notification.moduleName])
            [aModule handleNotification:notification shouldOpen:YES];
}


+ (void) sendDevicePushSetting:(NSMutableArray *) receiveArray
{
    NTOU_MobileAppDelegate *appDelegate = (NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:@"http://140.121.91.62/NTOUmsgProvider/devicePushSetting.php"];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = [NSString stringWithFormat:@"deviceToken=%@&moodle=%@&library=%@&emergency=%@",appDelegate.devicePushToken,receiveArray[0],receiveArray[1],receiveArray[2]];
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:receiveArray forKey:receivePushKey];
    [userDefaults synchronize];

}

+(NSMutableArray *) getDevicePushSettingArray
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:receivePushKey];
}

+ (void) sendRegisterDevice:(NSString *) studentID
{
    NTOU_MobileAppDelegate *appDelegate = (NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // You can send here, for example, an asynchronous HTTP request to your web-server to store this deviceToken remotely.
    //第一步，创建URL
    NSURL *url = [NSURL URLWithString:@"http://140.121.91.62/NTOUmsgProvider/register.php"];
    //第二步，创建请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];//设置请求方式为POST，默认为GET
    NSString *str = nil;
    if (studentID) {
        str = [NSString stringWithFormat:@"deviceToken=%@&OS=iOS&studentID=%@",appDelegate.devicePushToken,studentID];
    }
    else
        str = [NSString stringWithFormat:@"deviceToken=%@&OS=iOS",appDelegate.devicePushToken];//设置参数
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    //第三步，连接服务器
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

}

@end
