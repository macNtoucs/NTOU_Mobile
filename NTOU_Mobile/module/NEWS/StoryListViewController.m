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
#define STORY_TEXT_WIDTH (320.0 - STORY_TEXT_PADDING_LEFT - STORY_TEXT_PADDING_RIGHT - THUMBNAIL_WIDTH - ACCESSORY_WIDTH_PLUS_PADDING) // 8px horizontal padding
#define STORY_TEXT_HEIGHT (THUMBNAIL_WIDTH - STORY_TEXT_PADDING_TOP - STORY_TEXT_PADDING_BOTTOM) // 8px vertical padding (bottom is less because descenders on dekLabel go below baseline)
#define STORY_TITLE_FONT_SIZE 15.0
#define STORY_DEK_FONT_SIZE 12.0

#define SEARCH_BUTTON_TAG 7947
#define BOOKMARK_BUTTON_TAG 7948

#define NewsCategoryIdAnnounceAPI  @"announce"
#define NewsCategorySymposiumAPI  @"symposium"
#define NewsCategoryArtAPI  @"art"
#define NewsCategoryLectureAPI  @"lecture"
#define NewsCategoryDocumentAPI  @"document"
#define NewsCategoryInformationAPI  @"Information"

#define NewsAPIKeyNtou @"ntou"
#define NewsAPIKeyNotice @"notice"
#define NewsAPIKeyPromoter @"promoter"
#define NewsAPIKeyTel @"tel"
#define NewsAPIKeyTitle @"title"
#define NewsAPIKeyBody @"body"
#define NewsAPIKeyStartdate @"startdate"
#define NewsAPIKeyClass @"class"
#define NewsAPIKeyEmail @"email"
#define NewsAPIKeyText @"text"

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
NSString *const NewsCategoryAnnounce = @"學校公告";
NSString *const NewsCategorySymposium = @"研討會";
NSString *const NewsCategoryArt = @"藝文活動";
NSString *const NewsCategoryLecture = @"演講公告";
NSString *const NewsCategoryDocument = @"電子公文";
NSString *const NewsCategoryInformation = @"校外訊息";

NewsCategoryId buttonCategories[] = {
    NewsCategoryIdAnnounce, NewsCategoryIdSymposium,
    NewsCategoryIdArt, NewsCategoryIdLecture,
    NewsCategoryIdDocument, NewsCategoryIdInformation,
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
    
    self.navigationItem.title = @"MIT News";
    self.navigationItem.backBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Headlines" style:UIBarButtonItemStylePlain target:nil action:nil] autorelease];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)] autorelease];
    
    tempTableSelection = nil;
    
    storyTable = [[UITableView alloc] initWithFrame:self.view.bounds];
    storyTable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    storyTable.delegate = self;
    storyTable.dataSource = self;
    storyTable.separatorColor = [UIColor colorWithWhite:0.5 alpha:1.0];
    [self.view addSubview:storyTable];
    [storyTable release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNavScroller];
    
    // set up results table
    storyTable.frame = CGRectMake(0, navScrollView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - navScrollView.frame.size.height);
    [self setupActivityIndicator];
    
    [self loadFromCache];
	// Do any additional setup after loading the view.
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
    [self loadFromCache];
}


- (void)loadFromCache
{
    catchData = [Announce_API getAnnounceInfo_Count:6 andType:titleForCategoryId(buttonCategories[self.activeCategoryId]) andPage:1];
    NSArray* temp = [[catchData objectForKey:NewsAPIKeyNtou]objectForKey:NewsAPIKeyNotice];
    if (!tableDisplayData[self.activeCategoryId]) {
        tableDisplayData[self.activeCategoryId] = [[NSMutableArray alloc] init];
        [tableDisplayData[self.activeCategoryId] addObjectsFromArray:temp];
    }
    [storyTable reloadData];
    [storyTable flashScrollIndicators];
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
                             ,NewsCategoryDocument,NewsCategoryInformation,
                             nil];
    
    //NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:[buttonTitles count]];
    
    NSInteger i = 0;
    for (NSString *buttonTitle in buttonTitles)
    {
        UIButton *aButton = [UIButton buttonWithType:UIButtonTypeCustom];
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

        self.activeCategoryId = category;

        [storyTable reloadData];
        [self loadFromCache]; // makes request to server if no request has been made this session
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
    return [self->tableDisplayData[self.activeCategoryId] count]+1;
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
    UITableViewCell *result = nil;
    
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
                
                if (cell == nil)
                {
                    // Set up the cell
                    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StoryCellIdentifier] autorelease];
                    
                    // Title View
                    titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                    titleLabel.tag = 1;
                    titleLabel.font = [UIFont boldSystemFontOfSize:STORY_TITLE_FONT_SIZE];
                    titleLabel.numberOfLines = 0;
                    titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
                    [cell.contentView addSubview:titleLabel];
                    [titleLabel release];
                    
                    // Summary View
                    dekLabel = [[UILabel alloc] initWithFrame:CGRectZero];
                    dekLabel.tag = 2;
                    dekLabel.font = [UIFont systemFontOfSize:STORY_DEK_FONT_SIZE];
                    dekLabel.textColor = [UIColor colorWithHexString:@"#0D0D0D"];
                    dekLabel.highlightedTextColor = [UIColor whiteColor];
                    dekLabel.numberOfLines = 0;
                    dekLabel.lineBreakMode = UILineBreakModeTailTruncation;
                    [cell.contentView addSubview:dekLabel];
                    [dekLabel release];

                    
                    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
                    cell.selectionStyle = UITableViewCellSelectionStyleGray;
                }
                
                titleLabel = (UILabel *)[cell viewWithTag:1];
                dekLabel = (UILabel *)[cell viewWithTag:2];
                
                titleLabel.text = [[story objectForKey:NewsAPIKeyTitle] objectForKey:NewsAPIKeyText];
                dekLabel.text = [[story objectForKey:NewsAPIKeyStartdate] objectForKey:NewsAPIKeyText];
                
                titleLabel.textColor = [UIColor blackColor];
                titleLabel.highlightedTextColor = [UIColor whiteColor];
                
                // Calculate height
                CGFloat availableHeight = STORY_TEXT_HEIGHT;
                CGSize titleDimensions = [titleLabel.text sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(STORY_TEXT_WIDTH, availableHeight) lineBreakMode:UILineBreakModeTailTruncation];
                availableHeight -= titleDimensions.height;
                
                CGSize dekDimensions = CGSizeZero;
                // if not even one line will fit, don't show the deck at all
                if (availableHeight > dekLabel.font.leading)
                {
                    dekDimensions = [dekLabel.text sizeWithFont:dekLabel.font constrainedToSize:CGSizeMake(STORY_TEXT_WIDTH, availableHeight) lineBreakMode:UILineBreakModeTailTruncation];
                }
                
                
                titleLabel.frame = CGRectMake(STORY_TEXT_PADDING_LEFT,
                                              STORY_TEXT_PADDING_TOP,
                                              THUMBNAIL_WIDTH +STORY_TEXT_WIDTH,
                                              titleDimensions.height);
                dekLabel.frame = CGRectMake(STORY_TEXT_PADDING_LEFT,
                                            ceil(CGRectGetMaxY(titleLabel.frame)),
                                            THUMBNAIL_WIDTH +STORY_TEXT_WIDTH,
                                            dekDimensions.height);
                
                
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
                    moreArticlesLabel.textColor = [UIColor colorWithHexString:@"#990000"];
                    moreArticlesLabel.text = @"Load 10 more articles..."; // just something to make it place correctly
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
                    if (!self.xmlParser)
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
    [self setStatusText:(date) ? [NSString stringWithFormat:@"Last updated %@", [formatter stringFromDate:date]] : nil];
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
    activityView.userInteractionEnabled = NO;
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 0, 0)];
    loadingLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    loadingLabel.tag = 10;
    loadingLabel.text = @"Loading...";
    loadingLabel.textColor = [UIColor colorWithHexString:@"#DDDDDD"];
    loadingLabel.font = [UIFont boldSystemFontOfSize:14.0];
    loadingLabel.backgroundColor = [UIColor blackColor];
    loadingLabel.opaque = YES;
    [activityView addSubview:loadingLabel];
    loadingLabel.hidden = YES;
    [loadingLabel release];
    
    CGSize labelSize = [loadingLabel.text sizeWithFont:loadingLabel.font forWidth:self.view.bounds.size.width lineBreakMode:UILineBreakModeTailTruncation];
    
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
    updatedLabel.textAlignment = UITextAlignmentRight;
    updatedLabel.backgroundColor = [UIColor blackColor];
    updatedLabel.opaque = YES;
    [activityView addSubview:updatedLabel];
    [updatedLabel release];
    
    // shrink table down to accomodate
    CGRect frame = storyTable.frame;
    frame.size.height = frame.size.height - height;
    storyTable.frame = frame;
}


@end
