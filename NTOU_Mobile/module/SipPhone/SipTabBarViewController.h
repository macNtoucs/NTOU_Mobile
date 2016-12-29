//
//  SipTabBarViewController.h
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/4.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SipTabBarViewController.h"
#import "SipDiagPadViewController.h"
#import "SipPhoneUsuallyUseTableViewController.h"
#import "SipHistoryTableViewController.h"
#import "SipContactInformationTableViewController.h"
#import "SipEmergencyViewController.h"

@interface SipTabBarViewController : UITabBarController <UITabBarControllerDelegate>
{
    SipPhoneUsuallyUseTableViewController *view0;
    SipHistoryTableViewController *view1;
    SipContactInformationTableViewController *view2;
    SipDiagPadViewController *view3;
    SipEmergencyViewController *view4;
}

@property (nonatomic,assign)NSArray *NTOUContactInformation;

-(void)makeCallToNTOU:(NSString*)number;
-(void)addNumberToHistory:(NSString*)number;
-(void)checkUpdate;

@end
