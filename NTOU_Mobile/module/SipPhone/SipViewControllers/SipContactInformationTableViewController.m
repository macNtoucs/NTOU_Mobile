//
//  SipContactInformationTableViewController.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/15.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "SipContactInformationTableViewController.h"
#import "SipTabBarViewController.h"

@implementation SipContactInformationTableViewController

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [((SipTabBarViewController*)self.tabBarController).NTOUContactInformation count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SipTable"];
    cell.textLabel.text = [[((SipTabBarViewController*)self.tabBarController).NTOUContactInformation objectAtIndex:[indexPath row]]objectForKey:@"name"];
    cell.detailTextLabel.text = [[((SipTabBarViewController*)self.tabBarController).NTOUContactInformation objectAtIndex:[indexPath row]]objectForKey:@"number"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [(SipTabBarViewController*)self.tabBarController makeCallToNTOU:[[((SipTabBarViewController*)self.tabBarController).NTOUContactInformation objectAtIndex:[indexPath row]]objectForKey:@"number"] ];
}

@end
