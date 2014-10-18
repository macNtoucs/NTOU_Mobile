//
//  WOLSwitchViewController.h
//  NTOUMobile
//
//  Created by NTOUCS on 13/2/20.
//
//

#import <UIKit/UIKit.h>

@class ChiListViewController;
@class EnglistViewController;

@interface SwitchViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) ChiListViewController *chiViewController;
@property (strong, nonatomic) EnglistViewController *engViewController;

-(void)Chichooseitem;
-(void)Engchooseitem;
- (void)showMenuView;

@end

