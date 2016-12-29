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
    searchBar = [UISearchBar new];
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restorationIdentifier = @"SipTable";
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    [searchBar sizeToFit];
    self.tableView.tableHeaderView = searchBar ;
    
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

- (void)refresh:(UIRefreshControl*)sender{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
    [(SipTabBarViewController*)self.tabBarController checkUpdate];
    [self.tableView reloadData];
    [sender endRefreshing];
}

@end
