//
//  SipHistoryTableViewController.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/24.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "SipHistoryTableViewController.h"

@implementation SipHistoryTableViewController

-(id)init{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restorationIdentifier = @"SipTable";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
