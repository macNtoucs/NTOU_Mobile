#import "PeopleModule.h"


#import "NTOUModule+Protected.h"


@interface PeopleModule ()
@end

@implementation PeopleModule


- (id)init
{
    self = [super init];
    if (self) {
        
        self.shortName = @"生活圈";
        self.longName = @"People Directory";
        self.iconName = @"people";
    }
    return self;
}

- (void)loadModuleHomeController
{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController* initialHelpView = [storyboard instantiateInitialViewController];
    initialHelpView.title = @"海大生活圈";
    self.moduleHomeController = initialHelpView;
}



- (void)dealloc
{
	[super dealloc];
}


@end

