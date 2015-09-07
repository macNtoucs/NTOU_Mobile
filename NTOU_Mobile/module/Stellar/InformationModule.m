#import "InformationModule.h"
#import "AppDelegate+ModuleList.h"
#import "NTOUConstants.h"
#import "DisplayViewController.h"
#import "NTOUModule+Protected.h"

@implementation InformationModule

- (id)init
{
	self = [super init];
    if (self != nil) {
        self.tag = InformationTag;
        self.shortName = @"資訊";
        self.longName = @"NTOU Information";
        self.iconName = @"stellar";
        self.pushNotificationSupported = YES;
        self.moduleHomeController = [[[DisplayViewController alloc] init] autorelease];
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
        [(DisplayViewController *)self.moduleHomeController ChangeDisplayView];
	}
    
	return YES;
}

@end
