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
    NSMutableArray *itemsArray,*gradesArray;
    NSString * token;
}
- (void)setData:(NSDictionary *)info Year:(NSString*)year;
@property(nonatomic, retain)NSMutableArray *itemsArray,*gradesArray;
@property(nonatomic,retain)NSString * token;
@end
