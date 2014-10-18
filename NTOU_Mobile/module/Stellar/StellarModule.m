#import "StellarModule.h"
#import "AppDelegate+ModuleList.h"
#import "NTOUConstants.h"
#import "ScheduleViewController.h"
#import "NTOUModule+Protected.h"

@implementation StellarModule

- (id)init
{
	self = [super init];
    if (self != nil) {
        self.tag = StellarTag;
        self.shortName = @"個人課程";
        self.longName = @"NTOU Stellar";
        self.iconName = @"stellar";
        self.pushNotificationSupported = YES;
        self.moduleHomeController = [[[ScheduleViewController alloc] init] autorelease];
    }
    return self;
}

- (void)loadModuleHomeController
{
    [self setModuleHomeController: self.moduleHomeController];
}


- (BOOL)handleLocalPath:(NSString *)localPath query:(NSString *)query {

    if ([[[NTOUAppDelegate() rootNavigationController] viewControllers] containsObject:self.moduleHomeController]) {
        [[NTOUAppDelegate() rootNavigationController] popToViewController:self.moduleHomeController animated:NO];
    } else {
        [[NTOUAppDelegate() rootNavigationController] popToRootViewControllerAnimated:NO];
        [[NTOUAppDelegate() springboardController] pushModuleWithTag:self.tag];
    }
	return YES;
}

- (void)dealloc
{
	[super dealloc];
}

- (BOOL)handleNotification:(Notification *)notification shouldOpen: (BOOL)shouldOpen {
    if(shouldOpen) {
        [(ScheduleViewController *)self.moduleHomeController ChangeDisplayView];
	}
    
	return YES;
}

@end
