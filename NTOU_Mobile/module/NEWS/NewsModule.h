#import <Foundation/Foundation.h>
#import "NTOUModule.h"

@class StoryListViewController;

@interface NewsModule : NTOUModule {
	StoryListViewController *storyListChannelController;
}

@property (nonatomic, retain) StoryListViewController *storyListChannelController;

@end
