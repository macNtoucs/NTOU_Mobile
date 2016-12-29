//
//  SipHistoryTableViewController.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/24.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "SipHistoryTableViewController.h"
#import "SipTabBarViewController.h"

@implementation SipHistoryTableViewController

-(id)init{
    numbers = [NSMutableArray new];
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restorationIdentifier = @"SipHistory";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)addNumber:(NSString*)number{
    if(number)
        [numbers insertObject:number atIndex:0];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [numbers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SipHistory"];
    cell.textLabel.text = [numbers objectAtIndex:[indexPath row]];
    cell.detailTextLabel.text = [numbers objectAtIndex:[indexPath row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [(SipTabBarViewController*)self.tabBarController makeCallToNTOU:[[((SipTabBarViewController*)self.tabBarController).NTOUContactInformation objectAtIndex:[indexPath row]]objectForKey:@"number"] ];
}

@end
