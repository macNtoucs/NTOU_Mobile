//
//  NTOUBusTableViewController.m
//  NTOU_Mobile
//  交通：海洋專車
//
//  Created by iMac on 14/4/7.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "NTOUBusTableViewController.h"

#import "UIKit+NTOUAdditions.h"

@interface NTOUBusTableViewController ()

@end

@implementation NTOUBusTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.title = @"海洋專車";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 32;
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *headerTitle;
    //headerTitle = @"市區公車";
    
    switch (section) {
        case 0:
            headerTitle = @"學生專車";
            break;
            
        case 1:
            headerTitle =@"市區公車";
            break;
            
    }

    
    UIFont *font = [UIFont boldSystemFontOfSize:STANDARD_CONTENT_FONT_SIZE];
	CGSize size = [headerTitle sizeWithFont:font];
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(19.0, 3.0, appFrame.size.width - 19.0, size.height)];
	
	label.text = headerTitle;
	label.textColor = GROUPED_SECTION_FONT_COLOR;
	label.font = font;
	label.backgroundColor = [UIColor clearColor];
	
	UIView *labelContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, appFrame.size.width, GROUPED_SECTION_HEADER_HEIGHT)] autorelease];
	labelContainer.backgroundColor = [UIColor clearColor];
	
	[labelContainer addSubview:label];
	[label release];
	return labelContainer;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 3;
    
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 3;
            break;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    switch (indexPath.section)  {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"海洋大學  → 捷運劍潭站";
                    break;
                case 1:
                    cell.textLabel.text = @"捷運劍潭站  → 海洋大學";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"八斗子  → 海大  → 火車站";
                    break;
                case 1:
                    cell.textLabel.text = @"火車站  → 海大  → 八斗子";
                    break;
                case 2:
                    cell.textLabel.text = @"R66（海科館／七堵車站）";
                default:
                    break;
            }
            break;
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
    if (indexPath.section==0) {
        NTOUTableViewControllerLayer2 * Layer2 = [[NTOUTableViewControllerLayer2 alloc]initWithStyle:UITableViewStyleGrouped];
        [Layer2 SetRoute:indexPath.row];
        [self.navigationController pushViewController:Layer2 animated:YES];
        Layer2.navigationItem.leftBarButtonItem.title=@"back";
        [Layer2 release];
    }
    else if (indexPath.section == 1)
    {
        SecondaryGroupedTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        StopsViewController * stops = [[StopsViewController alloc]initWithStyle:UITableViewStyleGrouped];
        // 這行沒mark掉會導致R66公車無法進到下層
        //stops.title =[ NSString stringWithFormat:@"往%@",[cell.textLabel.text substringWithRange:NSMakeRange(13, 3)] ];
        R66SwitchViewController *r66Switch = [[R66SwitchViewController alloc] init];
        
        if (indexPath.row==0) {
            stops.title =[ NSString stringWithFormat:@"往%@",[cell.textLabel.text substringWithRange:NSMakeRange(13, 3)] ];            [stops setDirection:true];
            [self.navigationController pushViewController:stops animated:YES];
            stops.navigationItem.leftBarButtonItem.title=@"back";
        }
        else if (indexPath.row == 1) {
            stops.title =[ NSString stringWithFormat:@"往%@",[cell.textLabel.text substringWithRange:NSMakeRange(13, 3)] ];            [stops setDirection:false];
            [self.navigationController pushViewController:stops animated:YES];
            stops.navigationItem.leftBarButtonItem.title=@"Hi";
        }
        else
        {
            r66Switch.title = @"R66 時刻表";
            
            //[self.navigationController.toolbar setFrame:CGRectMake(0.0, 0.0, 320.0, 20.0)];
            //NSLog(@"toolbar = %f", self.navigationController.toolbar.frame.size.height);
            [self.navigationController pushViewController:r66Switch animated:YES];
            r66Switch.navigationItem.leftBarButtonItem.title = @"back";
        }
        [stops release];
        [r66Switch release];
    }
}

@end
