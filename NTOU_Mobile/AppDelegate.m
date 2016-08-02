    //
//  AppDelegate.m
//  NTOU_Mobile
//
//  Created by R MAC on 13/3/7.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "AppDelegate.h"
#import "NTOU_MobileAppDelegate+Private.h"
#import "AppDelegate+ModuleList.h"
#import "NTOUModule.h"
#import "NTOUSpringboard.h"
#import "Rotation.h"
#import "NTOUConstants.h"
#import "NTOUNotification.h"
#import "SettingsModuleViewController.h"
#import <pjsua.h>
@import GoogleMaps;
@implementation NTOU_MobileAppDelegate
@synthesize window=_window,
rootNavigationController = _rootNavigationController,
modules;

@synthesize devicePushToken;

@synthesize springboardController = _springboardController;

#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:@"AIzaSyDa7WM05jLY1Q7tdQWGn2R2kWctOXt2Ukc"]; //account:mac.ntoucs@gmail.com
    
    [NSThread detachNewThreadSelector:@selector(pjsuaStart) toTarget:self withObject:nil];//see SipPhone/NTOU_MobileAppDelegate+SipPhone
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    networkActivityRefCount = 0;
    
    //  [self updateBasicServerInfo];
    
    // Initialize all modules
    self.modules = [self createModules]; // -createModules defined in ModuleListAdditions category
    
    [self registerDefaultModuleOrder];
    [self loadSavedModuleOrder];
    
    
    NTOUSpringboard *springboard = [[[NTOUSpringboard alloc] initWithNibName:nil bundle:nil] autorelease];
    springboard.primaryModules = [NSArray arrayWithArray:self.modules];
    springboard.delegate = self;
    
    Rotation *rootController = [[Rotation alloc] init];
    rootController.delegate = springboard;
    rootController.navigationBar.tintColor = [UIColor colorWithRed:12.0/255 green:46.0/255 blue:112.0/255 alpha:1];
    [[UIBarButtonItem appearance] setTintColor: [UIColor colorWithRed:59.0/255 green:89.0/255 blue:152.0/255 alpha:1]];
    //rootController.navigationBar.barStyle = UIBarStyleBlack;
    self.springboardController = springboard;
    self.rootNavigationController = rootController;
    
    /*iOS7 UI fix*/
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.rootNavigationController.edgesForExtendedLayout = UIRectEdgeNone;
        self.springboardController.edgesForExtendedLayout = UIRectEdgeNone;
        
        
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)];   
    
    // TODO: don't store state like this when we're using a springboard.
	// set modules state
    [rootController pushViewController:springboard animated:NO];
    self.window.rootViewController = rootController;
    /* @try{
     [self.window setRootViewController:self.rootNavigationController];
     }
     @catch (NSException *exception) {
     NSLog(@"Exception - %@",[exception description]);
     }
     */
    //self.window.backgroundColor = [UIColor colorWithHexString:@"#EFEFF4"];
    self.window.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    [self.window makeKeyAndVisible];
    
    // Override point for customization after view hierarchy is set
    for (NTOUModule *aModule in self.modules) {
        [aModule applicationDidFinishLaunching];
    }
    
    //APNS dictionary generated from the json of a push notificaton
	NSDictionary *apnsDict = [launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"];
    
	// check if application was opened in response to a notofication
	if(apnsDict) {
        [NTOUNotificationHandle refreshRemoteBadge];
	}

    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/stationNumber.plist"];
    NSLog(@"filePath = %@", filePath);
    BOOL success;
    success = [fileManager fileExistsAtPath:filePath];
    if (success) return YES;
    
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/stationNumber.plist"];
    success = [fileManager copyItemAtPath:path toPath:filePath error:&error];
    
    if (!success) {
        NSAssert1(0, @"Failed to copy Plist. Error %@", [error localizedDescription]);
    }
    return YES;
    
}



// Because we implement -application:didFinishLaunchingWithOptions: this only gets called when an NTOUmobile:// URL is opened from within this app
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    BOOL canHandle = NO;
    
    NSString *scheme = [url scheme];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSArray *urlTypes = [infoDict objectForKey:@"CFBundleURLTypes"];
    for (NSDictionary *type in urlTypes) {
        NSArray *schemes = [type objectForKey:@"CFBundleURLSchemes"];
        for (NSString *supportedScheme in schemes) {
            if ([supportedScheme isEqualToString:scheme]) {
                canHandle = YES;
                break;
            }
        }
        if (canHandle) {
            break;
        }
    }
    
    if (canHandle) {
        NSString *path = [url path];
        NSString *moduleTag = [url host];
        NTOUModule *module = [self moduleForTag:moduleTag];
        if ([path rangeOfString:@"/"].location == 0) {
            path = [path substringFromIndex:1];
        }
        
        // right now expecting URLs like NTOUmobile://people/search?Some%20Guy
        NSString *query = [[url query] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        if (!module.hasLaunchedBegun) {
            module.hasLaunchedBegun = YES;
        }
        
        canHandle = [module handleLocalPath:path query:query];
    } else {
    }
    
    return canHandle;
}

- (void)applicationShouldSaveState:(UIApplication *)application {
    // Let each module perform clean up as necessary
    for (NTOUModule *aModule in self.modules) {
        [aModule applicationWillTerminate];
    }
    
	[self saveModulesState];
    
    // Save preferences
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    pjsua_destroy(); // close pjsip
	[self applicationShouldSaveState:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    for (NTOUModule *aModule in self.modules) {
        [aModule applicationDidEnterBackground];
    }
    [NTOUNotificationHandle refreshRemoteBadge];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //send to server payload
    
    for (NTOUModule *aModule in self.modules) {
        [aModule applicationWillEnterForeground];
    }
    [NTOUNotificationHandle refreshRemoteBadge];
}


#pragma mark -
#pragma mark Remote notifications

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    /* Get device token */
    NSString *strDevToken = [NSString stringWithFormat:@"%@", deviceToken];
    
    /* Replace '<', '>' and ' ' */
    NSCharacterSet *charDummy = [NSCharacterSet characterSetWithCharactersInString:@"<> "];
    strDevToken = [[strDevToken componentsSeparatedByCharactersInSet: charDummy] componentsJoinedByString: @""];
    devicePushToken = [strDevToken retain];
    [NTOUNotificationHandle refreshRemoteBadge];
    NSLog(@"Did register for remote notifications: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Fail to register for remote notifications: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"start didReceiveRemoteNotification");
    [NTOUNotificationHandle refreshRemoteBadge];
    // We can determine whether an application is launched as a result of the user tapping the action
    // button or whether the notification was delivered to the already-running application by examining
    // the application state.
    
    if (application.applicationState == UIApplicationStateActive) {
        NSString * title = @"收到通知";
        for (NTOUModule *aModule in self.modules) {
            if ([aModule.tag isEqualToString:[NSString stringWithFormat:@"%@",[userInfo objectForKey:@"moduleName"]]]) {
                title = [aModule.shortName mutableCopy];
                break;
            }
        }
        
        // Nothing to do if applicationState is Inactive, the iOS already displayed an alert view.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:[NSString stringWithFormat:@"%@",
                                                                     [[userInfo objectForKey:@"aps"] objectForKey:@"alert"]]
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        [alertView release];
    }
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    self.springboardController = nil;
    self.modules = nil;
	[window release];
	[super dealloc];
}

#pragma mark -
#pragma mark Shared resources

- (void)showNetworkActivityIndicator {
    networkActivityRefCount++;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)hideNetworkActivityIndicator {
    if (networkActivityRefCount > 0) {
        networkActivityRefCount--;
    }
    if (networkActivityRefCount == 0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
}


@end
