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

@interface SipTabBarViewController ()

@end

@implementation SipTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    SipPhoneUsuallyUseViewController * view1 = [SipPhoneUsuallyUseViewController new];
    view1.tabBarItem = [[UITabBarItem new] initWithTitle:@"常用聯絡資訊" image:nil tag:0];
    SipCallHistoryViewController * view2 = [SipCallHistoryViewController new];
    view2.tabBarItem = [[UITabBarItem new] initWithTitle:@"通話紀錄" image:nil tag:1];
    SipContactInformationViewController * view3 = [SipContactInformationViewController new];
    view3.tabBarItem = [[UITabBarItem new] initWithTitle:@"聯絡資訊" image:nil tag:2];
    TestViewController * view4 = [TestViewController new];
    view4.tabBarItem = [[UITabBarItem new] initWithTitle:@"數字鍵盤" image:nil tag:3];
    SipEmergencyViewController * view5 = [SipEmergencyViewController new];
    view5.tabBarItem = [[UITabBarItem new] initWithTitle:@"緊急聯絡" image:nil tag:4];
    self.viewControllers = [NSArray arrayWithObjects:view1,view2,view3,view4,view5,nil];
    self.selectedIndex = 3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
