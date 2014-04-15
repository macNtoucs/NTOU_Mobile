#import "EmergencyModule.h"
#import "EmergencyViewController.h"
#import "NTOUModule+Protected.h"

@implementation EmergencyModule

@synthesize mainViewController = _mainViewController,
            didReadMessage = _didReadMessage;

- (id) init {
    self = [super init];
    if (self != nil) {
        // Basic settings
        self.tag = EmergencyTag;
        self.shortName = @"緊急聯絡";
        self.longName = @"Emergency Info";
        self.iconName = @"emergency";
        self.pushNotificationSupported = YES;
        
        // preserve unread state
        if ([[NSUserDefaults standardUserDefaults] integerForKey:EmergencyUnreadCountKey] > 0) {
            // TODO: EmergencyUnreadCountKey doesn't seem to be used anywhere else
            // so we wouldn't ever get here
            self.badgeValue = @"1";
        }

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveNewEmergencyInfo:) name:EmergencyInfoDidChangeNotification object:nil];
        
		_emergencyMessageLoaded = NO;
        self.didReadMessage = NO; // will be reset if any emergency data (old or new) is received
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoDidLoad:) name:EmergencyInfoDidLoadNotification object:nil];
		
        // check for new emergency info on app launch
       // [[EmergencyData sharedData] checkForEmergencies];
    }
    return self;
}

- (void)loadModuleHomeController
{
    EmergencyViewController *controller = [[[EmergencyViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    controller.delegate = self;
    
    self.mainViewController = controller;
    self.moduleHomeController = controller;

}

@end
