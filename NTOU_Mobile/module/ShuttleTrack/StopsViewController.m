//
//  StopsViewController.m
//  MIT Mobile
//  交通功能：海洋專車：市區公車 站牌tableView
//  Created by mac_hero on 12/9/27.
//
//

#import "StopsViewController.h"

@interface StopsViewController ()

@end

@implementation StopsViewController
- (void) setDirection:(BOOL)dir{
    go=dir;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    innerStop=[[NSMutableArray alloc]init];
    outerStop=[[NSMutableArray alloc]init];
    NSURL *url = [NSURL URLWithString:@"http://140.121.91.62/NTOUBusStop/stop.php"];
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:NULL error:&error];
    if (data) {
        
        NSMutableDictionary  *stationInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
        
        //NSLog(@"NTstationInfo: %@",stationInfo);
        
        if([stationInfo[@"NTOUBusStop"]  isKindOfClass:[NSNull class]])
        {
            [innerStop addObject:@"更新中，暫無資料"];
            [outerStop addObject:@"請稍候再試"];
        }
        else
        {
            NSArray * responseArr = stationInfo[@"NTOUBusStop"][@"inner"];
            for(NSDictionary * dict in responseArr)
                [innerStop addObject:[dict valueForKey:@"name"]];
            responseArr = stationInfo[@"NTOUBusStop"][@"outer"];
            for(NSDictionary * dict in responseArr)
                [outerStop addObject:[dict valueForKey:@"name"]];
        }
    }
    else //data沒有資料（nil）（發生情形：沒有網路連線）
    {
        NSLog(@"error:%@\n",error);
        [innerStop addObject:@"無資料"];
        [outerStop addObject:@"請稍候再試"];
    }
    [innerStop retain];
    [outerStop retain];

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (go)
         return innerStop.count;
    else
         return outerStop.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    if (go)
        cell.textLabel.text=[innerStop objectAtIndex:indexPath.row];
    else
        cell.textLabel.text=[outerStop objectAtIndex:indexPath.row];    // Configure the cell...
    
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
    NSString *busName[6]={@"103 八斗子-經中正路(經海科館)",@"103 八斗子-經祥豐街(經海科館)",@"104 新豐街-經中正路",@"104 新豐街-經祥豐街",@"108 潮境公園-經祥豐街",@"108 潮境公園-基隆車站"};
    NSString *encodedBus[6];
    NSString *encodedStop;
    if(indexPath.section==0)
        encodedStop = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[innerStop objectAtIndex:indexPath.row], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    else
        encodedStop = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[outerStop objectAtIndex:indexPath.row], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);

    for(int i=0;i<6;++i)
       encodedBus[i] = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)busName[i], NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);

    RouteDetailViewController * detail = [[RouteDetailViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    detail.title = cell.textLabel.text;
    if (go){ //往市區
        [detail addRoutesURL:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=0",encodedBus[0],encodedStop]
            and:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=0",encodedBus[1],encodedStop]
            and:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=0",encodedBus[2],encodedStop]
            and:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=0",encodedBus[3],encodedStop]
            and:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=0",encodedBus[4],encodedStop]
            and:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=0",encodedBus[5],encodedStop]
        ];
    }
    else{//往八斗
        [detail addRoutesURL:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=1",encodedBus[0],encodedStop]
            and:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=1",encodedBus[1],encodedStop]
            and:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=1",encodedBus[2],encodedStop]
            and:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=1",encodedBus[3],encodedStop]
            and:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=1",encodedBus[4],encodedStop]
            and:[NSString stringWithFormat:@"http://140.121.91.62/NTOUBusStop/stopDetail.php?bus=%@&stopName=%@&goBack=1",encodedBus[5],encodedStop]
         ];
    }
    [detail goBackMode:go];
    [self.navigationController pushViewController:detail animated:YES];
    detail.navigationItem.leftBarButtonItem.title=@"back";
}

@end
