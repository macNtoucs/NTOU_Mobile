#import <UIKit/UIKit.h>
#import "CameraViewController.h"
#import "OutCampusViewController.h"
#import "NTOUNotification.h"
@protocol EmergencyViewControllerDelegate<NSObject>

@optional
- (void)didReadNewestEmergencyInfo;

@end


@interface EmergencyViewController : UITableViewController <UIWebViewDelegate,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate> {
    id<EmergencyViewControllerDelegate> delegate;
    NSIndexPath *alertTouchIndex;
	BOOL refreshButtonPressed;
    NSString *htmlString;
	NSString *htmlFormatString;
    UIWebView *infoWebView;
    UIImagePickerController * imagePicker;
    NSMutableArray *innerNumber;
    NSMutableArray *outerNumber;
}

- (void)infoDidLoad:(NSNotification *)aNotification;
- (void)infoDidFailToLoad:(NSNotification *)aNotification;
- (void)notificationProcess;
- (void)refreshInfo:(id)sender; // force view controller to refresh itself
- (void)setHtmlNotification:(NSString *)notification;

@property (nonatomic, retain) id<EmergencyViewControllerDelegate> delegate;
@property (nonatomic, retain) NSString *htmlString;
@property (nonatomic, retain) UIWebView *infoWebView;
@property (nonatomic, retain) NSMutableArray *innerNumber;
@property (nonatomic, retain) NSMutableArray *outerNumber;
@property (nonatomic, retain) NSIndexPath *alertTouchIndex;
@property (nonatomic, retain) UIImagePickerController * imagePicker;

@end
