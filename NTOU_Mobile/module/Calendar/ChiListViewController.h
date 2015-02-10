//
//  WOLChiListViewController.h
//  NTOUMobile
//
//  Created by NTOUCS on 13/2/18.
//
//

#import <UIKit/UIKit.h>
#import "SwitchViewController.h"

@interface ChiListViewController : UITableViewController <UIActionSheetDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) NSDictionary *events;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) SwitchViewController *switchviewcontroller;
@property (nonatomic) BOOL downLoadEditing;
@property (nonatomic) NSInteger menuHeight;
@property (nonatomic, strong) UIToolbar *actionToolbar;

- (IBAction)chooseitem;
- (void)scrolltableview;//自動滾動到當前月份
- (void)setupFrame:(float) NavBarHeight;
@end