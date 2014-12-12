//
//  OpenTimeTableViewController.m
//  NTOU_Mobile
//  library-關於圖書館-開館時間 (資料來源：https://dl.dropboxusercontent.com/u/68445784/libop.php)
//  順序：上學期  寒假 下學期 暑假
//
//  Created by Rick on 2014/6/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "OpenTimeTableViewController.h"
#import "MBProgressHUD.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 2.0f
#define OPEN_TIME_KEY "LibraryOpenTimeData"
#define OPEN_TIME_UPDATE_KEY "LibraryOpenTimeDataUpdate"

@interface OpenTimeTableViewController ()
@property (nonatomic, retain) NSArray * openTimeTypeArray;
@property (nonatomic, retain) NSArray * openTimeNoteArray;
@property (nonatomic, retain) NSArray * openTimeDisplayArray;
@property (nonatomic, retain) NSArray * openTimeSTimeArray;
@property (nonatomic) BOOL nowWifi;
@end

@implementation OpenTimeTableViewController
@synthesize openTimeTypeArray;
@synthesize openTimeNoteArray;
@synthesize openTimeDisplayArray;
@synthesize openTimeSTimeArray;
@synthesize nowWifi;

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

-(void) FetchDataFromApi {
    
    //NSData* urldata = [[NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/68445784/libop.php"]encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSData* urldata = [[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://lib.ntou.edu.tw/mobil_client/lib_open_xml.php"]encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [[NSDictionary alloc]init];
    dic =[XMLReader dictionaryForXMLData:urldata error:nil];
    
    
    NSMutableArray * openTimeFetchArray = [[NSMutableArray alloc] init];
    NSMutableArray * openTimeFetchNoteArray = [[NSMutableArray alloc] init];
    NSMutableArray * openTimeFetchTimeArray = [[NSMutableArray alloc] init];
    openTimeTypeArray = [[dic objectForKey:@"root"]objectForKey:@"tag"];
    
    int i = 0 ;
    for (NSDictionary* semester in openTimeTypeArray) {
        i++;
        //取得個學期時間
        NSMutableDictionary* semesterTime = [[NSMutableDictionary alloc] init];
        [semesterTime setObject:[[semester objectForKey:@"start_date"] objectForKey:@"text"] forKey:@"start_date"];
        [semesterTime setObject:[[semester objectForKey:@"end_date"] objectForKey:@"text"] forKey:@"end_date"];
        
        //取得服務
        NSMutableArray* semesterDetail = [[NSMutableArray alloc] init];
        for (NSDictionary* service in [semester objectForKey:@"week"]) {
            [semesterDetail addObject:[service objectForKey:@"value"]];
            [semesterDetail addObjectsFromArray:[service objectForKey:@"service"]];
        }
        
        //取得備註
        NSMutableArray* semesterNote = [[NSMutableArray alloc] init];
        //if(i != 2)  //測試無備註的情況
        {
            if([semester objectForKey:@"note"]) //辨認有無備註
            {
               for ( NSDictionary *note in [semester objectForKey:@"note"] )
               {
                    if([note isKindOfClass:[NSString class]]){  //僅一條備註
                        NSMutableDictionary* temp = [[NSMutableDictionary alloc] init];
                        [temp setObject:[[semester objectForKey:@"note"] objectForKey:@"value"] forKey:@"value"];
                        [temp setObject:[[semester objectForKey:@"note"] objectForKey:@"text"] forKey:@"text"];
                        [semesterNote addObject:temp];
                    }else{
                        [semesterNote addObjectsFromArray:[semester objectForKey:@"note"]];
                    }
                   break;
                }
            }
        }
        
        [openTimeFetchArray addObject:semesterDetail];
        [openTimeFetchNoteArray addObject:semesterNote];
        [openTimeFetchTimeArray addObject:semesterTime];
    }
    
    openTimeDisplayArray = [[NSArray alloc] initWithArray:openTimeFetchArray];
    openTimeNoteArray = [[NSArray alloc] initWithArray:openTimeFetchNoteArray];
    openTimeSTimeArray = [[NSArray alloc] initWithArray:openTimeFetchTimeArray];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    
    //正規化的格式設定
    //[formatter setTimeStyle:NSDateFormatterFullStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //把此次更新資訊存入使用者端
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //開館時間
    [defaults removeObjectForKey:@"LibraryOpenTimeSTime"];
    [defaults setObject:openTimeSTimeArray forKey:@"LibraryOpenTimeSTime"];
    
    [defaults removeObjectForKey:@"LibraryOpenTimeData"];
    [defaults setObject:openTimeDisplayArray forKey:@"LibraryOpenTimeData"];

    [defaults removeObjectForKey:@"LibraryOpenTimeNote"];
    [defaults setObject:openTimeNoteArray forKey:@"LibraryOpenTimeNote"];
    
    [defaults removeObjectForKey:@"LibraryOpenTimeType"];
    [defaults setObject:openTimeTypeArray forKey:@"LibraryOpenTimeType"];
    
    NSString *timeStr = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    //此次更新時間
    [defaults removeObjectForKey:@"LibraryOpenTimeDataUpdate"];
    [defaults setObject:[NSString stringWithString:timeStr] forKey:@"LibraryOpenTimeDataUpdate"];
    
    [defaults synchronize];
    
    [formatter release];
}

-(void) loadOpenTimeData {
    nowWifi = [self hasWifi];   //統一偵測有無網路，避免跑到一半突然有網路的狀況
    if(!nowWifi)
    {   //載入先前記錄
        //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LibraryOpenTimeData"];  //測試無資料情況
        //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LibraryOpenTimeDataUpdate"]; //測試無時間記錄情況
        
        openTimeSTimeArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"LibraryOpenTimeSTime"];
        openTimeDisplayArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"LibraryOpenTimeData"];
        openTimeNoteArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"LibraryOpenTimeNote"];
        openTimeTypeArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"LibraryOpenTimeType"];
        
        if(openTimeDisplayArray == NULL || openTimeTypeArray == NULL)   //無資料情況
        {
            openTimeTypeArray = [NSArray new];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"無網路連接，且沒有之前的記錄。"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        } else {
            NSString *formatter = [[NSUserDefaults standardUserDefaults] objectForKey:@"LibraryOpenTimeDataUpdate"];
            NSString *alertText;
            if(formatter == NULL)
                alertText = [NSString stringWithFormat:@"無網路連接"];
            else
                alertText = [NSString stringWithFormat:@"無網路連接，最後更新時間：%@",formatter];
            
            //顯示系統時間
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertText
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alertView show];
            [alertView release];
            [formatter release];
        }
    }else {
        //更新開館時間資訊
        /*
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            // Show the HUD in the main tread
            dispatch_async(dispatch_get_main_queue(), ^{
                // No need to hod onto (retain)
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
                hud.labelText = @"Loading";
            });*/
            
                [self FetchDataFromApi];
        /*
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
                [self.tableView reloadData];
            });
        });*/
    }
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
    openTimeTypeArray = [NSArray new];
    [self loadOpenTimeData];
    [openTimeTypeArray retain];
    //[self scrolltableview];
    
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scrolltableview];
}

-(void)scrolltableview
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    
    //正規化的格式設定
    [formatter setDateFormat:@"yyyy-MM-dd"];

    if(openTimeSTimeArray != NULL)
    {
        for(int i = 0 ; i < [openTimeSTimeArray count] ; i++)
        {
            NSDate *startDate = [formatter dateFromString:[[openTimeSTimeArray objectAtIndex:i] objectForKey:@"start_date"]];
            NSDate *endDate = [formatter dateFromString:[[openTimeSTimeArray objectAtIndex:i] objectForKey:@"end_date"]];
            NSComparisonResult startResult = [date compare:startDate];
            NSComparisonResult endResult = [date compare:endDate];
            /*
             NSOrderedAscending  升序 目前時間較前
             NSOrderedSame       相同
             NSOrderedDescending 降序 目前時間較後
             */
            if( startResult == NSOrderedDescending && endResult == NSOrderedAscending )
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]
                                      atScrollPosition:UITableViewScrollPositionTop animated:NO];
        }
    }
    
    /*
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:(NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekCalendarUnit) fromDate:today];
    if ((dateComponents.month >= 1 && dateComponents.day >= 18)&&(dateComponents.month <= 2 && dateComponents.day <= 23)){
        //寒假
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    else if ((dateComponents.month >= 2 && dateComponents.day >= 24)&&(dateComponents.month <= 6 && dateComponents.day <= 29)){
        //下學期
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    else if ((dateComponents.month >= 6 && dateComponents.day >= 22)&&(dateComponents.month <= 9 && dateComponents.day <= 11)){
        //暑假
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    else{
        //上學期
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }*/
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if(openTimeTypeArray == NULL || openTimeDisplayArray == NULL)
        return 1;
    else
        return [openTimeTypeArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(openTimeTypeArray == NULL || openTimeDisplayArray == NULL)
        return 1;
    else
        return [[openTimeDisplayArray objectAtIndex:section] count] + [[openTimeNoteArray objectAtIndex:section] count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(openTimeTypeArray == NULL || openTimeDisplayArray == NULL)
        return 0;
    else
        return 40;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(openTimeTypeArray == NULL || openTimeDisplayArray == NULL)
        return NULL;
    else{
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:@"Helvetica" size:15.0];
        label.text = [[openTimeTypeArray objectAtIndex:section]objectForKey:@"value"];
        label.backgroundColor=[UIColor colorWithRed:228.0/255 green:228.0/255 blue:228.0/255 alpha:1];
        label.textAlignment = NSTextAlignmentCenter;
        return label;
    }
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @" ";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d,%ld",indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(openTimeTypeArray == NULL || openTimeDisplayArray == NULL)
    {
        UILabel *nolabel = nil;
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            nolabel = [[UILabel alloc] init];
        }
        
        UIFont *boldfont = [UIFont boldSystemFontOfSize:18.0];
        
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        
        CGSize maximumLabelSize = CGSizeMake(200,9999);
        CGSize booknameLabelSize = [[NSString stringWithFormat:@"無記錄"] sizeWithFont:boldfont
                                                                  constrainedToSize:maximumLabelSize
                                                                      lineBreakMode:NSLineBreakByWordWrapping];
        nolabel.frame = CGRectMake((screenWidth - booknameLabelSize.width)/2,11,booknameLabelSize.width,20);
        
        nolabel.font = boldfont;
        nolabel.text = [NSString stringWithFormat:@"無記錄"];
        [cell.contentView addSubview:nolabel];
    }
    else {
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if(indexPath.row < [[openTimeDisplayArray objectAtIndex:indexPath.section] count])
        {
            id op = [[openTimeDisplayArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSString *opTitle = nil;
            NSString *opDetailTitle = nil;
            if ([op isKindOfClass:[NSString class]]){
                opTitle = op;
                cell.textLabel.textColor = [UIColor blueColor];
            }
            else{
                opTitle = [[[op objectForKey:@"value"]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
                opDetailTitle = [[[op objectForKey:@"text"]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            }

            cell.textLabel.text = opTitle;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            cell.textLabel.numberOfLines = 0;
            [cell setLineBreakMode:NSLineBreakByCharWrapping];
        
            cell.detailTextLabel.text = opDetailTitle;
            cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
            cell.detailTextLabel.textColor = [UIColor grayColor];
        } else {  //備註
            NSInteger cellIndex = indexPath.row - [[openTimeDisplayArray objectAtIndex:indexPath.section] count];
            id op = [[openTimeNoteArray objectAtIndex:indexPath.section] objectAtIndex:cellIndex];
            NSString *opTitle = nil;
            NSString *opDetailTitle = nil;
            
            opTitle = [[[op objectForKey:@"value"]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            opTitle = [NSString stringWithFormat:@"備註%@：", opTitle];
            opDetailTitle = [[[op objectForKey:@"text"]componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            
            cell.textLabel.text = opTitle;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            cell.textLabel.textColor = [UIColor blueColor];
            
            cell.detailTextLabel.text = opDetailTitle;
            cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.textColor = [UIColor blackColor];
            [cell setLineBreakMode:NSLineBreakByCharWrapping];
        }
        
    }
    
    // Configure the cell...
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(openTimeTypeArray == NULL || openTimeDisplayArray == NULL)
        return 40.0;
    else{
        if(indexPath.row < [[openTimeDisplayArray objectAtIndex:indexPath.section] count])
        {
            id op = [[openTimeDisplayArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
            NSString *openTimetitle = nil;
            if ([op isKindOfClass:[NSString class]])
                return 30;
            else{
                openTimetitle = [op objectForKey:@"value"];
            }
            
            CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [openTimetitle sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat height = size.height + 12 + 16 + 2;
            
            [openTimeTypeArray retain];
            return height;
        } else {
            NSInteger cellIndex = indexPath.row - [[openTimeDisplayArray objectAtIndex:indexPath.section] count];
            id op = [[openTimeNoteArray objectAtIndex:indexPath.section] objectAtIndex:cellIndex];
            NSString *openTimetitle = nil;
            
            CGRect screenBound = [[UIScreen mainScreen] bounds];
            CGSize screenSize = screenBound.size;
            CGFloat screenWidth = screenSize.width;
            
            openTimetitle = [op objectForKey:@"text"];
            CGSize constraint = CGSizeMake(screenWidth - (CELL_CONTENT_MARGIN * 2), 20000.0f);
            
            CGSize size = [openTimetitle sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat height = size.height + 12 + 16 + 2;
            
            [openTimeNoteArray retain];
            return height;
        }
    }
    
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*
    DetailOpenTimeTableViewController * detailOp = [[DetailOpenTimeTableViewController alloc]init];
    detailOp.detailOpenTime = [[openTimeTypeArray objectAtIndex:indexPath.row]objectForKey:@"week"];
    [self.navigationController pushViewController:detailOp animated:YES];
    [detailOp release];

*/
}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
