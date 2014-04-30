//
//  StationInfoViewController.m
//  MIT Mobile
//
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
    
    NSLog(@"departureStation:%@", departureStation);
    NSLog(@"arrivalStation:%@", arrivalStation);
    
    NSString* path = [[NSBundle mainBundle] pathForResource:@"stationNumber" ofType:@"plist"];
    NSDictionary* rootDictionary = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    //NSLog(@"rootDictionary: %@",rootDictionary);
    
    NSString * startId = [rootDictionary valueForKey:departureStation];
    //NSLog(@"startId = %@", startId);
    NSString * endId = [rootDictionary valueForKey:arrivalStation];

    
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
        while ([rs next])
        {
            NSLog(@"%@", [rs stringForColumn:@"westSea"]);
            // [searchResults addObject:[rs stringForColumn:@"shortRouteName"]];
        }
        [rs close];
    /* 結束判斷順逆行 */ 
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/StationInfo.php?startId=%@&endId=%@&date=%@&car=%@&lineDir=%@", startId, endId, selectedDate, selectedTrainStyle, @"1"]];
    // 逆時針:1
    NSLog(@"url=%@", url);
    
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSError *error;
    
    NSMutableDictionary  *trainInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
    
    //NSLog(@"trainInfo = %@",trainInfo);
    
    NSArray * responseArr = trainInfo[@"trainInfo"];
    
    for(NSDictionary * dict in responseArr)
    {
        [arrivalTimes addObject:[dict valueForKey:@"arriveTime"]];
        [trainStyle addObject:[dict valueForKey:@"carClass"]];
        [departureTimes addObject:[dict valueForKey:@"departureTime"]];
        [trainNumber addObject:[dict valueForKey:@"trainNumber"]];
        [trainStartFroms addObject:[dict valueForKey:@"trainStartFrom"]];
        [trainTravelTos addObject:[dict valueForKey:@"trainTravelTo"]];
    }
    
    /*NSLog(@"%@", StartAndTerminalstops);
    NSLog(@"%@", departureTimes);
    NSLog(@"%@", arrivalTimes);
    NSLog(@"%@", trainStyle);*/
    
    /*[StartAndTerminalstops addObject:@"基隆"];
    [StartAndTerminalstops addObject:@"台北"];*/
    
    /*NSArray * trainsAndTimes = [strResult componentsSeparatedByString:@";"];
    
    for(int i=0; i<[trainsAndTimes count]-1; i++)
    {
        NSArray * tmp = [[trainsAndTimes objectAtIndex:i] componentsSeparatedByString:@"|"];
        
        [StartAndTerminalstops addObject:[tmp objectAtIndex:0]];
        if(![[tmp objectAtIndex:2] isEqual:@""])
        {
            NSArray * time = [[tmp objectAtIndex:2] componentsSeparatedByString:@":"];
            NSString * depTime = [[[@"" stringByAppendingString:[time objectAtIndex:0]] stringByAppendingString:@":"] stringByAppendingString:[time objectAtIndex:1]];
            [depatureTimes addObject:depTime];
        }
        else
        {
            [depatureTimes addObject:[tmp objectAtIndex:2]];
        }
        if(![[tmp objectAtIndex:1] isEqual:@""])
        {
            NSArray * time = [[tmp objectAtIndex:1] componentsSeparatedByString:@":"];
            NSString * arrTime = [[[@"" stringByAppendingString:[time objectAtIndex:0]] stringByAppendingString:@":"] stringByAppendingString:[time objectAtIndex:1]];
            [arrivalTimes addObject:arrTime];
        }
        else
        {
            [arrivalTimes addObject:[tmp objectAtIndex:1]];
        }
        
        
        if([tmp objectAtIndex:3] == 1131)
        {
            [trainStyle addObject:@"區間車"];
        }
        else
        {
            [trainStyle addObject:@"自強"];
        }
    }*/
    //NSLog(@"fetch, depatureTimes = %@, arrivalTimes = %@, trainStyle = %@", depatureTimes, arrivalTimes, trainStyle);
    [arrivalTimes retain];
    [trainStyle retain];
    [departureTimes retain];
    [trainNumber retain];
    [trainStartFroms retain];
    [trainTravelTos retain];
    
    //[self.tableView reloadData];
    
    /*NSError* error;
    NSData* data = [[NSString stringWithContentsOfURL:dataURL encoding:NSUTF8StringEncoding error:&error] dataUsingEncoding:NSUTF8StringEncoding];
    TFHpple* parser = [[TFHpple alloc] initWithHTMLData:data];
    NSArray *tableData_td  = [parser searchWithXPathQuery:@"//body//form//div//table//tbody//tr//td"];
    int rowItemCount=10;
    if([tableData_td count]%rowItemCount !=0 || [tableData_td count]%11 ==0) rowItemCount=11;
     NSLog(@"%lu",(unsigned long)[tableData_td count]);
    for (int i=3 ; i< [tableData_td count] ; ++i){
        if (i%rowItemCount==3) {
            TFHppleElement * attributeElement = [tableData_td objectAtIndex:i];
            NSArray * contextArr = [attributeElement children];
            TFHppleElement * context = [contextArr objectAtIndex:0];
            NSArray * stops = [context children];
            [StartAndTerminalstops addObject: [[stops objectAtIndex:0]content] ];
        }
        else if (i%rowItemCount == 4){
            TFHppleElement * attributeElement = [tableData_td objectAtIndex:i];
            NSArray * contextArr = [attributeElement children];
            TFHppleElement * context = [contextArr objectAtIndex:0];
            NSArray * stops = [context children];
            [depatureTimes addObject: [[stops objectAtIndex:0]content] ];
        }
        else if (i%rowItemCount == 5){
            TFHppleElement * attributeElement = [tableData_td objectAtIndex:i];
            NSArray * contextArr = [attributeElement children];
            TFHppleElement * context = [contextArr objectAtIndex:0];
            NSArray * stops = [context children];
            [arrivalTimes addObject: [[stops objectAtIndex:0]content] ];
        }
    }
     NSArray *tableData_trainStyle  = [parser searchWithXPathQuery:@"//body//form//div//table//tbody//tr//td//span"];
    for (int i=0 ; i< [tableData_trainStyle count] ; ++i){
        TFHppleElement * attributeElement = [tableData_trainStyle objectAtIndex:i];
        NSArray * contextArr = [attributeElement children];
        if (!(i%3))
          [trainStyle addObject: [[contextArr objectAtIndex:0]content] ];
        else continue;
       }*/
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    trainNumber = [NSMutableArray new];
    departureTimes = [NSMutableArray new];
    arrivalTimes = [NSMutableArray new];
    trainStyle = [NSMutableArray new];
    trainStartFroms = [NSMutableArray new];
    trainTravelTos = [NSMutableArray new];
    //[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [departureTimes count]+1;
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
    
    /*static  NSString *CellIdentifier = @"cell";
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }*/

    
    /*if (![self hasWifi]){
        cell.textLabel.text = [NSString stringWithFormat:@"無法連線，請檢查網路"];
    }
   else if (indexPath.row == 0 ) {
        cell.textLabel.text = [NSString stringWithFormat:@"車種"];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        cell.detailTextLabel.textColor = [UIColor brownColor];
        cell.textLabel.textColor = [UIColor brownColor];
       UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(172, 13, 60, 15)] autorelease];
       label.backgroundColor = [UIColor clearColor];
       label.lineBreakMode = UILineBreakModeWordWrap;
       label.numberOfLines = 0;
       label.tag=25;
       label.font = [UIFont fontWithName:BOLD_FONT size:17.0];
       label.textColor = CELL_STANDARD_FONT_COLOR;
       label.text = startStation;
       label.textAlignment = UITextAlignmentCenter;
       UILabel* detailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(260, 13, 60, 15)] autorelease];
       detailLabel.font = [UIFont fontWithName:BOLD_FONT size:17.0];
       detailLabel.backgroundColor = [UIColor clearColor];
       detailLabel.tag=30;
       detailLabel.textColor = CELL_DETAIL_FONT_COLOR;
       detailLabel.highlightedTextColor = [UIColor whiteColor];
       detailLabel.backgroundColor = [UIColor clearColor];
       detailLabel.text = depatureStation;
       detailLabel.textAlignment = UITextAlignmentCenter;
       [cell.contentView addSubview:label];
       [cell.contentView addSubview:detailLabel];
    }*/
   
    
    /*else if ([StartAndTerminalstops count]==0){
        cell.imageView.image=nil;
        cell.textLabel.text = [NSString stringWithFormat:@"無資料"];
        cell.detailTextLabel.text=@"";
    }
    else if (indexPath.row > [StartAndTerminalstops count]){
        cell.textLabel.text=@"";
    }*/
    
    if (indexPath.row == 0 ) {
        cell.textLabel.text = [NSString stringWithFormat:@"       車種         車次"];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:10];
        cell.detailTextLabel.textColor = [UIColor brownColor];
        cell.textLabel.textColor = [UIColor brownColor];
        UILabel* label = [[[UILabel alloc] initWithFrame:CGRectMake(172, 13, 60, 15)] autorelease];
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0;
        label.tag=25;
        label.font = [UIFont fontWithName:BOLD_FONT size:17.0];
        label.textColor = CELL_STANDARD_FONT_COLOR;
        label.text = departureStation;
        //label.text = @"臺北";
        label.textAlignment = UITextAlignmentCenter;
        UILabel* detailLabel = [[[UILabel alloc] initWithFrame:CGRectMake(260, 13, 60, 15)] autorelease];
        detailLabel.font = [UIFont fontWithName:BOLD_FONT size:17.0];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.tag=30;
        detailLabel.textColor = CELL_DETAIL_FONT_COLOR;
        detailLabel.highlightedTextColor = [UIColor whiteColor];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.text = arrivalStation;
        //detailLabel.text = @"基隆";
        detailLabel.textAlignment = UITextAlignmentCenter;
        [cell.contentView removeAllSubviews];
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:detailLabel];
        //cell.imageView.image = NULL;
    }
    else {
        //NSString *textString = [NSString stringWithFormat:@"%@         %@", [trainStartFroms objectAtIndex:indexPath.row-1], [trainTravelTos objectAtIndex:indexPath.row-1]];
        NSString *textString = [NSString stringWithFormat:@"%@         %@", [trainStyle objectAtIndex:indexPath.row-1], [trainNumber objectAtIndex:indexPath.row-1]];
        NSString *detailString = [NSString stringWithFormat:@"%@         %@", [departureTimes objectAtIndex:indexPath.row-1],[arrivalTimes objectAtIndex:indexPath.row-1] ] ;
         
        if ([@"[1131]*[1132]*[1120]*[1130]" rangeOfString:[trainStyle objectAtIndex:indexPath.row-1]].location != NSNotFound)   //區間車、區間快、復興、電車
            cell.imageView.image = [UIImage imageNamed:@"local_train.png"];
        if ([@"[1100]*[1101]*[1102]*[1107]" rangeOfString:[trainStyle objectAtIndex:indexPath.row-1]].location != NSNotFound)   //自強號
            cell.imageView.image = [UIImage imageNamed:@"speed_train.png"];
        if ([@"[1110]" rangeOfString:[trainStyle objectAtIndex:indexPath.row-1]].location != NSNotFound)   //莒光號
            cell.imageView.image = [UIImage imageNamed:@"gigoung_train.png"];
       
        cell.textLabel.text = textString;
        cell.detailTextLabel.text = detailString;
        cell.detailTextLabel.textColor = [UIColor blueColor];
        //NSLog(@"textString: %@, detailString: %@", textString, detailString);
        
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

