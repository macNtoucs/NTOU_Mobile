//
//  SecondLevelViewController.m
//  TaipeiBusSystem
//
//  Created by Ching-Chi Lin on 12/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "KLRouteDetailViewController.h"
#define kRefreshInterval 60

@implementation KLRouteDetailViewController

//@synthesize busId;
@synthesize busName, goBack, departure, destination;
//@synthesize url;
@synthesize stops, IDs, m_waitTimeResult;

//@synthesize toolbar;
@synthesize anotherButton;
@synthesize success;
@synthesize lastRefresh;
@synthesize refreshTimer;
@synthesize preArray;
@synthesize activityIndicator, loadingView;

- (void) setter_busName:(NSString *)name andGoBack:(NSInteger) goback
{
    busName = name;
    goBack = [[NSString alloc] initWithFormat:@"%i", goback];
    NSLog(@"busName:%@, goBack:%@", busName, goBack);
    ISREAL = FALSE;
}

- (void) setter_departure:(NSString *)dep andDestination:(NSString *)des
{
    departure = [[NSString alloc] initWithString:dep];
    destination = [[NSString alloc] initWithString:des];
    //NSLog(@"dep:%@ / des:%@", depature, destination);
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
    ISREAL = TRUE;
    [self estimateTime];
    [self.tableView reloadData];
    [loadingView dismissWithClickedButtonIndex:0 animated:YES];
    [activityIndicator stopAnimating];
}

- (void)estimateTime
{
    if(stops)
    {
        [stops removeAllObjects];
        [IDs removeAllObjects];
        [m_waitTimeResult removeAllObjects];
    }
    
    NSString *encodedBus = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)busName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    //NSLog(@"url = %@", url);
    
    //NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    
    /*TFHpple* parser = [[TFHpple alloc] initWithHTMLData:dataURL];
    NSArray *tmpStop  = [parser searchWithXPathQuery:@"//body//div//table//tr//td"]; // get the title
    
    //NSLog(@"tmpStop = %@", tmpStop);
    
    for(int i=1; i<[tmpStop count]; i++)
    {
        TFHppleElement* stopData = [tmpStop objectAtIndex:i];
        //NSLog(@"stopData = %@", stopData);
        NSArray * attributes = [stopData children];
        //NSLog(@"attributes = %@", attributes);
        TFHppleElement* urlAndStopName = [attributes objectAtIndex:1];
        //NSLog(@"url&StopName = %@", urlAndStopName);
        
        NSString * estimateURL = [[urlAndStopName attributes] objectForKey:@"href"];
        
        //NSLog(@"estimateURL = %@", estimateURL);
        
        NSArray * tmp1 = [estimateURL componentsSeparatedByString:@"sid="];
        NSString * sid = [tmp1 objectAtIndex:1];*/
        
        //NSString *strURL = [NSString stringWithFormat:@"http://140.121.91.62/KLRouteDetail_web.php?url=%@", url];
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/KLRouteDetail_web.php?bus=%@", encodedBus]];
    //NSLog(@"KLencodebus=%@", encodedBus);
    //NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/KLRouteDetail_web.php?url=http://ebus.klcba.gov.tw/KLBusWeb/pda/estimate_stop.jsp?rid=104101"]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    //NSLog(@"data=%@", data);
    NSError *error;
    
    NSMutableDictionary  *stationInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    
    //NSLog(@"NTstationInfo: %@",stationInfo);
    
    NSArray * responseArr = stationInfo[@"stationInfo"];
    
    for(NSDictionary * dict in responseArr)
    {
        [stops addObject:[dict valueForKey:@"name"]];
        [m_waitTimeResult addObject:[dict valueForKey:@"time"]];
    }
    
        
    
        /*NSData *dataURL2 = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
        
        //NSString *strResult = [[[NSString alloc] initWithData:dataURL2 encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingBig5)]autorelease];
        //NSString *strResult = [[[NSString alloc] initWithData:dataURL2 encoding:NSUTF8StringEncoding]autorelease];
        
        NSLog(@"strResult = %@", strResult);*/
    
        //[stops addObject:@""];
        //[m_waitTimeResult addObject:@""];
        //[stops addObject:[[[urlAndStopName children] objectAtIndex:0] content]];
        //[m_waitTimeResult addObject:strResult];
    //}
    
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

/*- (void)startTimer
{
    self.lastRefresh = [NSDate date];
    NSDate *oneSecondFromNow = [NSDate dateWithTimeIntervalSinceNow:0];
    self.refreshTimer = [[[NSTimer alloc] initWithFireDate:oneSecondFromNow interval:1 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES] autorelease];
    [[NSRunLoop currentRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
	
}*/

/*-(void) countDownAction:(NSTimer *)timer
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
    
}*/

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    
    preArray = [[NSArray alloc] initWithObjects:@"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", @"讀取中請稍等", nil];
    
    //IDs = [NSMutableArray new];
    m_waitTimeResult = [NSMutableArray new];
    stops = [NSMutableArray new];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    loadingView =  [[UIAlertView alloc] initWithTitle:nil message:@"下載資料中\n請稍候" delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
    //loadingView.frame = CGRectMake(screenSize.width/2-100.0, screenSize.height/2-50.0, 200.0, 100.0);
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.frame = CGRectMake(115.0, 60.0, 50.0, 50.0);
    /*NSLog(@"activityIndicator=%lf", activityIndicator.center.x);
     NSLog(@"activityIndicator=%lf", activityIndicator.center.y);
     NSLog(@"loadingView=%lf", loadingView.center.x);
     NSLog(@"loadingView=%lf", loadingView.center.y);*/
    [self.loadingView addSubview:self.activityIndicator];
    NSLog(@"startAnimating");
    [activityIndicator startAnimating];
    [self.tableView addSubview:self.loadingView];
    [self.loadingView show];
    // Refresh button & toolbar
    /*toolbar = [[ToolBarController alloc]init];
    [self.navigationController.view addSubview:[toolbar CreatTabBarWithNoFavorite:NO delegate:self] ];*/
    /*anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPropertyList)];
    self.navigationItem.rightBarButtonItem = anotherButton;*/
    m_waitTimeResult = [NSMutableArray new];
    stops = [NSMutableArray new];
    
    // 手動下拉更新
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,0.0f - self.tableView.bounds.size.height,self.tableView.bounds.size.width,self.tableView.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
        [view1 release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    /*success = [[UIImageView alloc] initWithFrame:CGRectMake(75.0, 250.0, 150.0, 150.0)];
    [success setImage:[UIImage imageNamed:@"ok.png"]];*/
    //[self CatchData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    /*[self.navigationController.view addSubview:toolbar.toolbarcontroller];
    [self.toolbar hideTabBar:self.tabBarController];*/
    [super viewWillAppear:animated];
}


- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[Detail]viewDidAppear");
    [super viewDidAppear:animated];
    if (!ISREAL)
    {
        NSLog(@"RouteDetail.m stops is null");
        [self CatchData];
    }
    else
    {
        NSLog(@"[Detail]stopAnimating");
        [activityIndicator stopAnimating];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    /*[toolbar.toolbarcontroller removeFromSuperview];
    [self.toolbar showTabBar: self.tabBarController];*/
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
    if (ISREAL)
        return [stops count];   // for can't see cell
    else
        return [preArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    NSString * stopName = [[NSString alloc] init];
    NSString * comeTime = [[NSString alloc] init];
    if (ISREAL)
    {
        if (indexPath.row == [stops count])
        {
            [cell.contentView removeFromSuperview];
        }
        else
        {
            stopName = [stops objectAtIndex:indexPath.row];
            comeTime = [m_waitTimeResult objectAtIndex:indexPath.row];
            
            if([comeTime isEqualToString:@"即將進站..."])
            {
                cell.detailTextLabel.text = @"即將進站";
                cell.detailTextLabel.textColor = [UIColor redColor];//
            }
            else if([comeTime isEqualToString:@"目前無公車即時資料"])
            {
                cell.detailTextLabel.text = @"現在無班車";
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:100.0];
            }
            else
            {
                cell.detailTextLabel.text = comeTime;
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:0.0 green:45.0/255.0 blue:153.0/255.0 alpha:100.0];
            }
        }
        cell.textLabel.text = stopName;
        cell.textLabel.textColor = [UIColor blackColor];
        [[cell.contentView viewWithTag:indexPath.row+1]removeFromSuperview];
    }
    else
    {
        cell.textLabel.text = [preArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    
    
    //NSString * number = [[NSString alloc] initWithFormat:@"(%i) ", indexPath.row+1];
    
    //cell.textLabel.text = [number stringByAppendingString:stopName];
    //cell.textLabel.text = stopName;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    
    [[cell.contentView viewWithTag:indexPath.row+1]removeFromSuperview];
    //[cell.contentView addSubview:[toolbar CreateButton:indexPath]];
    
    // add into favorite
    //NSString * newString = [[busName componentsSeparatedByString:@"("] objectAtIndex:0];
    //[toolbar isStopAdded:newString andStop:stopName andNo:@"RouteDetail"];
    
    return cell;
}

- (void)dealloc
{
    [activityIndicator release];
    [loadingView release];
    [busName release];
    //[busId release];
    [goBack release];
    [IDs release];
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
    //[self CatchData];
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
