//
//  StationInfoViewController.m
//  MIT Mobile
//  交通功能：火車 查詢
//  Created by MacAir on 12/11/3.
//
//

#import "StationInfoViewController.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "NTOUUIConstants.h"

@interface StaionInfoTableViewController ()

@end

@implementation StaionInfoTableViewController
@synthesize dataURL;
@synthesize trainNumber;
@synthesize trainStartFroms;
@synthesize trainTravelTos;
@synthesize departureTimes;
@synthesize arrivalTimes;
@synthesize dataSource;
@synthesize selectedDate;
@synthesize selectedTrainStyle;
@synthesize lineDir;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

-(void) recieveURL{
    /*dataURL = [[NSURL alloc]init];
    dataURL = [self.dataSource StationInfoURL:self];*/
   
}
-(void) recieveStartAndDepature{
    departureStation =[[NSString alloc]initWithString:[self.dataSource startStationTitile:self]];
    arrivalStation =[[NSString alloc]initWithString:[self.dataSource depatureStationTitile:self]];
    [departureStation retain];
    [arrivalStation retain];
}
-(void)recieveData{
    NSLog(@"stationInfo.m recieveData");
    //[self recieveURL];
    //[self fetchData];
    if (![[dataURL absoluteString] isEqualToString:@""]){
        [self recieveStartAndDepature];
        [self fetchData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [downloadView AlertViewEnd];
        });
    }
    
}

-(void)fetchData
{
    NSLog(@"StationInfo.m fetchData");
    downloadView = [DownloadingView new];
    dispatch_async(dispatch_get_main_queue(), ^{
        [downloadView AlertViewStart];
    });
    
    /*StartAndTerminalstops = [NSMutableArray new];
    depatureTimes = [NSMutableArray new];
    arrivalTimes = [NSMutableArray new];
    trainStyle = [NSMutableArray new];*/
    
    if(arrivalTimes)
    {
        [arrivalTimes removeAllObjects];
        [trainStyle removeAllObjects];
        [departureTimes removeAllObjects];
        [trainNumber removeAllObjects];
        [trainStartFroms removeAllObjects];
        [trainTravelTos removeAllObjects];
    }
    
    [arrivalTimes addObject:@""];
    [trainStyle addObject:@""];
    [departureTimes addObject:@""];
    [trainNumber addObject:@""];
    [trainStartFroms addObject:@""];
    [trainTravelTos addObject:@""];
    
    NSLog(@"departureStation:%@", departureStation);
    NSLog(@"arrivalStation:%@", arrivalStation);
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"stationNumber" ofType:@"plist"];
    NSDictionary* rootDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    //NSLog(@"rootDictionary: %@",rootDictionary);
    
    NSString * startId = [rootDictionary valueForKey:departureStation];
    //NSLog(@"startId = %@", startId);
    NSString * endId = [rootDictionary valueForKey:arrivalStation];

    if(![startId isEqualToString:endId])//排除火車同起訖站
    {
    
    
        /* 處理傳入 server 的資料 */
        /*NSString * startId = [[NSString alloc]init];
        startId = [startId stringByAppendingFormat:@"%@",[self convertStation_NameToCode:[station indexOfObject:startStation]]];*/
        
        //NSString * endId = [[NSString alloc]init];
        //endId = [endId stringByAppendingFormat:@"%@",[self convertStation_NameToCode:[station indexOfObject:depatureStation]] ];
        
        // NSDate -> NSString
        /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        NSString *strDate = [dateFormatter stringFromDate:selectedDate];*/
        
        /*NSString * time = [[NSString alloc]init];
        time = [time stringByAppendingFormat:@"%@",[[selectedHTTime componentsSeparatedByString:@":"] objectAtIndex:0]];
        time = [time stringByAppendingFormat:@"%@",[[selectedHTTime componentsSeparatedByString:@":"] objectAtIndex:1]];*/
        
        //NSString *strURL = [NSString stringWithFormat:@"http://140.121.91.62/StationInfo.php?startId=%@&endId=%@&date=%@&car=%@", @"1001", @"1008", @"20140319", @"0000"];
        
        /* 判斷順逆行 */
        NSMutableDictionary * startLineNums = [[NSMutableDictionary alloc] init];
        NSArray * lineName = [[NSArray alloc] initWithObjects:@"westMountain", @"westSea", @"south", @"east", @"neiwan", @"pingtung", @"ilan", @"taitung", @"pingxi", @"jiji", @"shalun", @"shenao", @"north", nil];
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ntou_mobile3.db"];
        NSLog(@"defaultDBPath=%@", defaultDBPath);
        FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
        if (![db open])
            NSLog(@"Could not open db.");
        else
            NSLog(@"Open db successly.");
        
            //NSLog(@"[%d]:%@", i, [searchArray objectAtIndex:i]);
            NSMutableString *query = [NSMutableString stringWithString:@"SELECT * FROM trainlinedirinfo WHERE stationId = '"];
            [query appendString:startId];
            [query appendString:@"'"];
            //NSLog(@"query=%@", query);
            FMResultSet *rs = [db executeQuery:query];
        for(int i=0; i < [lineName count] && [rs next]; ++i)
            {
                    [startLineNums setObject:[rs stringForColumn:[lineName objectAtIndex:i]] forKey:[lineName objectAtIndex:i]];
            }
            [rs close];
        
        lineDir = @"1";
        int check = 0;
        
        NSMutableString *query2 = [NSMutableString stringWithString:@"SELECT * FROM trainlinedirinfo WHERE stationId = '"];
        [query2 appendString:endId];
        [query2 appendString:@"'"];
        //NSLog(@"query=%@", query);
        FMResultSet *rs2 = [db executeQuery:query2];
        for(int i=0; i < [lineName count] && [rs2 next]; ++i)//while ([rs2 next])
        {
            {
                if([rs2 stringForColumn:[lineName objectAtIndex:i]])
                {
                    NSLog(@"xxx1:%d", [[startLineNums valueForKey:[lineName objectAtIndex:i]] intValue]);
                    if([[startLineNums valueForKey:[lineName objectAtIndex:i]] intValue] > [[rs2 stringForColumn:[lineName objectAtIndex:i]] intValue])
                    {
                        NSLog(@"xxx2:%d", [[rs2 stringForColumn:[lineName objectAtIndex:i]] intValue]);
                        lineDir = @"0";
                        check = 1;
                        break;
                        
                    }
                }
                check = 0;
            }
            if(check)
                break;
            
        }
        [rs2 close];
        /* 結束判斷順逆行 */
        
        //NSLog(@"lineDir = %@", lineDir);
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/StationInfo.php?startId=%@&endId=%@&date=%@&car=%@&lineDir=%@", startId, endId, selectedDate, selectedTrainStyle, lineDir]];
        // 逆時針:1
        NSLog(@"url=%@", url);
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        NSError *error;
        //確定data有資料，以防閃退
        if(data)
        {
            NSMutableDictionary  *trainInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
            
            //NSLog(@"trainInfo = %@",trainInfo);
            
            NSArray * responseArr = trainInfo[@"trainInfo"];
            
            //NSLog(@"responseArr=%@", responseArr);
            
            if (responseArr != [NSNull null])
            {
                NSLog(@"In responseArr");
                for(NSDictionary * dict in responseArr)
                {
                    [arrivalTimes addObject:[dict valueForKey:@"arriveTime"]];
                    [trainStyle addObject:[dict valueForKey:@"carClass"]];
                    [departureTimes addObject:[dict valueForKey:@"departureTime"]];
                    [trainNumber addObject:[dict valueForKey:@"trainNumber"]];
                    [trainStartFroms addObject:[dict valueForKey:@"trainStartFrom"]];
                    [trainTravelTos addObject:[dict valueForKey:@"trainTravelTo"]];
                }
            }
        }
    }
    
    //NSLog(@"fetch, depatureTimes = %@, arrivalTimes = %@, trainStyle = %@", depatureTimes, arrivalTimes, trainStyle);
    [arrivalTimes retain];
    [trainStyle retain];
    [departureTimes retain];
    [trainNumber retain];
    [trainStartFroms retain];
    [trainTravelTos retain];
}

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
    [super viewDidLoad];
    [self.tableView reloadData];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    
    trainNumber = [NSMutableArray new];
    departureTimes = [NSMutableArray new];
    arrivalTimes = [NSMutableArray new];
    trainStyle = [NSMutableArray new];
    trainStartFroms = [NSMutableArray new];
    trainTravelTos = [NSMutableArray new];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    /*return [StartAndTerminalstops count]>=8 || [StartAndTerminalstops count]==0 ?
    [StartAndTerminalstops count]+2 : [StartAndTerminalstops count]+1;*/
    NSLog(@"count:%d", [departureTimes count]);
    return [departureTimes count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return tableView.rowHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier;
    if (!departureStation)
        CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    else 
        CellIdentifier = [NSString stringWithFormat:@"Cell%d%d%@+%@",indexPath.section,indexPath.row,departureStation,arrivalTimes];
    
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    if (![self hasWifi]){
        cell.textLabel.text = [NSString stringWithFormat:@"無法連線，請檢查網路"];
    }
    else if([trainNumber count] == 1)
    {
        cell.textLabel.text = @"查無資料！";
    }
    else
    {
        if (indexPath.row == 0 )
        {
            if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"           車種     車次"];
            }
            else
            {
                cell.textLabel.text = [NSString stringWithFormat:@"       車種          車次"];
            }
            cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
            cell.detailTextLabel.textColor = [UIColor brownColor];
            cell.textLabel.textColor = [UIColor brownColor];
            UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(187, 15.5, 60, 15)] autorelease];
            label.backgroundColor = [UIColor clearColor];
            label.lineBreakMode = UILineBreakModeWordWrap;
            label.numberOfLines = 0;
            label.tag=25;
            label.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
            label.textColor = CELL_STANDARD_FONT_COLOR;
            label.text = departureStation;
            label.textAlignment = UITextAlignmentCenter;
            UILabel* detailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(255, 15.5, 60, 15)] autorelease];
            detailLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
            detailLabel.backgroundColor = [UIColor clearColor];
            detailLabel.tag=30;
            detailLabel.textColor = CELL_STANDARD_FONT_COLOR;
            detailLabel.backgroundColor = [UIColor clearColor];
            detailLabel.text = arrivalStation;
            detailLabel.textAlignment = UITextAlignmentCenter;
            [cell.contentView removeAllSubviews];
            [cell.contentView addSubview:label];
            [cell.contentView addSubview:detailLabel];
        }
        else
        {
            NSString *textString = [NSString alloc];
            NSString *detailString = [NSString alloc];
            
            if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
            {
                textString = [NSString stringWithFormat:@"%@     %@", [trainStyle objectAtIndex:indexPath.row], [trainNumber objectAtIndex:indexPath.row]];
                detailString = [NSString stringWithFormat:@"%@     %@", [departureTimes objectAtIndex:indexPath.row],[arrivalTimes objectAtIndex:indexPath.row] ] ;
            }
            else
            {
                textString = [NSString stringWithFormat:@"%@         %@", [trainStyle objectAtIndex:indexPath.row], [trainNumber objectAtIndex:indexPath.row]];
                detailString = [NSString stringWithFormat:@"%@      %@", [departureTimes objectAtIndex:indexPath.row],[arrivalTimes objectAtIndex:indexPath.row] ] ;
            }
            
            if ([@"[1131]*[1132]*[1120]*[1130]" rangeOfString:[trainStyle objectAtIndex:indexPath.row]].location != NSNotFound)   //區間車、區間快、復興、電車
                cell.imageView.image = [UIImage imageNamed:@"local_train.png"];
            if ([@"[1100]*[1101]*[1102]*[1107]" rangeOfString:[trainStyle objectAtIndex:indexPath.row]].location != NSNotFound)   //自強號
                cell.imageView.image = [UIImage imageNamed:@"speed_train.png"];
            if ([@"[1110]" rangeOfString:[trainStyle objectAtIndex:indexPath.row]].location != NSNotFound)   //莒光號
                cell.imageView.image = [UIImage imageNamed:@"gigoung_train.png"];
            
            cell.textLabel.text = textString;
            cell.detailTextLabel.text = detailString;
            cell.detailTextLabel.textColor = [UIColor blueColor];
            //NSLog(@"textString: %@, detailString: %@", textString, detailString);
        }

    }
    
    return cell;
}

/*- (void)dealloc
{
    [dataURL release];
    [trainNumber release];
    [trainStartFroms release];
    [trainTravelTos release];
    [departureTimes release];
    [arrivalTimes release];
    [trainStyle release];
    [arrivalStation release];
    [departureStation release];
    [downloadView release];
    [super dealloc];
}*/


/*-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cell.backgroundColor = [UIColor grayColor];
}*/
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

