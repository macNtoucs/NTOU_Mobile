//
//  OpenTimeTableViewController.m
//  NTOU_Mobile
//
//  Created by Rick on 2014/6/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "OpenTimeTableViewController.h"
#define FONT_SIZE 15.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
@interface OpenTimeTableViewController ()
@property (nonatomic, retain) NSArray * openTimeTypeArray;
@property (nonatomic, retain) NSMutableArray * openTimeDisplayArray;
@end

@implementation OpenTimeTableViewController
@synthesize openTimeTypeArray;
@synthesize openTimeDisplayArray;
-(void) loadOpenTimeData {
    NSData* urldata = [[NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://dl.dropboxusercontent.com/u/68445784/libop.php"]encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [[NSDictionary alloc]init];
    dic =[XMLReader dictionaryForXMLData:urldata error:nil];
    openTimeTypeArray = [[dic objectForKey:@"root"]objectForKey:@"tag"];
    openTimeDisplayArray = [[NSMutableArray alloc] init];
    for (NSDictionary* semester in openTimeTypeArray) {
        NSMutableArray* semesterDetail = [[NSMutableArray alloc] init];
        for (NSDictionary* service in [semester objectForKey:@"week"]) {
            [semesterDetail addObject:[service objectForKey:@"value"]];
            [semesterDetail addObjectsFromArray:[service objectForKey:@"service"]];
        }
        [openTimeDisplayArray addObject:semesterDetail];
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
    [super viewDidLoad];
    openTimeTypeArray = [NSArray new];
    [self loadOpenTimeData];
    [openTimeTypeArray retain];
    //[self scrolltableview];
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
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *dateComponents = [calendar components:(NSWeekdayCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSWeekCalendarUnit) fromDate:today];
    if ((dateComponents.month >= 1 && dateComponents.day >= 18)&&(dateComponents.month <= 2 && dateComponents.day <= 21)){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    else if ((dateComponents.month >= 2 && dateComponents.day >= 22)&&(dateComponents.month <= 6 && dateComponents.day <= 30)){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    else if ((dateComponents.month >= 7 && dateComponents.day >= 1)&&(dateComponents.month <= 9 && dateComponents.day <= 6)){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    else{
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:3] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [openTimeTypeArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [[openTimeDisplayArray objectAtIndex:section] count];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.text = [[openTimeTypeArray objectAtIndex:section]objectForKey:@"value"];
    label.backgroundColor=[UIColor colorWithRed:228.0/255 green:228.0/255 blue:228.0/255 alpha:1];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @" ";
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"cell%d,%ld",indexPath.section,(long)indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    
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
    [cell setLineBreakMode:UILineBreakModeCharacterWrap];
    
    cell.detailTextLabel.text = opDetailTitle;
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    cell.detailTextLabel.textColor = [UIColor grayColor];

    
    
    // Configure the cell...
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
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
