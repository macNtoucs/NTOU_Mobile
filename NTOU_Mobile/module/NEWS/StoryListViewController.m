//
//  StoryListViewController.m
//  NTOU_Mobile
//
//  Created by mac_hero on 13/3/14.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//
#import "StoryListViewController.h"
#import "UIKit+NTOUAdditions.h"
#import "NTOUUIConstants.h"

#define SCROLL_TAB_HORIZONTAL_PADDING 5.0
#define SCROLL_TAB_HORIZONTAL_MARGIN  5.0

#define THUMBNAIL_WIDTH 76.0
#define ACCESSORY_WIDTH_PLUS_PADDING 18.0
#define STORY_TEXT_PADDING_TOP 3.0 // with 15pt titles, makes for 8px of actual whitespace
#define STORY_TEXT_PADDING_BOTTOM 7.0 // from baseline of 12pt font, is roughly 5px
#define STORY_TEXT_PADDING_LEFT 7.0
#define STORY_TEXT_PADDING_RIGHT 7.0
#define STORY_TEXT_WIDTH (320.0 - STORY_TEXT_PADDING_LEFT - STORY_TEXT_PADDING_RIGHT  - ACCESSORY_WIDTH_PLUS_PADDING) // 8px horizontal padding
#define STORY_TEXT_HEIGHT (THUMBNAIL_WIDTH - STORY_TEXT_PADDING_TOP - STORY_TEXT_PADDING_BOTTOM) // 8px vertical padding (bottom is less because descenders on dekLabel go below baseline)
#define STORY_TITLE_FONT_SIZE 15.0
#define STORY_DEK_FONT_SIZE 12.0

#define SEARCH_BUTTON_TAG 7947
#define BOOKMARK_BUTTON_TAG 7948

@interface StoryListViewController (Private)

- (void)NTOU;
- (void)setupNavScrollButtons;
- (void)buttonPressed:(id)sender;

- (void)setupActivityIndicator;
- (void)setStatusText:(NSString *)text;
- (void)setLastUpdated:(NSDate *)date;
- (void)setProgress:(CGFloat)value;

- (void)showSearchBar;
- (void)hideSearchBar;
- (void)releaseSearchBar;

- (void)pruneStories:(BOOL)asyncPrune;

@end

@implementation StoryListViewController
@synthesize activeCategoryId;
@synthesize catchData;
@synthesize connect;
@synthesize storyTable;
NSString *const NewsCategoryAnnounce = @"學校公告";
NSString *const NewsCategorySymposium = @"研討會";
NSString *const NewsCategoryArt = @"藝文活動";
NSString *const NewsCategoryLecture = @"演講公告";
NSString *const NewsCategoryDocument = @"電子公文";
NSString *const NewsCategoryInformation = @"校外訊息";

NewsCategoryId buttonCategories[] = {
    NewsCategoryIdAnnounce, NewsCategoryIdSymposium,
    NewsCategoryIdArt, NewsCategoryIdLecture,
    /*NewsCategoryIdDocument,*/ NewsCategoryIdInformation,
};

NSString *titleForCategoryId(NewsCategoryId category_id) {
    NSString *result = nil;
    switch (category_id)
    {
        case NewsCategoryIdAnnounce:
            result = NewsCategoryIdAnnounceAPI;
            break;
        case NewsCategoryIdSymposium:
            result = NewsCategorySymposiumAPI;
            break;
        case NewsCategoryIdArt:
            result = NewsCategoryArtAPI;
            break;
        case NewsCategoryIdLecture:
            result = NewsCategoryLectureAPI;
            break;
        case NewsCategoryIdDocument:
            result = NewsCategoryDocumentAPI;
            break;
        case NewsCategoryIdInformation:
            result = NewsCategoryInformationAPI;
            break;
        default:
            break;
    }
    return result;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)loadView
{
    [super loadView];
    self.navigationItem.title = @"最新消息";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)] autorelease];
    
    tempTableSelection = nil;
    storyTable = [[PullTableView alloc] initWithFrame:self.view.bounds];
    storyTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    storyTable.delegate = self;
    storyTable.dataSource = self;
    storyTable.separatorColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    [self.view addSubview:storyTable];
    [storyTable release];
}

- (void)viewDidLoad
{
    self.storyTable.pullArrowImage = [UIImage imageNamed:@"blackArrow"];
    self.storyTable.pullDelegate = self;
    [super viewDidLoad];
    
    [self setupNavScroller];
    
    // set up results table
    storyTable.frame = CGRectMake(0, navScrollView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - navScrollView.frame.size.height);
    [self setupActivityIndicator];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        
    }	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavScrollButtons];
    // Unselect the selected row
    [tempTableSelection release];
    tempTableSelection = [[storyTable indexPathForSelectedRow] retain];
    if (tempTableSelection)
    {
        [storyTable beginUpdates];
        [storyTable deselectRowAtIndexPath:tempTableSelection animated:YES];
        [storyTable endUpdates];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!pageCount[self.activeCategoryId]) {
        [self loadFromCache];
    }
    if (tempTableSelection)
    {
        [storyTable reloadRowsAtIndexPaths:[NSArray arrayWithObject:tempTableSelection] withRowAnimation:UITableViewRowAnimationNone];
        [tempTableSelection release];
        tempTableSelection = nil;
    }
}

- (void)refresh:(id)sender
{
    [tableDisplayData[self.activeCategoryId] release];
    tableDisplayData[self.activeCategoryId] = nil;
    pageCount[self.activeCategoryId] = 0;
    endCatchData[self.activeCategoryId] = false;
    [self loadFromCache];
}


- (void)loadFromCache
{
    if (self.connect) {
        [connect CancelConnection];
    }
    connect = [[Announce_API alloc] init];
    connect.delegate = self;
    [connect getAnnounceInfo_Count:NewsCatchDataCount andType:titleForCategoryId(buttonCategories[self.activeCategoryId]) andPage:pageCount[self.activeCategoryId]+1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Category selector
- (void)setupNavScroller
{
    // Nav Scroller View
    navScrollView = [[NavScrollerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44.0)];
    navScrollView.navScrollerDelegate = self;
    
    [self.view addSubview:navScrollView];
}

- (void)setupNavScrollButtons
{
    [navScrollView removeAllButtons];
    
    // add search button
    
    // add pile of text buttons
    
    // create buttons for nav scroller view
    NSArray *buttonTitles = [NSArray arrayWithObjects:
                             NewsCategoryAnnounce,NewsCategorySymposium,NewsCategoryArt,NewsCategoryLecture
                             ,NewsCategoryInformation,nil];
    
    //NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:[buttonTitles count]];
    
    NSInteger i = 0;
    for (NSString *buttonTitle in buttonTitles)
    {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
         [aButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        aButton.tag = buttonCategories[i];
        [aButton setTitle:buttonTitle forState:UIControlStateNormal];
        i++;
        [navScrollView addButton:aButton shouldHighlight:YES];
    }
    
    UIButton *homeButton = [navScrollView buttonWithTag:self.activeCategoryId];
    [navScrollView buttonPressed:homeButton];
}

- (void)buttonPressed:(id)sender
{
    UIButton *pressedButton = (UIButton *)sender;
    [self switchToCategory:pressedButton.tag];

}

- (void)switchToCategory:(NewsCategoryId)category
{
    if (category != self.activeCategoryId)
    {
        if (self.connect) {
            [self.connect CancelConnection];
            self.connect = nil;
        }
        [self setStatusText:@""];
        self.activeCategoryId = category;
        
        [storyTable reloadData];
        if (!pageCount[self.activeCategoryId]) {
            [self loadFromCache];
        } // makes request to server if no request has been made this session
    }
}


#pragma mark -
#pragma mark UITableViewDataSource and UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self->tableDisplayData[self.activeCategoryId] count]?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (endCatchData[self.activeCategoryId]==true) 
        return [self->tableDisplayData[self.activeCategoryId] count];
    return [self->tableDisplayData[self.activeCategoryId] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = THUMBNAIL_WIDTH;
    
    if (indexPath.row < [self->tableDisplayData[self.activeCategoryId] count])
    {
        rowHeight = THUMBNAIL_WIDTH;
    }
    else
    {
        rowHeight = 50; // "Load more articles..."
    }


    return rowHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *result = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StoryCell"] autorelease];
    //NSLog(@"%@,%d",indexPath,[self->tableDisplayData[self.activeCategoryId] count]);
    switch (indexPath.section)
    {
        case 0:
        {
            if (indexPath.row < [self->tableDisplayData[self.activeCategoryId] count])
            {
                NSDictionary *story = [self->tableDisplayData[self.activeCategoryId] objectAtIndex:indexPath.row];
                
                static NSString *StoryCellIdentifier = @"StoryCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:StoryCellIdentifier];
                
                UILabel *titleLabel = nil;
                UILabel *dekLabel = nil;
                UILabel *dpLabel = nil;
                
               // if (cell == nil)
               // {
                    // Set up the cell
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StoryCellIdentifier] autorelease];
                    
                    // Title View
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                    titleLabel.tag = 1;
                    titleLabel.font = [UIFont fontWithName:@"Helvetica" size:14.0];
                    titleLabel.numberOfLines = 0;
                    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
                    [cell.contentView addSubview:titleLabel];
                    [titleLabel release];
                    
                   /* // Summary View
                    dekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                    dekLabel.tag = 2;
                    dekLabel.font = [UIFont systemFontOfSize:STORY_DEK_FONT_SIZE];
                    dekLabel.textColor = [UIColor colorWithHexString:@"#0D0D0D"];
                    dekLabel.highlightedTextColor = [UIColor whiteColor];
                    dekLabel.numberOfLines = 0;
                    dekLabel.lineBreakMode = UILineBreakModeTailTruncation;
                    [cell.contentView addSubview:dekLabel];
                    [dekLabel release];*/

                    /*dpLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                    dpLabel.tag = 3;
                    dpLabel.font = [UIFont systemFontOfSize:STORY_DEK_FONT_SIZE];
                    dpLabel.textColor = [UIColor colorWithHexString:@"#0D0D0D"];
                    dpLabel.backgroundColor = [UIColor clearColor];
                    dpLabel.highlightedTextColor = [UIColor whiteColor];
                    dpLabel.numberOfLines = 0;
                    dpLabel.lineBreakMode = UILineBreakModeTailTruncation;
                    [cell.contentView addSubview:dpLabel];
                    [dpLabel release];
*/
                    
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                //}
                
                NSMutableString * News_Titile = [NSMutableString new];
            /*   News_Titile appendString: [[story objectForKey:NewsAPIKeyTitle] objectForKey:NewsAPIKeyText] ];
              // News_Titile =@" test";
                
                for (size_t i = 0; i<News_Titile.length ; ++i){
                    unichar ch = [News_Titile characterAtIndex: i];
                    printf("%x:%c\n", ch,ch);
                }
                */
                 [News_Titile appendString:[NSString stringWithFormat: @"日期：%@",[[[[story objectForKey:NewsAPIKeyStartdate] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""] ]];
                 [News_Titile stringByReplacingOccurrencesOfString:@" " withString:@""];
                
               
                [News_Titile appendString:[NSString stringWithFormat:@"\n來源：%@",[[[[story objectForKey:NewsAPIKeyDpname] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""] ]];
                
                [News_Titile appendString:[NSString stringWithFormat:@"\n主旨：%@",[[[[story objectForKey:NewsAPIKeyTitle] objectForKey:NewsAPIKeyText] stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""] ]];
                
                
                
                
                  titleLabel = (UILabel *)[cell viewWithTag:1];
                dekLabel = (UILabel *)[cell viewWithTag:2];
                dpLabel = (UILabel *)[cell viewWithTag:3];
                titleLabel.text =[NSString stringWithString:News_Titile] ;
               /* dekLabel.text = [[[[story objectForKey:NewsAPIKeyStartdate] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                dpLabel.text = [[[[story objectForKey:NewsAPIKeyDpname] objectForKey:NewsAPIKeyText]stringByReplacingOccurrencesOfString:@"\n" withString:@""]stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                */
                titleLabel.textColor = [UIColor blackColor];
                titleLabel.highlightedTextColor = [UIColor whiteColor];
    
                titleLabel.frame = CGRectMake(STORY_TEXT_PADDING_LEFT,
                                              STORY_TEXT_PADDING_TOP+NewsCatchDataCount,
                                            STORY_TEXT_WIDTH,
                                              THUMBNAIL_WIDTH-15-STORY_TEXT_PADDING_TOP);
               /* dekLabel.frame = CGRectMake(180+STORY_TEXT_PADDING_LEFT,
                                            THUMBNAIL_WIDTH-15,
                                            STORY_TEXT_WIDTH,
                                            15);
                dpLabel.frame = CGRectMake(30+STORY_TEXT_PADDING_LEFT,
                                            THUMBNAIL_WIDTH-15,
                                            STORY_TEXT_WIDTH,
                                            15);
               titleLabel.frame = CGRectMake(STORY_TEXT_PADDING_LEFT,
                                              THUMBNAIL_WIDTH-15,
                                              STORY_TEXT_WIDTH,
                                              15);
                dekLabel.frame =  CGRectMake(STORY_TEXT_PADDING_LEFT,
                                             STORY_TEXT_PADDING_TOP,
                                             STORY_TEXT_WIDTH,
                                             THUMBNAIL_WIDTH-15-STORY_TEXT_PADDING_TOP);
                dpLabel.frame = CGRectMake(30+STORY_TEXT_PADDING_LEFT,
                                           THUMBNAIL_WIDTH-15,
                                           STORY_TEXT_WIDTH,
                                           15);
                */
                result = cell;
            }
            else if (indexPath.row == [self->tableDisplayData[self.activeCategoryId] count])
            {
                NSString *MyIdentifier = @"moreArticles";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
                if (cell == nil)
                {
                    // Set up the cell
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier] autorelease];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                    
                    UILabel *moreArticlesLabel = [[UILabel alloc] initWithFrame:cell.frame];
                    moreArticlesLabel.font = [UIFont boldSystemFontOfSize:16];
                    moreArticlesLabel.numberOfLines = 1;
                    moreArticlesLabel.textColor = [UIColor colorWithHexString:@"m"];
                    moreArticlesLabel.text = @"載入更多..."; // just something to make it place correctly
                    [moreArticlesLabel sizeToFit];
                    moreArticlesLabel.tag = 1234;
                    CGRect frame = moreArticlesLabel.frame;
                    frame.origin.x = 10;
                    frame.origin.y = ((NSInteger)(50.0 - moreArticlesLabel.frame.size.height)) / 2;
                    moreArticlesLabel.frame = frame;
                    
                    [cell.contentView addSubview:moreArticlesLabel];
                    [moreArticlesLabel release];
                }
                
               // UILabel *moreArticlesLabel = (UILabel *)[cell viewWithTag:1234];
               /* if (moreArticlesLabel)
                {
                    NSInteger remainingArticlesToLoad = (!searchResults) ? (200 - [self.stories count]) : (searchTotalAvailableResults - [self.stories count]);
                    moreArticlesLabel.text = [NSString stringWithFormat:@"Load %d more articles...", (remainingArticlesToLoad > 10) ? 10 : remainingArticlesToLoad];
                    if (!self.connect)
                    { // disable when a load is already in progress
                        moreArticlesLabel.textColor = [UIColor colorWithHexString:@"#990000"]; // enable
                    }
                    else
                    {
                        moreArticlesLabel.textColor = [UIColor colorWithHexString:@"#999999"]; // disable
                    }
                    
                    
                    [moreArticlesLabel sizeToFit];
                }
                */
                result = cell;
            }
        }
            break;
    }
    return result;
}


- (void)tableView:(UITableView *)tv didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self->tableDisplayData[self.activeCategoryId] count])
    {
        [self loadFromCache];
    }
    else
    {
        NewsDetailViewController *detailViewController = [[NewsDetailViewController alloc] init];
        NSDictionary *story = [self->tableDisplayData[self.activeCategoryId] objectAtIndex:indexPath.row];
        detailViewController.story = story;
        [self.navigationController pushViewController:detailViewController animated:YES];
        detailViewController.navigationItem.leftBarButtonItem.title=@"back";
        [detailViewController release];
    }
}




#pragma mark -
#pragma mark Bottom status bar

- (void)setStatusText:(NSString *)text
{
    UILabel *loadingLabel = (UILabel *)[activityView viewWithTag:10];
    UIProgressView *progressBar = (UIProgressView *)[activityView viewWithTag:11];
    UILabel *updatedLabel = (UILabel *)[activityView viewWithTag:12];
    loadingLabel.hidden = YES;
    progressBar.hidden = YES;
    updatedLabel.hidden = NO;
    updatedLabel.text = text;
}

- (void)setLastUpdated:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [self setStatusText:(date) ? [NSString stringWithFormat:@"最後更新於 %@", [formatter stringFromDate:date]] : nil];
    [formatter release];
}

- (void)setProgress:(CGFloat)value
{
    UILabel *loadingLabel = (UILabel *)[activityView viewWithTag:10];
    UIProgressView *progressBar = (UIProgressView *)[activityView viewWithTag:11];
    UILabel *updatedLabel = (UILabel *)[activityView viewWithTag:12];
    loadingLabel.hidden = NO;
    progressBar.hidden = NO;
    updatedLabel.hidden = YES;
    progressBar.progress = value;
}


#pragma mark -
#pragma mark News activity indicator

- (void)setupActivityIndicator
{
    activityView = [[UIView alloc] initWithFrame:CGRectZero];
    activityView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    activityView.tag = 9;
    activityView.backgroundColor = [UIColor blackColor];
    storyTable.separatorColor = [UIColor colorWithHexString:@"E0E0E0"];
    // [storyTable.backgroundView setBackgroundColor:[UIColor yellowColor]];
    activityView.userInteractionEnabled = NO;
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 0, 0)];
    loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    loadingLabel.tag = 10;
    loadingLabel.text = @"讀取中...";
    loadingLabel.textColor = [UIColor colorWithHexString:@"#DDDDDD"];
    loadingLabel.font = [UIFont boldSystemFontOfSize:14.0];
    loadingLabel.backgroundColor = [UIColor blackColor];
    loadingLabel.opaque = YES;
    [activityView addSubview:loadingLabel];
    loadingLabel.hidden = YES;
    [loadingLabel release];
    
    CGSize labelSize = [loadingLabel.text sizeWithFont:loadingLabel.font forWidth:self.view.bounds.size.width lineBreakMode:NSLineBreakByTruncatingTail];
    
    [self.view addSubview:activityView];
    
    CGFloat bottom = CGRectGetMaxY(storyTable.frame);
    CGFloat height = labelSize.height + 8;
    activityView.frame = CGRectMake(0, bottom - height, self.view.bounds.size.width, height);
    
    UIProgressView *progressBar = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    progressBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    progressBar.tag = 11;
    progressBar.frame = CGRectMake((8 + (NSInteger)labelSize.width) + 5, 0, activityView.frame.size.width - (8 + (NSInteger)labelSize.width) - 13, progressBar.frame.size.height);
    progressBar.center = CGPointMake(progressBar.center.x, (NSInteger)(activityView.frame.size.height / 2) + 1);
    [activityView addSubview:progressBar];
    progressBar.progress = 0.0;
    progressBar.hidden = YES;
    [progressBar release];
    
    UILabel *updatedLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, activityView.frame.size.width - 16, activityView.frame.size.height)];
    updatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    updatedLabel.tag = 12;
    updatedLabel.text = @"";
    updatedLabel.textColor = [UIColor colorWithHexString:@"#DDDDDD"];
    updatedLabel.font = [UIFont boldSystemFontOfSize:14.0];
    updatedLabel.textAlignment = NSTextAlignmentRight;
    updatedLabel.backgroundColor = [UIColor blackColor];
    updatedLabel.opaque = YES;
    [activityView addSubview:updatedLabel];
    [updatedLabel release];
    
    // shrink table down to accomodate
    CGRect frame = storyTable.frame;
    frame.size.height = frame.size.height - height;
    storyTable.frame = frame;
}


#pragma mark -
#pragma mark Parser delegation

- (void)parserDidStartDownloading:(Announce_API *)parser
{
    if (parser == self.connect)
    {
        [self setProgress:0.1];
        [storyTable reloadData];
    }
}

- (void)parserDidStartParsing:(Announce_API *)parser
{
    if (parser == self.connect)
    {
        [self setProgress:0.3];
    }
}

- (void)parser:(Announce_API *)parser didMakeProgress:(CGFloat)percentDone
{
    if (parser == self.connect)
    {
        [self setProgress:0.3 + 0.7 * percentDone];
    }
}

- (void)parser:(Announce_API *)parser didFailWithDownloadError:(NSError *)error
{
    if (parser == self.connect)
    {
        // TODO: communicate download failure to user

        [self setStatusText:@"Update failed"];
        
        [self showError:error header:@"讀取失敗" alertViewDelegate:nil];
        if ([self->tableDisplayData[self.activeCategoryId] count] > 0)
        {
            [storyTable deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[self->tableDisplayData[self.activeCategoryId] count] inSection:0] animated:YES];
        }
    }
}

- (void)parser:(Announce_API *)parser didFailWithParseError:(NSError *)error
{
    if (parser == self.connect)
    {
        // TODO: communicate parse failure to user
        [self setStatusText:@"Update failed"];
        [self showError:error header:@"讀取失敗" alertViewDelegate:nil];
        if ([self->tableDisplayData[self.activeCategoryId] count] > 0)
        {
            [storyTable deselectRowAtIndexPath:[NSIndexPath indexPathForRow:[self->tableDisplayData[self.activeCategoryId] count] inSection:0] animated:YES];
        }
    }
}

- (void)parserDidFinishParsing:(Announce_API *)parser
{
    if (parser == self.connect)
    {
        pageCount[self.activeCategoryId]++;
        catchData = [[[NSDictionary alloc] initWithDictionary:self.connect.content] autorelease];
        NSArray* temp = [[catchData objectForKey:NewsAPIKeyNtou]objectForKey:NewsAPIKeyNotice];
        NSLog(@"---%lu",(unsigned long)[temp count]);
        /*if ([temp count]>NewsCatchDataCount)
            temp = [NSArray arrayWithObject:temp];
        else*/
        if ([temp count]<6)
            endCatchData[self.activeCategoryId]= TRUE;
        if (!tableDisplayData[self.activeCategoryId])
            tableDisplayData[self.activeCategoryId] = [[NSMutableArray alloc] init];
        [tableDisplayData[self.activeCategoryId] addObjectsFromArray:temp];
        [storyTable reloadData];
        [storyTable flashScrollIndicators];
        [self setLastUpdated:[NSDate date]];
    }
}

#define TIMED_OUT_CODE -1001
#define JSON_ERROR_CODE -2

-(void)showError:(NSError *)error header:(NSString *)header alertViewDelegate:(id<UIAlertViewDelegate>)alertViewDelegate {
	
	NSLog(@"MITMoileWebAPI.m header = %@", header);
    if(![header isEqual:@"Events"])
    {
        // Generic message
        NSString *message = @"連線失敗，請稍後再試";
        // if the error can be classifed we will use a more specific error message
        if(error) {
            if ([[error domain] isEqualToString:@"NSURLErrorDomain"] && ([error code] == TIMED_OUT_CODE)) {
                message = @"連線逾時，請稍後再試";
            } else if ([[error domain] isEqualToString:@"MITMobileWebAPI"] && ([error code] == JSON_ERROR_CODE)) {
                message = @"伺服器無回應，請稍後再試";
            }
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:header
                                                            message:message
                                                           delegate:alertViewDelegate
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        
        [alertView show];
        [alertView release];
    }
}

#pragma mark - Refresh and load more methods
- (void) refreshTable
{
    [self refresh:nil];
    self.storyTable.pullLastRefreshDate = [NSDate date];
    self.storyTable.pullTableIsRefreshing = NO;
}
- (void) loadMoreDataToTable
{
    [self loadFromCache];
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
