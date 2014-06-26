//
//  LoginResultViewController.m
//  library
//
//  Created by apple on 13/7/5.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "LoginResultViewController.h"
#import "TFHpple.h"
#import "BookDetailViewController.h"
#import "MBProgressHUD.h"
#import "SettingsModuleViewController.h"


@interface LoginResultViewController ()
@property (nonatomic, retain) NSMutableArray *maindata;
@property (nonatomic, retain) NSDictionary *historyData;
@property (nonatomic, retain) NSMutableArray *newData;
@property BOOL loginSuccess;
@end

@implementation LoginResultViewController
@synthesize maindata;
@synthesize historyData;
@synthesize page;
@synthesize newData;
@synthesize loginSuccess;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSInteger screenheight = [[UIScreen mainScreen] bounds].size.height;
        self.view.frame = CGRectMake(0, 0, 320,screenheight-110);
    }
    return self;
}

- (void)viewDidLoad
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
         [self.tableView setContentInset:UIEdgeInsetsMake(-35,0,-35,0)];
        
    }
    maindata = [[NSMutableArray alloc] init];
   
    historyData = [NSDictionary new];    
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

  /*  if (!(self.isMovingToParentViewController || self.isBeingPresented))
    {
        if([maindata count] != 0)
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#define library @"圖書館"


#pragma mark - delegate

-(BOOL)login:(NSString *)title
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

- (void) registerDeviceToken:(NSString *)title
{
    
}

-(void)fetchHistory{

    @try {
        newData = [NSMutableArray new];
        [newData removeAllObjects];
        NSString *account = [SettingsModuleViewController getLibraryAccount];
        NSString *pwd = [SettingsModuleViewController getLibraryPassword];
        NSString *historyPost = [[NSString alloc]initWithFormat:@"account=%@&password=%@&segment=%d",account,pwd,page];
        NSHTTPURLResponse *urlResponse = nil;
        NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
        NSString * queryURL = [NSString stringWithFormat:@"http://140.121.197.135:11114/LibraryHistoryAPI/getReadingHistory.do"];
        [request setURL:[NSURL URLWithString:queryURL]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[historyPost dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&urlResponse
                                                                 error:nil];
        newData =[NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        NSString* checkLogin = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        [maindata addObjectsFromArray:newData];
        [maindata retain];
        [self.tableView reloadData];
        
        if ([checkLogin rangeOfString:@"Login failed"].location == NSNotFound)
            loginSuccess=true;
        else{
            loginSuccess=false;
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
    @catch (NSException *exception) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
            //[self.navigationController popViewControllerAnimated:YES];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"無網路連接"
                                                                message:nil
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        });
    }
    @finally {
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

        if([newData count] == 0 || newData ==nil )return[maindata count];
        else if([newData count] < 10) return [newData count];
        else return[maindata count]+1;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *account = [SettingsModuleViewController getLibraryAccount];
    NSString *pwd = [SettingsModuleViewController getLibraryPassword];
    
    if ([account isEqual:@""] && [pwd  isEqual: @""])
        return [NSString stringWithFormat:@"\n帳密未設定\n請至主頁面→設定→圖書館 設定帳密"];
    else if([maindata count] == 0 && loginSuccess==true)
    {
        return [NSString stringWithFormat:@"\n沒有借閱歷史紀錄"];
    }
   else if (loginSuccess==false){
       return [NSString stringWithFormat:@"\n登入失敗\n請至主頁面→設定→圖書館 檢查設定"];
   }
    else
        return NULL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSString *MyIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    NSInteger screenwidth = [[UIScreen mainScreen] bounds].size.width;
    UILabel *name = nil;
    UILabel *date = nil;
    UILabel *namelabel = nil;
    UILabel *datelabel = nil;
    //UILabel *details = nil;
   // UILabel *detailsleabel = nil;
    UIFont *boldfont = [UIFont boldSystemFontOfSize:18.0];

    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        name = [[UILabel alloc] init];
        date = [[UILabel alloc] init];
        namelabel = [[UILabel alloc] init];
        datelabel = [[UILabel alloc] init];
        //details = [[UILabel alloc] init];
        //detailsleabel = [[UILabel alloc] init];
    }
    if (indexPath.row < [maindata count]){
        
    NSDictionary *book = [maindata objectAtIndex:indexPath.row];
    NSString *bookname = [book objectForKey:@"title"];
    NSString *bookdate = [book objectForKey:@"borrowDate"];
   // NSString *bookdetails = [book objectForKey:@"details"];

    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    UIFont *boldfont = [UIFont boldSystemFontOfSize:14.0];
    CGSize maximumLabelSize = CGSizeMake(200,9999);
    CGSize booknameLabelSize = [bookname sizeWithFont:font
                                    constrainedToSize:maximumLabelSize
                                        lineBreakMode:NSLineBreakByWordWrapping];
    CGSize bookStatusLabelSize = [bookdate sizeWithFont:font
                                        constrainedToSize:maximumLabelSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
    
    namelabel.frame = CGRectMake(5,7,80,15);
    namelabel.text = @"書名/作者：";
    namelabel.lineBreakMode = NSLineBreakByWordWrapping;
    namelabel.numberOfLines = 0;
    namelabel.textAlignment = NSTextAlignmentRight;
    namelabel.tag = indexPath.row;
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.font = boldfont;
    
    name.frame = CGRectMake(90,6,180,booknameLabelSize.height);
    name.text = bookname;
    name.lineBreakMode = NSLineBreakByWordWrapping;
    name.numberOfLines = 0;
    name.tag = indexPath.row;
    name.backgroundColor = [UIColor clearColor];
    name.font = font;
    
    datelabel.frame = CGRectMake(5,10 + booknameLabelSize.height + bookStatusLabelSize.height,80,15);
    datelabel.text = @"借書：";
    datelabel.lineBreakMode = NSLineBreakByWordWrapping;
    datelabel.numberOfLines = 0;
    datelabel.textAlignment = NSTextAlignmentRight;
    datelabel.tag = indexPath.row;
    datelabel.backgroundColor = [UIColor clearColor];
    datelabel.font = boldfont;
    
    date.frame = CGRectMake(90,10 + booknameLabelSize.height + bookStatusLabelSize.height,180,14);
    date.text = bookdate;
    date.lineBreakMode = NSLineBreakByWordWrapping;
    date.numberOfLines = 0;
    date.tag = indexPath.row;
    date.backgroundColor = [UIColor clearColor];
    date.font = font;
    
   /* detailsleabel.frame = CGRectMake(5,29 + booknameLabelSize.height,80,15);
    detailsleabel.text = @"細節：";
    detailsleabel.lineBreakMode = NSLineBreakByWordWrapping;
    detailsleabel.numberOfLines = 0;
    detailsleabel.textAlignment = NSTextAlignmentRight;
    detailsleabel.tag = indexPath.row;
    detailsleabel.backgroundColor = [UIColor clearColor];
    detailsleabel.font = boldfont;
    
    details.frame = CGRectMake(90,29 + booknameLabelSize.height,180,14);
    details.text = bookdetails;
    details.lineBreakMode = NSLineBreakByWordWrapping;
    details.numberOfLines = 0;
    details.tag = indexPath.row;
    details.backgroundColor = [UIColor clearColor];
    details.font = font;*/
    
    [cell.contentView addSubview:namelabel];
    [cell.contentView addSubview:name];
    
    [cell.contentView addSubview:datelabel];
    [cell.contentView addSubview:date];
  /*
    [cell.contentView addSubview:detailsleabel];
    [cell.contentView addSubview:details];*/
    
   cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    }
    else {
         NSString *MyIdentifier = [NSString stringWithFormat:@"moreArticlesCell"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        UILabel *morelabel = nil;
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            morelabel = [[UILabel alloc] init];
        }
        CGSize maximumLabelSize = CGSizeMake(200,9999);
        CGSize booknameLabelSize = [[NSString stringWithFormat:@"載入更多..."] sizeWithFont:boldfont
                                                                      constrainedToSize:maximumLabelSize
                                                                          lineBreakMode:NSLineBreakByWordWrapping];
        morelabel.frame = CGRectMake((screenwidth - booknameLabelSize.width)/2,7,booknameLabelSize.width,20);
        morelabel.tag = indexPath.row;
        morelabel.backgroundColor = [UIColor clearColor];
        morelabel.font = boldfont;
        morelabel.textColor = [UIColor brownColor];
        morelabel.text = @"載入更多...";
        
        [cell.contentView addSubview:morelabel];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row< [maindata count]){
    NSDictionary *book = [maindata objectAtIndex:indexPath.row];
    NSString *bookname = [book objectForKey:@"title"];
     NSString *bookdate = [book objectForKey:@"status"];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize maximumLabelSize = CGSizeMake(200,9999);
    CGSize booknameLabelSize = [bookname sizeWithFont:font
                                    constrainedToSize:maximumLabelSize
                                        lineBreakMode:NSLineBreakByWordWrapping];
    CGSize bookStatusLabelSize = [bookdate sizeWithFont:font
                                          constrainedToSize:maximumLabelSize
                                              lineBreakMode:NSLineBreakByWordWrapping];
    return 12 + booknameLabelSize.height +bookStatusLabelSize.height +16 + 4 + 19;
    }
    else
        return 32.0;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    if ([maindata count] == row)
    {
        ++page;
        [self.tableView setHidden:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
              
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.labelText = @"Loading";
        
            });
            
            [self fetchHistory];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
            });
        });
        [self.tableView reloadData];
        [self.tableView setHidden:NO];
    }else{
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.labelText = @"Loading";
                
            });
            NSDictionary *book = [maindata objectAtIndex:indexPath.row];
            BookDetailViewController *detailView = [[BookDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
            detailView.bookurl = [book objectForKey:@"bookDetailURL"];
            [detailView  fetchBookDetailAndReview];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:detailView animated:YES];
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];


            });
        });

    }
}

@end
