//
//  R66TableViewController.m
//  NTOU_Mobile
//
//  Created by 蘇琍 on 2015/2/5.
//  Copyright (c) 2015年 NTOUcs_MAC. All rights reserved.
//

#import "R66TableViewController.h"
#import "UIKit+NTOUAdditions.h"

#define STATE_IS_WEEKDAY  1
#define STATE_IS_WEEKEND  2




@interface R66TableViewController ()

@end

@implementation R66TableViewController
@synthesize weekdayButton;
@synthesize weekendButton;
- (void)initWithData
{
    weekend_marine = [[NSArray alloc] initWithObjects:@"海科館", @"06:30", @"07:10", @"07:50", @"08:30", @"09:10", @"10:00", @"11:00", @"12:00", @"13:00", @"14:00", @"15:00", @"16:00", @"16:50", @"17:40", @"18:30", @"19:30", @"20:30", @"21:30", nil];
    weekend_qidu = [[NSArray alloc] initWithObjects:@"七堵車站", @"07:20", @"08:00", @"08:40", @"09:20", @"10:00", @"10:50", @"11:50", @"12:50", @"13:50", @"14:50", @"15:50", @"16:50", @"17:40", @"18:30", @"19:20", @"20:20", @"21:20", @"22:20", nil];
    weekday_marine = [[NSArray alloc] initWithObjects:@"海科館", @"06:30", @"06:50", @"07:10", @"07:30", @"07:50", @"08:10", @"08:30", @"08:50", @"09:10", @"09:30", @"09:50", @"10:10", @"10:30", @"10:50", @"11:10", @"12:00", @"12:50", @"13:40", @"14:30", @"15:20", @"16:00", @"16:20", @"16:40", @"17:00", @"17:20", @"18:10", @"19:00", @"19:50", @"20:40", @"21:30", nil];
    weekday_qidu = [[NSArray alloc] initWithObjects:@"七堵車站", @"07:20", @"07:40", @"08:00", @"08:20", @"08:40", @"09:00", @"09:20", @"09:40", @"10:00", @"10:20", @"10:40", @"11:00", @"11:20", @"11:40", @"12:00", @"12:50", @"13:40", @"14:30", @"15:20", @"16:10", @"16:50", @"17:10", @"17:30", @"17:50", @"18:10", @"19:00", @"19:50", @"20:40", @"21:30", @"22:20", nil];
}


- (void)convertSwipeRecognizer
{
    if (swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        NSLog(@"switchLeft");
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
        [self switchView:STATE_IS_WEEKEND];

    }
    else
    {
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        NSLog(@"switchRight");
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
        [self switchView:STATE_IS_WEEKDAY];

    }
}

- (void)detectCurrentTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"cccc"];
    NSString *currentTime = [formatter stringFromDate:date];
    NSLog(@"%@", currentTime);
    if ([currentTime isEqualToString:@"Saturday"] || [currentTime isEqualToString:@"星期六"] || [currentTime isEqualToString:@"Sunday"] || [currentTime isEqualToString:@"星期日"])
        isWeekday = false;
    else
        isWeekday = true;
}


- (void)switchView:(NSInteger)state
{
    [UIView beginAnimations:@"View Curl" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    NSLog(@"state=%lu, weekState=%lu",(long)state,weekState);

    if (state!=weekState ) {
        if ( weekState==STATE_IS_WEEKDAY)
        {
            //weekdayButton.selected=NO;
            //weekendButton.selected=YES;
            weekState=STATE_IS_WEEKEND;
            NSLog(@"現在是假日發車");
        }
        else
        {
            //weekdayButton.selected=true;
            //weekendButton.selected=false;
            weekState=STATE_IS_WEEKDAY;
            NSLog(@"現在是平日發車");
        }

    }
    else
    {
        NSLog(@"state==weekstate, nothing");
    }

    [UIView commitAnimations];
    [self.tableView reloadData];

}

- (void)dealloc
{
    [weekend_marine release];
    [weekend_qidu release];
    [weekday_qidu release];
    [weekday_marine release];

    [super dealloc];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithData];

    [self detectCurrentTime];
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(convertSwipeRecognizer)];
    if (isWeekday)  // 平常日
    {
        weekState =STATE_IS_WEEKDAY;
        [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    }
    else            // 假日
    {
        weekState =STATE_IS_WEEKEND;
        [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    }
    [self.view addGestureRecognizer:swipeRecognizer];
    [self switchView:weekState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buttonPressed:(id)sender
{
    NSLog(@"buttonPressed");
    UIButton *abutton = (UIButton*)sender;
    [self switchView:abutton.tag];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (weekState ==STATE_IS_WEEKDAY) {
        NSLog(@"R66 weekday tableCell count:%lu",(unsigned long)[weekday_marine count]);
        return [weekday_marine count];

    }
    else//weekend
    {
        NSLog(@"R66 weekend tableCell count:%lu",(unsigned long)[weekend_marine count]);
        return [weekend_marine count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    SecondaryGroupedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *timeString;
    if (weekState ==STATE_IS_WEEKDAY) {
        if (indexPath.row == 0)
            timeString = [[NSString alloc] initWithFormat:@"           %@               %@", [weekday_marine objectAtIndex:indexPath.row], [weekday_qidu objectAtIndex:indexPath.row]];
        else
            timeString = [[NSString alloc] initWithFormat:@"            %@                  %@", [weekday_marine objectAtIndex:indexPath.row], [weekday_qidu objectAtIndex:indexPath.row]];
    }
    else//weekend
    {
        if (indexPath.row == 0)
            timeString = [[NSString alloc] initWithFormat:@"           %@               %@", [weekend_marine objectAtIndex:indexPath.row], [weekend_qidu objectAtIndex:indexPath.row]];
        else
            timeString = [[NSString alloc] initWithFormat:@"            %@                  %@", [weekend_marine objectAtIndex:indexPath.row], [weekend_qidu objectAtIndex:indexPath.row]];
    }
    // Configure the cell...
    cell.textLabel.text = timeString;
    return cell;

    
}
#pragma mark - Table view delegate
// 設定 Table 的 header 高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    // 設成 40 (Button 的父視圖的高度)
    return 40;
}

// 設定要填充 header 的 View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIImage *backgroundImage = [UIImage imageNamed:NTOUImageNameScrollTabBackgroundOpaque];
    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 320, 40)];
    //buttonView.backgroundColor = [UIColor lightGrayColor];
    [buttonView setBackgroundColor:[UIColor colorWithPatternImage:backgroundImage]];

    
    //UIImage *stretchableButtonImage = [[UIImage imageNamed:NTOUImageNameScrollTabSelectedTab] stretchableImageWithLeftCapWidth:15 topCapHeight:0];

    weekdayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    weekdayButton.frame = CGRectMake(20, 5, 120, 30);
    [weekdayButton setTitle:@"平常日發車時間"forState:UIControlStateNormal];
    weekdayButton.tag = STATE_IS_WEEKDAY;
    if (weekState==STATE_IS_WEEKDAY) {
        [weekdayButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
        [weekdayButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [weekdayButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [weekdayButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:weekdayButton];
    
    weekendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    weekendButton.frame = CGRectMake(180, 5, 120, 30);
    [weekendButton setTitle:@"例假日發車時間"forState:UIControlStateNormal];
    weekendButton.tag = STATE_IS_WEEKEND;
    if (weekState==STATE_IS_WEEKEND) {
        [weekendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    else
        [weekendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [weekendButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    //[weekendButton setBackgroundImage:nil forState:UIControlStateNormal];
    //[weekendButton setBackgroundImage:stretchableButtonImage forState:UIControlStateHighlighted];
    [weekendButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:weekendButton];
    
    return buttonView;
}

// 設定表格每列的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 32;

}
/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end