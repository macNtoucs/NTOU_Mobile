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
@synthesize searchController;

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
    
    searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    searchController.searchResultsUpdater = self;
    searchController.searchBar.delegate = self;
    searchController.obscuresBackgroundDuringPresentation = NO;
    searchController.dimsBackgroundDuringPresentation = NO;
    searchController.hidesNavigationBarDuringPresentation = NO;
    self.definesPresentationContext = YES;
    
    self.tableView.tableHeaderView = searchController.searchBar;
    
    informations = [[NSUserDefaults standardUserDefaults] objectForKey:@"SipInformations"];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(editMode)];
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
    if (editingStyle == UITableViewCellEditingStyleInsert) {
        if(searchController.active)
        {
            [(SipTabBarViewController*)self.tabBarController addUsuallyUse:[filteredInformations objectAtIndex:[indexPath row]]];
        }
        else
        {
            [(SipTabBarViewController*)self.tabBarController addUsuallyUse:[informations objectAtIndex:[indexPath row]]];
        }
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"加入最愛成功！" message:nil delegate:self cancelButtonTitle:@"確定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleInsert;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(searchController.active)
        return [filteredInformations count];
    else
        return [informations count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SipTable"];
    
    if(!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"SipTable"];

    if(searchController.active)
    {
        cell.textLabel.text = [[filteredInformations objectAtIndex:[indexPath row]]objectForKey:@"name"];
        cell.detailTextLabel.text = [[filteredInformations objectAtIndex:[indexPath row]]objectForKey:@"number"];
    }
    else
    {
        cell.textLabel.text = [[informations objectAtIndex:[indexPath row]]objectForKey:@"name"];
        cell.detailTextLabel.text = [[informations objectAtIndex:[indexPath row]]objectForKey:@"number"];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    searchController.active = NO;
    [(SipTabBarViewController*)self.tabBarController makeCallToNTOU:[[informations objectAtIndex:[indexPath row]]objectForKey:@"number"] ];
}

- (void)refresh:(UIRefreshControl*)sender{
    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:@"刷新中..."];
    [(SipTabBarViewController*)self.tabBarController checkUpdate];
    informations = [[NSUserDefaults standardUserDefaults] objectForKey:@"SipInformations"];
    [self.tableView reloadData];
    [sender endRefreshing];
}


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *searchString = [self.searchController.searchBar text];
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"(name CONTAINS %@) || (number CONTAINS %@)",searchString,searchString];
    
    [filteredInformations release];
    filteredInformations = [informations filteredArrayUsingPredicate:preicate];
    [filteredInformations retain];
    
    [self.tableView reloadData];
    
}


@end
