#import "AboutModule.h"
#import "AboutTableViewController.h"
#import "NTOUConstants.h"
#import "NTOUModule+Protected.h"

@implementation AboutModule

- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = AboutTag;
        self.shortName = @"關於";
        self.longName = @"About";
        self.iconName = @"about";
    }
    return self;
}

- (void)loadModuleHomeController
{
    self.moduleHomeController = [[[AboutTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"HUD123://"]];
}

@end
