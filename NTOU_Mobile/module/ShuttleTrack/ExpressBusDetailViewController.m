//
//  ExpressBusDetailViewController.m
//  NTOU_Mobile
//  交通功能：客運 站牌及到站資訊
//  Created by iMac on 14/4/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "ExpressBusDetail2ViewController.h"
#import "FMDatabase.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#define kRefreshInterval 20

@interface ExpressBusDetail2ViewController ()

@end

@implementation ExpressBusDetail2ViewController

@synthesize completeRouteName;
@synthesize stops;
@synthesize times;
@synthesize label;
@synthesize labelsize;
@synthesize departureTimeTableView;

@synthesize success;
@synthesize lastRefresh;
@synthesize refreshTimer;
//@synthesize activityIndicator;
@synthesize loadingView;
@synthesize preArray;

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
    NSLog(@"[Detail]CatchData");
    ISREAL = TRUE;
    [loadingView show];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self estimateTime];
        
        [loadingView dismissWithClickedButtonIndex:0 animated:YES];
        //[activityIndicator stopAnimating];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
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
    [routeId retain];
    [completeRouteName retain];
    NSLog(@"completeRouteName = %@", completeRouteName);
    ISREAL = FALSE;
}

- (void)estimateTime
{
    ISREAL = TRUE;
    if(stops)
    {
        [stops removeAllObjects];
        [times removeAllObjects];
    }
    NSString *encodedBus = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[routeId stringByAppendingString: completeRouteName], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/ExpressBusTime_web.php?bus=%@", encodedBus]];
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    if (data)
    {
        NSError *error;
        
        NSMutableDictionary  *stationInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
        if([stationInfo[@"stationInfo"]  isKindOfClass:[NSNull class]])
        {
            [stops addObject:@"更新中，暫無資料"];
            [times addObject:@"請稍候再試"];
        }
        else
        {
            NSArray * responseArr = stationInfo[@"stationInfo"];
            for(NSDictionary * dict in responseArr)
            {
                [stops addObject:[dict valueForKey:@"name"]];
                [times addObject:[dict valueForKey:@"time"]];
            }
        }
        [stops retain];
        [times retain];
        [self.tableView reloadData];
        /*for (UIView* view in self.view.subviews) {
            
            if([view isKindOfClass:[UIAlertView class]])
                [view dismissWithClickedButtonIndex:0 animated:YES];
        }
        [activityIndicator stopAnimating];*/
    }
}

-(void) alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"willDismissWithButtonIndex");
    
    if (buttonIndex == 0)
    {
        //cancel clicked ...do your action
        NSLog(@"cancel");    }
    else
    {
        NSLog(@"hi");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"alertClicked");
    
    if (buttonIndex == 0)
    {
        //cancel clicked ...do your action
        NSLog(@"cancel");
        
        //[alertView dismissWithClickedButtonIndex:0 animated:YES];
        //[self.activityIndicator stopAnimating];
        [self.navigationController popViewControllerAnimated:YES];//直接回客運列表
        /*
        if(stops)
        {
            [stops removeAllObjects];
            [times removeAllObjects];
        }
        [stops addObject:@"更新中，暫無資料"];
        [times addObject:@"請稍候再試"];
        [stops retain];
        [times retain];
        [self.tableView reloadData];
        */
    }
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

/*
-(void)alertViewEnd
{
    for (UIView* view in self.view.subviews) {
        
        if([view isKindOfClass:[UIAlertView class]])
            [view dismissWithClickedButtonIndex:1 animated:YES];
    }
    [activityIndicator stopAnimating];
}*/

-(bool)hasWifi{
    //Create zero addy
    struct sockaddr_in Addr;
    bzero(&Addr, sizeof(Addr));
    Addr.sin_len = sizeof(Addr);
    Addr.sin_family = AF_INET;
    
    //結果存至旗標中
    SCNetworkReachabilityRef target = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *) &Addr);
    SCNetworkReachabilityFlags flags;
    SCNetworkReachabilityGetFlags(target, &flags);
    
    
    //將取得結果與狀態旗標位元做AND的運算並輸出
    if (flags & kSCNetworkFlagsReachable)  return true;
    else return false;
}


- (void)viewDidLoad
{
    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.parentViewController.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    preArray = [[NSArray alloc] initWithObjects:nil];
    loadingView = [[UIAlertView alloc] initWithTitle:nil message:@"下載資料中\n請稍候\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    loadingView.frame = CGRectMake(0, 0, 200, 200);
    /*
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        activityIndicator.frame = CGRectMake(135.0, 260.0, 50.0, 50.0);
        activityIndicator.color = [UIColor blackColor];
    }
    else
        activityIndicator.frame = CGRectMake(115.0, 60.0, 50.0, 50.0);
    
    [self.loadingView addSubview:self.activityIndicator];
    [self.tableView addSubview:self.loadingView];
    [activityIndicator startAnimating];
    */
    [self.loadingView show];
    //[self.loadingView release];
    /*
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"下載資料中\n請稍候\n" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil];
    alert.frame = CGRectMake(0, 0, 200, 200);
     */
    /*
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        activityIndicator.frame = CGRectMake(135.0, 260.0, 50.0, 50.0);
        activityIndicator.color = [UIColor blackColor];
    }
    else
        activityIndicator.frame = CGRectMake(115.0, 60.0, 50.0, 50.0);
    
    [alert addSubview:activityIndicator];
    //[self.tableView addSubview:alert];
    [activityIndicator startAnimating];
    */
    //[self.view addSubview:alert];
    //[alert show];
    //[alert release];
    
    stops = [[NSMutableArray alloc] init];
    times = [[NSMutableArray alloc] init];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    [self startTimer];
    departureTimeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:UITableViewStyleGrouped];
    //departureTimeTableView.delegate = self;
    //departureTimeTableView.dataSource = self;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,0,0)];
    label.text = [NSString stringWithFormat:@"%@\n%@",routeId,completeRouteName];
    NSLog(label.text);
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    
    //設置自動行數與字符換行
    [label setNumberOfLines:0];
    label.lineBreakMode = NSLineBreakByWordWrapping;
    UIFont *font = [UIFont fontWithName:@"Arial" size:16];
    
    //設置寬、高上限
    CGSize size = CGSizeMake(screenWidth-40, screenHeight);
    //計算實際 frame 大小，並將 label 的 frame 變成實際大小
    labelsize = [label.text sizeWithFont:font constrainedToSize:size
                                         lineBreakMode:NSLineBreakByWordWrapping];
    [label setFrame:CGRectMake(20, 70, screenWidth-40, labelsize.height)];
    [label setFont:[UIFont fontWithName:@"Arial" size:14]];
    [self.parentViewController.view addSubview:label];
    
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.label removeFromSuperview];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [self stopTimer];
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    /*[activityIndicator stopAnimating];
    [loadingView dismissWithClickedButtonIndex:0 animated:YES];*/
    NSLog(@"viewDidAppear");
    [super viewDidAppear:animated];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        [self.tableView setFrame:CGRectMake(0,labelsize.height+40, screenWidth, screenHeight-labelsize.height-50)];
    else
        [self.tableView setFrame:CGRectMake(0,labelsize.height, screenWidth, screenHeight-labelsize.height-50)];
    
    if (!ISREAL)
    {
        NSLog(@"!ISREAL");
    }
    else
    {/*
        for (UIView* view in self.tableView.subviews) {
            
            if([view isKindOfClass:[UIAlertView class]])
                [view dismissWithClickedButtonIndex:1 animated:YES];
        }*/
        //[activityIndicator stopAnimating];
    }
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
    if (![self hasWifi])
        return 1;
    else if (ISREAL)
        return [stops count];
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
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    rowHeight = labelSize.height + 20.0f;
    
    return rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:14];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    if (![self hasWifi]){
        cell.textLabel.text = [NSString stringWithFormat:@"無法連線，請檢查網路"];
    }
    else if (ISREAL)
    {
        cell.textLabel.text = [stops objectAtIndex:indexPath.row];
        if([stops count] == 1)
        {
            cell.textLabel.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
            cell.detailTextLabel.text = [times objectAtIndex:indexPath.row];
            cell.detailTextLabel.textColor = [UIColor grayColor];
        }
        else
        {
            if([[times objectAtIndex:indexPath.row] rangeOfString:@"未發車"].location != NSNotFound)
            {
                cell.detailTextLabel.text = [[times objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(0, 3)];
                cell.detailTextLabel.textColor = [UIColor grayColor];
            }
            else if([[times objectAtIndex:indexPath.row] rangeOfString:@"分"].location != NSNotFound)
            {
                NSUInteger len = [[times objectAtIndex:indexPath.row] rangeOfString:@"分"].location+1;
                cell.detailTextLabel.text = [[times objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(0, len)];
                cell.detailTextLabel.textColor = [UIColor colorWithRed:81.0/255.0 green:102.0/255.0 blue:145.0/255.0 alpha:1.0];
            }
            else if([[times objectAtIndex:indexPath.row] rangeOfString:@"站"].location != NSNotFound)
            {
                NSUInteger pos1 = [[times objectAtIndex:indexPath.row] rangeOfString:@"將"].location;
                NSUInteger pos2 = [[times objectAtIndex:indexPath.row] rangeOfString:@"站"].location;
                cell.detailTextLabel.text = [[times objectAtIndex:indexPath.row] substringWithRange:NSMakeRange(pos1, pos2-pos1+1)];
                cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed:188.0/255.0 green:2.0/255.0 blue:9.0/255.0 alpha:100.0];
            }
        }
    }
    else
    {
        cell.textLabel.text = [preArray objectAtIndex:indexPath.row];
    }
    return cell;
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
            if (secs > 20)//20秒刷新一次
            {
                [self stopTimer];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self CatchData];
                });
                [self startTimer];
            }
            self.navigationItem.title=[NSString stringWithFormat:@"距離上次更新%d秒",secs];
            //NSLog(@"距離上次更新%d秒", secs);
        }
    }
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
