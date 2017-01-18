//
//  SipPhoneUsuallyUseTableViewController.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/8/24.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "SipPhoneUsuallyUseTableViewController.h"
#import "SipTabBarViewController.h"

@implementation SipPhoneUsuallyUseTableViewController

-(instancetype)init{
    self = [super init];
    if(self){
        usuallyUse = [NSMutableArray new];
    }
    return self;
}

-(void)viewDidLoad{
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(editMode)];
    [self.tabBarController.navigationItem setRightBarButtonItem:addButton];
}


-(void)editMode{
    if(self.tableView.editing)
    {
        [self.tableView setEditing:NO animated:YES];
    }
    else
    {
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [usuallyUse removeObjectAtIndex:[indexPath row]];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [usuallyUse count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SipUsuallyUse"];
    
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SipUsuallyUse"];
    
    cell.textLabel.text = [[usuallyUse objectAtIndex:[indexPath row]]objectForKey:@"name"];
    cell.detailTextLabel.text = [[usuallyUse objectAtIndex:[indexPath row]]objectForKey:@"number"];
    return cell;
}

-(void)addUsuallyUse:(NSDictionary*)data{
    [usuallyUse addObject:data];
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [(SipTabBarViewController*)self.tabBarController makeCallToNTOU:[[usuallyUse objectAtIndex:[indexPath row]]objectForKey:@"number"] ];
}
@end
