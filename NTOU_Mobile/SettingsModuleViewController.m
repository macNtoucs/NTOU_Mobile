//
//  SettingsModuleViewController.m
//  NTOU_Mobile
//
//  Created by mac_hero on 13/6/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "SettingsModuleViewController.h"
#import "Moodle_API.h"
#import "NTOUNotification.h"
#define loginSuccessButtonTittle @"登出"
#define loginFailButtonTittle @"登入"

@interface SettingsModuleViewController (){
    UIAlertView *logInAlertView;
    UIAlertView *logOutAlertView;
}

@end

@implementation SettingsModuleViewController
@synthesize accountDelegate;
@synthesize passwordDelegate;
@synthesize receiveArray;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        receiveArray = [[NTOUNotificationHandle getDevicePushSettingArray] mutableCopy];
        loginSuccess = [SettingsModuleViewController getLoginSuccess];
        
        if (!receiveArray) {
            receiveArray = [[NSMutableArray alloc]initWithObjects:[NSNumber numberWithBool:true],[NSNumber numberWithBool:true],[NSNumber numberWithBool:true], nil];
        }
    }
    return self;
}

-(void) addNavRightButton{
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleDone target:self action:@selector(finishSetting)];
    right.tintColor =[UIColor colorWithRed:115.0/255 green:128.0/255 blue:177.0/255 alpha:1];
    
    [self.navigationItem setRightBarButtonItem:right animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    [self.tableView applyStandardColors];
    self.title = @"設定";
    if (loginSuccess) {
        buttonTitle = [[NSMutableString alloc] initWithFormat:loginSuccessButtonTittle];
    }
    else
        buttonTitle = [[NSMutableString alloc] initWithFormat:loginFailButtonTittle];
    [self addNavRightButton];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[accountDelegate text] forKey:accountKey];
    [defaults setObject:[passwordDelegate text] forKey:passwordKey];
    [defaults synchronize];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



#pragma mark - Table view data source


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return 170;
    return 38;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}


- (void) hideKeyboard:(UITapGestureRecognizer*)recognizer {
    [accountDelegate resignFirstResponder];
    [passwordDelegate resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard:)];
    
    [self.tableView addGestureRecognizer:gestureRecognizer];
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    for (UIGestureRecognizer *recognizer in [self.tableView gestureRecognizers]) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.tableView removeGestureRecognizer:recognizer];
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL) loginAndRegisterDeviceToken
{
    NSDictionary* info = [Moodle_API Login:[SettingsModuleViewController getAccount] andPassword:[SettingsModuleViewController getPassword]];
    //NSLog(@"%@",[info objectForKey:moodleLoginResultKey]);
    if([[info objectForKey:moodleLoginResultKey] intValue]==1)
        return true;
    return false;
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView==logInAlertView) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Show the HUD in the main tread
                dispatch_async(dispatch_get_main_queue(), ^{
                    // No need to hod onto (retain)
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.labelText = @"登入中";
                });
                
                loginSuccess = [self loginAndRegisterDeviceToken];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    if (loginSuccess)
                    {
                        [NTOUNotificationHandle sendRegisterDevice:accountDelegate.text];
                        [buttonTitle setString:loginSuccessButtonTittle];
                        [self addNavRightButton];
                        accountDelegate.userInteractionEnabled = NO;
                        passwordDelegate.userInteractionEnabled = NO;
                    }
                    else
                    {
                        UIAlertView *loadingAlertView = [[UIAlertView alloc]
                                                             initWithTitle:nil message:@"帳號、密碼錯誤"
                                                             delegate:self cancelButtonTitle:@"確定"
                                                             otherButtonTitles:nil];
                        [loadingAlertView show];
                        [loadingAlertView release];
                        passwordDelegate.text = nil;
                    }
                    [self storeLoginSuccess];
                });
            });
        } else if(alertView==logOutAlertView) {
            [NTOUNotificationHandle sendRegisterDevice:nil];
            accountDelegate.userInteractionEnabled = YES;
            passwordDelegate.userInteractionEnabled = YES;
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:passwordKey];
            [defaults synchronize];
            passwordDelegate.text = nil;
            loginSuccess = NO;
            [self storeLoginSuccess];
            [buttonTitle setString:loginFailButtonTittle];
            [self addNavRightButton];
        }
    }
}

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}

-(void) finishSetting {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[accountDelegate text] forKey:accountKey];
    [defaults setObject:[passwordDelegate text] forKey:passwordKey];
    [defaults synchronize];
    
    [accountDelegate resignFirstResponder];
    [passwordDelegate resignFirstResponder];
    
    if([buttonTitle isEqualToString:loginFailButtonTittle])
    {
        logInAlertView = [[UIAlertView alloc]
                          initWithTitle:nil message:@"確定登入？"
                          delegate:self cancelButtonTitle:@"取消"
                          otherButtonTitles:@"確定", nil];
        [logInAlertView show];
        [logInAlertView release];
    }
    else
    {
        logOutAlertView = [[UIAlertView alloc]
                           initWithTitle:nil message:@"確定登出？"
                           delegate:self cancelButtonTitle:@"取消"
                           otherButtonTitles:@"確定", nil];
        [logOutAlertView show];
        [logOutAlertView release];
    }
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(15, 3, 284, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:18];
    label.backgroundColor = [UIColor clearColor];
    switch (section) {
        case 0:
            label.text = @"說明";
            break;
            
        case 1:
            label.text = @"Email";
            break;
        case 2:
            label.text = @"推播通知";
            break;
    }
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}

+(NSString *) getAccount
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:accountKey];
}


+(NSString *) getPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:passwordKey];
}

+(BOOL) getLoginSuccess
{
    NSNumber *success = [[NSUserDefaults standardUserDefaults] objectForKey:loginSuccessKey];
    if (success) {
        return [success boolValue];
    }
    return NO;
}

-(void) storeLoginSuccess
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:loginSuccess] forKey:loginSuccessKey];
    [defaults synchronize];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0)
        return 1;
    else if (section == 1)
        return 2;
    else if (section == 2)
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
    UITextField* contactNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(93, 10, 200, 20)];
    contactNameTextField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *explanation = @"帳號: 學校信箱之帳號(＠前的文字)；\n         預設為學號。\n密碼: 學校信箱之密碼；\n         預設為含大寫之身分證字號，\n         若是外籍生，則為含大寫之居留證\n         或護照號碼。";
    CGSize stringSize = [explanation sizeWithFont:[UIFont boldSystemFontOfSize:15]
                          constrainedToSize:CGSizeMake(320, 9999)
                              lineBreakMode:NSLineBreakByWordWrapping];
    UITextView *textV=[[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, stringSize.height+50)];
    
    switch (indexPath.section) {
        case 0:
            textV.font = [UIFont systemFontOfSize:15.0];
            textV.text = explanation;
            textV.textColor = [UIColor blackColor];
            textV.backgroundColor = [UIColor clearColor];
            textV.editable = NO;
            [cell.contentView addSubview:textV];
            [textV release];
            break;
            
        case 1:
            switch (indexPath.row) {
                case 0:
                    accountDelegate = contactNameTextField;
                    cell.textLabel.text = @"帳號:";
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    contactNameTextField.backgroundColor = [UIColor clearColor];
                    contactNameTextField.font = [UIFont boldSystemFontOfSize:15];
                    contactNameTextField.keyboardType = UIKeyboardTypeDefault;
                    contactNameTextField.text =[SettingsModuleViewController getAccount];
                    [cell addSubview:contactNameTextField];
                    break;
                case 1:
                    passwordDelegate = contactNameTextField;
                    cell.textLabel.text = @"密碼:";
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    contactNameTextField.backgroundColor = [UIColor clearColor];
                    contactNameTextField.font = [UIFont boldSystemFontOfSize:15];
                    contactNameTextField.keyboardType = UIKeyboardTypeDefault;
                    contactNameTextField.text =[SettingsModuleViewController getPassword];
                    contactNameTextField.secureTextEntry = YES;
                    [cell addSubview:contactNameTextField];
                    break;
            }
            if (loginSuccess) {
                contactNameTextField.userInteractionEnabled = NO;
            }
            break;
        case 2:
            switch (indexPath.row) {
                UISwitch *switchview = nil;
                case 0:

                    cell.textLabel.text = @"功課表";
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                  
                    switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                    switchview.on = [receiveArray[0] boolValue];
                    [switchview addTarget:self action:@selector(chick_Switch:) forControlEvents:UIControlEventValueChanged];

                    cell.accessoryView = switchview;
                    [switchview release];
                    break;
                case 1:

                    cell.textLabel.text = @"圖書館";
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                   
                    switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                    switchview.on = [receiveArray[1] boolValue];
                    [switchview addTarget:self action:@selector(chick_Switch:) forControlEvents:UIControlEventValueChanged];
                    
                    cell.accessoryView = switchview;
                    [switchview release];
                    break;
                case 2:
                    
                    cell.textLabel.text = @"緊急聯絡";
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    [cell.textLabel sizeToFit];
                    switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
                    switchview.on = [receiveArray[2] boolValue];
                    [switchview addTarget:self action:@selector(chick_Switch:) forControlEvents:UIControlEventValueChanged];
                    
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

-(void)chick_Switch:(id)sender
{
    UISwitch *switchView = (UISwitch *)sender;
    UITableViewCell *cell = (UITableViewCell *)switchView.superview;
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
