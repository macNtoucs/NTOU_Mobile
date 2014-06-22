//
//  NewsViewController.m
//  library
//
//  Created by su on 13/7/5.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "NewsViewController.h"
#import "MBProgressHUD.h"
#import "TFHpple.h"
#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f
@interface NewsViewController ()
@end

@implementation NewsViewController
@synthesize NEWSdata;

-(void)loadNews
{
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
    //配合nagitive和tabbar的圖片變動tableview的大小
    //nagitive 52 - 44 = 8 、 tabbar 55 - 49 = 6
    [self.tableView setContentInset:UIEdgeInsetsMake(8,0,6,0)];
    
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
    return [NEWSdata count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
   
    NSDictionary *news = [NEWSdata objectAtIndex:indexPath.row];
    NSString *newstitle = [[news objectForKey:@"news_title"]objectForKey:@"text"];
    cell.textLabel.text = newstitle;
    cell.font = [UIFont fontWithName:@"Helvetica" size:14.0];
    cell.textLabel.numberOfLines = 0;
    [cell setLineBreakMode:UILineBreakModeCharacterWrap];

    cell.detailTextLabel.text = [[news objectForKey:@"news_date"]objectForKey:@"text"];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    cell.detailTextLabel.textColor = [UIColor grayColor];
    [NEWSdata retain];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
     NSDictionary *news = [NEWSdata objectAtIndex:indexPath.row];
    NSString *text = [[news objectForKey:@"news_title"]objectForKey:@"text"];
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    CGFloat height = size.height + 12 + 16 + 2;
    
    return height;
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
    /*
    loadWebViewController* load = [[loadWebViewController alloc] init];
    load.stringurl = [[NEWSdata objectAtIndex:indexPath.row] objectForKeyedSubscript:@"url"];
    load.title = @"";
    */
    UIViewController *load = [[UIViewController alloc] init];
    NSString *weburl = [[[NEWSdata objectAtIndex:indexPath.row] objectForKey:@"news_url"]objectForKey:@"text"];
    
    if (weburl==nil) return;
    UIWebView *webView = [[[UIWebView alloc] initWithFrame: [[UIScreen mainScreen] bounds]] autorelease];
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString: weburl ] ]];
    [load.view addSubview: webView];
    load.title = weburl;

    [self.navigationController pushViewController:load animated:YES];
    
}




@end
