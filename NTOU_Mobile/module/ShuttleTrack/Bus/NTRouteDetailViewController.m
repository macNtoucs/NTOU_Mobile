//
//  SecondLevelViewController.m
//  TaipeiBusSystem
//  交通功能：公車 新北市公車站牌到站資訊
//  Created by Ching-Chi Lin on 12/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NTRouteDetailViewController.h"
#define kRefreshInterval 60

@implementation NTRouteDetailViewController

@synthesize busName;
@synthesize goBack;
@synthesize stops, IDs, m_waitTimeResult;

@synthesize anotherButton;
@synthesize success;
@synthesize lastRefresh;
@synthesize refreshTimer;
@synthesize xpathArray;
@synthesize xpathParser;
@synthesize preArray, activityIndicator, loadingView;
@synthesize secondsLabel;

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
    [self AlertStart:loadingView];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self estimateTime];
        
        [loadingView dismissWithClickedButtonIndex:0 animated:YES];
        [activityIndicator stopAnimating];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
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
    //[encodedBus release];   // Analyze MemLeak
    
    NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/NTRouteDetail_5284.php?bus=%@&goBack=%@", encodedBus, goBack]];
    

    NSError *error;
    
    //NSData *data = [NSData dataWithContentsOfURL:url];
    //NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:NULL error:&error];
    //NSLog(@"data=%@", data);
    
    if (data)
    {
        
        NSMutableDictionary  *stationInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    
        if([stationInfo[@"stationInfo"]  isKindOfClass:[NSNull class]])
        {
            [stops addObject:@"更新中，暫無資料"];
            [m_waitTimeResult addObject:@"請稍候再試"];
        }
        else
        {
            NSArray * responseArr = stationInfo[@"stationInfo"];
            for(NSDictionary * dict in responseArr)
            {
                [stops addObject:[dict valueForKey:@"name"]];
                [m_waitTimeResult addObject:[dict valueForKey:@"time"]];
            }
        }
    }
    else //data沒有資料（nil）（發生情形：沒有網路連線）
    {
        NSLog(@"error:%@\n",error);
        [stops addObject:@"無資料"];
        [m_waitTimeResult addObject:@"請稍候再試"];
    }
    
    [stops retain];
    //[IDs retain];
    [m_waitTimeResult retain];
    [self.tableView reloadData];
}


-(void)AlertStart:(UIAlertView *) loadingAlertView{
    CGRect frame = CGRectMake(120, 10, 40, 40);
    UIActivityIndicatorView* progressInd = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    progressInd.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [progressInd startAnimating];
    [loadingAlertView addSubview:progressInd];
    [loadingAlertView show];
    [progressInd release];
}

-(void)stopTimer
{
	if (self.refreshTimer !=nil)
	{
		[self.refreshTimer invalidate];
		self.refreshTimer = nil;
		//self.anotherButton.title = @"Refresh";
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
        if (updateTimeOnButton)
        {
            int secs = (1-sinceRefresh);
            if (secs > 20)
            {
                [self stopTimer];
                //[activityIndicator performSelectorInBackground:@selector(startAnimating) withObject:nil];
                //[self.loadingView performSelectorInBackground:@selector(show) withObject:nil];
                
                    [self CatchData];
            
                [self startTimer];
            }
            if ([goBack isEqualToString:@"0"])
                secondsLabel.text = [NSString stringWithFormat:@"%@ → %@\n距離上次更新%d秒", departure, destination ,secs];
            else
                secondsLabel.text = [NSString stringWithFormat:@"%@ → %@\n距離上次更新%d秒", destination, departure, secs];
            //NSLog(@"距離上次更新%d秒", secs);
        }
    }
}

- (void)changeDetailView
{
    if ([goBack isEqualToString:@"0"])
    {
        //anotherButton.title = destination;
        [self setter_busName:busName andGoBack:1];
        [self stopTimer];
        [activityIndicator performSelectorInBackground:@selector(startAnimating) withObject:nil];
        [self.loadingView performSelectorInBackground:@selector(show) withObject:nil];
        [self CatchData];
        [self startTimer];
    }
    else
    {
        //anotherButton.title = departure;
        [self setter_busName:busName andGoBack:0];
        [self stopTimer];
        [activityIndicator performSelectorInBackground:@selector(startAnimating) withObject:nil];
        [self.loadingView performSelectorInBackground:@selector(show) withObject:nil];
        [self CatchData];
        [self startTimer];
    }
    
}

#pragma mark - View lifecycle


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertClicked");
    
    if (buttonIndex == 0)
    {
        //cancel clicked ...do your action
        NSLog(@"cancel");
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
        [activityIndicator stopAnimating];
        
        if(stops)
        {
            [stops removeAllObjects];
            [m_waitTimeResult removeAllObjects];
        }
        [self.navigationController popViewControllerAnimated:YES];
        /*
        [stops addObject:@"更新中，暫無資料"];
        [m_waitTimeResult addObject:@"請稍候再試"];
        [stops retain];
        [m_waitTimeResult retain];
        [self.tableView reloadData];
        */
    }
}

- (void)viewDidLoad
{
    NSLog(@"[NTDetail]viewDidLoad");
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self startTimer];
    //IDs = [NSMutableArray new];
    m_waitTimeResult = [NSMutableArray new];
    stops = [NSMutableArray new];
    secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(320/2-200/2, 4, 200, 30)];
    secondsLabel.backgroundColor = [UIColor clearColor];
    secondsLabel.font = [UIFont systemFontOfSize:10.0];
    secondsLabel.textAlignment = NSTextAlignmentCenter;
    [secondsLabel setLineBreakMode:NSLineBreakByWordWrapping];
    secondsLabel.numberOfLines=2;
    secondsLabel.text = [NSString stringWithFormat:@"%@ → %@\n距離上次更新0秒", departure, destination];
    self.navigationItem.titleView=secondsLabel;

    preArray = [[NSArray alloc] initWithObjects:nil];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    loadingView =  [[UIAlertView alloc] initWithTitle:nil message:@"下載資料中\n請稍候" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    
    /*activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        activityIndicator.frame = CGRectMake(135.0, 280.0, 50.0, 50.0);
        activityIndicator.color = [UIColor blackColor];
    }
    else
    {
        activityIndicator.frame = CGRectMake(115.0, 120.0, 50.0, 50.0);
        activityIndicator.color = [UIColor blackColor];
    }
    
    //[self.tableView addSubview:self.secondsLabel];
    [self.loadingView addSubview:self.activityIndicator];
    [activityIndicator startAnimating];
     */
    [self.tableView addSubview:self.loadingView];
    [self.loadingView show];
    anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"往返" style:UIBarButtonItemStylePlain target:self action:@selector(changeDetailView)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    // 手動下拉更新
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,0.0f - self.tableView.bounds.size.height,self.tableView.bounds.size.width,self.tableView.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
        [view1 release];
        [self CatchData];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    success = [[UIImageView alloc] initWithFrame:CGRectMake(75.0, 250.0, 150.0, 150.0)];
    [success setImage:[UIImage imageNamed:@"ok.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    NSLog(@"[NTDetail]viewDidUnload");
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"[NTDetail]viewWillAppear");
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    NSLog(@"[Detail]viewDidAppear");
    [super viewDidAppear:animated];
    if (!ISREAL)
    {
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
        return 0.01f;
    
    return 10.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (ISREAL)
        return [stops count];   // for can't see cell
    else
        return [preArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    
    cellText = @"A"; // just something to guarantee one line
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByCharWrapping];
    //rowHeight = labelSize.height + 20.0f;
    //rowHeight = labelSize.height + 25.0f;
    rowHeight = 44.0f;
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier = [NSString stringWithFormat:@"Cell%lu%lu", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
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
            
            if ([comeTime isEqual:@"未發車"])
            {
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
            /*else if ([comeTime isEqual:@"更新中..."])
             {
             cell.detailTextLabel.text = @"更新中...";
             cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:13.0/255.0 green:139.0/255.0 blue:13.0/255.0 alpha:100.0];
             }*/
            else if ([comeTime isEqual:@"進站中"])
            {
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:188.0/255.0 green:2.0/255.0 blue:9.0/255.0 alpha:100.0];
            }
            else if ([comeTime isEqualToString:@"請稍候再試"])//data==nil
            {
                cell.detailTextLabel.text = @"沒有網路或資料庫異常";
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:100.0];
            }
            /*else if ([comeTime isEqual:@"將到站"])
             {
             cell.detailTextLabel.textColor = [UIColor orangeColor];
             }*/
            else
            {
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:0.0 green:45.0/255.0 blue:153.0/255.0 alpha:100.0];
            }
        }
        cell.textLabel.text = stopName;
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.text = comeTime;
        [[cell.contentView viewWithTag:indexPath.row+1]removeFromSuperview];
    }
    else
    {
        cell.textLabel.text = [preArray objectAtIndex:indexPath.row];
        cell.textLabel.textColor = [UIColor grayColor];
    }
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    //[comeTime release]; // Analyze MemLeak
    //[stopName release]; // Analyze MemLeak
    return cell;
}

- (void)dealloc
{
    [activityIndicator release];
    [loadingView release];
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
