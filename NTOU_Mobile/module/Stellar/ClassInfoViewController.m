//
//  ClassInfoViewController.m
//  MIT Mobile
//
//  Created by mini server on 12/11/3.
//
//

#import "ClassInfoViewController.h"
#import "ClassDataBase.h"
@interface ClassInfoViewController (){
    ClassLabelBasis * classinfo;
    ClassInfoView * view5;
}

@end

@implementation ClassInfoViewController
@synthesize classId;
@synthesize courseId;
@synthesize tag;
@synthesize tabBarArrow;
@synthesize token;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        }
    
    return self;
}

-(void)presentOn:(UIViewController*)ViewController
{
    //ViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //ViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    
    
    [self.navigationController pushViewController:ViewController animated:YES];
}
-(void)presentOff
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    // A single tab item's width is the entire width of the tab bar divided by number of items
    CGFloat tabItemWidth = self.tabBar.frame.size.width / self.tabBar.items.count;
    // A half width is tabItemWidth divided by 2 minus half the width of the arrow
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
    
    // The horizontal location is the index times the width plus a half width
    return (tabIndex * tabItemWidth) + halfTabItemWidth;
}

- (void) addTabBarArrow
{
    UIImage* tabBarArrowImage = [UIImage imageNamed:@"TabBarNipple@2x.png"];
    self.tabBarArrow = [[[UIImageView alloc] initWithImage:tabBarArrowImage] autorelease];
    // To get the vertical location we start at the bottom of the window, go up by height of the tab bar, go up again by the height of arrow and then come back down 2 pixels so the arrow is slightly on top of the tab bar.
    CGFloat verticalLocation = [[UIScreen mainScreen] bounds].size.height-tabBarArrowImage.size.height-self.tabBar.frame.size.height-[[UIApplication sharedApplication] statusBarFrame].size.height-44+5;;
    tabBarArrow.frame = CGRectMake([self horizontalLocationFor:0], verticalLocation, tabBarArrowImage.size.width, tabBarArrowImage.size.height);
    
    [self.view addSubview:tabBarArrow];
}

-(void)Task
{
    @autoreleasepool {
        NSString* key;
        UIViewController *viewController = [self.viewControllers objectAtIndex:1];
        [viewController.view removeAllSubviews];
        ClassInfoView *view = [[ClassInfoView alloc] initWithStyle:UITableViewStyleGrouped];
        if ([self.navigationItem.rightBarButtonItem.title isEqual: type6]) {
            self.navigationItem.rightBarButtonItem.title = @"講義";
            view.title = type6;
            viewController.title = type6;
            classinfo.text = type6;
            key = moodleFileExamKey;
        }
        else{
            self.navigationItem.rightBarButtonItem.title = type6;
            view.title = type4;
            viewController.title = type4;
            key = moodleFileLetureKey;
            classinfo.text = @"講義";
        }
        view.view.frame = CGRectMake(0, 40, 320, [[UIScreen mainScreen] bounds].size.height-150);
        view.moodleid = [moodleid retain];
        
        view.resource = [[NSMutableArray alloc] initWithArray:[Moodle_API getFilesFolder_InDir:[NSString stringWithFormat:@"/%@/%@",moodleid,key]]];
        
        if (!view.resource) {
            UIAlertView *loadingAlertView = [[UIAlertView alloc]
                                             initWithTitle:nil message:@"網路連線失敗"
                                             delegate:self cancelButtonTitle:@"確定"
                                             otherButtonTitles:nil];
            [loadingAlertView show];
            [loadingAlertView release];
        }
        [view.tableView reloadData];
        [viewController.view addSubview:view.tableView];
    }
}

-(void)changeType{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"Loading";
    [HUD showWhileExecuting:@selector(Task) onTarget:self withObject:nil animated:YES];
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect frame = tabBarArrow.frame;
    frame.origin.x = [self horizontalLocationFor:self.selectedIndex];
    tabBarArrow.frame = frame;
    [UIView commitAnimations];
    if (self.selectedIndex==1) {
        UIBarButtonItem *rightButton;
        classinfo.font = [UIFont fontWithName:BOLD_FONT size:20];
        if ([[[self.viewControllers objectAtIndex:1] title]isEqualToString:type6]) {
            classinfo.text = [NSString stringWithFormat:type6];
            rightButton= [[UIBarButtonItem alloc] initWithTitle:@"講義"
                                               style:UIBarButtonItemStyleBordered
                                              target:self
                                                         action:@selector(changeType)];
        } else {
            classinfo.text = [NSString stringWithFormat:@"講義"];
            rightButton= [[UIBarButtonItem alloc] initWithTitle:type6
                                                          style:UIBarButtonItemStyleBordered
                                                         target:self
                                                         action:@selector(changeType)];
        }
        [self.navigationItem setRightBarButtonItem:rightButton];
    }
    else{
        [self.navigationItem setRightBarButtonItem:nil];
        classinfo.text = nil;
        if (self.selectedIndex==0){
            classinfo.font = [UIFont fontWithName:BOLD_FONT size:15];
            classinfo.text = [NSString stringWithFormat:@"教授名稱：%@\n 教室地點：%@",[[ClassDataBase sharedData] FetchProfessorName:[NSNumber numberWithInt:self.tag]],[[ClassDataBase sharedData] FetchClassroomLocation:[NSNumber numberWithInt:self.tag]]];
        }
    }
    
}


- (void)leaveEditMode {
    [view5.textView resignFirstResponder];
}

-(void)rightBarButtonItemOn{
    UIBarButtonItem *done =    [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)] autorelease];
    done.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = done;
    view5.view.frame = CGRectMake(0, 10, 320, [[UIScreen mainScreen] bounds].size.height-280);
}
-(void)rightBarButtonItemOff{
    self.navigationItem.rightBarButtonItem = nil;
    view5.view.frame = CGRectMake(0, 10, 320, [[UIScreen mainScreen] bounds].size.height-30);
}

- (void)viewDidLoad
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        
    }
    
    
    //[[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //self.view.backgroundColor = TABLE_SEPARATOR_COLOR;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.viewControllers) {
        NSDictionary* apiKey = [[ClassDataBase sharedData] loginCourseToGetCourseidAndClassid:self.title];
        UIViewController *viewController1, *viewController2, *viewController3, *viewController4, *viewController5;
        viewController1 = [[UIViewController alloc] init];
        viewController1.title = type3;
        UITabBarItem *item1 = [[UITabBarItem alloc] initWithTitle:type3 image:[UIImage imageNamed:@"公告.png"] tag:1];
        [item1 setFinishedSelectedImage:[UIImage imageNamed:@"公告.png"]
            withFinishedUnselectedImage:[UIImage imageNamed:@"公告.png"]];
        viewController1.tabBarItem = item1;
        [item1 release];

        viewController2 = [[UIViewController alloc] init];
        viewController2.title = type4;
        UITabBarItem *item2 = [[UITabBarItem alloc] initWithTitle:type4 image:[UIImage imageNamed:@"公告.png"] tag:2];
        [item2 setFinishedSelectedImage:[UIImage imageNamed:@"講義.png"]
            withFinishedUnselectedImage:[UIImage imageNamed:@"講義.png"]];
        viewController2.tabBarItem = item2;
        [item2 release];
        
        viewController3 = [[UIViewController alloc] init];
        viewController3.title = type2;
        UITabBarItem *item3 = [[UITabBarItem alloc] initWithTitle:type2 image:[UIImage imageNamed:@"作業.png"] tag:3];
        [item3 setFinishedSelectedImage:[UIImage imageNamed:@"作業.png"]
            withFinishedUnselectedImage:[UIImage imageNamed:@"作業.png"]];
        viewController3.tabBarItem = item3;
        [item3 release];
        
        viewController4 = [[UIViewController alloc] init];
        viewController4.title = type1;
        UITabBarItem *item4 = [[UITabBarItem alloc] initWithTitle:type1 image:[UIImage imageNamed:@"成績.png"] tag:4];
        [item4 setFinishedSelectedImage:[UIImage imageNamed:@"成績.png"]
            withFinishedUnselectedImage:[UIImage imageNamed:@"成績.png"]];
        viewController4.tabBarItem = item4;
        [item4 release];
        
        viewController5 = [[UIViewController alloc] init];
        viewController5.title = type5;
        UITabBarItem *item5 = [[UITabBarItem alloc] initWithTitle:type5 image:[UIImage imageNamed:@"筆記.png"] tag:5];
        [item5 setFinishedSelectedImage:[UIImage imageNamed:@"筆記.png"]
            withFinishedUnselectedImage:[UIImage imageNamed:@"筆記.png"]];
        viewController5.tabBarItem = item5;
        [item5 release];
        
        ClassInfoView *view1, *view2, *view3, *view4;
        view1 = [[ClassInfoView alloc] initWithStyle:UITableViewStyleGrouped];
        view1.title = type3;
        NSArray* listData = [[Moodle_API GetMoodleInfo_AndUseToken:token courseID:[apiKey objectForKey:courseIDKey] classID:[apiKey objectForKey:classIDKey]] objectForKey:moodleListKey];
        NSArray* data = [[NSArray alloc] init];
        if ([listData count]) {
            data = [[listData objectAtIndex:0] objectForKey:moodleResourceInfoKey];
        }
        data = [[data reverseObjectEnumerator] allObjects];
        NSMutableArray* resource = [[NSMutableArray alloc] init];
        moodleid = [[[Moodle_API GetMoodleID_AndUseToken:token courseID:[apiKey objectForKey:courseIDKey] classID:[apiKey objectForKey:classIDKey]] objectForKey:moodleMoodleID] retain];
        for (NSDictionary* info in data) {
            NSRange range  = [[info objectForKey:moodleResourceUrlKey] rangeOfString:@"php?id="];
            if (![[info objectForKey:moodleResourceModuleKey] isEqualToString:@"forum"]) {
                NSDictionary* infoDetail = [Moodle_API MoodleID_AndUseToken:token
                                                                     module:[info objectForKey:moodleResourceModuleKey]
                                                                   moodleID:[[info objectForKey:moodleResourceUrlKey] substringFromIndex: range.location+range.length]
                                                                   courseID:[apiKey objectForKey:courseIDKey]
                                                                    classID:[apiKey objectForKey:classIDKey]];
                if ((![[infoDetail objectForKey:moodleInfoDescriptionKey] isEqualToString:@""])||(!([infoDetail objectForKey:moodleInfoSummaryKey]==NULL||[[infoDetail objectForKey:moodleInfoSummaryKey] isEqualToString:@""]))) {
                    [resource addObject:infoDetail];
                }
            }
        }
        
        view1.delegatetype5 = self;
        view1.resource = resource;
        view1.moodleid = [moodleid retain];
        view1.view.frame = CGRectMake(0, 40, 320, [[UIScreen mainScreen] bounds].size.height-60);
        [viewController1.view addSubview:view1.tableView];
        
        view2 = [[ClassInfoView alloc] initWithStyle:UITableViewStyleGrouped];
        view2.title = type4;
        view2.delegatetype5 = self;
        view2.moodleData = [Moodle_API GetMoodleInfo_AndUseToken:token courseID:[apiKey objectForKey:courseIDKey] classID:[apiKey objectForKey:classIDKey]];
        view2.resource = [[NSMutableArray alloc] initWithArray:[Moodle_API getFilesFolder_InDir:[NSString stringWithFormat:@"/%@/%@",moodleid,moodleFileLetureKey]]];
        view2.moodleid = [moodleid retain];
        view2.view.frame = CGRectMake(0, 40, 320, [[UIScreen mainScreen] bounds].size.height-60);
        [viewController2.view addSubview:view2.tableView];
        
        view3 = [[ClassInfoView alloc] initWithStyle:UITableViewStyleGrouped];
        view3.title = type2;
        view3.moodleData = [Moodle_API GetGrade_AndUseToken:token courseID:[apiKey objectForKey:courseIDKey] classID:[apiKey objectForKey:classIDKey]];
        view3.resource = [[NSMutableArray alloc] initWithArray:[Moodle_API getFilesFolder_InDir:[NSString stringWithFormat:@"/%@/%@",moodleid,moodleFileAssignmentKey]]];
        view3.moodleid = [moodleid retain];
        view3.delegatetype5 = self;
        view3.view.frame = CGRectMake(0, 10, 320, [[UIScreen mainScreen] bounds].size.height-30);
        [viewController3.view addSubview:view3.tableView];
        
        view4 = [[ClassInfoView alloc] initWithStyle:UITableViewStyleGrouped];
        view4.title = type1;
        view4.delegatetype5 = self;
        view4.moodleid = [moodleid retain];
        view4.view.frame =  CGRectMake(0, 10, 320, [[UIScreen mainScreen] bounds].size.height-30);
        [viewController4.view addSubview:view4.tableView];
        
        view5 = [[ClassInfoView alloc] initWithStyle:UITableViewStyleGrouped];
        view5.delegatetype5 = self;
        view5.moodleData = apiKey;
        view5.title = type5;
        view5.moodleid = [moodleid retain];
        view5.view.frame = CGRectMake(0, 10, 320, [[UIScreen mainScreen] bounds].size.height-30);
        [viewController5.view addSubview:view5.tableView];
        
        [self setViewControllers:[NSArray arrayWithObjects:viewController1, viewController2,viewController3,viewController4,viewController5, nil] animated:YES];
        self.delegate=self;
        self.view.backgroundColor = TABLE_SEPARATOR_COLOR;
        [self addTabBarArrow];
    }
    
    if (!classinfo) {
        classinfo = [[[ClassLabelBasis alloc] initWithFrame:CGRectMake(0, 0, 320, 40)] autorelease];
        classinfo.backgroundColor = [UIColor clearColor];
        classinfo.textAlignment = NSTextAlignmentCenter;
        classinfo.font = [UIFont fontWithName:BOLD_FONT size:15];
        classinfo.lineBreakMode = NSLineBreakByWordWrapping;
        classinfo.numberOfLines = 0;
        ClassDataBase* ClassData = [ClassDataBase sharedData];
        classinfo.text = [NSString stringWithFormat:@"教授名稱：%@\n 教室地點：%@",[ClassData FetchProfessorName:[NSNumber numberWithInt:self.tag]],[ClassData FetchClassroomLocation:[NSNumber numberWithInt:self.tag]]];
    }
    [self.view addSubview:classinfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}


@end
