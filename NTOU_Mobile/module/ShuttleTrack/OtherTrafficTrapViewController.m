//
//  OtherTrafficTrapViewController.m
//  MIT Mobile
//
//  Created by mini server on 12/11/16.
//
//

#import "OtherTrafficTrapViewController.h"

@interface OtherTrafficTrapViewController ()

@end

@implementation OtherTrafficTrapViewController

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
    return 4;
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
    switch (indexPath.row)  {
        case 0:
            cell.textLabel.text = @"台鐵";
            break;
        case 1:
            cell.textLabel.text = @"高鐵";
            break;
        case 2:
            cell.textLabel.text=@"國光客運";
            break;
        case 3:
            cell.textLabel.text=@"福合客運";
            break;
        default:
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

-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    
    cellText = @"A"; // just something to guarantee one line
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    rowHeight = labelSize.height + 20.0f;
    
    return rowHeight;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        SetStationViewController *setStationView = [[SetStationViewController alloc]init];
        [setStationView initIsHighSpeedTrain:false];
        [self.navigationController pushViewController:setStationView animated:YES];
        [setStationView release];
    }
    else if(indexPath.row==1)
    {
        DownloadingView* downloadView = [DownloadingView new];
        
        SetStationViewController *setStationView = [[SetStationViewController alloc]init];
        [setStationView initIsHighSpeedTrain:true];
        [self.navigationController pushViewController:setStationView animated:YES];
        [setStationView release];
    }
    else if (indexPath.row==2)
    {
        KUO_RouteViewController_Bra2* route = [[KUO_RouteViewController_Bra2 alloc] initWithStyle:UITableViewStyleGrouped WithType:Kuo_Data];
        route.title = @"路線";
        [self.navigationController pushViewController:route animated:YES];
        [route release];
    }
    else if (indexPath.row==3)
    {
        KUO_RouteViewController_Bra2* route = [[KUO_RouteViewController_Bra2 alloc] initWithStyle:UITableViewStyleGrouped WithType:Fuho_Data];
        route.title = @"路線";
        [self.navigationController pushViewController:route animated:YES];
        [route release];
    }
}

@end
