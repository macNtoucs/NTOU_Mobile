//
//  SearchResultViewController.m
//  library-搜尋結果
//
//  Created by R MAC on 13/5/31.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "SearchResultViewController.h"
#import "BookDetailViewController.h"
#import "MBProgressHUD.h"

@interface SearchResultViewController ()
@property (nonatomic,strong) NSMutableDictionary *urlData;
@property (nonatomic) NSInteger urlLength;
@property (nonatomic,strong) NSMutableDictionary *pageData;

@property (nonatomic,strong) NSMutableArray *tableData_book;
@property (nonatomic, strong) NSArray * newSearchBooks;
@property (nonatomic) NSNumber* totalBookNumber;
@property (nonatomic) NSNumber* firstBookNumber;
@property (nonatomic ,retain) NSMutableArray *imgFinish;

@end

@implementation SearchResultViewController
@synthesize urlData;
@synthesize mainview;
@synthesize data;
@synthesize inputtext;
@synthesize urlLength;
@synthesize pageData;
@synthesize start;
@synthesize book_count;
@synthesize tableData_book;
@synthesize newSearchBooks;
@synthesize totalBookNumber;
@synthesize firstBookNumber;
@synthesize Searchpage;
@synthesize searchType;
@synthesize imgFinish;
@synthesize storyTable;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        storyTable = [[PullTableView alloc] initWithFrame:self.view.bounds];
        storyTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        storyTable.delegate = self;
        storyTable.dataSource = self;
        //storyTable.separatorColor = [UIColor colorWithWhite:0.5 alpha:1.0];
        storyTable.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
        storyTable.pullDelegate = self;
        storyTable.frame = CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height);
        self.tableView = storyTable;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    if ([searchType  isEqual: @"i"]){
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:0];
        if ([self.tableView.delegate respondsToSelector:
             @selector(tableView:didSelectRowAtIndexPath:)]) {
            [self.tableView.delegate tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            searchType = @"X";
        }
    }
}

- (void)viewDidLoad
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    // [self search];
    
    
    
    
    pageData = [[NSMutableDictionary alloc] init];
    tableData_book = [[NSMutableArray alloc] init];
    urlData = [[NSMutableDictionary alloc] init];
    newSearchBooks =[NSArray new];
    imgFinish = [NSMutableArray new];
    /*
     UILabel *titleView = (UILabel *)self.navigationItem.titleView;
     titleView = [[UILabel alloc] initWithFrame:CGRectZero];
     titleView.backgroundColor = [UIColor clearColor];
     titleView.font = [UIFont boldSystemFontOfSize:18.0];
     NSString * tittleString = [NSString stringWithFormat:@"   查詢結果 共%@筆", totalBookNumber];
     titleView.text =tittleString;
     
     [titleView sizeToFit];
     
     self.navigationItem.titleView = titleView;
     */
    //配合nagitive和tabbar的圖片變動tableview的大小
    //nagitive 52 - 44 = 8 、 tabbar 55 - 49 = 6
    [self.tableView setContentInset:UIEdgeInsetsMake(8,0,6,0)];
    
    
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)search{

    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Show the HUD in the main tread
        dispatch_async(dispatch_get_main_queue(), ^{
            // No need to hod onto (retain)
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow  animated:YES];
            hud.labelText = @"Loading";
        });
        @try {
            NSError *error;
            //  設定url
            NSString *url;
            if ([searchType  isEqual: @"X"]){
                url = [NSString stringWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/Search.do?searcharg=%@&searchtype=X&segment=%d",inputtext,Searchpage];
                url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            else{
                url = [NSString stringWithFormat:@"http://140.121.100.103:8080/NTOULibraryAPI/Search.do?searcharg=%@&searchtype=i&segment=%d",inputtext,Searchpage];
                url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            }
            // 設定丟出封包，由data來接
            NSData* urldata = [[NSString stringWithContentsOfURL:[NSURL URLWithString:url]encoding:NSUTF8StringEncoding error:&error] dataUsingEncoding:NSUTF8StringEncoding];
        
            NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:urldata options:0 error:nil];
        
            newSearchBooks = [NSMutableArray arrayWithArray:[dic objectForKey:@"bookResult"]];
            totalBookNumber =  [dic objectForKey:@"totalBookNumber"];
            firstBookNumber =[dic objectForKey:@"firstBookNumber"];
            [newSearchBooks retain];
            [totalBookNumber retain];
            [firstBookNumber retain];
            
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

        dispatch_async(dispatch_get_main_queue(), ^{
            start = YES;
            [self getContentTotal];
            [self.tableView reloadData];
            [storyTable flashScrollIndicators];
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
            //self.title = [NSString stringWithFormat:@"共 %@ 筆", totalBookNumber];
            UILabel* lbNavTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,40,320,40)];
            lbNavTitle.textAlignment = NSTextAlignmentCenter;
            if(totalBookNumber == NULL)
                lbNavTitle.text = [NSString stringWithFormat:@"共 0 筆"];
            else
                lbNavTitle.text = [NSString stringWithFormat:@"共 %@ 筆", totalBookNumber];
            lbNavTitle.backgroundColor = [UIColor clearColor];
            self.navigationItem.titleView = lbNavTitle;
            [lbNavTitle release];
            
            UILabel *pageStatus = [[UILabel alloc]initWithFrame:CGRectMake(0,
                                                                           40,
                                                                           80,
                                                                           44)];
            [pageStatus setFont:[UIFont fontWithName:@"Helvetica" size:15]];
            [pageStatus setBackgroundColor:[UIColor clearColor]];
            pageStatus.textAlignment = NSTextAlignmentRight;
            if ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0) pageStatus.textColor = [UIColor whiteColor];
            [pageStatus setText:[NSString stringWithFormat:@"1~%lu 筆",(unsigned long)[data count]]];
            if([data count]==0)  [pageStatus setText: @""];
            
            UIBarButtonItem *pageStatusButtonItem = [[UIBarButtonItem alloc] initWithCustomView:pageStatus];
            
            self.navigationItem.rightBarButtonItem = pageStatusButtonItem;
            start = NO;
        });
    });
     
    
}


//截取書的資料(書名、作者、圖片...etc)
-(void)getContentTotal{
    //分析 newSearchBooks 內容 並串接到 data 達到載入更多的效果
    [data addObjectsFromArray:newSearchBooks];
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
    NSString *nextpage_url = [pageData objectForKey:@"nextpage"];
    
    if(nextpage_url != NULL || [firstBookNumber intValue] +10 < [totalBookNumber intValue])  //後面還有書
        return [data count];
    else if ([data count] == 0 && start == YES) //沒有查獲的館藏
        return 1;
    else
        return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger screenwidth = [[UIScreen mainScreen] bounds].size.width;
    UIFont *boldfont = [UIFont boldSystemFontOfSize:18.0];
    
    if ([data count] == 0)  //沒有查獲的館藏
    {
        NSString *MyIdentifier = @"nobookArticles";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        UILabel *nolabel = nil;
        if (cell == nil)
        {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            nolabel = [[UILabel alloc] init];
        }
        
        CGSize maximumLabelSize = CGSizeMake(200,9999);
        CGSize booknameLabelSize = [[NSString stringWithFormat:@"沒有查獲的館藏"] sizeWithFont:boldfont
                                                                      constrainedToSize:maximumLabelSize
                                                                          lineBreakMode:NSLineBreakByWordWrapping];
        nolabel.frame = CGRectMake((screenwidth - booknameLabelSize.width)/2,11,booknameLabelSize.width,20);
        nolabel.tag = indexPath.row;
        nolabel.backgroundColor = [UIColor clearColor];
        nolabel.font = boldfont;
        nolabel.text = @"沒有查獲的館藏";
        
        [cell.contentView addSubview:nolabel];
        return cell;
    }
    else if(indexPath.row < [data count])
    {
        NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld",(long)indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        UILabel *presslabel = nil;
        UILabel *booklabel = nil;
        UILabel *authorlabel = nil;
        UILabel *imgLoadinglabel = nil;
        
        if (cell == nil)
        {
            presslabel = [[UILabel alloc] init];
            booklabel = [[UILabel alloc] init];
            authorlabel = [[UILabel alloc] init];
            imgLoadinglabel = [[UILabel alloc]init];
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        UIFont *nameFont = [UIFont fontWithName:@"Helvetica" size:14.0];
        UIFont *otherFont = [UIFont fontWithName:@"Helvetica" size:12.0];
        UIFont *loadingFont = [UIFont fontWithName:@"Helvetica" size:8.0];
        
        NSDictionary *book = [data objectAtIndex:indexPath.row];
        NSString *bookname = [book objectForKey:@"title"];
        NSString *image_url = [book objectForKey:@"image"];
        NSString *author = [book objectForKey:@"author"];
        NSString *press = [book objectForKey:@"pubInform"];
        NSArray *electricBook = [book objectForKey:@"electricBookDetail"];
        if ([electricBook count]!=0) bookname = [NSString stringWithFormat:@"[電子資源]%@",bookname];
        if([image_url isEqualToString:@""])
            image_url = @"http://static.findbook.tw/image/book/1419879251/large";
        CGSize booknameLabelSize,authorLabelSize,pressLabelSize;
        CGRect booknameLabelRect, authorLabelRect,pressLabelRect;
        CGSize maximumLabelSize = CGSizeMake(200,9999);
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
            
            booknameLabelRect = [bookname boundingRectWithSize:maximumLabelSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:nameFont}
                                                       context:nil];
            
            
            authorLabelRect = [author boundingRectWithSize:maximumLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:otherFont}
                                                   context:nil];
            
            pressLabelRect = [press boundingRectWithSize:maximumLabelSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:otherFont}
                                                 context:nil];
            booknameLabelSize = booknameLabelRect.size;
            authorLabelSize = authorLabelRect.size;
            pressLabelSize = pressLabelRect.size;
            
        }
        else {
            booknameLabelSize = [bookname sizeWithFont:nameFont
                                     constrainedToSize:maximumLabelSize
                                         lineBreakMode:NSLineBreakByWordWrapping];
            authorLabelSize = [author sizeWithFont:otherFont
                                 constrainedToSize:maximumLabelSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
            
            pressLabelSize = [press sizeWithFont:otherFont
                               constrainedToSize:maximumLabelSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        
        if([press isEqualToString:@""])
            pressLabelSize.height = 0;
        if([author isEqualToString:@""])
            authorLabelSize.height = 0;
        
        CGFloat height = 11 + booknameLabelSize.height + authorLabelSize.height + pressLabelSize.height;
        CGFloat imageY = height/2 - 80/2;
        if(imageY < 6)
            imageY = 6;
        
        imgLoadinglabel.frame = CGRectMake(10,imageY,60,80);
        imgLoadinglabel.text = @"圖片載入中...";
        imgLoadinglabel.lineBreakMode = NSLineBreakByWordWrapping;
        imgLoadinglabel.font= loadingFont;
        [cell.contentView addSubview:imgLoadinglabel];
        float spaceHeight = 6;
        if ((booknameLabelSize.height+authorLabelSize.height+pressLabelSize.height) < 76)
            spaceHeight = (92 - (booknameLabelSize.height+authorLabelSize.height+pressLabelSize.height))/2 -2;
        NSLog(@"indexPath.row:%d  spaceHeight:%f",indexPath.row,spaceHeight);
        booklabel.frame = CGRectMake(80,spaceHeight,200,booknameLabelSize.height);
        booklabel.text = bookname;
        booklabel.lineBreakMode = NSLineBreakByWordWrapping;
        booklabel.numberOfLines = 0;
        booklabel.tag = indexPath.row;
        booklabel.backgroundColor = [UIColor clearColor];
        booklabel.font = nameFont;
        //booklabel.textColor = CELL_STANDARD_FONT_COLOR;
        [cell.contentView addSubview:booklabel];
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            NSData * imageData = [[NSData alloc] initWithContentsOfURL:[ NSURL URLWithString: image_url ]];
            dispatch_sync(dispatch_get_main_queue(), ^{
                UIImageView *imageview = [[UIImageView alloc] initWithImage: [UIImage imageWithData: imageData]];
                imageview.frame = CGRectMake(10,imageY,60,80);
                [cell.contentView addSubview:imageview];
                [imgLoadinglabel removeFromSuperview];
            });

        });
     
        
        if(![author isEqualToString:@""])
        {
            authorlabel.frame = CGRectMake(80,spaceHeight+2 + booknameLabelSize.height,200,authorLabelSize.height);
            authorlabel.tag = indexPath.row;
            authorlabel.lineBreakMode = NSLineBreakByWordWrapping;
            authorlabel.numberOfLines = 0;
            authorlabel.backgroundColor = [UIColor clearColor];
            authorlabel.font = otherFont;
            authorlabel.textColor = [UIColor grayColor];
            authorlabel.text = author;
            [cell.contentView addSubview:authorlabel];
        }
        
        if(![press isEqualToString:@""])
        {
            presslabel.frame = CGRectMake(80,spaceHeight+4 + booknameLabelSize.height + authorLabelSize.height,200,pressLabelSize.height);
            presslabel.text = press;
            presslabel.lineBreakMode = NSLineBreakByWordWrapping;
            presslabel.numberOfLines = 0;
            presslabel.tag = indexPath.row;
            presslabel.backgroundColor = [UIColor clearColor];
            presslabel.font = otherFont;
            presslabel.textColor = [UIColor grayColor];
            [cell.contentView addSubview:presslabel];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return cell;
    }
    else
    {
        NSString *MyIdentifier = @"moreArticles";
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
    if([data count] == 0)  //沒有查獲的館藏
        return 40.0;
    if(indexPath.row < [data count])
    {
        NSDictionary *book = [data objectAtIndex:indexPath.row];
        NSString *bookname = [book objectForKey:@"title"];
        NSString *author = [book objectForKey:@"author"];
        NSString *press = [book objectForKey:@"pubInform"];
        NSArray * eBookDetail = [book objectForKey:@"electricBookDetail"];
        if ([eBookDetail count]!=0) bookname = [NSString stringWithFormat:@"[電子資源]%@",bookname]; //[電子資源也要進去算行數]
        
        UIFont *nameFont = [UIFont fontWithName:@"Helvetica" size:14.0];
        UIFont *otherFont = [UIFont fontWithName:@"Helvetica" size:12.0];
        UIFont *loadingFont = [UIFont fontWithName:@"Helvetica" size:8.0];
        
        
        CGSize booknameLabelSize,authorLabelSize,pressLabelSize;
        CGRect booknameLabelRect, authorLabelRect,pressLabelRect;
        CGSize maximumLabelSize = CGSizeMake(200,9999);
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
            
            booknameLabelRect = [bookname boundingRectWithSize:maximumLabelSize
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:nameFont}
                                                       context:nil];
            
            
            authorLabelRect = [author boundingRectWithSize:maximumLabelSize
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:otherFont}
                                                   context:nil];
            
            pressLabelRect = [press boundingRectWithSize:maximumLabelSize
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:otherFont}
                                                 context:nil];
            booknameLabelSize = booknameLabelRect.size;
            authorLabelSize = authorLabelRect.size;
            pressLabelSize = pressLabelRect.size;
            
        }
        else {
            booknameLabelSize = [bookname sizeWithFont:nameFont
                                     constrainedToSize:maximumLabelSize
                                         lineBreakMode:NSLineBreakByWordWrapping];
            authorLabelSize = [author sizeWithFont:otherFont
                                 constrainedToSize:maximumLabelSize
                                     lineBreakMode:NSLineBreakByWordWrapping];
            
            pressLabelSize = [press sizeWithFont:otherFont
                               constrainedToSize:maximumLabelSize
                                   lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        
        
        if([press isEqualToString:@""])
            pressLabelSize.height = 0;
        if([author isEqualToString:@""])
            authorLabelSize.height = 0;
        
        CGFloat height = 16 + booknameLabelSize.height + authorLabelSize.height + pressLabelSize.height;
        CGFloat imageheight = 92;
        NSLog(@"indexPath.row:%d  height:%f",indexPath.row,height);
        return ( height > imageheight )? height : imageheight;
    }
    else
        return 32.0;
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
    NSUInteger row = [indexPath row];
    
    if ([data count] == 0)  //沒有查獲的館藏
        return;
    
    if(row < [data count])
    {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
                hud.labelText = @"Loading";
                
            });
            BookDetailViewController *detailView = [[BookDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
            detailView.bookurl = [[data objectAtIndex:row] objectForKey:@"URL"];
            [detailView  fetchBookDetailAndReview];
           
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController pushViewController:detailView animated:YES];
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
                
                
            });
        });
        
    }
    else
    {
        ++Searchpage;
        [self search];
    }
}

#pragma mark - Refresh and load more methods

- (void) refreshTable
{
    Searchpage = 1;
    [data removeAllObjects];
    [self search];
    
    self.storyTable.pullLastRefreshDate = [NSDate date];
    self.storyTable.pullTableIsRefreshing = NO;
}


- (void) loadMoreDataToTable
{
    ++Searchpage;
    [self search];
    self.storyTable.pullTableIsLoadingMore = NO;
}

#pragma mark - PullTableViewDelegate

- (void)pullTableViewDidTriggerRefresh:(PullTableView *)pullTableView
{
    [self performSelector:@selector(refreshTable) withObject:nil afterDelay:0];
}

- (void)pullTableViewDidTriggerLoadMore:(PullTableView *)pullTableView
{
    [self performSelector:@selector(loadMoreDataToTable) withObject:nil afterDelay:0];
}

@end