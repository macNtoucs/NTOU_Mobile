//
//  WOLChiListViewController.h
//  NTOUMobile
//
//  Created by NTOUCS on 13/2/18.
//
//

#import <UIKit/UIKit.h>
#import "WOLSwitchViewController.h"

@interface WOLChilistViewController : UITableViewController
@property (strong, nonatomic) NSDictionary *events;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) WOLSwitchViewController *switchviewcontroller;

- (IBAction)chooseitem;

@end