//
//  LoginOutResultViewController.m
//  library -個人圖書館-借出記錄
//
//  Created by apple on 13/7/21.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "LoginOutResultViewController.h"
#import "TFHpple.h"
#import "WOLSwitchViewController.h"
#import "MBProgressHUD.h"
#import "SettingsModuleViewController.h"
#import "NTOUNotification.h"

@interface LoginOutResultViewController ()
@property (nonatomic, strong) NSMutableArray *selectindexs;
@property (nonatomic,retain) NSMutableArray *maindata;
@property (nonatomic, strong) UIToolbar *actionToolbar;
@property (nonatomic, strong) UIActionSheet *acsheet;
@property (nonatomic) BOOL showing;
@property BOOL loginSuccess;
@property (nonatomic , retain) NSString * errMsg;
@end

@implementation LoginOutResultViewController
@synthesize selectindexs;
@synthesize maindata;
@synthesize fetchURL;
@synthesize actionToolbar;
@synthesize showing;
@synthesize switchviewcontroller;
@synthesize acsheet;
@synthesize userAccountId;
@synthesize loginSuccess;
@synthesize errMsg;
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
        //[self.tableView setContentInset:UIEdgeInsetsMake(-54,0,-54,0)];
    }

    
    selectindexs = [[NSMutableArray alloc] init];
    maindata = [[NSMutableArray alloc] init];
    [maindata retain];
    self.tableView.allowsMultipleSelection = YES;
    
    CGFloat toolbarHeight = [actionToolbar frame].size.height;
    actionToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - toolbarHeight - 20, self.view.bounds.size.width, toolbarHeight)];
    
    actionToolbar.barStyle = UIBarStyleDefault;
    //Set the toolbar to fit the width of the app.
    [actionToolbar sizeToFit];
    
    UIBarButtonItem *flexiblespace_l = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    flexiblespace_l.width = 12.0;
    
    UIBarButtonItem *allselectButton =[[UIBarButtonItem alloc]
                                       initWithTitle:@"全   選"
                                       style:UIBarButtonItemStyleBordered
                                       target:self
                                       action:@selector(allselect)];
    allselectButton.width = 110.0;
    
    UIBarButtonItem *flexiblespace_m = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    flexiblespace_m.width = 12.0;
    
    UIBarButtonItem *finishButton =[[UIBarButtonItem alloc]
                                    initWithTitle:@"續   借"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(keepSelectResBook)];
    finishButton.width = 110.0;
    
    UIBarButtonItem *flexiblespace_r = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    flexiblespace_r.width = 12.0;
    
    [actionToolbar setItems:[NSArray arrayWithObjects:flexiblespace_l,allselectButton,flexiblespace_m,finishButton,flexiblespace_r, nil]];

    
    [super viewDidLoad];
    
}

-(void)viewDidAppear:(BOOL)animated
{
  [[UIApplication sharedApplication].keyWindow addSubview:actionToolbar];
    if (!loginSuccess) {
        accountTableViewController *detailViewController = [[accountTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        detailViewController.title = library;
        detailViewController.explanation = @"帳號:     請輸入學號,敎職員證號或本館借書證號\n密碼:     您的身份證字號(預設值)\n\n若無法使用，請將您的《姓名》、《讀者證號》、《身份證號》E-mail 至hwa重新設定！\n        若您的證件曾經補發過一次，請在讀者證號後加二位數字01；補發二次，請加02；其餘類推。";
        detailViewController.accountStoreKey = libraryAccountKey;
        detailViewController.passwordStoreKey = libraryPasswordKey;
        detailViewController.loginSuccessStoreKey = libraryLoginSuccessKey;
        detailViewController.delegate = self;
        UINavigationController *navController = self.navigationController;
        
        // retain ourselves so that the controller will still exist once it's popped off
        [[self retain] autorelease];
        
        [navController popViewControllerAnimated:NO];
        [navController pushViewController:detailViewController animated:YES];
        [detailViewController release];
        UIAlertView *loginFail = [[UIAlertView alloc]
                           initWithTitle:nil message:@"帳號登入失敗，請重新輸入帳密。"
                           delegate:self cancelButtonTitle:@"確定"
                           otherButtonTitles:nil];
        [loginFail show];
        [loginFail release];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
    if (!(self.isMovingToParentViewController || self.isBeingPresented))
    {
        if([maindata count] != 0)
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [actionToolbar removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchoutHistory{
    NSError *error;
    NSData* bookdata = [[NSString stringWithContentsOfURL:[NSURL URLWithString:fetchURL] encoding:NSUTF8StringEncoding error:&error] dataUsingEncoding:NSUTF8StringEncoding];
    
    [self fetchout:bookdata];
}




#pragma mark - delegate

-(BOOL)login:(NSString *)title
{
    NSString *account = [SettingsModuleViewController getLibraryAccount];
    NSString *pwd = [SettingsModuleViewController getLibraryPassword];
    NSString *historyPost = [[NSString alloc]initWithFormat:@"account=%@&password=%@",account,pwd];
    NSHTTPURLResponse *urlResponse = nil;
    NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
    NSString * queryURL = [NSString stringWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/login.do"];
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



-(void)fetchout:(NSData*)bookdata
{
    @try {
        NSString *account = [SettingsModuleViewController getLibraryAccount];
        NSString *pwd = [SettingsModuleViewController getLibraryPassword];
        NSString *historyPost = [[NSString alloc]initWithFormat:@"account=%@&password=%@",account,pwd];
        NSHTTPURLResponse *urlResponse = nil;
        NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
        NSString * queryURL = [NSString stringWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/getCurrentBorrowedBooks.do"];
        [request setURL:[NSURL URLWithString:queryURL]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[historyPost dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&urlResponse
                                                                 error:nil];
        NSString* checkLogin = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
        maindata=  [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        [maindata retain];
        [self.tableView reloadData];
        
        if ([checkLogin rangeOfString:@"Login failed"].location == NSNotFound)
            loginSuccess=true;
        else
            loginSuccess=false;
        
    }
    @catch (NSException *exception) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
            
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
        [self.tableView reloadData];
    }
}

- (void)allselect
{
    NSInteger r;
    for (r = 0; r < [self.tableView numberOfRowsInSection:0]; r++) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:0]
                                    animated:YES
                              scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:0]];
    }
}

- (void)allcancel
{
    NSInteger r;
    for (r = 0; r < [self.tableView numberOfRowsInSection:0]; r++) {
        [[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:r inSection:0]] setAccessoryType:UITableViewCellAccessoryNone];
    }
}

-(void)keepSelectResBook
{
    
    UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"續借功能暫時關閉"
                                                     message:nil
                                                    delegate:self
                                           cancelButtonTitle:@"好"
                                           otherButtonTitles:nil];
    [alerts show];
    /* 2017/1/15關閉
    NSString *radioVal = [NSString new];
    if([selectindexs count] == 0)
    {
        UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"請選擇欲續借的紀錄"
                                                         message:nil
                                                        delegate:self
                                               cancelButtonTitle:@"好"
                                               otherButtonTitles:nil];
        [alerts show];
        return;
    }
    int isSuccess=0;
    for (int i = 0 ; i < [selectindexs count] ; i++) {
        NSIndexPath *index = [selectindexs objectAtIndex:i];
        NSDictionary *book = [maindata objectAtIndex:index.row];
        radioVal = [book objectForKey:@"radioValue"];
        NSString *account = [SettingsModuleViewController getLibraryAccount];
        NSString *pwd = [SettingsModuleViewController getLibraryPassword];
        NSString *historyPost = [[NSString alloc]initWithFormat:@"account=%@&password=%@&radioValue=%@",account,pwd,radioVal];
       
        NSHTTPURLResponse *urlResponse = nil;
        NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
        NSString * queryURL = [NSString stringWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/renewBook.do"];
        [request setURL:[NSURL URLWithString:queryURL]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[historyPost dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&urlResponse
                                                                 error:nil];
        NSDictionary *renewResponse=  [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        [maindata retain];
        if ([[renewResponse objectForKey:@"querySuccess"] isEqualToString:@"true"]) ++isSuccess;
        errMsg =[renewResponse objectForKey:@"errorMsg"];
    }
    if (isSuccess == [selectindexs count]){
        UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"續借成功"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"好"
                                                otherButtonTitles:nil];
        [alerts show];
        isSuccess = 0;
        [self cleanselectindexs];
    }
    else{
        UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"續借失敗"
                                                         message:errMsg
                                                        delegate:self
                                               cancelButtonTitle:@"好"
                                               otherButtonTitles:nil];
        [alerts show];
        isSuccess = 0;
        [self cleanselectindexs];
    }
    for (UITableViewCell *cell in [self.tableView visibleCells]) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    [self.tableView reloadData];
    */
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *cancelbook = [[NSString alloc] init];
    NSData *responseData = nil;
    for (int i = 0 ; i < [selectindexs count] ; i++) {
        NSIndexPath *index = [selectindexs objectAtIndex:i];
        NSDictionary *book = [maindata objectAtIndex:index.row];
        NSString *buf = [book objectForKey:@"id"];
        NSString *value = [book objectForKey:@"value"];
        cancelbook = [NSString stringWithFormat:@"%@&%@=%@",cancelbook,buf,value];
    }
    
    if(buttonIndex == [acsheet destructiveButtonIndex])
    {
        //是
        NSString *finalPost = [[NSString alloc]initWithFormat:@"currentsortorder=current_checkout%@&currentsortorder=current_checkout&renewsome=是",cancelbook];
        
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = [[[NSError alloc] init]autorelease];
        NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
        [request setURL:[NSURL URLWithString:fetchURL]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:[finalPost dataUsingEncoding:NSUTF8StringEncoding]];
        responseData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&urlResponse
                                                        error:&error];
    }
    else if(buttonIndex == [acsheet cancelButtonIndex])
    {
        //沒有
        NSString *finalPost = [[NSString alloc]initWithFormat:@"currentsortorder=current_checkout%@&currentsortorder=current_checkout&donothing=沒有",cancelbook];
        
        NSHTTPURLResponse *urlResponse = nil;
        NSError *error = [[[NSError alloc] init]autorelease];
        NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
        [request setURL:[NSURL URLWithString:fetchURL]];
        [request setHTTPMethod:@"POST"];
        [request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
        [request setHTTPBody:[finalPost dataUsingEncoding:NSUTF8StringEncoding]];
        responseData = [NSURLConnection sendSynchronousRequest:request
                                            returningResponse:&urlResponse
                                                        error:&error];
    }
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Show the HUD in the main tread
        dispatch_async(dispatch_get_main_queue(), ^{
            // No need to hod onto (retain)
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
            hud.labelText = @"Loading";
        });
        
        [self fetchout:responseData];
        [self cleanselectindexs];
        [self allcancel];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [maindata count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([maindata count] == 0 && loginSuccess == true)
        return 20;
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(0, 70, 320, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Helvetica" size:18];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    if ([maindata count] == 0 && loginSuccess == true) {
        label.text = [NSString stringWithFormat:@"沒有借出記錄"];
    }
    // Create header view and add label as a subview
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
    [view addSubview:label];
    
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *book = [maindata objectAtIndex:indexPath.row];
    NSString *bookname = [book objectForKey:@"title"];
    NSString *bookdate = [book objectForKey:@"status"];
   // NSString *bookbarcode = [book objectForKey:@"barcode"];
    //NSString *bookcallno = [book objectForKey:@"radioValue"];
   // NSString *bookkeep = [book objectForKey:@"keep"];
    NSString *MyIdentifier = [NSString stringWithFormat:@"Cell%d%@",indexPath.row,bookname];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    UILabel *name = nil;
    UILabel *date = nil;
    UILabel *namelabel = nil;
    UILabel *datelabel = nil;
    UILabel *barcode = nil;
    UILabel *barcodelabel = nil;
    UILabel *callno = nil;
    UILabel *callnoleabel = nil;
    UILabel *keeplabel = nil;
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        name = [[UILabel alloc] init];
        date = [[UILabel alloc] init];
        namelabel = [[UILabel alloc] init];
        datelabel = [[UILabel alloc] init];
        barcode = [[UILabel alloc] init];
        barcodelabel = [[UILabel alloc] init];
        callno = [[UILabel alloc] init];
        callnoleabel = [[UILabel alloc] init];
        keeplabel = [[UILabel alloc] init];
    }
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    UIFont *boldfont = [UIFont boldSystemFontOfSize:14.0];
    CGSize maximumLabelSize = CGSizeMake(200,9999);
    CGSize booknameLabelSize = [bookname sizeWithFont:font
                                    constrainedToSize:maximumLabelSize
                                        lineBreakMode:NSLineBreakByWordWrapping];
    CGSize bookStatusLabelSize = [bookdate sizeWithFont:font
                                    constrainedToSize:maximumLabelSize
                                        lineBreakMode:NSLineBreakByWordWrapping];
    
    namelabel.frame = CGRectMake(5,7,90,15);
    namelabel.text = @"書名/作者：";
    namelabel.lineBreakMode = NSLineBreakByWordWrapping;
    namelabel.numberOfLines = 0;
    namelabel.textAlignment = NSTextAlignmentRight;
    namelabel.tag = indexPath.row;
    namelabel.backgroundColor = [UIColor clearColor];
    namelabel.font = boldfont;
    
    name.frame = CGRectMake(100,6,180,booknameLabelSize.height);
    name.text = bookname;
    name.lineBreakMode = NSLineBreakByWordWrapping;
    name.numberOfLines = 0;
    name.tag = indexPath.row;
    name.backgroundColor = [UIColor clearColor];
    name.font = font;

    datelabel.frame = CGRectMake(5,10 + booknameLabelSize.height,90,15);
    datelabel.text = @"狀態：";
    datelabel.lineBreakMode = NSLineBreakByWordWrapping;
    datelabel.numberOfLines = 0;
    datelabel.textAlignment = NSTextAlignmentRight;
    datelabel.tag = indexPath.row;
    datelabel.backgroundColor = [UIColor clearColor];
    datelabel.font = boldfont;
    
    date.frame = CGRectMake(100,10 + booknameLabelSize.height,180,bookStatusLabelSize.height);
    date.text = bookdate;
    date.lineBreakMode = NSLineBreakByWordWrapping;
    date.numberOfLines = 0;
    date.tag = indexPath.row;
    date.backgroundColor = [UIColor clearColor];
    date.font = font;
    
    [cell.contentView addSubview:namelabel];
    [cell.contentView addSubview:name];
    
    [cell.contentView addSubview:datelabel];
    [cell.contentView addSubview:date];
    
   //[cell.contentView addSubview:barcodelabel];
   // [cell.contentView addSubview:barcode];
        
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *book = [maindata objectAtIndex:indexPath.row];
    NSString *bookname = [book objectForKey:@"title"];
    NSString *bookStatus = [book objectForKey:@"status"];
    UIFont *nameFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize maximumLabelSize = CGSizeMake(200,9999);
    CGSize booknameLabelSize = [bookname sizeWithFont:nameFont
                                    constrainedToSize:maximumLabelSize
                                    lineBreakMode:NSLineBreakByWordWrapping];
    CGSize bookStatusLabelSize = [bookStatus sizeWithFont:nameFont
                                    constrainedToSize:maximumLabelSize
                                        lineBreakMode:NSLineBreakByWordWrapping];
    
    return 6 + booknameLabelSize.height +bookStatusLabelSize.height + 22;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL selected = NO;
    for(NSIndexPath *index in selectindexs)
    {
        if([indexPath isEqual:index])
            selected = YES;
    }
    
    if(selected == NO)
    {
        [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
        [selectindexs addObject:indexPath];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [selectindexs removeObject:indexPath];
    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
}

-(void)cleanselectindexs
{
    [selectindexs removeAllObjects];
}

@end
