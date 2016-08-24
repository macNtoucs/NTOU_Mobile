//
//  SipTabBarViewController.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/4.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "SipTabBarViewController.h"
#include "NTOUConstants.h"

@implementation SipTabBarViewController

@synthesize NTOUContactInformation;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self; //To use delegate,must to do this
    
    view0 = [SipPhoneUsuallyUseTableViewController new];
    view0.tabBarItem = [[UITabBarItem new] initWithTitle:@"常用聯絡資訊" image:[UIImage imageNamed:@"SipButtons-Star.png"] tag:0];
    view1 = [SipHistoryTableViewController new];
    view1.tabBarItem = [[UITabBarItem new] initWithTitle:@"通話紀錄" image:[UIImage imageNamed:@"SipButtons-History.png"] tag:1];
    view2 = [SipContactInformationTableViewController new];
    view2.tabBarItem = [[UITabBarItem new] initWithTitle:@"聯絡資訊" image:[UIImage imageNamed:@"SipButtons-Contactperson.png"] tag:2];
    view3 = [SipDiagPadViewController new];
    view3.tabBarItem = [[UITabBarItem new] initWithTitle:@"數字鍵盤" image:[UIImage imageNamed:@"SipButtons-Pad.png"] tag:3];
    view4 = [SipEmergencyViewController new];
    view4.tabBarItem = [[UITabBarItem new] initWithTitle:@"緊急聯絡" image:[UIImage imageNamed:@"SipButtons-Warning.png"] tag:4];
    
    self.viewControllers = [NSArray arrayWithObjects:view0,view1,view2,view3,view4,nil];
    
    self.selectedIndex = 3;
    self.title = @"數字鍵盤";
    
    [self checkUpdate];
    
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
-(void)checkUpdate{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *lastUpdateTimeOld = [userDefaults stringForKey:@"SipPhoneLastUpdateTime"];
    NSURL *url = [NSURL URLWithString:[NTOUUrlSipPhone stringByAppendingString:@"getSipPhoneLastUpdate"]];
    NSString *lastUpdateTime = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    if(!lastUpdateTimeOld)
        lastUpdateTimeOld = @"87"; //give it value to compare
    if([lastUpdateTimeOld compare:lastUpdateTime]!=0){
        [userDefaults setObject:lastUpdateTime forKey:@"SipPhoneLastUpdateTime"];
        [userDefaults synchronize];
    }
    [self updateData];
    
}
-(void)updateData{
    NSURL *url = [NSURL URLWithString:[NTOUUrlSipPhone stringByAppendingString:@"getSipPhoneFullJson"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NTOUContactInformation = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    [NTOUContactInformation retain];
}
-(void)makeCallToNTOU:(NSString*)number{
    self.selectedIndex = 3;
    view3.callinfo.text = number;
    [view3 makeCallToNTOU];
}

@end
