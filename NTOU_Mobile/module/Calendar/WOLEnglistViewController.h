//
//  WOLlistViewController.h
//  calandertest
//
//  Created by apple on 13/2/15.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WOLSwitchViewController.h"

@interface WOLEnglistViewController : UITableViewController <UIActionSheetDelegate>
@property (strong, nonatomic) NSDictionary *events;
@property (strong, nonatomic) NSArray *keys;
@property (strong, nonatomic) WOLSwitchViewController *switchviewcontroller;
@property (nonatomic) BOOL downLoadEditing;
@property (nonatomic) NSInteger menuHeight;
@property (nonatomic, strong) UIToolbar *actionToolbar;

- (IBAction)chooseitem;

@end
