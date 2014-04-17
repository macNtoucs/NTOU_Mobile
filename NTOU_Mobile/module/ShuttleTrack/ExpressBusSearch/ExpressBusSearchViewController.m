//
//  ExpressBusSearchViewController.m
//  NTOU_Mobile
//
//  Created by iMac on 14/4/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "ExpressBusSearchViewController.h"
#import "FMDatabase.h"

@interface ExpressBusSearchViewController ()

@end

@implementation ExpressBusSearchViewController

@synthesize searchResults;
@synthesize searchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    
    self.searchResults =[[NSMutableArray alloc]init];
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ntou_mobile3.db"];
    NSLog(@"defaultDBPath=%@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    if (![db open])
        NSLog(@"Could not open db.");
    else
        NSLog(@"Open db successly.");
    
    NSMutableString *query = [NSMutableString stringWithString:@"SELECT shortRouteName FROM expressinfo"];
    //NSLog(@"query=%@", query);
    FMResultSet *rs = [db executeQuery:query];
    
    while ([rs next])
    {
        [searchResults addObject:[rs stringForColumn:@"shortRouteName"]];
    }
    [rs close];
    
    //NSLog(@"searchResults: %@", searchResults);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0,320,44)];
    [self.searchBar setTintColor:[UIColor lightGrayColor]];
    self.searchBar.placeholder = @"請輸入路線編號或名稱";
    //self.searchBar.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.tableView.tableHeaderView = searchBar;
    self.searchBar.delegate = (id)self;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
    //NSLog(@"search bar text = %@", theSearchBar.text);
    if(searchText.length != 0)
    {
        if([searchResults count] > 0)
            [searchResults removeAllObjects];
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ntou_mobile3.db"];
        NSLog(@"defaultDBPath=%@", defaultDBPath);
        FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
        if (![db open])
            NSLog(@"Could not open db.");
        else
            NSLog(@"Open db successly.");
        
        NSMutableString *query = [NSMutableString stringWithString:@"SELECT shortRouteName FROM expressinfo WHERE shortRouteName LIKE '%"];
        [query appendString:searchText];
        [query appendString:@"%'"];
        //NSLog(@"query=%@", query);
        FMResultSet *rs = [db executeQuery:query];
        
        while ([rs next])
        {
            [searchResults addObject:[rs stringForColumn:@"shortRouteName"]];
        }
        [rs close];
        
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    // You can write search code Here
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSArray * tmpArr = [[searchResults objectAtIndex:indexPath.row] componentsSeparatedByString:@"["];
    NSString * text = [tmpArr objectAtIndex:0];
    NSString * detail = @"";
    if([tmpArr count] == 2)
        detail = [[[tmpArr objectAtIndex:1] componentsSeparatedByString:@"]"] objectAtIndex:0];
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detail;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressBusDetailViewController * secondLevel = [[ExpressBusDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    NSString * selectedShortRouteName = [[NSString alloc] initWithString:[searchResults objectAtIndex:indexPath.row]];
    secondLevel.title = [[NSString alloc] initWithString:[selectedShortRouteName substringWithRange:NSMakeRange(0, 4)]];
    
    [secondLevel setCompleteRouteName:selectedShortRouteName];
    
    [self.navigationController pushViewController:secondLevel animated:YES];
    [secondLevel release];
}

@end
