//
//  R66Layer2ViewController.m
//  NTOU_Mobile
//  R66假日
//  Created by NTOUCS on 13/11/20.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "R66RightLayerViewController.h"
#import "UIKit+NTOUAdditions.h"

@interface R66RightLayerViewController ()

@end

@implementation R66RightLayerViewController
@synthesize weekend_marine, weekend_qidu;

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
    weekend_marine = [[NSArray alloc] initWithObjects:@"海科館", @"06:30", @"07:10", @"07:50", @"08:30", @"09:10", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"16:50", @"17:40", @"18:30", @"19:30", @"20:30", @"21:30", nil];
    weekend_qidu = [[NSArray alloc] initWithObjects:@"七堵車站", @"07:20", @"08:00", @"08:40", @"09:20", @"10:00", @"10:50", @"11:50", @"12:50", @"13:50", @"14:50", @"15:50", @"16:50", @"17:40", @"18:30", @"19:20", @"20:20", @"21:20", @"22:20", nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    [self.tableView applyStandardColors];
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
    if (section ==1) {
        return 0;
    }
    NSLog(@"R66Right tableCell count:%lu",(unsigned long)[weekend_marine count]);
    return [weekend_marine count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
    if (section ==1) {
        return @"";
    }
    return @"例假日發車時間";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==1) {
        return [UITableView groupedSectionHeaderWithTitle3:@"" andOther:@""];
    }
	NSString *headerTitle1 = @"平常日發車時間";
    NSString *headerTitle2 = @"例假日發車時間";
    return [UITableView groupedSectionHeaderWithTitle3:headerTitle1 andOther:headerTitle2];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
    
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *timeString;
        
      if (indexPath.section ==0) {
    if (indexPath.row == 0)
        timeString = [[NSString alloc] initWithFormat:@"           %@               %@", [weekend_marine objectAtIndex:indexPath.row], [weekend_qidu objectAtIndex:indexPath.row]];
    else
        timeString = [[NSString alloc] initWithFormat:@"            %@                  %@", [weekend_marine objectAtIndex:indexPath.row], [weekend_qidu objectAtIndex:indexPath.row]];
    
    // Configure the cell...
    cell.textLabel.text = timeString;
          }
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
