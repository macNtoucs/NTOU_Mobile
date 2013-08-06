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
    
    // 抓取系統時間
    NSDateFormatter *formatterB = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    NSString * dateStringB = [[NSString alloc] init];
    
    //正規化的格式設定
    [formatterB setDateStyle:NSDateFormatterMediumStyle];
    [formatterB setTimeStyle:NSDateFormatterShortStyle];
    [formatterB setDateFormat:@"mm:ss.SSS"];
    
    //正規化取得的系統時間並顯示
    dateStringB = [formatterB stringFromDate:date];
    
    // declare mm, ss, SS
    NSArray * characterArrayB = [[NSArray alloc] init];
    NSString * mmB = [[NSString alloc] init];
    NSString * ssB = [[NSString alloc] init];
    NSString * SSB = [[NSString alloc] init];
    
    //get time token
    characterArrayB = [dateStringB componentsSeparatedByString:@":"];
    mmB = [characterArrayB objectAtIndex:0];
    characterArrayB = [[characterArrayB objectAtIndex:1] componentsSeparatedByString:@"."];
    ssB = [characterArrayB objectAtIndex:0];
    SSB = [characterArrayB objectAtIndex:1];
    NSInteger mmIntegerB = [mmB integerValue];
    NSInteger ssIntegerB = [ssB integerValue];
    NSInteger SSIntegerB = [SSB integerValue];
    [formatterB release];
    
    // parsing html
    NSString * string = [NSString stringWithFormat:@"http://e-bus.ntpc.gov.tw/pda/online.php?rid=%@", strResult];
    NSURL * nsurl = [[NSURL alloc] initWithString:string];
     
    NSData * htmlData = [[NSData alloc] initWithContentsOfURL:nsurl];
    xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
    NSArray * elements = [xpathParser searchWithXPathQuery:@"//td"];
    NSInteger arrayLength = [elements count];
    
    TFHppleElement * element;
    NSString * tdContent;
    
    //NSLog(@"TEST = %@", [[elements objectAtIndex:80] children]);
    for (int i = 0; i < arrayLength; i ++)
    {
        if ([[[elements objectAtIndex:i] children] count] > 0)
        {
            element = [[[elements objectAtIndex:i] children] objectAtIndex:0];
            tdContent = [element content];
            if ([goBack isEqual:@"0"])
            {
                if (i % 4 == 0)
                    [stops addObject:tdContent];
                else if (i % 4 == 1)
                         [m_waitTimeResult addObject:tdContent];
            }
            else
            {
                if (i % 4 == 2)
                    [stops addObject:tdContent];
                else if (i % 4 == 3)
                    [m_waitTimeResult addObject:tdContent];
            }
        }
    }
    NSDateFormatter *formatterE = [[NSDateFormatter alloc] init];
    NSDate *dateE = [NSDate date];
    NSString * dateStringE = [[NSString alloc] init];
    
    [formatterE setDateStyle:NSDateFormatterMediumStyle];
    [formatterE setTimeStyle:NSDateFormatterShortStyle];
    [formatterE setDateFormat:@"mm:ss.SSS"];
    
    dateStringE = [formatterE stringFromDate:dateE];
    
    // declare mm, ss, SS
    NSArray * characterArrayE = [[NSArray alloc] init];
    NSString * mmE = [[NSString alloc] init];
    NSString * ssE = [[NSString alloc] init];
    NSString * SSE = [[NSString alloc] init];
    
    // get time token
    characterArrayE = [dateStringE componentsSeparatedByString:@":"];
    mmE = [characterArrayE objectAtIndex:0];
    characterArrayE = [[characterArrayE objectAtIndex:1] componentsSeparatedByString:@"."];
    ssE = [characterArrayE objectAtIndex:0];
    SSE = [characterArrayE objectAtIndex:1];
    NSInteger mmIntegerE = [mmE integerValue];
    NSInteger ssIntegerE = [ssE integerValue];
    NSInteger SSIntegerE = [SSE integerValue];
    
    NSInteger timeForCatchI = abs(mmIntegerE-mmIntegerB)*60*1000 + abs(ssIntegerE-ssIntegerB)*1000 + abs(SSIntegerE-SSIntegerB);
    NSString * timeForCatchS = [[NSString alloc] initWithFormat:@"公車路線:%@ 去回程:%@ 時間:%d(ms)", busName, goBack, timeForCatchI];
    [formatterE release];
    
    // ------------ 寫入plist ------------
    // 取得檔案路徑
    /*NSMutableArray * catchTimeArray = [[NSMutableArray alloc] init];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingString:@"/Property List.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *plistDict;
    if ([fileManager fileExistsAtPath: filePath]) // 檢查檔案是否存在
        plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
    else
        plistDict = [[NSMutableDictionary alloc] init];
    
    if ([plistDict objectForKey:@"CatchTime"])
        catchTimeArray = [plistDict objectForKey:@"CatchTime"];
    
    [catchTimeArray addObject:timeForCatchS];
    [plistDict setValue:catchTimeArray forKey:@"CatchTime"];
    
    // 存檔
    if ([plistDict writeToFile:filePath atomically: YES])
    {
        NSLog(@"writePlist success");
    }
    else
    {
        NSLog(@"writePlist fail");
    }
    [plistDict release];*/
    // ------------ 寫入完成 ------------
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //IDs = [NSMutableArray new];
    m_waitTimeResult = [NSMutableArray new];
    stops = [NSMutableArray new];
    
    // Refresh button & toolbar
    //toolbar = [[ToolBarController alloc]init];
    //[self.navigationController.view addSubview:[toolbar CreatTabBarWithNoFavorite:NO delegate:self] ];
    anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPropertyList)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    // 手動下拉更新
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,5.0f - self.tableView.bounds.size.height,self.tableView.bounds.size.width,self.tableView.bounds.size.height)];
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
    [self startTimer];
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
    
    return [stops count] + 1;   // for can't see cell
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * CellIdentifier = [NSString stringWithFormat:@"Cell%d%d", [indexPath section], [indexPath row]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
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
        else if ([comeTime isEqual:@"約1分鐘"])
        {
            cell.detailTextLabel.text = comeTime;
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
        else
        {
            cell.detailTextLabel.text = comeTime;
            cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:0.0 green:45.0/255.0 blue:153.0/255.0 alpha:100.0];
        }
    }
        
    
    NSString * number = [[NSString alloc] initWithFormat:@"(%i) ", indexPath.row+1];
    
    cell.textLabel.text = [number stringByAppendingString:stopName];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:15.0];
    
    [[cell.contentView viewWithTag:indexPath.row+1]removeFromSuperview];
    //[cell.contentView addSubview:[toolbar CreateButton:indexPath]];
    NSString * newString = [[busName componentsSeparatedByString:@"("] objectAtIndex:0];
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
