//
//  SettingsModuleViewController.m
//  NTOU_Mobile
//
//  Created by mac_hero on 13/6/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "SettingsModuleViewController.h"

@interface SettingsModuleViewController (){
    UIAlertView *logInAlertView;
    UIAlertView *logOutAlertView;
}

@end

@implementation SettingsModuleViewController
@synthesize accountDelegate;
@synthesize passwordDelegate;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) addNavRightButton {
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithTitle:buttonTitle style:UIBarButtonItemStyleDone target:self action:@selector(finishSetting)];
    right.tintColor =[UIColor colorWithRed:115.0/255 green:128.0/255 blue:177.0/255 alpha:1];
    
    [self.navigationItem setRightBarButtonItem:right animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    self.title = @"設定";
    buttonTitle = [[NSMutableString alloc] initWithFormat:@"登入"];
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


-(float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    
    cellText = @"A"; // just something to guarantee one line
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    rowHeight = labelSize.height + 20.0f;
    
    return rowHeight;
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 50;
    }
    return 0;
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
                
                loginSuccess = [[ClassDataBase sharedData] loginAccount:[SettingsModuleViewController getAccount]
                                                               Password:[SettingsModuleViewController getPassword]
                                                        ClearAllCourses:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    if (loginSuccess)
                    {
                        [buttonTitle setString:@"登出"];
                        [self addNavRightButton];
                    }
                });
            });
        } else if(alertView==logOutAlertView) {
            passwordDelegate.text = nil;
            [buttonTitle setString:@"登入"];
            [self addNavRightButton];
        }else {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Show the HUD in the main tread
                dispatch_async(dispatch_get_main_queue(), ^{
                    // No need to hod onto (retain)
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.labelText = @"請稍候";
                });
                
                [[ClassDataBase sharedData] ClearAllCourses];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    [self finishSetting];
                });
            });
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
    
    if([buttonTitle isEqualToString:@"登入"])
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
    [[ClassDataBase sharedData] storeUserDefaults];
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *headerTitle = nil;
    switch (section) {
        case 0:
            headerTitle = @"Email";
            break;
        default:
            break;
    }
    UIFont *font = [UIFont boldSystemFontOfSize:STANDARD_CONTENT_FONT_SIZE];
	CGSize size = [headerTitle sizeWithFont:font];
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(19.0, 25, appFrame.size.width - 19.0, size.height)];
	
	label.text = headerTitle;
	label.textColor = GROUPED_SECTION_FONT_COLOR;
	label.font = font;
	label.backgroundColor = [UIColor clearColor];
	//label.textAlignment = UITextAlignmentCenter;
	UIView *labelContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, appFrame.size.width, GROUPED_SECTION_HEADER_HEIGHT)] autorelease];
	labelContainer.backgroundColor = [UIColor clearColor];
	
	[labelContainer addSubview:label];
	[label release];
	return labelContainer;
}

+(NSString *) getAccount
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:accountKey];
}


+(NSString *) getPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:passwordKey];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SecondaryCellIdentifier = @"SecondaryCell";
    
    SecondaryGroupedTableViewCell *cell = (SecondaryGroupedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondaryCellIdentifier];
    if (cell == nil) {
        cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:SecondaryCellIdentifier] autorelease];
    }
    UITextField* contactNameTextField = [[UITextField alloc] initWithFrame:CGRectMake(93, 10, 200, 20)];
    contactNameTextField.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            accountDelegate = contactNameTextField;
            cell.textLabel.text = @"帳號:";
            contactNameTextField.backgroundColor = [UIColor clearColor];
            contactNameTextField.font = [UIFont boldSystemFontOfSize:15];
            contactNameTextField.keyboardType = UIKeyboardTypeDefault;
            contactNameTextField.text =[SettingsModuleViewController getAccount];
            [cell addSubview:contactNameTextField];
            break;
        case 1:
            passwordDelegate = contactNameTextField;
            cell.textLabel.text = @"密碼:";
            contactNameTextField.backgroundColor = [UIColor clearColor];
            contactNameTextField.font = [UIFont boldSystemFontOfSize:15];
            contactNameTextField.keyboardType = UIKeyboardTypeDefault;
            contactNameTextField.text =[SettingsModuleViewController getPassword];
            contactNameTextField.secureTextEntry = YES;
            [cell addSubview:contactNameTextField];
            break;
    }
    
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
