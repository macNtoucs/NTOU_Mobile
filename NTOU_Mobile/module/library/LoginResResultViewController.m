//
//  LoginResResultViewController.m
//  library
//
//  Created by apple on 13/7/19.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "LoginResResultViewController.h"
#import "TFHpple.h"
#import "WOLSwitchViewController.h"
#import "MBProgressHUD.h"
#import "SettingsModuleViewController.h"

@interface LoginResResultViewController ()
@property (nonatomic, strong) NSMutableArray *selectindexs;
@property (nonatomic,retain) NSMutableArray *maindata;
@property (nonatomic, strong) UIActionSheet *acsheet;
@property (nonatomic) BOOL showing;
@property (nonatomic,retain) UIToolbar *actionToolbar;
@property BOOL loginSuccess;
@end

@implementation LoginResResultViewController
@synthesize selectindexs;
@synthesize maindata;
@synthesize fetchURL;
@synthesize showing;
@synthesize switchviewcontroller;
@synthesize acsheet;
@synthesize userAccountId;
@synthesize actionToolbar;
@synthesize loginSuccess;
int isSuccess=0;
bool shouldCancel = false;


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
        [self.tableView setContentInset:UIEdgeInsetsMake(-19,0,-19,0)];
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
                                    initWithTitle:@"取消預約"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(cancelSelectResBook)];
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

    if(!(self.isMovingToParentViewController || self.isBeingPresented))
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



-(void)fetchresHistory{
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        @try {
            NSString *account = [SettingsModuleViewController getLibraryAccount];
            NSString *pwd = [SettingsModuleViewController getLibraryPassword];
            NSString *historyPost = [[NSString alloc]initWithFormat:@"account=%@&password=%@",account,pwd];
            NSHTTPURLResponse *urlResponse = nil;
            NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
            NSString * queryURL = [NSString stringWithFormat:@"http://140.121.197.135:11114/LibraryHistoryAPI/getCurrentHolds.do"];
            [request setURL:[NSURL URLWithString:queryURL]];
            [request setHTTPMethod:@"POST"];
            [request setHTTPBody:[historyPost dataUsingEncoding:NSUTF8StringEncoding]];
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                         returningResponse:&urlResponse
                                                                     error:nil];
            NSString* checkLogin = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                        NSArray * reponseDataArray = [NSArray new];
            reponseDataArray= [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            maindata = [NSMutableArray arrayWithArray:reponseDataArray];
            [maindata retain];
            if ([checkLogin rangeOfString:@"Login failed"].location == NSNotFound)
                loginSuccess=true;
            else
                loginSuccess=false;
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
        
        
    });
    
    dispatch_barrier_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });

    
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

-(void) doCancelAction{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Show the HUD in the main tread
        dispatch_async(dispatch_get_main_queue(), ^{
            // No need to hod onto (retain)
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.superview animated:YES];
            hud.labelText = @"Loading";
        });
        NSDictionary * Jsonresponse = [NSDictionary new];
        
        NSMutableArray * postVal = [NSMutableArray new];
        for (int i = 0 ; i < [selectindexs count] ; i++) {
            NSIndexPath *index = [selectindexs objectAtIndex:i];
            NSString * radioVal = [NSString new];
            NSDictionary *book = [maindata objectAtIndex: index.row ] ;
            radioVal = [book objectForKey:@"radioValue"];
            NSMutableDictionary *rv = [NSMutableDictionary new];
            [rv setValue:radioVal forKey:@"radioValue"];
            [postVal addObject: rv];
            [rv release];
            
        }//end for
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postVal options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSString *account = [SettingsModuleViewController getLibraryAccount];
        NSString *pwd = [SettingsModuleViewController getLibraryPassword];
        NSString *historyPost = [[NSString alloc]initWithFormat:@"account=%@&password=%@&radioValue=%@",account,pwd,jsonString];
        NSHTTPURLResponse *urlResponse = nil;
        NSMutableURLRequest * request = [[NSMutableURLRequest new]autorelease];
        NSString * queryURL = [NSString stringWithFormat:@"http://140.121.197.135:11114/LibraryHistoryAPI/cancelReserveBook.do"];
        [request setURL:[NSURL URLWithString:queryURL]];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[historyPost dataUsingEncoding:NSUTF8StringEncoding]];
        NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&urlResponse
                                                                 error:nil];
        Jsonresponse=  [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
        [Jsonresponse retain];
        
        if ([[Jsonresponse objectForKey:@"querySuccess"] isEqualToString:@"true"]) {
            ++isSuccess;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector: @selector(fetchresHistory) withObject: nil afterDelay:0.5];
        });
        
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            if(isSuccess)
            {
                UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"取消成功"
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"好"
                                                       otherButtonTitles:nil];
                [alerts show];
            }
            else {
                UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"取消失敗"
                                                                 message:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"好"
                                                       otherButtonTitles:nil];
                [alerts show];
            }
            
            [MBProgressHUD hideHUDForView:self.view.superview animated:YES];
            [self.tableView reloadData];
            [selectindexs removeAllObjects];
        });
        
    });
}


- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:{
            [self doCancelAction];
            break;
        }    }
}

    
-(void)cancelSelectResBook
{
    if([selectindexs count] == 0)
    {
        UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:@"請選擇欲取消的預約"
                                                         message:nil
                                                        delegate:nil
                                               cancelButtonTitle:@"好"
                                               otherButtonTitles:nil];
        [alerts show];
        return;
    }
    else {
        NSString * title = [NSString stringWithFormat:@"即將取消%d本書", [selectindexs count]];
       UIAlertView *alerts = [[UIAlertView alloc] initWithTitle:title
                                                                             message:nil
                                                                            delegate:self
                                                                   cancelButtonTitle:@"取消"
                                                                   otherButtonTitles:@"好",nil];
          [alerts show];
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[maindata count]);
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
        label.text = [NSString stringWithFormat:@"沒有預約記錄"];
    }
    // Create header view and add label as a subview
    UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)] autorelease];
    [view addSubview:label];
    
    return view;
}

- (void) alignLabelWithTop:(UILabel *)label {
    CGSize maxSize = CGSizeMake(label.frame.size.width, 999);
    label.adjustsFontSizeToFitWidth = NO;
    // get actual height
    CGSize actualSize = [label.text sizeWithFont:label.font constrainedToSize:maxSize lineBreakMode:label.lineBreakMode];
    CGRect rect = label.frame;
    rect.size.height = actualSize.height;
    label.frame = rect;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *book = [maindata objectAtIndex:indexPath.row];
    NSString *bookname = [book objectForKey:@"title"];
    NSString *bookdate = [book objectForKey:@"status"];
    NSString *bookplace = [book objectForKey:@"location"];
    //NSString *bookcancel = [book objectForKey:@"cancel"];
    NSString *MyIdentifier = [NSString stringWithFormat:@"Cell%d%@",indexPath.row,bookname];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    UILabel *name = nil;
    UILabel *date = nil;
    UILabel *namelabel = nil;
    UILabel *datelabel = nil;
    UILabel *place = nil;
    UILabel *placelabel = nil;
    UILabel *cancel = nil;
    UILabel *cancelleabel = nil;
    
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        name = [[UILabel alloc] init];
        date = [[UILabel alloc] init];
        namelabel = [[UILabel alloc] init];
        datelabel = [[UILabel alloc] init];
        place = [[UILabel alloc] init];
        placelabel = [[UILabel alloc] init];
        cancel = [[UILabel alloc] init];
        cancelleabel = [[UILabel alloc] init];
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
    
    datelabel.frame = CGRectMake(5,10 + booknameLabelSize.height , 90,15);
    datelabel.text = @"狀態：";
    datelabel.lineBreakMode = NSLineBreakByWordWrapping;
    datelabel.numberOfLines = 0;
    datelabel.textAlignment = NSTextAlignmentRight;
    datelabel.tag = indexPath.row;
    datelabel.backgroundColor = [UIColor clearColor];
    datelabel.font = boldfont;
    
    date.frame = CGRectMake(100,10 + booknameLabelSize.height ,180,bookStatusLabelSize.height);
    date.text = bookdate;
    date.lineBreakMode = NSLineBreakByWordWrapping;
    date.numberOfLines = 0;
    date.tag = indexPath.row;
    //[self alignLabelWithTop:date];
    date.backgroundColor = [UIColor clearColor];
    date.font = font;
    
    placelabel.frame = CGRectMake(5,30 + booknameLabelSize.height + bookStatusLabelSize.height/2,90,15);
    placelabel.text = @"取書館藏地：";
    placelabel.lineBreakMode = NSLineBreakByWordWrapping;
    placelabel.numberOfLines = 0;
    placelabel.textAlignment = NSTextAlignmentRight;
    placelabel.tag = indexPath.row;
    placelabel.backgroundColor = [UIColor clearColor];
    placelabel.font = boldfont;
    
    place.frame = CGRectMake(100,30 + booknameLabelSize.height + bookStatusLabelSize.height/2,180,14);
    place.text = bookplace;
    place.lineBreakMode = NSLineBreakByWordWrapping;
    place.numberOfLines = 0;
    place.tag = indexPath.row;
    place.backgroundColor = [UIColor clearColor];
    place.font = font;
  
    
    [cell.contentView addSubview:namelabel];
    [cell.contentView addSubview:name];
    
    [cell.contentView addSubview:datelabel];
    [cell.contentView addSubview:date];
    
    [cell.contentView addSubview:placelabel];
    [cell.contentView addSubview:place];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *book = [maindata objectAtIndex:indexPath.row];
    NSString *bookname = [book objectForKey:@"title"];
    NSString *bookdate = [book objectForKey:@"status"];
    NSString *bookLocation = [book objectForKey:@"location"];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize maximumLabelSize = CGSizeMake(200,9999);
    
    
    
    CGSize booknameLabelSize, bookStatusLabelSize, bookLocationLabelSize;
     CGRect booknameLabelRect, bookStatusLabelRect,bookLocationLabelRect;
       
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        booknameLabelRect = [bookname boundingRectWithSize:maximumLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:font}
                                                   context:nil];
        
        
        bookStatusLabelRect = [bookdate boundingRectWithSize:maximumLabelSize
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil];
        
        bookLocationLabelRect = [bookLocation boundingRectWithSize:maximumLabelSize
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:font}
                                             context:nil];
        booknameLabelSize = booknameLabelRect.size;
        bookStatusLabelSize = bookStatusLabelRect.size;
        bookLocationLabelSize = bookLocationLabelRect.size;
        
    }
    else {
        
         booknameLabelSize = [bookname sizeWithFont:font
                                        constrainedToSize:maximumLabelSize
                                            lineBreakMode:NSLineBreakByWordWrapping];
         bookStatusLabelSize = [bookdate sizeWithFont:font
                                          constrainedToSize:maximumLabelSize
                                              lineBreakMode:NSLineBreakByWordWrapping];
        
         bookLocationLabelSize = [bookLocation sizeWithFont:font
                                                constrainedToSize:maximumLabelSize
                                                    lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return  booknameLabelSize.height + bookStatusLabelSize.height + bookLocationLabelSize.height + 10*3;
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
