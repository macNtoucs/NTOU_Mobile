//
//  SecondLevelViewController.m
//  TaipeiBusSystem
//
//  Created by Ching-Chi Lin on 12/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NTRouteDetailViewController.h"
#define kRefreshInterval 60

@implementation NTRouteDetailViewController

@synthesize busName;
@synthesize goBack;
@synthesize stops, IDs, m_waitTimeResult;

//@synthesize toolbar;
@synthesize anotherButton;
@synthesize success;
@synthesize lastRefresh;
@synthesize refreshTimer;
@synthesize xpathArray;
@synthesize xpathParser;    //

- (void) setter_busName:(NSString *)name andGoBack:(NSInteger) goback
{
    busName = name;
    goBack = [[NSString alloc] initWithFormat:@"%i", goback];
    NSLog(@"busName:%@, goBack:%@", busName, goBack);
}

- (void) setter_departure:(NSString *)dep andDestination:(NSString *)des
{
    departure = [[NSString alloc] initWithString:dep];
    destination = [[NSString alloc] initWithString:des];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)CatchData
{
    [self estimateTime];
    [self.tableView reloadData];
}

- (void)estimateTime
{
    if(stops)
    {
        [stops removeAllObjects];
        //[IDs removeAllObjects];
        [m_waitTimeResult removeAllObjects];
    }
    
    NSString *encodedBus = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)busName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    NSString *strURL = [NSString stringWithFormat:@"http://140.121.91.62/NTRouteDetail.php?bus=%@&goBack=%@", encodedBus, goBack];
    
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    NSString *strResult = [[[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding]autorelease];
    
    NSLog(@"strResult = %@", strResult);
    
    NSArray * stopsAndTimes = [strResult componentsSeparatedByString:@";"];
    
    NSArray * tmp_stops = [[NSArray alloc] init];
    tmp_stops = [[stopsAndTimes objectAtIndex:0] componentsSeparatedByString:@"|"];
    for (NSString * str in tmp_stops)
    {
        [stops addObject:str];
    }
    [stops removeLastObject];
    
    /*NSArray * tmp_IDs = [[NSArray alloc] init];
     tmp_IDs = [[stopsAndTimes objectAtIndex:1] componentsSeparatedByString:@"|"];
     for (NSString * str in tmp_IDs)
     {
     [IDs addObject:str];
     }
     [IDs removeLastObject];*/
    
    NSArray * tmp_m = [[NSArray alloc] init];
    tmp_m = [[stopsAndTimes objectAtIndex:1] componentsSeparatedByString:@"|"];
    for (NSString * str in tmp_m)
    {
        [m_waitTimeResult addObject:str];
    }
    [m_waitTimeResult removeLastObject];
    
    [stops retain];
    //[IDs retain];
    [m_waitTimeResult retain];
}

-(void)AlertStart:(UIAlertView *) loadingAlertView{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    CGRect frame = CGRectMake(120, 10, 40, 40);
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [progressInd startAnimating];
    [loadingAlertView addSubview:progressInd];
    [loadingAlertView show];
    [progressInd release];
    [pool drain];
}

-(void)stopTimer
{
	if (self.refreshTimer !=nil)
	{
		[self.refreshTimer invalidate];
		self.refreshTimer = nil;
		self.anotherButton.title = @"Refresh";
	}
}

- (void)refreshPropertyList{
    self.lastRefresh = [NSDate date];
    self.navigationItem.rightBarButtonItem.title = @"Refreshing";
    UIAlertView *  loadingAlertView = [[UIAlertView alloc]
                                       initWithTitle:nil message:@"\n\nDownloading\nPlease wait"
                                       delegate:nil cancelButtonTitle:nil
                                       otherButtonTitles: nil];
    NSThread*thread = [[NSThread alloc]initWithTarget:self selector:@selector(AlertStart:) object:loadingAlertView];
    [thread start];
    while (true) {
        if ([thread isFinished]) {
            break;
        }
    }
    [self CatchData];
    [loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
    [loadingAlertView release];
    [thread release];
}

- (void)startTimer
{
    self.lastRefresh = [NSDate date];
    NSDate *oneSecondFromNow = [NSDate dateWithTimeIntervalSinceNow:0];
    self.refreshTimer = [[[NSTimer alloc] initWithFireDate:oneSecondFromNow interval:1 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES] autorelease];
    [[NSRunLoop currentRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
	
}

-(void) countDownAction:(NSTimer *)timer
{
    
    if (self.refreshTimer !=nil && self.refreshTimer)
	{
		NSTimeInterval sinceRefresh = [self.lastRefresh timeIntervalSinceNow];
        
        // If we detect that the app was backgrounded while this timer
        // was expiring we go around one more time - this is to enable a commuter
        // bookmark time to be processed.
        
        bool updateTimeOnButton = YES;
        
		if (sinceRefresh <= -kRefreshInterval)
		{
            [self refreshPropertyList];
			self.anotherButton.title = @"Refreshing";
            //updateTimeOnButton = NO;
		}
        
        else if (updateTimeOnButton)
        {
            int secs = (1+kRefreshInterval+sinceRefresh);
            if (secs < 0) secs = 0;
            self.anotherButton.title = [NSString stringWithFormat:@"Refresh in %d", secs];
            
        }
	}
    
}

- (void)changeDetailView
{
    if ([goBack isEqualToString:@"0"])
    {
        anotherButton.title = destination;
        self.navigationItem.title = [NSString stringWithFormat:@"往 %@", departure];
        [self setter_busName:busName andGoBack:1];
        [self CatchData];
    }
    else
    {
        anotherButton.title = departure;
        self.navigationItem.title = [NSString stringWithFormat:@"往 %@", destination];
        [self setter_busName:busName andGoBack:0];
        [self CatchData];
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    //IDs = [NSMutableArray new];
    m_waitTimeResult = [NSMutableArray new];
    stops = [NSMutableArray new];
    
    // Refresh button & toolbar
    //toolbar = [[ToolBarController alloc]init];
    //[self.navigationController.view addSubview:[toolbar CreatTabBarWithNoFavorite:NO delegate:self] ];
    anotherButton = [[UIBarButtonItem alloc] initWithTitle:departure style:UIBarButtonItemStylePlain target:self action:@selector(changeDetailView)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    // 手動下拉更新
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,0.0f - self.tableView.bounds.size.height,self.tableView.bounds.size.width,self.tableView.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
        [view1 release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    success = [[UIImageView alloc] initWithFrame:CGRectMake(75.0, 250.0, 150.0, 150.0)];
    [success setImage:[UIImage imageNamed:@"ok.png"]];
    [self CatchData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    //[self.navigationController.view addSubview:toolbar.toolbarcontroller];
    //[self.toolbar hideTabBar:self.tabBarController];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!stops) {
        NSLog(@"RouteDetail.m stops is null");
        [self CatchData];
    }
    //[self startTimer];
    [super viewDidAppear:animated];
    //[self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //[toolbar.toolbarcontroller removeFromSuperview];
    //[self.toolbar showTabBar: self.tabBarController];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopTimer];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
    
    return [stops count];   // for can't see cell
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
    NSString * CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSString * stopName = [[NSString alloc] init];
    NSString * comeTime = [[NSString alloc] init];
    
    if (indexPath.row == [stops count])
    {
        [cell.contentView removeFromSuperview];
    }
    else
    {
        stopName = [stops objectAtIndex:indexPath.row];
        comeTime = [m_waitTimeResult objectAtIndex:indexPath.row];
        
        if ([comeTime isEqual:@"尚未發車"])
        {
            cell.detailTextLabel.text = @"尚未發車";
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        else if ([comeTime isEqual:@"更新中..."])
        {
            cell.detailTextLabel.text = @"更新中...";
            cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:13.0/255.0 green:139.0/255.0 blue:13.0/255.0 alpha:100.0];
        }
        else if ([comeTime isEqual:@"約1分鐘"] || [comeTime isEqual:@"約0分鐘"])
        {
            cell.detailTextLabel.text = @"進站中";
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        else if ([comeTime isEqual:@"約2分鐘"] || [comeTime isEqual:@"約3分鐘"])
        {
            cell.detailTextLabel.text = @"即將進站";
            cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:255.0/255.0 green:138.0/255.0 blue:25.0/255.0 alpha:100.0];
        }
        else
        {
            cell.detailTextLabel.text = comeTime;
            cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:0.0 green:45.0/255.0 blue:153.0/255.0 alpha:100.0];
        }
    }
    
    
    //NSString * number = [[NSString alloc] initWithFormat:@"(%i) ", indexPath.row+1];
    cell.textLabel.text = stopName;
    //cell.textLabel.text = [number stringByAppendingString:stopName];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    
    [[cell.contentView viewWithTag:indexPath.row+1]removeFromSuperview];
    //[cell.contentView addSubview:[toolbar CreateButton:indexPath]];
    //NSString * newString = [[busName componentsSeparatedByString:@"("] objectAtIndex:0];
    //[toolbar isStopAdded:newString andStop:stopName andNo:@"RouteDetail"];
    
    return cell;
}

- (void)dealloc
{
    [busName release];
    [goBack release];
    //[IDs release];
    [stops release];
    [m_waitTimeResult release];
    [anotherButton release];
    [lastRefresh release];
    [refreshTimer release];
    [success release];
    //[toolbar release];
    [super dealloc];
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
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark –
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
    _reloading = YES;
}

- (void)doneLoadingTableViewData{
    _reloading = NO;
    [self CatchData];
    self.lastRefresh = [NSDate date];
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
}

#pragma mark –
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}

#pragma mark –
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    [self reloadTableViewDataSource];
    [self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:0];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    return [NSDate date];
}
@end
