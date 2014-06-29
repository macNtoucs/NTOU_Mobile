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
@synthesize stops, m_waitTimeResult;

//@synthesize toolbar;
@synthesize anotherButton;
@synthesize success;
@synthesize lastRefresh;
@synthesize refreshTimer;
@synthesize preArray;
@synthesize activityIndicator, loadingView;
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
        [m_waitTimeResult removeAllObjects];
    }
    NSString *encodedBus = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)busName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    //NSLog(@"url = %@", url);
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/KLRouteDetail_web.php?bus=%@", encodedBus]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    //NSLog(@"data=%@", data);
    NSError *error;
    
    NSMutableDictionary  *stationInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    
    //NSLog(@"NTstationInfo: %@",stationInfo);
    
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
    /*
    [stops addObject:@"更新中，暫無資料"];
    [m_waitTimeResult addObject:@"請稍候再試"];*/
    
    [stops retain];
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

#pragma mark - View lifecycle

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertClicked");
    
    if (buttonIndex == 0)
    {
        //cancel clicked ...do your action
        NSLog(@"cancel");
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        [activityIndicator stopAnimating];
        
        if(stops)
        {
            [stops removeAllObjects];
            [m_waitTimeResult removeAllObjects];
        }
        [stops addObject:@"更新中，暫無資料"];
        [m_waitTimeResult addObject:@"請稍候再試"];
        [stops retain];
        [m_waitTimeResult retain];
        [self.tableView reloadData];
        
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self startTimer];
    preArray = [[NSArray alloc] initWithObjects:nil];
    /*secondsLabel = [[UILabel alloc] initWithFrame:CGRectMake(320/2-200/2, 4, 200, 30)];
    secondsLabel.backgroundColor = [UIColor clearColor];
    secondsLabel.textColor = [UIColor grayColor];
    secondsLabel.text = @"距離上次更新0秒";
    secondsLabel.font = [UIFont systemFontOfSize:15.0];
    secondsLabel.textAlignment = NSTextAlignmentCenter;*/
    m_waitTimeResult = [NSMutableArray new];
    stops = [NSMutableArray new];
    
    loadingView =  [[UIAlertView alloc] initWithTitle:nil message:@"下載資料中\n請稍候" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
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
    
    m_waitTimeResult = [NSMutableArray new];
    stops = [NSMutableArray new];
    
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
        
        /*for (UIView* view in self.tableView.subviews) {
            
            if([view isKindOfClass:[UIAlertView class]])
                [view dismissWithClickedButtonIndex:0 animated:YES];
        }
        [activityIndicator stopAnimating];*/
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self CatchData];
                });
                [self startTimer];
            }
            //NSLog(@"距離上次更新%d秒", secs);
        }
	}
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

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    
    cellText = @"A"; // just something to guarantee one line
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    //rowHeight = labelSize.height + 20.0f;
    //rowHeight = labelSize.height + 25.0f;
    rowHeight = 44.0f;
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    
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
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:188.0/255.0 green:2.0/255.0 blue:9.0/255.0 alpha:100.0];
            }
            else if([comeTime isEqualToString:@"目前無公車即時資料"])
            {
                cell.detailTextLabel.text = @"現在無班車";
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:127.0/255.0 green:127.0/255.0 blue:127.0/255.0 alpha:100.0];
            }
            else
            {
                NSRange pos1 = [comeTime rangeOfString:@"約"];
                NSRange pos2 = [comeTime rangeOfString:@"鐘"];
                cell.detailTextLabel.text = [comeTime substringWithRange:NSMakeRange(pos1.location+1, pos2.location-1)];
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
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15.0];
    
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
