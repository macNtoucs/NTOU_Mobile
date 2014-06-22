//
//  NTOUNotification.m
//  NTOU_Mobile
//
//  Created by IMAC on 2014/4/10.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "NTOUNotification.h"
#import "ClassDataBase.h"
#import "SettingsModuleViewController.h"
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

+ (void)modifyBadge //Icon 的bedgets
{
    NSMutableDictionary *notifications = [self getNotifications];
    int count = 0;
    for ( id notifi in [notifications allValues]) { //緊急聯絡推播數目
        if ([notifi isKindOfClass:[NSString class]])
            count++;
        else if ([notifi isKindOfClass:[NSNumber class]]) //圖書館推播數目
        {
            count += [notifi intValue];
        }
        else if ([notifi isKindOfClass:[NSDictionary class]])  //功課表推播數目
        {
            for (NSNumber* courseNumber in [notifi allValues])
                count += [courseNumber intValue];
        }
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = count;
}

#pragma mark -
#pragma mark delete


+ (void) deleteUnreadNotificationAndModifyBadge:(NSMutableDictionary *)notifications modules:(NSString *)tag
{
    [notifications removeObjectForKey:tag];
    [self storeNotifications:notifications];
    [self modifyBadge];
}

+ (NSString *) getEmergencyNotificationAndDelete
{
    NSMutableDictionary *notifications = [self getNotifications];
    if ([notifications objectForKey:EmergencyTag]) {
        NSString *emergencyNotification = [NSString stringWithString:[notifications objectForKey:EmergencyTag]];
        [self deleteUnreadNotificationAndModifyBadge:notifications modules:EmergencyTag];
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

+ (void)setAllBadge     //主選單的bedgets
{
    NTOU_MobileAppDelegate *appDelegate = (NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableDictionary *notifications = [self getNotifications];
    id unReadNotification = nil;
    for (SpringboardIcon *aButton in [appDelegate.springboardController.grid icons])
    {
        unReadNotification = [notifications objectForKey:aButton.moduleTag];
        if (unReadNotification && [unReadNotification isKindOfClass:[NSString class]]) //緊急聯絡推播數目
            [aButton setBadgeValue:@"1"];
        else if (unReadNotification && [unReadNotification isKindOfClass:[NSNumber class]])  //圖書館推播數目
            [aButton setBadgeValue:[NSString stringWithFormat:@"%d",[unReadNotification intValue]]];
        else if (unReadNotification && [unReadNotification isKindOfClass:[NSDictionary class]])   //功課表推播數目
        {
            int count = 0;
            for (NSNumber* courseNumber in [unReadNotification allValues])
                count += [courseNumber intValue];
            [aButton setBadgeValue:[NSString stringWithFormat:@"%d",count]];
        }
        else
            [aButton setBadgeValue:nil];
    }
    [self modifyBadge];
}

+ (void) updateUI:(Notification *) notification
{
    NSLog(@"%@,%@",notification.moduleName,notification.content);
    NSMutableDictionary *notifications = [self getNotifications];
    
    id unReadNotification = nil;
    if ([notification.moduleName isEqualToString:EmergencyTag]){  //緊急聯絡
        [notifications setValue:[notification string] forKey:notification.moduleName];
        [self setBadgeValue:@"1" forModule:EmergencyTag];
    }
    else if([notification.moduleName isEqualToString:LibrariesTag]) //圖書館
    {
        unReadNotification = [[notifications objectForKey:notification.moduleName] retain];
        if (!unReadNotification) unReadNotification = [[NSNumber alloc] initWithInt:0];
        unReadNotification = [NSNumber numberWithInt:[unReadNotification intValue]+1];
        [notifications setObject:unReadNotification forKey:notification.moduleName];
        [self setBadgeValue:[NSString stringWithFormat:@"%d",[unReadNotification intValue]] forModule:notification.moduleName];
    }
    else if([notification.moduleName isEqualToString:StellarTag])   //功課表
    {
        NSMutableDictionary* dataBase = [ClassDataBase sharedData].courseTempID;
        if ([[dataBase allValues] indexOfObject:notification.content] == NSNotFound) //若通知不存在抓取下來的功課表，則不放入未讀推播
            return;
        
        unReadNotification = [NSMutableDictionary dictionaryWithDictionary:[notifications objectForKey:notification.moduleName]];
        if (!unReadNotification) unReadNotification = [[NSMutableDictionary alloc] init];  //手機端不存在功課表
        
        NSNumber *number = [[unReadNotification objectForKey:notification.content] retain];
        if (!number) number = [[NSNumber alloc] initWithInt:0];   //手機端不存在這個課程
        number = [NSNumber numberWithInt:[number intValue]+1];
        [unReadNotification setObject:number forKey:notification.content];
        [notifications setObject:unReadNotification forKey:notification.moduleName];
        int count = 0;
        for (NSNumber* number in [unReadNotification allValues]) {
            count += [number intValue];
        }
        
        [self setBadgeValue:[NSString stringWithFormat:@"%d",count] forModule:notification.moduleName];

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
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];

    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
    {
        if ([data length] > 0 && error == nil)
            [self devicePushResponse:data];
    }];
    
}

+(void)devicePushResponse:(NSData *) responseData
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil]];
    NSDictionary* courseNotification = [dictionary objectForKey:StellarTag];
    
    NSMutableDictionary *notifications = [self getNotifications];
    id localUnReadNotification = nil;
    
    //stellar 更新推播數目
    if ([courseNotification isKindOfClass:[NSDictionary class]]) {
        localUnReadNotification = [NSMutableDictionary dictionaryWithDictionary:[notifications objectForKey:StellarTag]];
        if (!localUnReadNotification) localUnReadNotification = [NSMutableDictionary new];
        
        NSMutableDictionary* dataBase = [ClassDataBase sharedData].courseTempID;
        
        for (NSString *courseId in [courseNotification allKeys]) {
            if ([[dataBase allValues] indexOfObject:courseId] != NSNotFound)
            {
                if ([localUnReadNotification objectForKey:courseId]) {
                    [localUnReadNotification setObject:[NSNumber numberWithInt:[[localUnReadNotification objectForKey:courseId] intValue]+[[courseNotification objectForKey:courseId] intValue]] forKey:courseId];
                }
                else
                    localUnReadNotification[courseId] = courseNotification[courseId];
            }
            
        }
        notifications[StellarTag] = localUnReadNotification;
        
    }
    
    //library 更新推播數目
    localUnReadNotification = (NSNumber *)notifications[LibrariesTag];
    if (!localUnReadNotification) localUnReadNotification = [NSNumber numberWithInt:0];
    
    localUnReadNotification = [NSNumber numberWithInt:[localUnReadNotification intValue]+[dictionary[LibrariesTag] intValue]];
    if ([localUnReadNotification intValue])
        notifications[LibrariesTag] = localUnReadNotification;
    
    //emergency 更新推播數目
    
    localUnReadNotification = (NSString *)notifications[EmergencyTag];
    if (!localUnReadNotification) localUnReadNotification = [NSString new];
    if ([dictionary[EmergencyTag] intValue] >= 1)
    {
        NSURL *url = [NSURL URLWithString:@"http://140.121.91.62/NTOUmsgProvider/getLatestEmergency.php"];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
         {
             if ([data length] > 0 && error == nil)
             {
                 notifications[EmergencyTag] = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                 [self storeNotifications:notifications];
             }

         }];
    }
    [self storeNotifications:notifications];
    [NTOUNotificationHandle setAllBadge];
    
    [self setRemotePNS_Badge];
}

+(void)setRemotePNS_Badge
{
    NTOU_MobileAppDelegate *appDelegate = (NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/NTOUmsgProvider/setBadge.php?token_SET=%@&newBadgeVal=%ld",appDelegate.devicePushToken,(long)[UIApplication sharedApplication].applicationIconBadgeNumber]];
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSURLConnection *connection = [[[NSURLConnection alloc] initWithRequest:req delegate:self]autorelease];
    [connection start];
}

+(void)refreshRemoteBadge
{
    if ([SettingsModuleViewController getMoodleLoginSuccess])
        [NTOUNotificationHandle sendRegisterDevice:[SettingsModuleViewController getMoodleAccount]];
    else
        [NTOUNotificationHandle sendRegisterDevice:nil];
        
    [NTOUNotificationHandle setAllBadge];
    
    [self setRemotePNS_Badge];
}

@end
