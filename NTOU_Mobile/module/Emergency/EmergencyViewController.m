#import "EmergencyModule.h"
#import "EmergencyViewController.h"
#import "SecondaryGroupedTableViewCell.h"
#import "NTOUUIConstants.h"
#import "AppDelegate.h"

@implementation EmergencyViewController
#define emergencyUserDefaultsKey @"emergencyUserDefaults"
@synthesize delegate, htmlString, infoWebView;
@synthesize imagePicker;
@synthesize innerNumber;
@synthesize outerNumber;
@synthesize alertTouchIndex;
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
		refreshButtonPressed = NO;
        infoWebView = nil;
        innerNumber=[[NSMutableArray alloc]init];
        outerNumber=[[NSMutableArray alloc]init];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://140.121.91.62/contact/contact.php"]];
        //NSLog(@"url = %@", url);
        
        NSError *error;
        //NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
        NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:url] returningResponse:NULL error:&error];
        //NSLog(@"data=%@", data);
        
        //data有資料
        if (data) {
            
            NSMutableDictionary  *stationInfo = [NSJSONSerialization JSONObjectWithData:data options: NSJSONReadingMutableContainers error: &error];
            
            //NSLog(@"NTstationInfo: %@",stationInfo);
            
            NSArray * responseArr = stationInfo[@"contactInfo"][@"inner"];
            for(NSDictionary * dict in responseArr)
                [innerNumber addObject:dict];
            responseArr = stationInfo[@"contactInfo"][@"outer"];
            for(NSDictionary * dict in responseArr)
                [outerNumber addObject:dict];
            [innerNumber retain];
            [outerNumber retain];
        }
        else //data沒有資料（nil）（發生情形：沒有網路連線）
        {
            innerNumber =[[NSMutableArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                        @"教官室(24H)", @"name",
                        @"0224629976", @"phone",
                        @"",@"email",
                        nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                        @"衛生保健組", @"name",
                        @"0224622192,1071", @"phone",
                        @"",@"email",
                        nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                        @"警衛室", @"name",
                        @"0224622192,1132", @"phone",
                        @"",@"email",
                        nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                        @"拍照寄給教官",@"name",
                        @"",@"phone",
                        @"wendylin@mail.ntou.edu.tw",@"email",
                        nil],
                    nil] retain];
            outerNumber =[[NSMutableArray arrayWithObjects:
                    [NSDictionary dictionaryWithObjectsAndKeys:
                        @"八斗子派出所", @"name",
                        @"0224692077", @"phone",
                        @"",@"email",
                        nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                        @"正濱派出所", @"name",
                        @"0224621889", @"phone",
                        @"",@"email",
                        nil],
                    [NSDictionary dictionaryWithObjectsAndKeys:
                        @"基隆市警察局", @"name",
                        @"0224248141", @"phone",
                        @"",@"email",
                        nil],
                    nil] retain];
        }
        htmlFormatString = [@"<html>"
                            "<head>"
                            "<style type=\"text/css\" media=\"screen\">"
                            "body { margin: 0; padding: 0; font-family: Helvetica; font-size: 17px; } "
                            "</style>"
                            "</head>"
                            "<body>"
                            "%@"
                            "</body>"
                            "</html>" retain];
        self.title = @"緊急聯絡";
    }
    return self;
}

- (void)setHtmlNotification:(NSString *)notification
{
    self.htmlString = [NSString stringWithFormat:htmlFormatString, notification];
    [self.tableView reloadData];
}


-(void)notificationProcess
{
    NSString* notifications = [NTOUNotificationHandle getEmergencyNotificationAndDelete];
    if (notifications) {
        self.htmlString = [NSString stringWithFormat:htmlFormatString, notifications];
        [NTOUNotificationHandle setBadgeValue:nil forModule:EmergencyTag];
        [[NSUserDefaults standardUserDefaults] setObject:notifications forKey:emergencyUserDefaultsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [NTOUNotificationHandle refreshRemoteBadge];
    }
    else{
        NSString *notification = nil;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:emergencyUserDefaultsKey] != nil) {
            notification = [NSString stringWithString:[[NSUserDefaults standardUserDefaults] objectForKey:emergencyUserDefaultsKey]];
        }

        if (!notification)
            self.htmlString = [NSString stringWithFormat:htmlFormatString, @"目前無緊急事件"];
        else
            self.htmlString = [NSString stringWithFormat:htmlFormatString, notification];
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSysteNTOUem:UIBarButtonSysteNTOUemRefresh target:self action:@selector(refreshInfo:)] autorelease];
	self.tableView.scrollEnabled = YES;
	infoWebView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width - 30 , 90)];
	infoWebView.delegate = self;
	infoWebView.dataDetectorTypes = UIDataDetectorTypeAll;
	infoWebView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	   
	[self.tableView applyStandardColors];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // register for emergencydata notifications
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoDidLoad:) name:EmergencyInfoDidLoadNotification object:nil];
	//[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(infoDidFailToLoad:) name:EmergencyInfoDidFailToLoadNotification object:nil];
    
	//if ([[[EmergencyData sharedData] lastUpdated] compare:[NSDate distantPast]] == NSOrderedDescending) {
	//	[self infoDidLoad:nil];
	//}
    [self notificationProcess];
    [self.tableView reloadData];
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	EmergencyModule *emergencyModule = (EmergencyModule *)[NTOU_MobileAppDelegate moduleForTag:EmergencyTag];
	[emergencyModule resetURL];
}

/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}
#pragma mark -
#pragma mark UIWebView delegation
#pragma mark -
#pragma mark Table view methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"緊急公告";
            break;
            
        case 1:
            return @"校內";
            break;
            
        case 2:
            return @"校內";
            break;
       
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 26.5;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num = 0;

    switch (section) {
        case 0:
            num = 1;
            break;
        case 1: {
            num=innerNumber.count;
            break;
        }
        case 2: {
            num=outerNumber.count;
            break;
        }
          }
    return num;
}


- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
   
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(15, 3, 284, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:18];
    label.backgroundColor = [UIColor clearColor];
    switch (section) {
        case 0:
             label.text = @"緊急公告";
            break;
            
        case 1:
             label.text =@"校內";
            break;
            
        case 2:
             label.text =@"校外";
            break;
            
    }
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    
    switch (indexPath.section) {
        case 0:
            rowHeight = infoWebView.frame.size.height + 10.0;
            break;
        default:
            cellText = @"A"; // just something to guarantee one line
            CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
            rowHeight = labelSize.height + 20.0f;
            break;
    }
    
    return rowHeight;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    static NSString *SecondaryCellIdentifier = @"SecondaryCell";
    
    switch (indexPath.section) {
        // Emergency Info
        case 0:
		{
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                // info cell should not be tappable
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
			}
            // use a UIWebView for html content
            UIWebView *existingWebView = (UIWebView *)[cell.contentView viewWithTag:42];
            if (!existingWebView) {
                existingWebView = [[UIWebView alloc] initWithFrame:infoWebView.frame];
                existingWebView.delegate = self;
                existingWebView.tag = 42;
                infoWebView.dataDetectorTypes = UIDataDetectorTypeAll;
                [cell.contentView addSubview:existingWebView];
                [existingWebView release];
            }
            existingWebView.frame = infoWebView.frame;
            [existingWebView loadHTMLString:htmlString baseURL:nil];
			return cell;
		}
        // Emergency numbers
        case 1:
		{
			SecondaryGroupedTableViewCell *cell = (SecondaryGroupedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondaryCellIdentifier];
			if (cell == nil) {
				cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondaryCellIdentifier] autorelease];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [innerNumber objectAtIndex:indexPath.row][@"name"];
			if ([[innerNumber objectAtIndex:indexPath.row][@"phone"] isEqualToString:@""]){
                cell.accessoryView = [UIImageView accessoryViewWithNTOUType: NTOUAccessoryViewEmail];
                cell.secondaryTextLabel.text =[innerNumber objectAtIndex:indexPath.row][@"email"];
            }
            else{
                cell.secondaryTextLabel.text =[innerNumber objectAtIndex:indexPath.row][@"phone"];
                cell.accessoryView = [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewPhone];
            }
			
			return cell;
		}
        case 2:
        {
            SecondaryGroupedTableViewCell *cell = (SecondaryGroupedTableViewCell *)[tableView dequeueReusableCellWithIdentifier:SecondaryCellIdentifier];
            if (cell == nil) {
                cell = [[[SecondaryGroupedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SecondaryCellIdentifier] autorelease];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [outerNumber objectAtIndex:indexPath.row][@"name"];
            if ([[outerNumber objectAtIndex:indexPath.row][@"phone"] isEqualToString:@""]){
                cell.accessoryView = [UIImageView accessoryViewWithNTOUType: NTOUAccessoryViewEmail];
                cell.secondaryTextLabel.text =[outerNumber objectAtIndex:indexPath.row][@"email"];
            }
            else{
                cell.secondaryTextLabel.text =[outerNumber objectAtIndex:indexPath.row][@"phone"];
                cell.accessoryView = [UIImageView accessoryViewWithNTOUType:NTOUAccessoryViewPhone];
            }
            
            return cell;
		}
       
    }
	
	return nil;
    
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    //執行取消發送電子郵件畫面的動畫
    [self dismissViewControllerAnimated:YES completion:nil];
   

}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
  
    
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
        mailView.mailComposeDelegate = self;

        if(alertTouchIndex.section==1)
            [mailView setToRecipients:[NSArray arrayWithObjects:[innerNumber objectAtIndex:alertTouchIndex.row][@"email"], nil]];
        else
            [mailView setToRecipients:[NSArray arrayWithObjects:[outerNumber objectAtIndex:alertTouchIndex.row][@"email"], nil]];

        [mailView setSubject:@"緊急事件"];
        
        [mailView setMessageBody:@"[照片]" isHTML:NO];
        NSData *imageData = UIImageJPEGRepresentation(image,0.3);
        [mailView addAttachmentData:imageData mimeType:@"image/png" fileName:@"image"];
        [self dismissViewControllerAnimated:YES completion:nil];
        [self presentViewController:mailView animated:YES completion:nil];
    }
    else
        [self dismissViewControllerAnimated:YES completion:nil];

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            if([alertView.message isEqualToString:@"未偵測到可用郵件帳號"])
            {
                NSURL* mailURL = [NSURL URLWithString:@"message://"];
                if ([[UIApplication sharedApplication] canOpenURL:mailURL]) {
                    [[UIApplication sharedApplication] openURL:mailURL];
                }
            }
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",alertView.message]]];
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *anEntry;
    NSString *phoneNumber;
    NSString *title;
    switch (indexPath.section) {
        case 2:{
        }
        case 1:{
            alertTouchIndex=[indexPath copy];
            
            if ([[innerNumber objectAtIndex:indexPath.row][@"phone"] isEqualToString:@""]){
                if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                    break;
                }
                if([MFMailComposeViewController canSendMail])
                {
                    imagePicker = [UIImagePickerController new];
                    imagePicker.delegate = self;
                    imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                    [self presentViewController:imagePicker animated:YES completion:nil];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提醒" message:@"未偵測到可用郵件帳號" delegate:self cancelButtonTitle:@"前往郵件" otherButtonTitles:nil];
                    [alert show];
                    [alert release];
                }
                break;
            }
            
            if(alertTouchIndex.section==1)
                anEntry= [innerNumber objectAtIndex:alertTouchIndex.row];
            else
                anEntry= [outerNumber objectAtIndex:alertTouchIndex.row];
            title = [[anEntry objectForKey:@"name"]
                           stringByReplacingOccurrencesOfString:@"."
                           withString:@""];
            phoneNumber = [[anEntry objectForKey:@"phone"]
                                     stringByReplacingOccurrencesOfString:@"."
                                     withString:@""];
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"即將撥往" message:[NSString stringWithFormat:@"%@",phoneNumber] delegate:self cancelButtonTitle:@"取消"  otherButtonTitles:@"撥打", nil];
                [alert show];
            break;
         }
    }
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return nil;
    }
    return indexPath;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView comNTOUEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[htmlFormatString release];
	self.htmlString = nil;
	self.infoWebView = nil;
    [super dealloc];
}


@end

