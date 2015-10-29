//
//  RouteDetailViewController.m
//  bus
//  交通功能：海洋專車：市區公車站牌列表-所經公車路線到站資訊
//  Created by mac_hero on 12/5/18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RouteDetailViewController.h"
#import "UIKit+NTOUAdditions.h"
#define kPlainId				@"Plain"
#define kRefreshInterval 60



@implementation RouteDetailViewController
@synthesize routeNames;
@synthesize waitTimes;
@synthesize waitTime;
@synthesize waitTime1_103;
@synthesize waitTime2_103;
@synthesize waitTime1_104;
@synthesize waitTime2_104;
@synthesize waitTime1_108;
@synthesize waitTime2_108;
@synthesize station_waitTime1_103;
@synthesize station_waitTime1_104;
@synthesize station_waitTime2_103;
@synthesize station_waitTime2_104;
@synthesize anotherButton;
@synthesize refreshTimer;
@synthesize lastRefresh;
@synthesize receivedData;
@synthesize theConncetion;
@synthesize queue;
- (void) getURL:(NSString* ) inputURL
{
   
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self.tableView applyStandardColors];
        // Custom initialization
    }
    theConncetionCount = 0;
    updateTimeOnButton = NO;
    waitTimes=[[NSMutableArray alloc]init];
    routeNames=[[NSMutableArray alloc]init];
    queue = [[NSOperationQueue alloc] init];
    waitTime = [NSMutableArray new];
    return self;
}

-(void) addRoutesURL:(NSString *)_103First and:(NSString *)_103Second and:(NSString *)_104First and:(NSString *)_104Second and: (NSString *)_108First and: (NSString *)_108Second;{
    if (_103First){
        waitTime1_103 = [[NSURL alloc ]initWithString:_103First];
        [waitTime  addObject:waitTime1_103 ];
    }
    if (_103Second){
        waitTime2_103 = [[NSURL alloc ]initWithString:_103Second];
        [ waitTime  addObject:waitTime2_103 ];
    }
    if (_104First){
        waitTime1_104 = [[NSURL alloc ]initWithString:_104First];
        [ waitTime  addObject:waitTime1_104 ];
    }
    if (_104Second){
        waitTime2_104 = [[NSURL alloc ]initWithString:_104Second];
        [ waitTime  addObject:waitTime2_104 ];
    }
    
    if (_108First){
        waitTime1_108 = [[NSURL alloc ]initWithString:_108First];
        [ waitTime  addObject:waitTime1_108 ];
    }
    if (_108Second){
        waitTime2_108 = [[NSURL alloc ]initWithString:_108Second];
        [ waitTime  addObject:waitTime2_108 ];
    }
}
-(void) addStationURL:(NSString *)_103First and:(NSString *)_103Second and:(NSString *)_104First and:(NSString *)_104Second{
    station_waitTime1_103 = [[NSURL alloc]initWithString:_103First];
    station_waitTime2_103 = [[NSURL alloc]initWithString:_103Second];
    station_waitTime1_104 = [[NSURL alloc]initWithString:_104First];
    station_waitTime2_104 = [[NSURL alloc]initWithString:_104Second];
    [waitTime addObject:station_waitTime1_103];
    [waitTime addObject:station_waitTime2_103];
    [waitTime addObject:station_waitTime1_104];
    [waitTime addObject:station_waitTime2_104];
}

-(void)goBackMode:(BOOL)go{
       dir = go;
} 
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


-(void)CatchData{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [routeNames removeAllObjects];
        [waitTimes removeAllObjects];
        for(int i=0;i<6;++i){
            NSURL *url=[waitTime objectAtIndex:i];
            //NSLog(@"url = %@", url);
            
            NSError *error;
            //NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
            NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:NULL error:&error];
            //NSLog(@"data=%@", data);
            
            //data有資料
            if (data) {
                
                NSMutableDictionary  *stationInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
                
                //NSLog(@"NTstationInfo: %@",stationInfo);
                if(![stationInfo[@"stationInfo"]  isKindOfClass:[NSNull class]]){
                    NSArray * responseArr = stationInfo[@"stationInfo"];
                    for(NSDictionary * dict in responseArr)
                    {
                        [routeNames addObject:[dict valueForKey:@"name"]];
                        [waitTimes addObject:[dict valueForKey:@"time"]];
                    }
                }
            }
            else{//data沒有資料（nil）（發生情形：沒有網路連線
                NSLog(@"error:%@\n",error);
                [routeNames addObject:@"網路異常"];
                [waitTimes addObject:@"請稍候再試"];
            }
        }
        [routeNames retain];
        [waitTimes retain];
            
        [loadingAlertView dismissWithClickedButtonIndex:0 animated:YES];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    
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


- (void)refreshPropertyList{
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
    self.anotherButton.title = @"更新中";
    updateTimeOnButton = NO;
    loadingAlertView = [[UIAlertView alloc]
                        initWithTitle:nil message:@"\n\n下載資料中\n請稍候"
                        delegate:self cancelButtonTitle:@"取消"
                        otherButtonTitles: nil];
    [self AlertStart:loadingAlertView];
    /*NSThread*thread = [[NSThread alloc]initWithTarget:self selector:@selector(AlertStart:) object:loadingAlertView];
    [thread start];
    while (true) {
        if ([thread isFinished]) {
            break;
        }
    }*/
    double interval = 1.0;
    [NSTimer scheduledTimerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(CatchData)
                                   userInfo:nil
                                    repeats:FALSE];


    //[thread release];
}

- (void)startTimer
{
    self.lastRefresh = [NSDate date];
    NSDate *oneSecondFromNow = [NSDate dateWithTimeIntervalSinceNow:0];
    self.refreshTimer = [[[NSTimer alloc] initWithFireDate:oneSecondFromNow interval:1 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES] autorelease];
    [[NSRunLoop currentRunLoop] addTimer:self.refreshTimer forMode:NSDefaultRunLoopMode];
	
}
//更新倒數
-(void) countDownAction:(NSTimer *)timer
{
    
    if (self.refreshTimer !=nil && self.refreshTimer)
	{
		NSTimeInterval sinceRefresh = [self.lastRefresh timeIntervalSinceNow];
        
        // If we detect that the app was backgrounded while this timer
        // was expiring we go around one more time - this is to enable a commuter
        // bookmark time to be processed.
        if (!updateTimeOnButton) {
            return;
        }
		else if (sinceRefresh <= -kRefreshInterval)
		{
            
            [self refreshPropertyList];
		}
        
        else
        {
            int secs = (1+kRefreshInterval+sinceRefresh);
            if (secs < 0) secs = 0;
            self.anotherButton.title = [NSString stringWithFormat:@"%d秒後更新", secs];
            
        }
	}
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex==0) {
        NSLog(@"%@",[queue operations]);
        [queue cancelAllOperations];
        queue = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)viewDidLoad
{
    loadingAlertView = [[UIAlertView alloc]
                        initWithTitle:nil message:@"\n\n下載資料中\n請稍候"                        delegate:self cancelButtonTitle:@"取消"
                        otherButtonTitles: nil];
    [self AlertStart:loadingAlertView];
    [super viewDidLoad];
    anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"更新" style:UIBarButtonItemStylePlain target:self action:@selector(refreshPropertyList)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    //[anotherButton release];
    
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *view1 = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f,0.0f - self.tableView.bounds.size.height,self.tableView.bounds.size.width,self.tableView.bounds.size.height)];
        view1.delegate = self;
        [self.tableView addSubview:view1];
        _refreshHeaderView = view1;
        [view1 release];
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}

-(void)viewDidLayoutSubviews
{
    
    [super viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    double interval = 1.0;
    [NSTimer scheduledTimerWithTimeInterval:interval
                                     target:self
                                   selector:@selector(CatchData)
                                   userInfo:nil
                                    repeats:FALSE];
    
    [self startTimer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    /*dispatch_queue_t network = dispatch_get_specific("");
    dispatch_async(network, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            dispatch_release(network);
        });
    });*/
    //dispatch_release(network);
}

-(void)stopTimer
{
	if (self.refreshTimer !=nil)
	{
		[self.refreshTimer invalidate];
		self.refreshTimer = nil;
		self.anotherButton.title = @"更新";
	}
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self stopTimer];
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)dealloc {
    [super dealloc];
}


#pragma mark - connected

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Did Receive Response %@", response);
    receivedData = [[NSMutableData alloc]init];
}
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    //NSLog(@"Did Receive Data %@", data);
    [receivedData appendData:data];
}
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    UIAlertView * AlertView;
    theConncetionCount++;
    if ([waitTime count]==theConncetionCount) {
        if (loadingAlertView) {
            [loadingAlertView dismissWithClickedButtonIndex:0 animated:NO];
            [loadingAlertView release];
            loadingAlertView = nil;
        }
        if (error) {
            AlertView = [[UIAlertView alloc] initWithTitle:nil message:@"無法連接伺服器\n或無網路連線"
                                                  delegate:nil cancelButtonTitle:@"確定"
                                         otherButtonTitles: nil];
            [AlertView show];
        }
        else{
            AlertView = [[UIAlertView alloc] initWithTitle:nil message:@"無法連接伺服器\n或無網路連線"
                                                  delegate:nil cancelButtonTitle:@"確定"
                                         otherButtonTitles: nil];
            [AlertView show];
        }
        self.lastRefresh = [NSDate date];
        theConncetionCount=0;
        updateTimeOnButton = YES;
    }
    NSLog(@"Did Fail");
}

- (void)isZhongzheng:(BOOL)is
{
    isZhongzheng = is;
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
    return [routeNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kPlainId];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kPlainId] autorelease];
    }
    
    // Set up the cell
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text =[waitTimes objectAtIndex:indexPath.row];
    
    cell.backgroundColor = SECONDARY_GROUP_BACKGROUND_COLOR;
	
	cell.textLabel.font = [UIFont fontWithName:BOLD_FONT size:CELL_STANDARD_FONT_SIZE];
	cell.textLabel.textColor = CELL_STANDARD_FONT_COLOR;
	cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [routeNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
    if ([cell.detailTextLabel.text isEqualToString:@"即將進站..."]) {
        cell.detailTextLabel.textColor = [UIColor redColor];
    }
    else if ([cell.detailTextLabel.text isEqualToString:@"目前無公車即時資料"]) {
        cell.detailTextLabel.textColor = [UIColor grayColor];
    }
    else{
        cell.detailTextLabel.textColor = [UIColor colorWithRed:35.0/255 green:192.0/255 blue:46/255 alpha:1];
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
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
    }
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
