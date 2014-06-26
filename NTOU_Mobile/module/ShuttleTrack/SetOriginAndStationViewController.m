//
//  SetOriginAndStationViewController.m
//  MIT Mobile
//
//  Created by MacAir on 12/11/16.
//
//

#import "SetOriginAndStationViewController.h"
#import "UIKit+NTOUAdditions.h"
@interface SetOriginAndStationViewController ()

@end

@implementation SetOriginAndStationViewController
@synthesize region;
@synthesize station;
@synthesize delegate;
@synthesize indexTitles;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView applyStandardColors];
    [self createData];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        indexTitles = [NSMutableArray new];
        for(int i=0; i<[region count]; i++)
        {
            [self addIndexTitle:[region objectAtIndex:i]];
        }
    }
}

-(void) addIndexTitle:(NSString *) indexTitle
{
    [self.indexTitles addObject:indexTitle];
    [self.indexTitles addObject:@""];
}

-(void) createData
{
    region = [[NSArray alloc] initWithObjects:@"臺北",@"桃園",@"新竹",@"苗栗",@"臺中",@"彰化",@"雲林",@"南投",@"嘉義",@"臺南",@"高雄",@"屏東",@"臺東",@"花蓮",@"宜蘭",nil];
    station = [[NSArray alloc]initWithObjects:
               [NSArray arrayWithObjects:@"福隆",@"貢寮",@"雙溪",@"牡丹",@"三貂嶺",@"侯硐",@"瑞芳",@"四腳亭",@"暖暖",@"基隆",@"三坑",@"八堵",@"七堵",@"百福",@"五堵",@"汐止",@"汐科",@"南港",@"松山",@"臺北",@"萬華",@"板橋",@"浮州",@"樹林",@"山佳",@"鶯歌",nil ],
               [NSArray arrayWithObjects:@"桃園",@"內壢",@"中壢",@"埔心",@"楊梅",@"富岡",nil ],
               [NSArray arrayWithObjects:@"北湖",@"湖口",@"新豐",@"竹北",@"北新竹",@"新竹",@"香山",nil ],
               [NSArray arrayWithObjects:@"崎頂",@"竹南",@"談文",@"大山",@"後龍",@"龍港",@"白沙屯",@"新埔",@"通霄",@"苑里",@"豐富",@"苗栗",@"南勢",@"銅鑼",@"三義",nil ],
               [NSArray arrayWithObjects:@"日南",@"大甲",@"臺中港",@"清水",@"沙鹿",@"龍井",@"大肚",@"追分",@"泰安",@"后里",@"豐原",@"潭子",@"太原",@"臺中",@"大慶",@"烏日",@"新烏日",@"成功",nil ],
               [NSArray arrayWithObjects:@"彰化",@"花壇",@"大村",@"員林",@"永靖",@"社頭",@"田中",@"二水",nil ],
               [NSArray arrayWithObjects:@"林內",@"石榴",@"斗六",@"斗南",@"石龜",nil ],
               [NSArray arrayWithObjects:@"源泉",@"濁水",@"龍泉",@"集集",@"水里",@"車程",nil ],
               [NSArray arrayWithObjects:@"大林",@"民雄",@"嘉北",@"嘉義",@"水上",@"南靖",nil ],
               [NSArray arrayWithObjects:@"後壁",@"新營",@"柳營",@"林鳳營",@"隆田",@"拔林",@"善化",@"南科",@"新市",@"永康",@"大橋",@"臺南",@"保安",@"中洲",@"長榮大學",@"沙崙",nil ],
               [NSArray arrayWithObjects:@"大湖",@"路竹",@"岡山",@"橋頭",@"楠梓",@"新左營",@"左營",@"高雄",@"鳳山",@"後庄",@"九曲堂",nil ],
               [NSArray arrayWithObjects:@"六塊厝",@"屏東",@"歸來",@"麟落",@"西勢",@"竹田",@"潮州",@"崁頂",@"南州",@"鎮安",@"林邊",@"佳冬",@"東海",@"枋寮",@"加祿",@"內獅",@"枋山",nil ],
               [NSArray arrayWithObjects:@"古莊",@"瀧溪",@"大武",@"金崙",@"太麻里",@"知本",@"康樂",@"臺東",@"山里",@"鹿野",@"瑞源",@"瑞和",@"月美",@"關山",@"海瑞",@"池上",nil ],
               [NSArray arrayWithObjects:@"富里",@"東竹",@"東里",@"玉里",@"三民",@"瑞穗",@"富源",@"大富",@"光榮",@"萬榮",@"鳳林",@"南平",@"溪口",@"豐田",@"壽豐",@"平和",@"志學",@"吉安",@"花蓮",@"北埔",@"景美",@"新城",@"崇德",@"和仁",@"和平",nil ],
               [NSArray arrayWithObjects:@"漢本",@"武塔",@"南澳",@"東澳",@"永樂",@"蘇澳",@"蘇澳新",@"新馬",@"冬山",@"羅東",@"中里",@"二結",@"宜蘭",@"四城",@"礁溪",@"頂埔",@"頭城",@"外澳",@"龜山",@"大溪",@"大里",@"石城",nil ]
               
               , nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        if ([title isEqualToString:@""])
        {
            if ( index>=13 && index<=28) index-=2;
            
            if ( index>=29) index-=1;
        }
    }
   
    return index;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        return indexTitles;
    
    return region;
}
- (float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        if ([indexTitles[section] isEqualToString:@""])
            return 0.01f;
    }
    return 30;
}

-(float)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 5.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        return [indexTitles count];
    
    return [region count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        if ([indexTitles[section] isEqualToString:@""])
            return 0;
        else
            return [[station objectAtIndex:(section+1)/2]count];
    }
    
    return [[station objectAtIndex:section]count];
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        headerTitle = [indexTitles objectAtIndex:section];
    else
        headerTitle = [region objectAtIndex:section];
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(15, 3, 284, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:25];
    label.text = headerTitle;
    label.backgroundColor = [UIColor clearColor];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
    //}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    
    switch (indexPath.section) {
        default:
            cellText = @"A"; // just something to guarantee one line
            CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            rowHeight = labelSize.height + 20.0f;
            break;
    }
    
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        cell.textLabel.text = [[station objectAtIndex:(indexPath.section+1)/2] objectAtIndex:indexPath.row];
    else
        cell.textLabel.text = [[station objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        NSLog(@"station = %@", [[station objectAtIndex:(indexPath.section+1)/2] objectAtIndex:indexPath.row]);
        [delegate SetOriginAndStationViewTableView:self nowSelected:[[station objectAtIndex:(indexPath.section+1)/2] objectAtIndex:indexPath.row]];
    }
    else
    {
        NSLog(@"station = %@", [[station objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]);
        [delegate SetOriginAndStationViewTableView:self nowSelected:[[station objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    }
}

@end