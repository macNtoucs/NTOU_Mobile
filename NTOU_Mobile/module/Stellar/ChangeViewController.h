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
#import "DisplayViewController.h"
@interface ChangeViewController:UIViewController{
    NSMutableArray *itemsArray;
    NSDictionary* info;
    NSString * token;
    NSUInteger currentPage;
    NSMutableArray *contentList;
}
@property(nonatomic, retain)NSMutableArray *itemsArray,*gradesArray;
@property(nonatomic, retain)NSMutableArray *contentList;
@property(nonatomic,retain)NSString * token;
@property NSUInteger currentPage;
@property(nonatomic,retain)NSDictionary* info;
@property (retain,nonatomic)IBOutlet UIScrollView *myScrollView;
@property (retain,nonatomic)IBOutlet UIPageControl *myPageControl;
@end
