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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    history = [NSMutableArray new];
    [history addObjectsFromArray:[defaults objectForKey:@"SipHistory"]];
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.restorationIdentifier = @"SipHistory";
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(editMode)];
    [self.tabBarController.navigationItem setRightBarButtonItem:addButton];
    [addButton release];
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
        [history removeObjectAtIndex:[indexPath row]];
        [[NSUserDefaults standardUserDefaults]setObject:history forKey:@"SipHistory"];
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)addNumberToHistory:(NSString*)number{
    
    NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date]
                                                          dateStyle:NSDateFormatterShortStyle
                                                          timeStyle:NSDateFormatterShortStyle];
    NSMutableDictionary *data = [[NSMutableDictionary alloc]init];
    
    [data setValue:number forKey:@"number"];
    [data setValue:dateString forKey:@"date"];
    [history insertObject:data atIndex:0];
    
    if([history count] > 20)
        [history removeObjectAtIndex:20];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:history forKey:@"SipHistory"];

    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [history count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SipHistory"];
    
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SipHistory"];
    
    cell.textLabel.text = [[history objectAtIndex:[indexPath row]]objectForKey:@"number"];
    cell.detailTextLabel.text = [[history objectAtIndex:[indexPath row]]objectForKey:@"date"];;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
