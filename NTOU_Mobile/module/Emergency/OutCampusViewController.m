//
//  OutCampusViewController.m
//  MIT Mobile
//
//  Created by mac_hero on 12/10/16.
//
//

#import "OutCampusViewController.h"

@interface OutCampusViewController ()

@end

@implementation OutCampusViewController
@synthesize emergencyData;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        emergencyData =  [[NSArray arrayWithObjects:
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"教官室(24H)", @"title",
                            @"0224629976", @"phone",
                            nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"衛生保健組", @"title",
                            @"0224622192#1071", @"phone",
                            nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"警衛室", @"title",
                            @"0224622192#1132", @"phone",
                            nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"八斗子派出所", @"title",
                            @"0224692077", @"phone",
                            nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"正濱派出所", @"title",
                            @"0224621889", @"phone",
                            nil],
                           [NSDictionary dictionaryWithObjectsAndKeys:
                            @"基隆市警察局", @"title",
                            @"0224248141", @"phone",
                            nil],
                           nil] retain];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [emergencyData count]-3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
     static NSString *SecondaryCellIdentifier = @"SecondaryCell";
    
    SecondaryGroupedTableViewCell *cell = (SecondaryGroupedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondaryCellIdentifier];
    if (cell == nil) {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondaryCellIdentifier] autorelease];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if ([self.title isEqualToString: @"警察局"]){
        NSDictionary *anEntry = [emergencyData objectAtIndex:indexPath.row+3];
        cell.textLabel.text = [anEntry objectForKey:@"title"];
        cell.secondaryTextLabel.text = [anEntry objectForKey:@"phone"];
        cell.accessoryView = [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewPhone];
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
    NSDictionary *anEntry;
    NSString *phoneNumber;
    NSURL *aURL;
    anEntry = [emergencyData objectAtIndex:indexPath.row+3];
    phoneNumber = [[anEntry objectForKey:@"phone"]
                   stringByReplacingOccurrencesOfString:@"."
                   withString:@""];
    aURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]];
    if ([[UIApplication sharedApplication] canOpenURL:aURL]) {
        [[UIApplication sharedApplication] openURL:aURL];
    }
}

@end
