//
//  NTOUNotification.h
//  NTOU_Mobile
//
//  Created by IMAC on 2014/4/10.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>

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


+ (void) updateUI:(Notification *) notification;

@end
