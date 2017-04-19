//
//  OtherLinkTableViewController.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2017/4/6.
//  Copyright © 2017年 NTOUcs_MAC. All rights reserved.
//

#import "OtherLinkTableViewController.h"
#import <SafariServices/SafariServices.h>

@interface OtherLinkTableViewController ()

@end

@implementation OtherLinkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            SFSafariViewController* safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://www.season2016.com/"]];
            [self presentViewController:safari animated:YES completion:nil];
            break;
        }
        case 1:
        {
            SFSafariViewController* safari = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://www.stu.ntou.edu.tw/sq/Page_Show.asp?Page_ID=13007"]];
            [self presentViewController:safari animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

@end
