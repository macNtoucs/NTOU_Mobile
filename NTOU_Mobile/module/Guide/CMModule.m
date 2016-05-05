#import "CMModule.h"
#import "NTOUGuideViewController.h"
#import "NTOUModule+Protected.h"

@implementation CMModule
@dynamic campusMapVC;

- (id) init {
    self = [super init];
    if (self != nil) {
        self.tag = CampusMapTag;
        self.shortName = @"校園導覽";
        self.longName = @"Campus Map";
        self.iconName = @"map";
    }
    return self;
}

- (void)loadModuleHomeController
{
    
    [self setModuleHomeController:[[[NTOUGuideViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease]];
    
   
}

- (CampusMapViewController*)campusMapVC
{
    return ((CampusMapViewController*)self.moduleHomeController);
}

-(void) dealloc
{
	[super dealloc];
}



@end
