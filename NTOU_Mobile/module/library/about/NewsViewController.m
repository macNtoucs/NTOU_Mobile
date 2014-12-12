//
//  NewsViewController.m
//  library-關於圖書館-最新消息
//
//  Created by su on 13/7/5.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "NewsViewController.h"
#import "MBProgressHUD.h"
#import "TFHpple.h"
#import <netinet/in.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define FONT_SIZE 14.0f
#define ARROW_WIDTH 20.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
@interface NewsViewController ()
@property (nonatomic) BOOL nowWifi;
@end

@implementation NewsViewController
@synthesize NEWSdata;
@synthesize nowWifi;

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


-(void)loadNews
{
    nowWifi = [self hasWifi];   //統一偵測有無網路，避免跑到一半突然有網路的狀況
    if(!nowWifi)
        return;
    NSData* urldata = [[NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://lib.ntou.edu.tw/mobil_client/lib_news_xml.php"]encoding:NSUTF8StringEncoding error:nil] dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [[NSDictionary alloc]init];
    dic =[XMLReader dictionaryForXMLData:urldata error:nil];
    NEWSdata = [[dic objectForKey:@"root"]objectForKey:@"news"];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NEWSdata = [[NSArray alloc] init];
    [self loadNews];
    [NEWSdata retain];
    //配合nagitive和tabbar的圖片變動tableview的大小
    //nagitive 52 - 44 = 8 、 tabbar 55 - 49 = 6
    //[self.tableView setContentInset:UIEdgeInsetsMake(8,0,6,0)];
    
    [super viewDidLoad];

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(nowWifi) //若有網路
        return [NEWSdata count];
    else
        return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(nowWifi) //若有網路
    {
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        
        NSDictionary *news = [NEWSdata objectAtIndex:indexPath.row];
        NSString *newstitle = [[news objectForKey:@"news_title"]objectForKey:@"text"];
        cell.textLabel.text = newstitle;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
        cell.textLabel.numberOfLines = 0;
        [cell setLineBreakMode:UILineBreakModeCharacterWrap];
        
        cell.detailTextLabel.text = [[news objectForKey:@"news_date"]objectForKey:@"text"];
        cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else {
        UILabel *nolabel = nil;
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            nolabel = [[UILabel alloc] init];
        }
        
        UIFont *boldfont = [UIFont boldSystemFontOfSize:18.0];
        
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
        
        CGSize maximumLabelSize = CGSizeMake(200,9999);
        CGSize booknameLabelSize = [[NSString stringWithFormat:@"無網路連接"] sizeWithFont:boldfont
                                                                      constrainedToSize:maximumLabelSize
                                                                          lineBreakMode:NSLineBreakByWordWrapping];
        nolabel.frame = CGRectMake((screenWidth - booknameLabelSize.width)/2,11,booknameLabelSize.width,20);
        
        nolabel.font = boldfont;
        nolabel.text = [NSString stringWithFormat:@"無網路連接"];
        [cell.contentView addSubview:nolabel];
    }
    
    [NEWSdata retain];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGSize size;
    CGRect rect;
    
    if(nowWifi) //若有網路
    {
        NSDictionary *news = [NEWSdata objectAtIndex:indexPath.row];
        NSString *text = [[news objectForKey:@"news_title"]objectForKey:@"text"];
    
        CGRect screenBound = [[UIScreen mainScreen] bounds];
        CGSize screenSize = screenBound.size;
        CGFloat screenWidth = screenSize.width;
    
        CGSize constraint = CGSizeMake(screenWidth - (CELL_CONTENT_MARGIN * 2) - ARROW_WIDTH, 10000.0f);
        UIFont *labelFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    
        CGSize maximumLabelSize = CGSizeMake(screenWidth - (CELL_CONTENT_MARGIN * 2) - ARROW_WIDTH,10000.0f);
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
            rect = [text boundingRectWithSize:maximumLabelSize
                    options:NSStringDrawingUsesLineFragmentOrigin
                    attributes:@{NSFontAttributeName:labelFont}
                    context:nil];
            size = rect.size;
        
        }
        else {
            size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE]
                    constrainedToSize:constraint
                    lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        CGFloat height = size.height + 12 + 16 + 2;
        
        return height;
    }else
        return 40.0;
}

-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (progress == 0.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        progressView.progress = 0;
        [UIView animateWithDuration:0.27 animations:^{
            progressView.alpha = 1.0;
        }];
    }
    if (progress == 1.0) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        [UIView animateWithDuration:0.27 delay:progress - progressView.progress options:0 animations:^{
            progressView.alpha = 0.0;
        } completion:nil];
    }
    
    [progressView setProgress:progress animated:NO];
}



#define NAV_X self.navigationController.navigationBar.frame.origin.x
#define NAV_Y self.navigationController.navigationBar.frame.origin.y
#define NAV_HEIGHT self.navigationController.navigationBar.frame.size.height
#define NAV_WIDTH   self.navigationController.navigationBar.frame.size.width
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0){
        progressView.frame = CGRectMake(NAV_X,
                                        NAV_Y+NAV_HEIGHT,
                                        NAV_WIDTH ,
                                        20);
    }else{
        progressView.frame = CGRectMake(NAV_X,
                                        -3,
                                        NAV_WIDTH ,
                                        20);
        
    }
       
     NSString *weburl = [[[NEWSdata objectAtIndex:indexPath.row] objectForKey:@"news_url"]objectForKey:@"text"];
    UIViewController *webViewController = [[[UIViewController alloc]init] autorelease];
    UIWebView *webView = [[[UIWebView alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)
    {
        CGRect webFrame = webView.frame;
        webFrame.size.height -= 64;
        webView.frame = webFrame;
    }
    webView.scalesPageToFit = YES;
    NJKWebViewProgress *_progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weburl]]];
    [webViewController.view addSubview: webView];
    [webView addSubview:progressView];
    [self.navigationController pushViewController:webViewController animated:YES];
    
    }




@end
