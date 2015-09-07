//
//  ScheduleViewController.h
//  MIT Mobile
//
//  Created by mac_hero on 12/10/25.
//
//

#import <UIKit/UIKit.h>
#import "DefineConstant.h"
#import "Moodle_API.h"
#import "SettingsModuleViewController.h"
@interface DisplayViewController : UITableViewController{
    NSMutableArray *itemsArray;
    NSString * token;
}
@property(nonatomic, retain)NSMutableArray *itemsArray,*gradesArray;
@property(nonatomic,retain)NSString * token;
@property(nonatomic,retain)NSDictionary* info;
@end
