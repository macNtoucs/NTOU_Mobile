//
//  WOLSwitchViewController.h
//  NTOUMobile
//
//  Created by NTOUCS on 13/2/20.
//
//

#import <UIKit/UIKit.h>

@class WOLChiListViewController;
@class WOLEnglistViewController;

@interface WOLSwitchViewController : UIViewController <UIGestureRecognizerDelegate>

@property (strong, nonatomic) WOLChiListViewController *chiViewController;
@property (strong, nonatomic) WOLEnglistViewController *engViewController;

-(void)Chichooseitem;
-(void)Engchooseitem;

@end

