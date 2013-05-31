#import "LibrariesModule.h"
#import "WOLSwitchViewController.h"
#import "NTOUModule+Protected.h"
#import "NTOUConstants.h"
@implementation LibrariesModule
@synthesize requestQueue = _requestQueue;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = LibrariesTag;
        self.shortName = @"行事曆";
        self.longName = @"Calendar";
        self.iconName = @"calendar";
        self.requestQueue = [[[NSOperationQueue alloc] init] autorelease];
        
    }
    return self;
}

- (void) dealloc {
    self.requestQueue = nil;
    [super dealloc];
}

- (void)loadModuleHomeController
{
    WOLSwitchViewController *viewcontroller = [[WOLSwitchViewController alloc] init];
    viewcontroller.title = @"行事曆";
    self.moduleHomeController = viewcontroller;
}

@end
