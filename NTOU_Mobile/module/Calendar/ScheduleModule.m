#import "ScheduleModule.h"
#import "SwitchViewController.h"
#import "NTOUModule+Protected.h"
#import "NTOUConstants.h"


@implementation ScheduleModule
@synthesize requestQueue = _requestQueue;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = CalendarTag;
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
    SwitchViewController *viewcontroller = [[SwitchViewController alloc] init];
    viewcontroller.title = @"行事曆";
    self.moduleHomeController = viewcontroller;
}

@end
