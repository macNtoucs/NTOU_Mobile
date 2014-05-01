//
//  StoryDetailViewController.m
//  NTOU_Mobile
//
//  Created by mac_hero on 13/3/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "StoryDetailViewController.h"

@interface StoryDetailViewController ()

@end

@implementation StoryDetailViewController
@synthesize story;
@synthesize webView = _webView;
@synthesize textView;
@synthesize textSubView;
@synthesize dataTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString *)stringToDeleteLineAndTab:(NSString *)oldString
{
    return [[oldString stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect dataFrame;
    //if (buttonDisplay) {
    dataFrame = CGRectMake(0, 0, 320, 180);
    /* } else {
     dataFrame = CGRectMake(0, 0, 320, 45);
     }*/

    dataTableView = [[UITableView alloc] initWithFrame:dataFrame style:UITableViewStylePlain];
    dataTableView.dataSource = self;
    dataTableView.delegate = self;
    dataTableView.scrollEnabled = NO;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height)];
    else
        textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-60)];
    
    textView.editable = NO;
    textView.scrollEnabled = YES;
    
    // 一行大約20個中文字
    NSInteger lineNum = [[[[[story objectForKey:NewsAPIKeyTitle] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""] length] / 17 + 1;
    //if (buttonDisplay) {
    textSubView = [[UITextView alloc] initWithFrame:CGRectMake(0, 181, 320, lineNum*35)];
    /*} else {
     textSubView = [[UITextView alloc] initWithFrame:CGRectMake(0, 46, 320, lineNum*50)];
     }*/
    textSubView.text = [[[[story objectForKey:NewsAPIKeyTitle] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    textSubView.editable = NO;
    textSubView.userInteractionEnabled = NO;
    textSubView.backgroundColor = [UIColor clearColor];
    [textSubView setFont:[UIFont boldSystemFontOfSize:18.0]];
    
    [dataTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.navigationItem.title = [[[[story objectForKey:NewsAPIKeyTitle]objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    
    NSInteger newLineHeight = lineNum*1.5;
    //NSLog(@"newLineHeight = %i", newLineHeight);
    
    NSString * newLine;
    //if (buttonDisplay) {
    newLine = [[NSString alloc] initWithString:@"\n\n\n\n\n\n\n\n\n\n\n"];
    /*} else {
     newLine = [[NSString alloc] initWithString:@"\n\n\n"];
     }*/
    for (NSInteger i = 0; i < newLineHeight; i ++)
    {
        newLine = [newLine stringByAppendingString:@"\n"];
    }
    
    textView.font = [UIFont systemFontOfSize:15.0];
    textView.text = [newLine stringByAppendingString:[self stringToDeleteLineAndTab:[[story objectForKey:NewsAPIKeyBody] objectForKey:NewsAPIKeyText]]];
    
    [textView addSubview:dataTableView];
    [textView addSubview:textSubView];
    [self.view addSubview:textView];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    /*NSString * tmpDate = @"公告日期：";
     NSString * tmpUndertaker = @"承辦人員：";
     NSString * tmpContact = @"聯絡方式：";
     NSString * tmpAttachment = @"附        件：";*/
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    switch (indexPath.row)
    {
        case 0:
            //cell.textLabel.text = tmpDate;
            //cell.detailTextLabel.text = [story objectAtIndex:0];
            cell.textLabel.text = [[[[story objectForKey:NewsAPIKeyStartdate] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            cell.imageView.image = [UIImage imageNamed:@"news/home-calendar.png"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news/cell1.png"]];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            break;
        case 1:
            //cell.textLabel.text = tmpUndertaker;
            //cell.detailTextLabel.text = [story objectAtIndex:1];
            cell.textLabel.text = [[[[story objectForKey:NewsAPIKeyPromoter] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            cell.imageView.image = [UIImage imageNamed:@"news/home-people.png"];
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news/cell2.png"]];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            break;
        case 2:
            //cell.textLabel.text = tmpContact;
            //cell.detailTextLabel.text = [story objectAtIndex:2];
            cell.textLabel.text = [[[[story objectForKey:NewsAPIKeyTel]  objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            cell.imageView.image = [UIImage imageNamed:@"news/action-phone.png"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news/cell3.png"]];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            break;
        case 3:
            //cell.textLabel.text = tmpAttachment;
            //cell.detailTextLabel.text = [story objectAtIndex:5];
            cell.textLabel.text = nil;
            cell.imageView.image = [UIImage imageNamed:@"news/action-pdf"];
            cell.contentView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"news/cell4.png"]];
            cell.detailTextLabel.backgroundColor = [UIColor clearColor];
            break;
    }
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1)
    {
        [self openMail];
    }
    else if (indexPath.row == 2)
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",cell.textLabel.text]]];
    else if (indexPath.row == 3)
    {
        // 放附件連結
    }
}


-(void)openMail
{
    if([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:[NSString stringWithFormat:@"%@",[[[[story objectForKey:NewsAPIKeyTitle] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""]]];
        NSArray *toRecipients = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",[[[[story objectForKey:NewsAPIKeyEmail] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""]], nil];
        [mailer setToRecipients:toRecipients];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your deice"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed.:");
            break;
            
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    [self dismissModalViewControllerAnimated:YES];
}


@end
