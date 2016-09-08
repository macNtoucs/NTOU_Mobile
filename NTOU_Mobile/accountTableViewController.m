//
//  accountTableViewController.m
//  NTOU_Mobile
//  設定-moodle & 圖書館共用
//  Created by IMAC on 2014/5/14.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "accountTableViewController.h"
#import "SettingsModuleViewController.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define loginSuccessButtonTittle @"登出"
#define loginFailButtonTittle @"登入"
@interface accountTableViewController ()
{
    UIAlertView *logInAlertView;
    UIAlertView *logOutAlertView;
    
}

@end

@implementation accountTableViewController
@synthesize accountDelegate;
@synthesize passwordDelegate;
@synthesize receiveArray;
@synthesize accountStoreKey;
@synthesize passwordStoreKey;
@synthesize loginSuccessStoreKey;
@synthesize explanation;
@synthesize delegate;

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
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    [self.tableView applyStandardColors];
    
    loginSuccess = [self getLoginSuccess];
    if (loginSuccess) {
        buttonTitle = [[NSMutableString alloc] initWithFormat:loginSuccessButtonTittle];
    }
    else
        buttonTitle = [[NSMutableString alloc] initWithFormat:loginFailButtonTittle];
    [self addNavRightButton];

}

-(void)viewWillDisappear:(BOOL)animated
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[accountDelegate text] forKey:accountStoreKey];
    [defaults setObject:[passwordDelegate text] forKey:passwordStoreKey];
    [defaults synchronize];
    [super viewWillDisappear:animated];
}

-(void) addNavRightButton{
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleDone target:self action:@selector(finishSetting)];
    right.tintColor =[UIColor colorWithRed:115.0/255 green:128.0/255 blue:177.0/255 alpha:1];
    
    [self.navigationItem setRightBarButtonItem:right animated:YES];
}

-(void) finishSetting {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[accountDelegate text] forKey:accountStoreKey];
    [defaults setObject:[passwordDelegate text] forKey:passwordStoreKey];
    [defaults synchronize];
    
    [accountDelegate resignFirstResponder];
    [passwordDelegate resignFirstResponder];
    
    if([buttonTitle isEqualToString:loginFailButtonTittle])
    {
        if([self hasWifi])
        {
            logInAlertView = [[UIAlertView alloc]
                              initWithTitle:nil message:@"確定登入？"
                              delegate:self cancelButtonTitle:@"取消"
                              otherButtonTitles:@"確定", nil];
            [logInAlertView show];
            [logInAlertView release];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"無網路連接"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 帳號密碼 data source

-(NSString *) getAccount
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:accountStoreKey];
}


-(NSString *) getPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:passwordStoreKey];
}

-(BOOL) getLoginSuccess
{
    NSNumber *success = [[NSUserDefaults standardUserDefaults] objectForKey:loginSuccessStoreKey];
    if (success) {
        return [success boolValue];
    }
    return NO;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 2;
    else if (section == 1)
        return 1;
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 15;
    }
    return 40;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CGSize stringSize = [explanation sizeWithFont:[UIFont boldSystemFontOfSize:15]
                                    constrainedToSize:CGSizeMake(200, 9999)
                                        lineBreakMode:NSLineBreakByWordWrapping];
        return stringSize.height+5;
    }
    return 38;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SecondaryCellIdentifier = @"SecondaryCell";
    /*
    SecondaryGroupedTableViewCell *cell = (SecondaryGroupedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondaryCellIdentifier];
    if (cell == nil) {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondaryCellIdentifier] autorelease];
    }*/
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondaryCellIdentifier];
    
    UITextField* contactNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(93, 10, 200, 20)];
    contactNameTextField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize stringSize = [explanation sizeWithFont:[UIFont boldSystemFontOfSize:15]
                                constrainedToSize:CGSizeMake(200, 9999)
                                    lineBreakMode:NSLineBreakByWordWrapping];
    UITextView *textCaption = [[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, stringSize.height)];
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    accountDelegate = contactNameTextField;
                    cell.textLabel.text = @"帳號:   ";
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    if([buttonTitle isEqualToString:loginFailButtonTittle])
                        contactNameTextField.textColor = [UIColor blackColor];
                    else
                        contactNameTextField.textColor = [UIColor grayColor];
                    contactNameTextField.backgroundColor = [UIColor clearColor];
                    contactNameTextField.keyboardType = UIKeyboardTypeDefault;
                    contactNameTextField.text = [self getAccount];
                    [cell addSubview:contactNameTextField];
                    break;
                case 1:
                    passwordDelegate = contactNameTextField;
                    cell.textLabel.text = @"密碼:   ";
                    cell.textLabel.textAlignment = NSTextAlignmentLeft;
                    if([buttonTitle isEqualToString:loginFailButtonTittle])
                        contactNameTextField.textColor = [UIColor blackColor];
                    else
                        contactNameTextField.textColor = [UIColor grayColor];
                    contactNameTextField.backgroundColor = [UIColor clearColor];
                    contactNameTextField.keyboardType = UIKeyboardTypeDefault;
                    contactNameTextField.text = [self getPassword];
                    contactNameTextField.secureTextEntry = YES;
                    [cell addSubview:contactNameTextField];
                break;
            }
            if (loginSuccess) {
                contactNameTextField.userInteractionEnabled = NO;
            }
            break;
            
        case 1:
            //說明文字
            textCaption.font = [UIFont systemFontOfSize:15.0];
            textCaption.text = explanation;
            textCaption.textColor = [UIColor blackColor];
            textCaption.backgroundColor = [UIColor clearColor];
            textCaption.editable = NO;
            [cell.contentView addSubview:textCaption];
            [textCaption release];
            break;
        default:
            break;
    }
    

    
    return cell;
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(15, 3, 284, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:18];
    label.backgroundColor = [UIColor clearColor];
    switch (section) {
        case 0:
            label.text = @" ";
            break;
            
        case 1:
            label.text = @"說明";
            break;
    }
    // Create header view and add label as a subview
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
    [view addSubview:label];
    
    return view;
}


#pragma mark - delegate

-(void) storeLoginSuccess
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:loginSuccess] forKey:loginSuccessStoreKey];
    [defaults synchronize];
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
                
                loginSuccess = [SettingsModuleViewController login:self.title];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    if (loginSuccess)
                    {
                        [SettingsModuleViewController registerDeviceToken:self.title];
                        [buttonTitle setString:loginSuccessButtonTittle];
                        [self addNavRightButton];
                        accountDelegate.userInteractionEnabled = NO;
                        passwordDelegate.userInteractionEnabled = NO;
                        [self.tableView reloadData];
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
            [defaults removeObjectForKey:passwordStoreKey];
            [defaults synchronize];
            passwordDelegate.text = nil;
            loginSuccess = NO;
            [self storeLoginSuccess];
            [buttonTitle setString:loginFailButtonTittle];
            [self addNavRightButton];
        }
    }
    [self.tableView reloadData];
}



- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}


- (void) hideKeyboard:(UITapGestureRecognizer*)recognizer {
    [accountDelegate resignFirstResponder];
    [passwordDelegate resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //偵測點擊UITextField
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
