//
//  SecondLevelViewController.m
//  TaipeiBusSystem
//
//  Created by Ching-Chi Lin on 12/7/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TPRouteDetailViewController.h"
#define kRefreshInterval 60

@implementation TPRouteDetailViewController

@synthesize busName;
@synthesize goBack;
@synthesize depature, destination;
@synthesize stops, IDs, m_waitTimeResult;

//@synthesize toolbar;
@synthesize anotherButton;
@synthesize success;
@synthesize lastRefresh;
@synthesize refreshTimer;
@synthesize preArray;
@synthesize activityIndicator, loadingView;
@synthesize secondsLabel;

- (void) setter_busName:(NSString *)name andGoBack:(NSInteger)goback
{
    busName = name;
    goBack = [[NSString alloc] initWithFormat:@"%lu", goback];
    NSLog(@"busName:%@, goBack:%@", busName, goBack);
    ISREAL = FALSE;
}

- (void) setter_departure:(NSString *)dep andDestination:(NSString *)des
{
    depature = [[NSString alloc] initWithString:dep];
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
    NSLog(@"[TPRouteDetailView]CatchData");
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
        [IDs removeAllObjects];
        [m_waitTimeResult removeAllObjects];
    }
    
    NSString *encodedBus = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)busName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/AllRoutePhpFile.php?bus=%@&goBack=%@", encodedBus, goBack]];
    
    NSLog(@"url:%@",url);
    NSError *error;
    
    //NSData *data = [NSData dataWithContentsOfURL:url];
    //NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:NULL error:&error];
    //NSLog(@"data=%@", data);
    
    if (data)
    {
        NSMutableDictionary  *trainInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
        
        NSArray * responseArr = trainInfo[@"stationInfo"];
        
        if (![responseArr isKindOfClass:[NSNull class]]) {//排除單項路線會閃退情況
            for(NSDictionary * dict in responseArr)
            {
                [stops addObject:[dict valueForKey:@"name"]];
                [m_waitTimeResult addObject:[dict valueForKey:@"time"]];
            }
        }
        else
        {
            [stops addObject:@"無資料"];
            [m_waitTimeResult addObject:@"沒有此班車資訊"];
        }
        
    }
    else //data沒有資料（nil）（發生情形：沒有網路連線）
    {
        NSLog(@"error:%@\n",error);
        [stops addObject:@"無資料"];
        [m_waitTimeResult addObject:@"請稍候再試"];
    }
    
    [stops retain];
    [m_waitTimeResult retain];
    [self.tableView reloadData];
}

-(void)AlertStart:(UIAlertView *) loadingAlertView{
    CGRect frame;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        frame = CGRectMake(140, 80, 40, 40);
        NSLog(@"alert");
    }
    else
        frame = CGRectMake(120, 10, 40, 40);
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
            //NSLog(@"距離上次更新%d秒", secs);
        }
	}
}

- (void)changeDetailView
{
    if ([goBack isEqualToString:@"0"])
    {
        //anotherButton.title = destination;
        self.navigationItem.title = [NSString stringWithFormat:@"%@ → %@", destination, depature];
        [self setter_busName:busName andGoBack:1];
        [self stopTimer];
        [activityIndicator performSelectorInBackground:@selector(startAnimating) withObject:nil];
        [self.loadingView performSelectorInBackground:@selector(show) withObject:nil];
        [self CatchData];
        [self startTimer];
    }
    else
    {
        //anotherButton.title = depature;
        self.navigationItem.title = [NSString stringWithFormat:@"%@ → %@", depature, destination];
        [self setter_busName:busName andGoBack:0];
        [self stopTimer];
        [activityIndicator performSelectorInBackground:@selector(startAnimating) withObject:nil];
        [self.loadingView performSelectorInBackground:@selector(show) withObject:nil];
        [self CatchData];
        [self startTimer];
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"[Detail]viewDidLoad");
    [super viewDidLoad];
    [self startTimer];
    preArray = [[NSArray alloc] initWithObjects:nil];
    self.title = [NSString stringWithFormat:@"%@ → %@", depature, destination];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    /*secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(320/2-200/2, 4, 200, 30)];
    secondsLabel.backgroundColor = [UIColor clearColor];
    secondsLabel.textColor = [UIColor grayColor];
    secondsLabel.text = @"距離上次更新0秒";
    secondsLabel.font = [UIFont systemFontOfSize:15.0];
    secondsLabel.textAlignment = NSTextAlignmentCenter;*/
    
    
    //放入下載提示視窗（alert）
    loadingView =  [[UIAlertView alloc] initWithTitle:nil message:@"下載資料中\n請稍候" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    loadingView.frame = CGRectMake(0, 0, 200, 200);
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
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
    [self.tableView addSubview:self.loadingView];
    [activityIndicator startAnimating];
    [self.loadingView show];
    
    [self.tableView applyStandardColors];
    IDs = [NSMutableArray new];
    m_waitTimeResult = [NSMutableArray new];
    stops = [NSMutableArray new];
    
    anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"往返" style:UIBarButtonItemStylePlain target:self action:@selector(changeDetailView)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    // 手動下拉更新
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height,self.tableView.bounds.size.width,self.tableView.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
        [view1 release];
        [self CatchData];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    success = [[UIImageView alloc] initWithFrame:CGRectMake(75.0, 250.0, 150.0, 150.0)];
    [success setImage:[UIImage imageNamed:@"ok.png"]];
    //[self CatchData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!ISREAL)
    {
        [self CatchData];
    }
    else
    {
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
    if (ISREAL)
    {
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
            
            if ([comeTime isEqual:@"-1"])
            {
                cell.detailTextLabel.text = @"未發車";
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
            else if ([comeTime isEqual:@"-2"])
            {
                cell.detailTextLabel.text = @"交管不停靠";
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
            else if ([comeTime isEqual:@"-3"])
            {
                cell.detailTextLabel.text = @"末班車已過";
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
            else if ([comeTime isEqualToString:@"請稍候再試"])//data==nil
            {
                cell.detailTextLabel.text = @"沒有網路或資料庫異常";
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:100.0];
            }
            else if ([comeTime isEqualToString:@"沒有此班車資訊"])//responseArr is null
            {
                cell.detailTextLabel.text = @"沒有此班車資訊";
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:100.0];
            }
            else if ([comeTime isEqual:@"更新中..."])
            {
                cell.detailTextLabel.text = @"更新中";
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:13.0/255.0 green:139.0/255.0 blue:13.0/255.0 alpha:100.0];
            }
            else if ([comeTime intValue] <= 10)
            {
                cell.detailTextLabel.text = @"進站中";
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:188.0/255.0 green:2.0/255.0 blue:9.0/255.0 alpha:100.0];
            }
            else if ([comeTime intValue] > 10 && [comeTime intValue] <= 120)
            {
                cell.detailTextLabel.text = @"即將進站";
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:0.0 green:45.0/255.0 blue:153.0/255.0 alpha:100.0];
            }
            else
            {
                cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%i 分", (int)([comeTime doubleValue]/60 - 0.5)];
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
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    return cell;
}

- (void)dealloc
{
    [activityIndicator release];
    [loadingView release];
    [busName release];
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
