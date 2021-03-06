//
//  AboutViewController.m
//  library-關於圖書館首頁
//
//  Created by su on 13/7/3.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "AboutViewController.h"
#import "NewsViewController.h"
#import "floorInfoViewController.h"
#import "AccountViewController.h"
#import "UIKit+NTOUAdditions.h"
#import "OpenTimeTableViewController.h"
#import "ContactInfoTableViewController.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface AboutViewController ()
@property (strong, nonatomic) AccountViewController *loginaccount;
@end

@implementation AboutViewController
@synthesize loginaccount;

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
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    [self.tableView applyStandardColors];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    loginaccount = [[AccountViewController alloc] init];
    loginaccount.title=@"帳戶登錄";
        
    //配合nagitive和tabbar的圖片變動tableview的大小
    //nagitive 52 - 44 = 8 、 tabbar 55 - 49 = 6
    [self.tableView setContentInset:UIEdgeInsetsMake(20,0,6,0)];
    
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NULL;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
               switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"最新消息";
                       break;
                case 1:
                    cell.textLabel.text = @"開館時間";
                    break;
                case 2:
                    cell.textLabel.text = @"樓層簡介";
                    break;
                case 3:
                       cell.textLabel.text = @"聯絡資訊";
                       break;
                case 4:
                       cell.textLabel.text = @"電子書籍";
                       break;
                default:
                    break;
               }
    
    
    return cell;

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    switch (indexPath.row)
    {
       
                case 0:
                {
                    NewsViewController *news = [[NewsViewController alloc]init];
                    news.title= @"最新消息";
                    [self.navigationController pushViewController:news  animated:YES];
                    [news release];
                    break;
                }

                case 1:
                {
                    OpenTimeTableViewController *op = [[OpenTimeTableViewController alloc]init];
                    op.title= @"開館時間";
                    [self.navigationController pushViewController:op  animated:YES];
                    [op release];
                    break;
                }
                case 2:
                {
                    floorInfoViewController *floorinfo = [[floorInfoViewController alloc] init];
                    floorinfo.title=@"樓層簡介";
                    [self.navigationController pushViewController:floorinfo  animated:YES];
                    [floorinfo release];
                    break;
                }
            
        case 3: {
                    ContactInfoTableViewController *contact = [[[ContactInfoTableViewController alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
                    [self.navigationController pushViewController:contact  animated:YES];
                    break;
        }
            
            case 4:{
                if([self hasWifi]) //若有網路
                {
                    UIViewController *load = [[UIViewController alloc] init];
                    NSString *weburl = @"http://li.ntou.edu.tw/4net/search.php?databases_categoy=ii&top_cet=b";
                
                    if (weburl==nil) return;
                    UIWebView *webView = [[[UIWebView alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];
                    webView.scalesPageToFit = YES;
                    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: weburl ] ]];
                    [load.view addSubview: webView];
                    load.title = @"電子書籍";
                
                    [self.navigationController pushViewController:load animated:YES];
                } else {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"無網路連接"
                                                                        message:nil
                                                                       delegate:self
                                                              cancelButtonTitle:@"OK"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    [alertView release];
                }
                break;
            }
            
            default:
                break;
         }
    }


@end
