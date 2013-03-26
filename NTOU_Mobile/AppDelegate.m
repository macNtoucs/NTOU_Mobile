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
@implementation NTOU_MobileAppDelegate
@synthesize window=_window,
rootNavigationController = _rootNavigationController,
modules;

@synthesize deviceToken = devicePushToken;

@synthesize springboardController = _springboardController;
#pragma mark -
#pragma mark Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
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
    rootController.navigationBar.barStyle = UIBarStyleBlack;
    self.springboardController = springboard;
    self.rootNavigationController = rootController;
    
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
    
    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NTOUImageNameBackground]];
    [self.window makeKeyAndVisible];
    
    // Override point for customization after view hierarchy is set
    for (NTOUModule *aModule in self.modules) {
        [aModule applicationDidFinishLaunching];
    }
    NSError *error;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/stationNumber.plist"];
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
	[self applicationShouldSaveState:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    for (NTOUModule *aModule in self.modules) {
        [aModule applicationDidEnterBackground];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    for (NTOUModule *aModule in self.modules) {
        [aModule applicationWillEnterForeground];
    }
}

#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    self.springboardController = nil;
    self.deviceToken = nil;
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
