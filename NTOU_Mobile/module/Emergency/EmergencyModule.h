#import "NTOUModule.h"
#import "EmergencyViewController.h"

@interface EmergencyModule : NTOUModule <EmergencyViewControllerDelegate> {
    EmergencyViewController *_mainViewController;
	BOOL _emergencyMessageLoaded;
    BOOL _didReadMessage;
}

//- (void)didReceiveNewEmergencyInfo:(NSNotification *)aNotification;

- (void)syncUnreadNotifications;
- (void)infoDidLoad:(id)object;

@property (readwrite, retain) EmergencyViewController *mainViewController;
@property (nonatomic) BOOL didReadMessage;

@end