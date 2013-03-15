//
//  WOLSwitchViewController.h
//  NTOUMobile
//
//  Created by NTOUCS on 13/2/20.
//
//

#import <UIKit/UIKit.h>

@class WOLChilistViewController;
@class WOLEnglistViewController;

@interface WOLSwitchViewController : UIViewController

@property (strong, nonatomic) WOLChilistViewController *chiViewController;
@property (strong, nonatomic) WOLEnglistViewController *engViewController;

-(void)Chichooseitem;
-(void)Engchooseitem;

@end

