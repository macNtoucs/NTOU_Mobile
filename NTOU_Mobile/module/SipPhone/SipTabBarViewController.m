//
//  SipTabBarViewController.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/4.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "SipTabBarViewController.h"
#import "TestViewController.h"
#import "SipPhoneUsuallyUseViewController.h"
#import "SipCallHistoryViewController.h"
#import "SipContactInformationViewController.h"
#import "SipEmergencyViewController.h"
#import "EmergencyViewController.h"

@implementation SipTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self; //To use delegate,must to do this
    
    SipPhoneUsuallyUseViewController * view0 = [SipPhoneUsuallyUseViewController new];
    view0.tabBarItem = [[UITabBarItem new] initWithTitle:@"常用聯絡資訊" image:[UIImage imageNamed:@"SipButtons-Star.png"] tag:0];
    view0.sipViewRoot = self;
    SipCallHistoryViewController * view1 = [SipCallHistoryViewController new];
    view1.tabBarItem = [[UITabBarItem new] initWithTitle:@"通話紀錄" image:[UIImage imageNamed:@"SipButtons-History.png"] tag:1];
    view1.sipViewRoot = self;
    SipContactInformationViewController * view2 = [SipContactInformationViewController new];
    view2.tabBarItem = [[UITabBarItem new] initWithTitle:@"聯絡資訊" image:[UIImage imageNamed:@"SipButtons-Contactperson.png"] tag:2];
    view2.sipViewRoot = self;
    TestViewController * view3 = [TestViewController new];
    view3.tabBarItem = [[UITabBarItem new] initWithTitle:@"數字鍵盤" image:[UIImage imageNamed:@"SipButtons-Pad.png"] tag:3];
    view3.sipViewRoot = self;
    SipEmergencyViewController * view4 = [SipEmergencyViewController new];
    view4.tabBarItem = [[UITabBarItem new] initWithTitle:@"緊急聯絡" image:[UIImage imageNamed:@"SipButtons-Warning.png"] tag:4];
    view4.sipViewRoot = self;
    self.viewControllers = [NSArray arrayWithObjects:view0,view1,view2,view3,view4,nil];
    
    self.selectedIndex = 3;
    self.title = @"數字鍵盤";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) tabBarController:(SipTabBarViewController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    switch (self.selectedIndex) {
        case 0:
            self.title = @"常用聯絡資訊";
            break;
        case 1:
            self.title = @"通話紀錄";
            break;
        case 2:
            self.title = @"聯絡資訊";
            break;
        case 3:
            self.title = @"數字鍵盤";
            break;
        case 4:
            self.title = @"緊急聯絡";
            break;
            
        default:
            break;
    }
}


@end
