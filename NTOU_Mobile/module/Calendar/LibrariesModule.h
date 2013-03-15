#import <Foundation/Foundation.h>
#import "NTOUModule.h"

@class WOLCalendarViewController;
@interface LibrariesModule : NTOUModule {
    NSOperationQueue *_requestQueue;
    WOLCalendarViewController *TimeviewController;
}

@property (nonatomic, retain) NSOperationQueue *requestQueue;

@end

