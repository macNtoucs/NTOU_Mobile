//
//  SettingsModuleViewController.m
//  NTOU_Mobile
//
//  Created by mac_hero on 13/6/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "SettingsModuleViewController.h"
#import "accountTableViewController.h"
#import "Moodle_API.h"
#define moodle @"Moodle"
#define library @"圖書館"

@interface SettingsModuleViewController ()

@end

@implementation SettingsModuleViewController

@synthesize receiveArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        receiveArray = [[NTOUNotificationHandle getDevicePushSettingArray] mutableCopy];
        
        if (!receiveArray) {
            receiveArray = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:true],[NSNumber numberWithBool:true],[NSNumber numberWithBool:true], nil];
        }
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    [self.tableView applyStandardColors];
    self.title = @"設定";

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 38;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(15, 3, 284, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:18];
    label.backgroundColor = [UIColor clearColor];
    switch (section) {
        case 0:
            label.text = @"帳號";
            break;
        case 1:
            label.text = @"推播通知";
            break;
    }
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}

#pragma mark - API

+(NSString *) getMoodleAccount
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:moodleAccountKey];
}


+(NSString *) getMoodlePassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:moodlePasswordKey];
}

+(BOOL) getMoodleLoginSuccess
{
    NSNumber *success = [[NSUserDefaults standardUserDefaults] objectForKey:moodleLoginSuccessKey];
    if (success) {
        return [success boolValue];
    }
    return NO;
}

+(NSString *) getLibraryAccount
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:libraryAccountKey];
}


+(NSString *) getLibraryPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:libraryPasswordKey];
}

+(BOOL) getLibraryLoginSuccess
{
    NSNumber *success = [[NSUserDefaults standardUserDefaults] objectForKey:libraryLoginSuccessKey];
    if (success) {
        return [success boolValue];
    }
    return NO;
}

#pragma mark - delegate

-(BOOL)loginAndRegisterDeviceToken:(NSString *)title
{
    if ([title isEqual:moodle]) {
        NSDictionary* info = [Moodle_API Login:[SettingsModuleViewController getMoodleAccount] andPassword:[SettingsModuleViewController getMoodlePassword]];
        if([[info objectForKey:moodleLoginResultKey] intValue]==1)
            return true;
        return false;
    }
    else if ([title isEqual:library])
    {
        NSString *account = [SettingsModuleViewController getLibraryAccount];
        NSString *pwd = [SettingsModuleViewController getLibraryPassword];
        NSString *historyPost = [[NSString alloc]initWithFormat:@"account=%@&password=%@",account,pwd];
        NSHTTPURLResponse *urlResponse = nil;
        NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
        NSString * queryURL = [NSString stringWithFormat:@"http://140.121.197.135:11114/LibraryHistoryAPI/login.do"];
        [request setURL:[NSURL URLWithString:queryURL]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[historyPost dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&urlResponse
                                                                 error:nil];
        NSString* checkLogin = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        if ([checkLogin rangeOfString:@"Login failed"].location == NSNotFound)
            return true;
        else
            return false;
    }
    return false;
}

#pragma mark - tableView setting

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0)
        return 2;
    else if (section == 1)
        return 3;
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SecondaryCellIdentifier = @"SecondaryCell";
    
    SecondaryGroupedTableViewCell *cell = (SecondaryGroupedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondaryCellIdentifier];
    if (cell == nil) {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondaryCellIdentifier] autorelease];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"Moodle   ";
                    break;
                case 1:
                    cell.textLabel.text = @"圖書館";
                    break;
            }
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            switch (indexPath.row) {
                UISwitch *switchview = nil;
                case 0:

                    cell.textLabel.text = @"功課表";
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                  
                    switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                    switchview.on = [receiveArray[0] boolValue];
                    [switchview addTarget:self action:@selector(check_Switch:) forControlEvents:UIControlEventValueChanged];

                    cell.accessoryView = switchview;
                    [switchview release];
                    break;
                case 1:

                    cell.textLabel.text = @"圖書館";
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                   
                    switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                    switchview.on = [receiveArray[1] boolValue];
                    [switchview addTarget:self action:@selector(check_Switch:) forControlEvents:UIControlEventValueChanged];
                    
                    cell.accessoryView = switchview;
                    [switchview release];
                    break;
                case 2:
                    
                    cell.textLabel.text = @"緊急聯絡";
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    [cell.textLabel sizeToFit];
                    switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                    switchview.on = [receiveArray[2] boolValue];
                    [switchview addTarget:self action:@selector(check_Switch:) forControlEvents:UIControlEventValueChanged];
                    
                    cell.accessoryView = switchview;
                    [switchview release];
                    break;
            }

            break;

            
        default:
            break;
    }
    
    return cell;
}

-(void)check_Switch:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    
    UITableViewCell *cell = nil;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        cell = (UITableViewCell *)switchView.superview.superview;
    else
        cell = (UITableViewCell *)switchView.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    receiveArray[indexPath.row] = [NSNumber numberWithBool:switchView.on];
    
    [NTOUNotificationHandle sendDevicePushSetting:receiveArray];
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
    if (indexPath.section == 0 && indexPath.row == 0) {
        accountTableViewController *detailViewController = [[accountTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.title = moodle;
        detailViewController.explanation = @"帳號: 學校信箱之帳號(＠前的文字)；\n         預設為學號。\n密碼: 學校信箱之密碼；\n         預設為含大寫之身分證字號，\n         若是外籍生，則為含大寫之居留證\n         或護照號碼。";
        detailViewController.accountStoreKey = moodleAccountKey;
        detailViewController.passwordStoreKey = moodlePasswordKey;
        detailViewController.loginSuccessStoreKey = moodleLoginSuccessKey;
        detailViewController.delegate = self;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
    else if (indexPath.section == 0 && indexPath.row == 1) {
        accountTableViewController *detailViewController = [[accountTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.title = library;
        detailViewController.explanation = @"帳號:     請輸入學號,敎職員證號或本館借書證號\n密碼:     您的身份證字號(預設值)\n\n若無法使用，請將您的《姓名》、《讀者證號》、《身份證號》E-mail 至hwa重新設定！\n        若您的證件曾經補發過一次，請在讀者證號後加二位數字01；補發二次，請加02；其餘類推。";
        detailViewController.accountStoreKey = libraryAccountKey;
        detailViewController.passwordStoreKey = libraryPasswordKey;
        detailViewController.loginSuccessStoreKey = libraryLoginSuccessKey;
        detailViewController.delegate = self;
        [self.navigationController pushViewController:detailViewController animated:YES];
        [detailViewController release];
    }
     
}

@end
