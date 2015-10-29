#import <Foundation/Foundation.h>
#import "NTOUModule.h"

@class CalendarViewController;
@interface ScheduleModule : NTOUModule {
    NSOperationQueue *_requestQueue;
    CalendarViewController *TimeviewController;
}

@property (nonatomic, retain) NSOperationQueue *requestQueue;

@end

