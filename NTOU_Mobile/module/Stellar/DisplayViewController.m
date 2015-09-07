//
//  ScheduleViewController.m
//  MIT Mobile
//
//  Created by mac_hero on 12/10/25.
//
//

#import "DisplayViewController.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface DisplayViewController ()

@end

@implementation DisplayViewController
@synthesize itemsArray;
@synthesize gradesArray;
@synthesize token;
@synthesize info;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"成績單";
    }
    return self;
}
- (void)dealloc
{
    [itemsArray release];
    [gradesArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    itemsArray = [[NSMutableArray alloc] init];
    gradesArray = [[NSMutableArray alloc] init];
    info = [Moodle_API Login:[SettingsModuleViewController getMoodleAccount]andPassword:[SettingsModuleViewController getMoodlePassword]];
    //NSLog(@"%@",[info objectForKey:moodleLoginResultKey]);
    if([[info objectForKey:moodleLoginResultKey] intValue]==1){
        token = [info objectForKey:moodleLoginTokenKey];
        NSDictionary *dictionary = [Moodle_API GetCourseGrade_AndUseToken:token];
        dictionary=@{@"result":@"1",@"list":@[@{@"name":@"經濟學",@"grade":@"81",@"year":@"1011"},@{@"name":@"濟學",@"grade":@"61",@"year":@"1011"},@{@"name":@"經學",@"grade":@"51",@"year":@"1011"},@{@"name":@"經濟學",@"grade":@"",@"year":@"1011"}]};
  //@{@"key1": @"value1",@"key2": @"value2"};
        for (NSDictionary * gradeDic in [dictionary objectForKey:moodleListKey]){
            [itemsArray addObject:[gradeDic objectForKey:moodleGradeNameKey]];
            [gradesArray addObject:[gradeDic objectForKey:moodleGradeKey]];
            [gradeDic count];
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *loadingAlertView = [[UIAlertView alloc]
                                             initWithTitle:nil message:@"帳號、密碼錯誤"
                                             delegate:self cancelButtonTitle:@"確定"
                                             otherButtonTitles:nil];
            [loadingAlertView show];
            [loadingAlertView release];
        });
    }
    //初始化資料陣列，待會使用
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    // 告訴tableView總共有多少個section需要顯示
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    // 告訴tableView一個section裡要顯示多少行
    return [itemsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //cell的標飾符
    static NSString *CellIdentifier = @"cellIdentifier";
    
    //指定tableView可以重用cell，增加性能，不用每次都alloc新的cell object
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];\
    //如果cell不存在，從預設的UITableViewCell Class裡alloc一個Cell object，應用Default樣式，你可以修改為其他樣式
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    // Configure the cell...
    
    //每一行row進來都判定一下，分別依次選用不同的圖片
    /*
    switch (indexPath.row) {
        case 0:
        {
            cell.imageView.image = [UIImage imageNamed:@"image0.png"];
        }
            break;
        case 1:
        {
            cell.imageView.image = [UIImage imageNamed:@"image1.png"];
        }
            break;
        case 2:
        {
            cell.imageView.image = [UIImage imageNamed:@"image2.png"];
        }
            break;
        default:
        {
            cell.imageView.image = [UIImage imageNamed:@"default.png"];
        }
            break;
    }
    */
    //其他相同的屬性一併設定
    //設字體、顏色、背景色什麼的
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:54.0/255.0 green:161.0/255.0 blue:219.0/255.0 alpha:1];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1];
    cell.textLabel.text = [itemsArray objectAtIndex:indexPath.row];
    if([[gradesArray objectAtIndex:indexPath.row] intValue]){
        cell.detailTextLabel.text=[gradesArray objectAtIndex:indexPath.row];
        if([cell.detailTextLabel.text intValue]<60)
            cell.textLabel.textColor=cell.detailTextLabel.textColor=[UIColor redColor];
    }
    else
        cell.detailTextLabel.text=@"暫無成績";
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    
    //設定textLabel的最大允許行數，超過的話會在尾未以...表示
    cell.textLabel.numberOfLines = 2;
    
    return cell;
}

//這個是非必要的，如果你想修改每一行Cell的高度，特別是有多行時會超出原有Cell的高度！
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85.0;
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods


@end
