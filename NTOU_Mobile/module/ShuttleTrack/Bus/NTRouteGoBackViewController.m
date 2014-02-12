//
//  TPRouteGoBackViewController.m
//  bus
//
//  Created by iMac on 12/10/29.
//
//

#import "NTRouteGoBackViewController.h"
#import "NTRouteDetailViewController.h"

@implementation NTRouteGoBackViewController


- (void) setter_departure:(NSString *) name //取得所點選的公車路線起始位置
{
    departure = name;
    NSLog(@"RouteGoBack.m 起始站牌 = %@", departure);
}

- (void) setter_destination:(NSString *) name   //取得所點選的公車路線終點位置
{
    destination = name;
    NSLog(@"RouteGoBack.m 終點站牌 = %@", destination);
}

- (void) setter_busName:(NSString *)name
{
    busName = name;
    NSLog(@"RouteGoBack.m  busName:%@", busName);
    [busName retain];
}


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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
    return 2;
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString * to = @"往 ";
    
    if(indexPath.row == 0)
        cell.textLabel.text = [to stringByAppendingString:destination];
    else
        cell.textLabel.text = [to stringByAppendingString:departure];
    
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
    UIAlertView *loadingAlertView = [[UIAlertView alloc]
                                     initWithTitle:nil message:@"\n\nDownloading\nPlease wait"
                                     delegate:nil cancelButtonTitle:nil
                                     otherButtonTitles: nil];
    CGRect frame = CGRectMake(120, 10, 40, 40);
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [progressInd startAnimating];
    [loadingAlertView addSubview:progressInd];
    [loadingAlertView show];
    [progressInd release];
    
    NTRouteDetailViewController * secondLevel = [NTRouteDetailViewController new];
    NSString * selectedRouteName = [[NSString alloc] init];
    NSString * to = @"往 ";
    
    if(indexPath.row == 0)
        selectedRouteName = [to stringByAppendingString:destination];
    else
        selectedRouteName = [to stringByAppendingString:departure];
    
    NSLog(@"BusName:%@", busName);
    NSLog(@"selected route = %@, goback = %i", selectedRouteName, indexPath.row);
    secondLevel.title = selectedRouteName;
    [secondLevel setter_busName:busName andGoBack:indexPath.row];
    
    [self.navigationController pushViewController:secondLevel animated:YES];
    
    [loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
    [loadingAlertView release];
    [secondLevel release];

}

- (void)dealloc
{
    [busName release];
    [departure release];
    [destination release];
    [super dealloc];
}

@end
