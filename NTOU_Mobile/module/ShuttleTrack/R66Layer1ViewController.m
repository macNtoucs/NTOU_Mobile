//
//  R66Layer1ViewController.m
//  NTOU_Mobile
//
//  Created by NTOUCS on 13/11/20.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "R66Layer1ViewController.h"
#import "UIKit+NTOUAdditions.h"

@interface R66Layer1ViewController ()

@end

@implementation R66Layer1ViewController
@synthesize weekday_marine, weekday_qidu;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initWithData
{
    weekday_marine = [[NSArray alloc] initWithObjects:@"海科館", @"06:30", @"06:50", @"07:10", @"07:30", @"07:50", @"08:10", @"08:30", @"08:50", @"09:10", @"09:30", @"09:50", @"10:10", @"10:30", @"10:50", @"11:10", @"12:00", @"12:50", @"13:40", @"14:30", @"15:20", @"16:00", @"16:20", @"16:40", @"17:00", @"17:20", @"18:10", @"19:00", @"19:50", @"20:40", @"21:30", nil];
    weekday_qidu = [[NSArray alloc] initWithObjects:@"七堵車站", @"07:20", @"07:40", @"08:00", @"08:20", @"08:40", @"09:00", @"09:20", @"09:40", @"10:00", @"10:20", @"10:40", @"11:00", @"11:20", @"11:40", @"12:00", @"12:50", @"13:40", @"14:30", @"15:20", @"16:10", @"16:50", @"17:10", @"17:30", @"17:50", @"18:10", @"19:00", @"19:50", @"20:40", @"21:30", @"22:20", nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    [self initWithData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [weekday_marine count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    
    cellText = @"A"; // just something to guarantee one line
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    rowHeight = labelSize.height + 20.0f;
    
    return rowHeight;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"平常日發車時間";
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSString *headerTitle = @"平常日發車時間";
    return [UITableView groupedSectionHeaderWithTitle:headerTitle];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    NSString *timeString;
    if (indexPath.row == 0)
        timeString = [[NSString alloc] initWithFormat:@"           %@               %@", [weekday_marine objectAtIndex:indexPath.row], [weekday_qidu objectAtIndex:indexPath.row]];
    else
        timeString = [[NSString alloc] initWithFormat:@"            %@                  %@", [weekday_marine objectAtIndex:indexPath.row], [weekday_qidu objectAtIndex:indexPath.row]];
        
    // Configure the cell...
    cell.textLabel.text = timeString;
    [timeString release];   // Analyze Mem Leak
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
    
}

@end
