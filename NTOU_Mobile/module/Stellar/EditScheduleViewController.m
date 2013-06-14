//
//  EditScheduleViewController.m
//  NTOU Mobile
//
//  Created by mac_hero on 12/10/27.
//
//

#import "EditScheduleViewController.h"
#import "NTOUUIConstants.h"
#import "NTOU_ClassColorViewController.h"
#import "SettingsModuleViewController.h"


@interface EditScheduleViewController (){
    SetWeekTimesViewController * setweek;
    UIAlertView *downloadingAlertView;
    UIAlertView *resetAlertView;
}

@end

@implementation EditScheduleViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.scrollEnabled = NO;
        self.title = @"設定";
        self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:59.0/255 saturation:89.0/255 brightness:182.0/255 alpha:1];
        [[UIBarButtonItem appearance] setTintColor: [UIColor colorWithHexString:@"#144893"]];
        self.view.backgroundColor = [UIColor clearColor];
        [ClassDataBase sharedData].EditScheduleDelegate = self; 
    }
    return self;
}

-(void) addNavRightButton {
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(finishSetting)];
    
    [self.navigationItem setRightBarButtonItem:right animated:YES];
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

- (void)viewDidLoad
{
    
    [self addNavRightButton]; 
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[ClassDataBase sharedData].ScheduleViewDelegate ChangeDisplayView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==1) {
        return @" ";
    }
    return nil;
    
}

-(float)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 32;
    }
    return 0;
}



- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *headerTitle = nil;
    switch (section) {
        default:
            break;
    }
    UIFont *font = [UIFont boldSystemFontOfSize:STANDARD_CONTENT_FONT_SIZE];
	CGSize size = [headerTitle sizeWithFont:font];
	CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(19.0, 0, appFrame.size.width - 19.0, size.height)];
	
	label.text = headerTitle;
	label.textColor = GROUPED_SECTION_FONT_COLOR;
	label.font = font;
	label.backgroundColor = [UIColor clearColor];
	label.textAlignment = UITextAlignmentCenter;
	UIView *labelContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, appFrame.size.width, GROUPED_SECTION_HEADER_HEIGHT)] autorelease];
	labelContainer.backgroundColor = [UIColor clearColor];
	
	[labelContainer addSubview:label];
	[label release];
	return labelContainer;
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section==0) {
        return 4;
    }
    else if (section==1) {
        return 1;
    }
    else if (section==2) {
        return 1;
    }
    return 0;
}

-(void) finishSetting {
    [self dismissModalViewControllerAnimated:YES];
    [[ClassDataBase sharedData] storeUserDefaults];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    SecondaryGroupedTableViewCell *cell;
    if ((indexPath.section==1&&indexPath.row==0)||(indexPath.section==2&&indexPath.row==0))
        cell  = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    else
        cell  = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];

    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchview.on = [[ClassDataBase sharedData] FetchshowClassTimes];
    UISlider *sliderView = [[UISlider alloc]initWithFrame:CGRectMake(174,12,120,23)];
    sliderView.maximumValue = 14;
    sliderView.minimumValue = 8;
    sliderView.value = [[ClassDataBase sharedData] FetchClassSessionTimes];
    if (indexPath.section==0) {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"一周上課天數";
                cell.detailTextLabel.text = @"";
                cell.detailTextLabel.textColor = [UIColor blueColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 1:
                cell.textLabel.text = @"課堂顏色";
                cell.detailTextLabel.text = @"";
                cell.detailTextLabel.textColor = [UIColor blueColor];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                break;
            case 2:
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.text = @"節次";
                cell.accessoryView = sliderView;
                [(UISlider *)cell.accessoryView addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f",sliderView.value];
                cell.detailTextLabel.textColor = [UIColor blueColor];
                cell.detailTextLabel.backgroundColor = [UIColor clearColor];
                break;
            case 3:
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryView = switchview;
                [(UISwitch *)cell.accessoryView addTarget:self action:@selector(switchValueChange:) forControlEvents:UIControlEventTouchUpInside];
                cell.textLabel.text = @"顯示課堂時間";
                break;
        }
    }
    else if (indexPath.section==1)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"下載當學期課表";
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                break;
        }
    }
    else if (indexPath.section==2)
    {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"還原初始設定";
                cell.textLabel.textAlignment = UITextAlignmentCenter;
                break;
        }
    }
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)switchValueChange:(id)sender{
    UISwitch *theSwitch = (UISwitch *)sender;
    willbeset_showClassTimes = theSwitch.on;
    [[ClassDataBase sharedData] SetShowClassTimes:willbeset_showClassTimes];
}

- (void)sliderValueChange:(id)sender{
    UISlider *theSlider = (UISlider *)sender;
    SecondaryGroupedTableViewCell *cell = (SecondaryGroupedTableViewCell *)theSlider.superview;
    willbeset_ClassSessionTimes = theSlider.value;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f",theSlider.value];
    [[ClassDataBase sharedData] SetClassSessionTimes:[cell.detailTextLabel.text intValue]];
}

-(void)ReloadSetWeek
{
    [setweek.tableView reloadData];
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
- (void)tableView:(UITableView *)tableView comNTOUEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
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

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if (alertView==downloadingAlertView) {
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                // Show the HUD in the main tread
                dispatch_async(dispatch_get_main_queue(), ^{
                    // No need to hod onto (retain)
                    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hud.labelText = @"下載中";
                });
                
                loginSuccess = [[ClassDataBase sharedData] loginAccount:[SettingsModuleViewController getAccount]
                                                               Password:[SettingsModuleViewController getPassword]
                                                        ClearAllCourses:NO];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
                    if (loginSuccess)
                        [self finishSetting];
                });
            });
        } else {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0&&indexPath.row==0){
        setweek = [SetWeekTimesViewController new];
        [self.navigationController pushViewController:setweek animated:YES];
        setweek.title = @"設定一周天數";
        setweek.navigationItem.leftBarButtonItem.title=@"上一頁";
    }
    else if (indexPath.section==0&&indexPath.row==1){
        NTOU_ClassColorViewController* classColor = [[NTOU_ClassColorViewController alloc] init];
        classColor.title = @"設定課堂顏色";
        [self.navigationController pushViewController:classColor animated:YES];
        classColor.navigationItem.leftBarButtonItem.title=@"上一頁";
    }
    else if (indexPath.section==1&&indexPath.row==0){
        downloadingAlertView = [[UIAlertView alloc]
                                         initWithTitle:nil message:@"下載當學期課表"
                                         delegate:self cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"確定", nil];
        [downloadingAlertView show];
        [downloadingAlertView release];
    }
    else if (indexPath.section==2&&indexPath.row==0){
        resetAlertView = [[UIAlertView alloc]
                                         initWithTitle:nil message:@"還原初始設定"
                                         delegate:self cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"確定", nil];
        [resetAlertView show];
        [resetAlertView release];
    }
}

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}

@end
