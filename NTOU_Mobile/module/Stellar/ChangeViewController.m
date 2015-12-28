//
//  ScheduleViewController.m
//  MIT Mobile
//
//  Created by mac_hero on 12/10/25.
//
//

#import "ChangeViewController.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface ChangeViewController ()

@end

@implementation ChangeViewController
@synthesize itemsArray;
@synthesize gradesArray;
@synthesize token;
@synthesize info;
@synthesize currentPage;
@synthesize contentList;
@synthesize myPageControl;
@synthesize myScrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"成績單";
    }
    return self;
}
- (void)dealloc
{
    [itemsArray release];
    [gradesArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonSystemItemDone target:self action:@selector(refresh)];
    right.tintColor =[UIColor colorWithRed:115.0/255 green:128.0/255 blue:177.0/255 alpha:1];
    
    [self.navigationItem setRightBarButtonItem:right animated:YES];
    
    myPageControl=[[UIPageControl alloc]init];
    myPageControl.center = CGPointMake(self.view.frame.size.width*0.5,self.view.frame.size.height-20);
    myPageControl.bounds=CGRectMake(0,0,150,50);
    myScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.frame.size.height)];
    [self.view addSubview:myScrollView];
    [self.view addSubview:myPageControl];
    contentList=[[NSMutableArray alloc]init];
    itemsArray = [[NSMutableArray alloc] init];
    [self refresh];
    self.myScrollView.pagingEnabled = YES;
    self.myScrollView.showsHorizontalScrollIndicator = NO;
    self.myScrollView.showsVerticalScrollIndicator = NO;
    self.myScrollView.scrollsToTop = YES;
    self.myScrollView.delegate = self;
    [itemsArray retain];
    [contentList retain];
}

- (void)loadScrollViewWithPage:(NSUInteger)page
{
    if (page >= self.contentList.count)
        return;
    
    // replace the placeholder if necessary
    DisplayViewController *controller = [self.contentList objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[DisplayViewController alloc] init];
        [self.contentList replaceObjectAtIndex:page withObject:controller];
        [controller setData:info Year:[itemsArray objectAtIndex:page]];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = self.myScrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.size.height-=40;
        controller.view.frame = frame;
        [self.myScrollView addSubview:controller.view];
    }
}

- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.myPageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // update the scroll view to the appropriate page
    CGRect bounds = self.myScrollView.bounds;
    bounds.origin.x = CGRectGetWidth(bounds) * page;
    bounds.origin.y = 20;
    [self.myScrollView scrollRectToVisible:bounds animated:animated];
}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = CGRectGetWidth(self.myScrollView.frame);
    NSUInteger page = floor((self.myScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.myPageControl.currentPage = page;
    NSLog(@"當前頁面 = %lu",page);
    // a possible optimization would be to unload the views+controllers which are no longer visible
    self.title=[NSString stringWithFormat:@"%@成績",[itemsArray objectAtIndex:page]];
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
}

-(void)refresh{
    [contentList removeAllObjects];
    [itemsArray removeAllObjects];
    [gradesArray removeAllObjects];
    info = [Moodle_API Login:[SettingsModuleViewController getMoodleAccount]andPassword:[SettingsModuleViewController getMoodlePassword]];
    //NSLog(@"%@",[info objectForKey:moodleLoginResultKey]);
    if([[info objectForKey:moodleLoginResultKey] intValue]==1){
        token = [info objectForKey:moodleLoginTokenKey];
        info = [Moodle_API GetCourseGrade_AndUseToken:token];
        for (NSDictionary * gradeDic in [info objectForKey:moodleListKey]){
            if([itemsArray indexOfObject:[gradeDic objectForKey:moodleGradeYearKey]]==NSNotFound){
                [itemsArray addObject:[gradeDic objectForKey:moodleGradeYearKey]];
                [gradeDic count];
            }
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *loadingAlertView = [[UIAlertView alloc]
                                             initWithTitle:nil message:@"帳號、密碼錯誤"
                                             delegate:nil cancelButtonTitle:@"確定"
                                             otherButtonTitles:nil];
            [loadingAlertView show];
            [loadingAlertView release];
        });
        return;
    }
    NSUInteger numberPages = self.itemsArray.count;
    for(NSUInteger i=0;i<numberPages;++i)
        [contentList addObject:[NSNull null]];
    myPageControl.numberOfPages=numberPages;
    self.title=[NSString stringWithFormat:@"%@成績",[itemsArray objectAtIndex:0]];
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    [info retain];
    self.myScrollView.contentSize =
    CGSizeMake(CGRectGetWidth(self.myScrollView.frame) * numberPages,0);
    CGPoint temp=CGPointMake(0,0);
    temp=self.myScrollView.contentOffset;
    temp.x=0;
    [self.myScrollView setContentOffset:temp];
    [self scrollViewDidEndDecelerating:myScrollView];
    
}
@end
