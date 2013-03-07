//
//  AppDelegate.h
//  NTOU_Mobile
//
//  Created by R MAC on 13/3/7.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "NTOUSpringboard.h"

#define NTOUAppDelegate() ((NTOU_MobileAppDelegate *)[[UIApplication sharedApplication] delegate])

@interface NTOU_MobileAppDelegate : NSObject <UIApplicationDelegate, NTOUSpringboardDelegate> {
    UIWindow *window;
    
    UINavigationController *rootNavigationController;
    
    NSArray *modules; // all registered modules as defined in NTOUModuleList.m
    NSData *devicePushToken; // deviceToken returned by Apple's push servers when we register. Will be nil if not available.
    
    NSInteger networkActivityRefCount; // the number of concurrent network connections the user should know about. If > 0, spinny in status bar is shown
}

- (BOOL)shouldShowOpenHouseContent;

- (void)showNetworkActivityIndicator;
- (void)hideNetworkActivityIndicator;

- (void)presentAppModalViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)dismissAppModalViewControllerAnimated:(BOOL)animated;

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic, retain) UINavigationController *rootNavigationController;
@property (nonatomic, retain) NTOUSpringboard *springboardController;
@property (nonatomic, retain) NSArray *modules;
@property (nonatomic, retain) NSData *deviceToken;

@end

@interface APNSUIDelegate : NSObject <UIAlertViewDelegate>
{
	NSDictionary *apnsDictionary;
	NTOU_MobileAppDelegate *appDelegate;
}

- (id) initWithApnsDictionary: (NSDictionary *)apns appDelegate: (NTOU_MobileAppDelegate *)delegate;

@end


