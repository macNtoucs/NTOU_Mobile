//
//  ExpressBusDetailViewController.m
//  NTOU_Mobile
//
//  Created by iMac on 14/4/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "ExpressBusDetailViewController.h"
#import "FMDatabase.h"

@interface ExpressBusDetailViewController ()

@end

@implementation ExpressBusDetailViewController

@synthesize completeRouteName;
@synthesize stops;
@synthesize times;
@synthesize label;
@synthesize labelsize;
@synthesize departureTimeTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

// 顯示發車時間
- (void)showDepartureTime:(NSString *)selectedShortRouteName
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"發車時間"])
    {
        self.navigationItem.rightBarButtonItem.title = @"動態資訊";
        [self.tableView addSubview:departureTimeTableView];
    }
    else
    {
        self.navigationItem.rightBarButtonItem.title = @"發車時間";
        [departureTimeTableView removeFromSuperview];
    }
}

- (void)setCompleteRouteName:(NSString *)selectedShortRouteName
{
    NSLog(@"selectedShortRouteName = %@", selectedShortRouteName);
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ntou_mobile3.db"];
    NSLog(@"defaultDBPath=%@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    if (![db open])
        NSLog(@"Could not open db.");
    else
        NSLog(@"Open db successly.");
    
    NSMutableString *query = [NSMutableString stringWithString:@"SELECT completeRouteName FROM expressinfo WHERE shortRouteName = '"];
    [query appendString:selectedShortRouteName];
    [query appendString:@"'"];
    //NSLog(@"ExpressBusDetail.m query=%@", query);
    FMResultSet *rs = [db executeQuery:query];
    
    while ([rs next])
    {
        completeRouteName = [rs stringForColumn:@"completeRouteName"];
    }
    [rs close];
    
    routeId = [completeRouteName substringWithRange:NSMakeRange(0, 4)];
    completeRouteName = [completeRouteName substringFromIndex:4];
    
    NSLog(@"completeRouteName = %@", completeRouteName);
}

- (void) estimateTime
{
    if(stops)
    {
        [stops removeAllObjects];
        [times removeAllObjects];
    }
    
    NSString *encodedBus = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[routeId stringByAppendingString: completeRouteName], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    //NSLog(@"url = %@", url);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/ExpressBusTime_web.php?bus=%@", encodedBus]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    //NSLog(@"data=%@", data);
    NSError *error;
    
    NSMutableDictionary  *stationInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    
    //NSLog(@"ExpressBus stationInfo: %@",stationInfo);
    
    NSArray * responseArr = stationInfo[@"stationInfo"];
    
    for(NSDictionary * dict in responseArr)
    {
        [stops addObject:[dict valueForKey:@"name"]];
        [times addObject:[dict valueForKey:@"time"]];
    }
    
    //NSLog(@"stops = %@", stops);
    
    [stops retain];
    [times retain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    
    /*UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"發車時間" style:UIButtonTypeRoundedRect target:self action:@selector(showDepartureTime:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [rightButton release];*/
    
    stops = [[NSMutableArray alloc] init];
    times = [[NSMutableArray alloc] init];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    departureTimeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    //departureTimeTableView.delegate = self;
    //departureTimeTableView.dataSource = self;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    label.text = completeRouteName;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    //設置自動行數與字符換行
    [label setNumberOfLines:0];
    label.lineBreakMode = UILineBreakModeWordWrap;
    UIFont *font = [UIFont fontWithName:@"Arial" size:18];
    
    //設置寬、高上限
    CGSize size = CGSizeMake(screenWidth-40, screenHeight);
    //計算實際 frame 大小，並將 label 的 frame 變成實際大小
    labelsize = [completeRouteName sizeWithFont:font constrainedToSize:size
                                         lineBreakMode:UILineBreakModeWordWrap];
    [label setFrame:CGRectMake(20, 70, screenWidth-40, labelsize.height)];
    
    [self.parentViewController.view addSubview:label];
    
    //NSLog(@"labelsize.height = %f", labelsize.height);
    
    [self estimateTime];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.label removeFromSuperview];
}

- (void)viewDidAppear:(BOOL)animated
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    [self.tableView setFrame:CGRectMake(0,labelsize.height+10, screenWidth, screenHeight-labelsize.height-50)];
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
    return [stops count];
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [stops objectAtIndex:indexPath.row];
    if([[times objectAtIndex:indexPath.row] rangeOfString:@"未發車"].location != NSNotFound)
    {
        cell.detailTextLabel.text = [[times objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(0, 3)];
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    else if([[times objectAtIndex:indexPath.row] rangeOfString:@"分"].location != NSNotFound)
    {
        NSUInteger len = [[times objectAtIndex:indexPath.row] rangeOfString:@"分"].location+1;
        cell.detailTextLabel.text = [[times objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(0, len)];
        cell.detailTextLabel.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];;
    }
    else if([[times objectAtIndex:indexPath.row] rangeOfString:@"站"].location != NSNotFound)
    {
        NSUInteger pos1 = [[times objectAtIndex:indexPath.row] rangeOfString:@"將"].location;
        NSUInteger pos2 = [[times objectAtIndex:indexPath.row] rangeOfString:@"站"].location;
        cell.detailTextLabel.text = [[times objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(pos1, pos2-pos1+1)];
        cell.detailTextLabel.textColor = [UIColor redColor];
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
