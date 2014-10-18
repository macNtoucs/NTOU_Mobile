//
//  switchController.m
//  library
//
//  Created by apple on 13/7/3.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "switchController.h"
#import "MainViewController.h"
#import "HistoryTableViewController.h"
#import "AboutViewController.h"
#import "UIKit+NTOUAdditions.h"
#import "NTOUNotification.h"
#import "MBProgressHUD.h"

@interface switchController ()

@property (nonatomic ,retain) MainViewController * mainviewcon;
@property (nonatomic ,retain) HistoryTableViewController * hisTableCon;
@property (nonatomic ,retain) AboutViewController * aboutViewCon;
@property (nonatomic, retain) igViewController * scannerCon;
@property (nonatomic, retain) NSMutableArray * controllerArray;
@end

@implementation switchController
@synthesize mainviewcon;
@synthesize hisTableCon;
@synthesize aboutViewCon;
@synthesize another;
@synthesize scannerCon;
@synthesize controllerArray;
-(void)setView
{
   
    mainviewcon = [[MainViewController alloc] init];
    UITabBarItem *item1 = [[UITabBarItem alloc] init];
    item1.tag = 1;
    [item1 setFinishedSelectedImage:[UIImage imageNamed:@"Search_30x30.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Search_30x30.png"]];

    item1.title = @"搜尋";
    mainviewcon.tabBarItem = item1;
    mainviewcon.switchviewcontroller = self;
    [item1 release];
  
    UINavigationController * nav1 = [[UINavigationController alloc]initWithRootViewController:mainviewcon];
    
    [mainviewcon release];
    
    hisTableCon = [[HistoryTableViewController alloc] init];
    UITabBarItem *item2 = [[UITabBarItem alloc] init];
    item2.tag = 2;
    [item2 setFinishedSelectedImage:[UIImage imageNamed:@"Personal_30x30.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Personal_30x30.png"]];
    item2.title = @"個人圖書館";
    hisTableCon.tabBarItem = item2;
    [item2 release];
    
    UINavigationController * nav2 = [[UINavigationController alloc]initWithRootViewController:hisTableCon];
    [hisTableCon release];
    
    aboutViewCon = [[AboutViewController alloc] init];
    UITabBarItem *item3 = [[UITabBarItem alloc] init];
    item3.tag = 3;
    [item3 setFinishedSelectedImage:[UIImage imageNamed:@"Library_30x30.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Library_30x30.png"]];
    item3.title = @"關於圖書館";
    aboutViewCon.tabBarItem = item3;
    UINavigationController * nav3 = [[UINavigationController alloc]initWithRootViewController:aboutViewCon];
   
    [aboutViewCon release];

    if (!self.viewControllers) {
        [self.viewControllers release];
    }
    
    controllerArray = [[NSMutableArray alloc]initWithObjects:mainviewcon,hisTableCon,aboutViewCon, nil];
    [self setViewControllers:controllerArray animated:NO];
   
    
    [nav1 release];
    [nav2 release];
    [nav3 release];
}

- (id)init{
    self = [super init];
    if (self) {
        [self setView];
        self.delegate = self;
    }
    return self;
}




-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self ChangeDisplayView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [scannerCon.view removeFromSuperview];
}


-(void)chanSearchStyle{
    if ([another.title  isEqual:@"條碼掃描"]){
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // Show the HUD in the main tread
            dispatch_async(dispatch_get_main_queue(), ^{
                // No need to hod onto (retain)
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
                hud.labelText = @"Loading";
            });
         if (scannerCon == nil)
        scannerCon = [[igViewController alloc] init];
        scannerCon.switchCon = self;
        scannerCon.mainview = mainviewcon;
        [ scannerCon.view  setFrame:CGRectMake(mainviewcon.view.frame.origin.x,
                                               mainviewcon.view.frame.origin.y,
                                               mainviewcon.view.frame.size.width,
                                               mainviewcon.view.frame.size.height)
        ];

            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                [mainviewcon.view addSubview:scannerCon.view];
                [another setTitle:@"取消"];
            });
        });
        }
  
    
    else{
        [another setTitle:@"條碼掃描"];
        [scannerCon.view  removeFromSuperview];
        //[scannerCon release];
    }
 
}

-(void)navAddRightButton{
    if (another== nil){
    another = [[UIBarButtonItem alloc]initWithTitle:@"條碼掃描" style:UIBarButtonItemStylePlain target:self action:@selector(chanSearchStyle)];
        self.navigationItem.rightBarButtonItem = another;
    }
    else {
         self.navigationItem.rightBarButtonItem = another;
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    }
   if (another==nil)[self navAddRightButton];
    self.view.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
   // [self navAddRightButton];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reloadHistoryTableViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[HistoryTableViewController class]]) {
        HistoryTableViewController *controller = (HistoryTableViewController *)viewController;
        [controller.tableView reloadData];
    }
}


- (void)tabBarController:(UITabBarController *)tabBarController
 didSelectViewController:(UIViewController *)viewController
{
   if( tabBarController.selectedIndex ==0 )   [self navAddRightButton];
   else{
       [another setTitle:@"條碼掃描"];
       [scannerCon.view removeFromSuperview];
       self.navigationItem.rightBarButtonItem = nil;
   }
   //[self setView];
    [self reloadHistoryTableViewController:viewController];
}

-(void)ChangeDisplayView
{
    NSNumber *notifs = [[NTOUNotificationHandle getNotifications] objectForKey:LibrariesTag];
    UITabBarItem *tbi = (UITabBarItem *)[self.tabBar.items objectAtIndex:1];
    if ([notifs intValue])
        tbi.badgeValue = [NSString stringWithFormat:@"%d",[notifs intValue]];
    else
        tbi.badgeValue = nil;
    [self reloadHistoryTableViewController:[[self viewControllers] objectAtIndex:1]];
}



@end

