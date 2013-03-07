#import "ShuttleModule.h"
#import "NTOUTableViewControllerLayer1.h"

@implementation ShuttleModule

- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = ShuttleTag;
        self.shortName = @"交通資訊";
        self.longName = @"ShuttleTrack";
        self.iconName = @"shuttle";
        self.pushNotificationSupported = YES;
    }
    return self;
}

- (void)loadModuleHomeController
{
    [self setModuleHomeController:[[[NTOUTableViewControllerLayer1 alloc] initWithStyle:UITableViewStyleGrouped] autorelease]];
}


@end
