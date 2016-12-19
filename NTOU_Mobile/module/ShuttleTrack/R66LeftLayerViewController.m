//
//  R66Layer1ViewController.m
//  NTOU_Mobile
//  R66平日班次
//  Created by NTOUCS on 13/11/20.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "R66LeftLayerViewController.h"
#import "UIKit+NTOUAdditions.h"

@interface R66LeftLayerViewController ()

@end

@implementation R66LeftLayerViewController
@synthesize weekday_marine, weekday_qidu;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

    }
    return self;
}

- (void)initWithData
{
    weekday_marine = [[NSArray alloc] initWithObjects:@"海科館", @"06:30", @"06:50", @"07:10", @"07:30", @"08:00", @"08:20", @"08:40", @"09:10", @"10:00", @"11:20", @"12:40", @"14:00", @"15:20", @"15:40", @"15:55", @"16:20", @"16:35", @"17:00", @"17:25", @"18:10", @"19:00", @"19:40", @"20:30", nil];
    weekday_qidu = [[NSArray alloc] initWithObjects:@"七堵車站", @"07:05", @"07:25", @"07:45", @"08:05", @"08:35", @"08:55", @"09:15", @"09:45", @"10:35", @"11:55", @"13:15", @"14:35", @"15:55", @"16:15", @"16:45", @"17:15", @"17:35", @"17:55", @"18:15", @"18:45", @"19:35", @"20:15", @"21:00", @"17:50", nil];
}

/*- (void)swipeLeft:(UITapGestureRecognizer *)recongizer
 {
 if (self.r66layer2ViewController == nil)
 {
 //R66Layer2ViewController *layer2ViewController = [[R66Layer2ViewController alloc] initWithStyle:UITableViewStyleGrouped];
 R66RightLayerViewController *layer2ViewController = [[R66RightLayerViewController alloc] initWithStyle:UITableViewStyleGrouped];
 layer2ViewController.tableView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
 self.r66layer2ViewController = layer2ViewController;
 [layer2ViewController release];
 }
 [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
 switchButton.title = @"平常日";
 [r66layer1ViewController.view removeFromSuperview];
 [self.view insertSubview:r66layer2ViewController.view atIndex:0];
 }*/

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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSLog(@"R66Left tableCell count:%lu",(unsigned long)[weekday_marine count]);

    return [weekday_marine count];
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
    return @"平常日發車時間";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	NSString *headerTitle1 = @"平常日發車時間";
    NSString *headerTitle2 = @"例假日發車時間";
    return [UITableView groupedSectionHeaderWithTitle2:headerTitle1 andOther:headerTitle2];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *timeString;
    if (indexPath.row == 0)
        timeString = [[NSString alloc] initWithFormat:@"           %@               %@", [weekday_marine objectAtIndex:indexPath.row], [weekday_qidu objectAtIndex:indexPath.row]];
    else
        timeString = [[NSString alloc] initWithFormat:@"            %@                  %@", [weekday_marine objectAtIndex:indexPath.row], [weekday_qidu objectAtIndex:indexPath.row]];
    
    // Configure the cell...
    cell.textLabel.text = timeString;
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
