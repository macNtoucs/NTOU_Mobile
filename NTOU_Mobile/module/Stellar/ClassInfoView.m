//
//  ClassInfoView.m
//  NTOU Mobile
//
//  Created by mini server on 12/11/3.
//
//

#import "ClassInfoView.h"
#import "UIKit+NTOUAdditions.h"
#import "NTOUUIConstants.h"
#import "ClassDataBase.h"
@interface ClassInfoView (){
    int types;
    BOOL edit;
}
@end

@implementation ClassInfoView
@synthesize textView;
@synthesize delegatetype5;
@synthesize moodleData;
@synthesize resource;
@synthesize moodleid;
#pragma mark Constants

#define DEMO_VIEW_CONTROLLER_PUSH FALSE

#pragma mark UIViewController methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.textView = [[UITextView alloc] init];
            self.textView.textColor = CELL_STANDARD_FONT_COLOR;
            self.textView.font = [UIFont fontWithName:STANDARD_FONT size:CELL_STANDARD_FONT_SIZE];
            self.textView.delegate = self;
            self.textView.backgroundColor = [UIColor clearColor];
            self.textView.returnKeyType = UIReturnKeyDefault;
            self.textView.keyboardType = UIKeyboardTypeDefault;
            self.textView.scrollEnabled = YES;
            
        });
        
        edit = NO;
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) // See README
		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	else
		return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    self.tableView.backgroundColor = TABLE_SEPARATOR_COLOR;
    if ([self.title isEqual: type1]){
        types = 1;
    }
    else if ([self.title isEqual: type2])
        types = 2;
    else if ([self.title isEqual: type3])
        types = 3;
    else if ([self.title isEqual: type4])
        types = 4;
    else if ([self.title isEqual: type5]){
        types = 5;
        self.tableView.scrollEnabled = NO;
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.textView.text = [[NSUserDefaults standardUserDefaults] objectForKey:[moodleData objectForKey:courseIDKey]];
        });
    }
    else if ([self.title isEqual: type6])
        types = 6;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    if (types == 1)
        return 1;
    else if (types == 2)
        return 2;
    else if (types == 3)
        return [resource count];
    else if (types == 4)
        return 1;
    else if (types == 5)
        return 1;
    else if (types == 6)
        return 1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (types == 1)
        return [[moodleData objectForKey:moodleListKey] count];
    else if (types == 2){
        if (section == 0) {
            return [[moodleData objectForKey:moodleListKey] count]+1;
        }
        else
            return [resource count]+1;
    }
    else if (types == 3)
        return 1;
    else if (types == 4)
        return [resource count];
    else if (types == 5)
        return 1;
    else if (types == 6)
        return [resource count]+1;
    return 1;
}


- (void)handleSingle:(NSString*)filename path:(NSString*) path
{
    NSString *phrase = [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    UIViewController *webViewController = [[[UIViewController alloc]init] autorelease];
    UIWebView *webView = [[[UIWebView alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:phrase]]];
    [webViewController.view addSubview: webView];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                   initWithTitle: @"返回"
                                   style: UIBarButtonItemStylePlain
                                   target: delegatetype5  action: @selector(presentOff)];
    
    webViewController.navigationItem.leftBarButtonItem = backButton;
    webViewController.title = filename;
    [delegatetype5 presentOn:webViewController];
    /*
    
	NSString *phrase = [filename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
   // NSString *filePath = [[[NSBundle mainBundle] bundlePath]stringByAppendingPathComponent:filename];
    if (![[phrase substringFromIndex:[phrase rangeOfString:@"."].location] isEqualToString:@"pdf"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phrase]];
    }
    else{
        
    }
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filename password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
     
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
		[self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
        [delegatetype5 presentOn:readerViewController];
        
        
#endif // DEMO_VIEW_CONTROLLER_PUSH

        
	}*/
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    [delegatetype5 presentOff];
	
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}

- (void) myAction: (UITapGestureRecognizer *) gr {
    NSURL *url = nil;
    //UILabel*label = (UILabel *)[self.tableView viewWithTag:gr.view.tag];
    //NSLog(@"%@",label.text);
    if (types==4) {
        [self handleSingle:[resource objectAtIndex:gr.view.tag] path:[Moodle_API GetPathOfDownloadFiles_fileName:[resource objectAtIndex:gr.view.tag] FromDir:[NSString stringWithFormat:@"/%@/%@",moodleid,moodleFileLetureKey]]];
        

    }
    else if (types==2)
    {
        [self handleSingle:[resource objectAtIndex:gr.view.tag] path:[Moodle_API GetPathOfDownloadFiles_fileName:[resource objectAtIndex:gr.view.tag] FromDir:[NSString stringWithFormat:@"/%@/%@",moodleid,moodleFileAssignmentKey]]];
    }
    else if (types==6)
    {
        [self handleSingle:[resource objectAtIndex:gr.view.tag] path:[Moodle_API GetPathOfDownloadFiles_fileName:[resource objectAtIndex:gr.view.tag] FromDir:[NSString stringWithFormat:@"/%@/%@",moodleid,moodleFileExamKey]]];
    }
    if (url!=nil) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

-(NSString *)subLabeltext:(NSIndexPath *)indexPath
{
    if (types == 1){
        NSDictionary* gradeInfo = [[moodleData objectForKey:moodleListKey] objectAtIndex:indexPath.row];
        return [gradeInfo objectForKey:moodleGradeKey];
    }
    if (types == 2&indexPath.section==0) {
        if (indexPath.row==0) {
            return  @"繳交期限   ";
        }
        else{
            NSTimeInterval time = [[[[moodleData objectForKey:moodleListKey] objectAtIndex:indexPath.row-1] objectForKey:moodleGradeEndKey] doubleValue];
            if (!time) {
                return nil;
            }
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-dd HH:mm"];
            NSString *strDate = [dateFormatter stringFromDate:date];
            [dateFormatter release];
            return strDate;
        }

    }
    return nil;
}

-(NSString *)textLabeltext:(NSIndexPath *)indexPath
{
    if (types == 1){
        NSDictionary* gradeInfo = [[moodleData objectForKey:moodleListKey] objectAtIndex:indexPath.row];
        NSString *str = nil;
        if ([gradeInfo objectForKey:moodleGradeCommentKey]) {
            str = [[gradeInfo objectForKey:moodleGradeNameKey] stringByAppendingFormat:@"\n(%@)",[gradeInfo objectForKey:moodleGradeCommentKey]];
        }
        else
            str = [gradeInfo objectForKey:moodleGradeNameKey];
        return str;
    }
    else if (types == 2){
        if (indexPath.section==0) {
            if (indexPath.row == 0)
                return @"            作業";
            else{
                return [[[moodleData objectForKey:moodleListKey] objectAtIndex:indexPath.row-1] objectForKey:moodleGradeNameKey];
            }

        }
        else{
            if (indexPath.row == 0)
                return @"                      作業資源";
            else{
                return [resource objectAtIndex:indexPath.row-1];
            }
        }
            
    }
    else if (types == 4||types == 6){
        if (indexPath.row == 0&&types == 6)
            return @"考試名稱與範圍";
        else if (types == 6)
            return [resource objectAtIndex:indexPath.row-1];
        else
            return [resource objectAtIndex:indexPath.row];
    }
    else if (types == 3){
        NSString* cellDisplay = [[resource objectAtIndex:indexPath.section] objectForKey:moodleInfoDescriptionKey];
       // NSLog(@"----------------\n%@",cellDisplay);
        if ([cellDisplay isEqualToString:@""]) {
            return [[resource objectAtIndex:indexPath.section] objectForKey:moodleInfoSummaryKey];
        }
        else
            return cellDisplay;
        
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UILabel *label = nil;
    UILabel *detailLabel = nil;
    if (cell == nil)
    {
        CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:CELL_STANDARD_FONT_SIZE];
        CGSize labelSize = [[self textLabeltext:indexPath] sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        CGFloat rowHeight = labelSize.height + 20.0f;
        label = [[UILabel alloc] init];
        detailLabel = [[UILabel alloc] init];
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        if (types==1){
            label.frame = CGRectMake(5, 0,220, rowHeight);
            detailLabel.frame = CGRectMake(230, 0,60, rowHeight);
        }
        else if (types==2){
            label.frame = CGRectMake(5, 0,180, rowHeight);
            detailLabel.frame = CGRectMake(190, 0,100, rowHeight);
        }
        else{
            label.frame = CGRectMake(5, 0,295, rowHeight);
            detailLabel.frame = CGRectMake(280, 0,20, rowHeight);
            
            if (types==3){
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5,290, rowHeight-10)];
                    NSLog([NSString stringWithFormat:@"<body width=320px style=\"word-wrap:break-word;\">%@</body>",[self textLabeltext:indexPath]]);
                    [webView loadHTMLString:[NSString stringWithFormat:@"<body width=320px style=\"word-wrap:break-word;\">%@</body>",[self textLabeltext:indexPath]] baseURL:nil];
                    webView.backgroundColor = [UIColor clearColor];
                    [webView setOpaque:NO];
                    webView.scrollView.scrollEnabled = NO;
                    webView.scrollView.bounces = NO;
                    webView.delegate = self;
                    webView.tag = indexPath.section*100+50;
                    [cell.contentView addSubview:webView];
                    
                });
                
            }
           
        }
        cell.backgroundColor = SECONDARY_GROUP_BACKGROUND_COLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (types==4)
            label.tag=indexPath.row;
        else if((types==2&&indexPath.section==1)||types==6)
            label.tag=indexPath.row-1;
        
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.numberOfLines = 0;
        label.font = [UIFont fontWithName:STANDARD_FONT size:CELL_STANDARD_FONT_SIZE];
        label.textColor = CELL_STANDARD_FONT_COLOR;
        label.backgroundColor = [UIColor clearColor];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.lineBreakMode = NSLineBreakByWordWrapping;
        detailLabel.numberOfLines = 0;
        
        [cell.contentView addSubview:label];
        [cell.contentView addSubview:detailLabel];
        if ( types != 3) {
            NSLog([self textLabeltext:indexPath]);
            label.text = [self textLabeltext:indexPath];
            detailLabel.text = [self subLabeltext:indexPath];
        }
        
        if (types==1&&[detailLabel.text floatValue]<60) {
            detailLabel.textColor = [UIColor redColor];
        }
        if (types==6) {
            label.textAlignment = NSTextAlignmentCenter;
        }
        if (types == 4||(types == 2&&indexPath.section==1&&indexPath.row>0) ||(types == 6&&indexPath.row>0)) {
            label.userInteractionEnabled = YES;
            label.textColor = [UIColor blueColor];
            UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myAction:)];
            [label addGestureRecognizer:gr];
            gr.numberOfTapsRequired = 1;
            gr.cancelsTouchesInView = NO;
        }
        else if((types == 2&&indexPath.row==0) ||(types == 6&&indexPath.row==0)){
            label.font = [UIFont fontWithName:BOLD_FONT size:CELL_STANDARD_FONT_SIZE];
            detailLabel.font = [UIFont fontWithName:BOLD_FONT size:CELL_STANDARD_FONT_SIZE];
        }
        

    }
    else
    {
        label = (UILabel *)[cell.contentView viewWithTag:indexPath.row];
    }
    
    if (types==5) {
        if (edit) {
            textView.frame = CGRectMake(0, 0, 300, [[UIScreen mainScreen] bounds].size.height-320);
        } else {
            textView.frame = CGRectMake(0, 0, 300, [[UIScreen mainScreen] bounds].size.height-55);
        }
        [cell.contentView addSubview:self.textView];
    }
    return cell;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [webView sizeToFit];
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:(webView.tag-50)/100];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];

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

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    edit = YES;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationLeft];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [delegatetype5 rightBarButtonItemOn];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [delegatetype5 rightBarButtonItemOff];
        NSUserDefaults *userPrefs = [NSUserDefaults standardUserDefaults];
        [userPrefs setObject:self.textView.text forKey:[moodleData objectForKey:courseIDKey]];
        [userPrefs synchronize];
    edit = NO;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:0], nil] withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)textViewDidChange:(UITextView *)textView{
    
}


-(NSString *)titleForHeaderInSection:(NSInteger)section
{
    NSString *headerTitle = nil;
    if (types==1) {
        switch (section) {
            case 0:
                headerTitle = @"作業成績";
                break;
                
            default:
                break;
        }
    }
    else if (types==3)
        headerTitle = [[resource objectAtIndex:section] objectForKey:moodleInfoTitleKey];

    return headerTitle;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (types==1||types==3) {
        CGFloat rowHeight = 0;
        UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
        CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
        NSString *cellText = nil;
        
        cellText = [self titleForHeaderInSection:section];
        CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        rowHeight = labelSize.height + 20.0f;
        
        return rowHeight;
    }
    return 1;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName=nil;
    if (types==3) {
        sectionName= @" ";
    }
    return sectionName;
}


- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (types==1||types==3) {
        NSString *headerTitle = [self titleForHeaderInSection:section];
        UIFont *font = [UIFont boldSystemFontOfSize:STANDARD_CONTENT_FONT_SIZE];
        CGSize size = [headerTitle sizeWithFont:font];
        CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(19.0, 3.0, appFrame.size.width - 19.0, size.height)];
        
        label.text = headerTitle;
        label.textColor = GROUPED_SECTION_FONT_COLOR;
        label.font = font;
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode=NSLineBreakByWordWrapping;
        label.numberOfLines=0;
        [label sizeToFit];
        UIView *labelContainer = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, appFrame.size.width, GROUPED_SECTION_HEADER_HEIGHT)] autorelease];
        labelContainer.backgroundColor = [UIColor clearColor];
        [labelContainer addSubview:label];
        [labelContainer sizeToFit];
        [label release];
        return labelContainer;
    }
    //return [[resource objectAtIndex:section] objectForKey:moodleResourceTitleKey];
    return nil;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
    if (types==3) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectMake(5, 5,290, 0)];
            [webView loadHTMLString:[self textLabeltext:indexPath] baseURL:nil];
            CGSize size = [webView sizeThatFits:CGSizeZero];
            getSize = size.height;
            NSLog(@"getSize1:%f",getSize);
        });
        NSLog(@"getSize2:%f",getSize);
        return getSize;
    }
*/
    
    UIWebView* webView = (UIWebView*)[self.tableView viewWithTag:indexPath.section*100+50];
    if (webView) {
        NSString *yourHTMLSourceCodeString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
        NSLog(@"======\n%@\n--------%f\n",yourHTMLSourceCodeString,webView.scrollView.contentSize.height+5);
        return webView.scrollView.contentSize.height+5;
    }
    
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:CELL_STANDARD_FONT_SIZE];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = @" ";
    cellText = [self textLabeltext:indexPath]; // just something to guarantee one line
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    rowHeight = labelSize.height + 20.0f;
    if (edit) {
        return [[UIScreen mainScreen] bounds].size.height-320;
    }
    else if (types==5) {
        return [[UIScreen mainScreen] bounds].size.height-155;
    }
    else
        return rowHeight;
}


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
