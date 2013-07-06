//
//  WOLChiListViewController.h
//  NTOUMobile
//
//  Created by NTOUCS on 13/2/18.
//
//

#import <UIKit/UIKit.h>
#import "WOLSwitchViewController.h"

@interface WOLChiListViewController : UITableViewController <UIActionSheetDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) NSDictionary *events;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) WOLSwitchViewController *switchviewcontroller;
@property (nonatomic) BOOL downLoadEditing;
@property (nonatomic) NSInteger menuHeight;
@property (nonatomic, strong) UIToolbar *actionToolbar;

- (IBAction)chooseitem;
- (void)scrolltableview;
@end