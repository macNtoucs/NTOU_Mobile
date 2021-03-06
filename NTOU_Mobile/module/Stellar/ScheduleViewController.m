//
//  ScheduleViewController.m
//  MIT Mobile
//
//  Created by mac_hero on 12/10/25.
//
//

#import "ScheduleViewController.h"
#import "ClassDataBase.h"
#import "NTOUNotification.h"
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

@interface ScheduleViewController ()

@end

@implementation ScheduleViewController
@synthesize  UpperleftView;
@synthesize  scrollView;
@synthesize  TopWeekcontroller;
@synthesize LeftViewController;
@synthesize weekschedule;
@synthesize classInfo;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"功課表";
        TopWeekcontroller = [[WeekNameView alloc] initWithFrame:CGRectMake(LeftBaseline, [[UIApplication sharedApplication] statusBarFrame].size.height+NavigationHight, UpperViewWidth*[[ClassDataBase sharedData] FetchWeekTimes], UpperBaseline)];
        LeftViewController  = [[LessonTimeView alloc]initWithFrame:CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height+NavigationHight+UpperBaseline, LeftBaseline,(LeftViewHeight-TextLabelborderWidth)*[[ClassDataBase sharedData] FetchClassSessionTimes])];
        UpperleftView = [[UIView alloc] initWithFrame:CGRectMake(0,[[UIApplication sharedApplication] statusBarFrame].size.height+NavigationHight, LeftBaseline, UpperBaseline)];
        UpperleftView.backgroundColor = [UIColor colorWithRed:105.0/255 green:105.0/255 blue:105.0/255 alpha:1];
        UpperleftView.layer.borderWidth = TextLabelborderWidth;
        UpperleftView.layer.borderColor = [UIColor blackColor].CGColor;
        [ClassDataBase sharedData].ScheduleViewDelegate = self;
        
    }
    return self;
}

-(void)Task:(ClassLabelBasis *)label
{
    NSString* token = [[ClassDataBase sharedData] loginTokenWhenAccountFromUserDefault];
    if (token) {
        classInfo = [[[ClassInfoViewController alloc] init]autorelease];
        classInfo.title = label.text;
        classInfo.tag = label.labelID;
        classInfo.token = token;
        NSDictionary* courseInfo = [[ClassDataBase sharedData] loginCourseToGetCourseidAndClassid:label.text];
        classInfo.courseId = [courseInfo objectForKey:courseIDKey];
        classInfo.classId = [courseInfo objectForKey:classIDKey];
        [self.navigationController pushViewController:classInfo animated:YES];
        classInfo.navigationItem.leftBarButtonItem.title=@"back";
        
        //將未讀課程的推播通知刪除
        NSMutableDictionary* notif = [NTOUNotificationHandle getNotifications];
        NSMutableDictionary* unReadNotifs = [NSMutableDictionary dictionaryWithDictionary:[notif objectForKey:StellarTag]];
        
        NSString *courseName = [[ClassDataBase sharedData] searchCourseIDFormCourseName:label.text];
        [unReadNotifs removeObjectForKey:courseName];
        
        if ([unReadNotifs count])
            [notif setObject:unReadNotifs forKey:StellarTag];
        else
            [notif removeObjectForKey:StellarTag];
        [NTOUNotificationHandle storeNotifications:notif];
        [weekschedule drawRect:CGRectZero];
        [NTOUNotificationHandle refreshRemoteBadge];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *loadingAlertView = [[UIAlertView alloc]
                                             initWithTitle:@"登入失敗" message:@"請確認網路狀態或稍後再嘗試"
                                             delegate:self cancelButtonTitle:@"確定"
                                             otherButtonTitles:nil];
            [loadingAlertView show];
            [loadingAlertView release];
        });

    }
        
}

-(void) showClassInfo:(ClassLabelBasis *)label{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	
    // Add HUD to screen
    [self.navigationController.view addSubview:HUD];
	
    // Regisete for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;
	
    HUD.labelText = @"讀取中";
	
    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(Task:) onTarget:self withObject:label animated:YES];
    
}

-(void) buttonDidFinish:(int)FinishType StringData:(NSArray *)array
{
    if (FinishType == clean||(FinishType == moveConstant&&[weekschedule.TapAddCourse count]==1)) {
        [weekschedule restorTheOriginalColor];
        [weekschedule removeAllcourselabel];
        return;
    }
    ClassLabelBasis* FirstTap = [weekschedule.TapAddCourse objectAtIndex:0];
    if (FinishType == moveConstant||[[array objectAtIndex:0] isEqualToString:[NSString string]]) {
        NSNumber* deleteCourseTag = [NSNumber numberWithInt:[[weekschedule.TapAddCourse objectAtIndex:0] labelID]];
        [[ClassDataBase sharedData] UpdataScheduleInfo:deleteCourseTag ScheduleInfo:@" "];
        [[ClassDataBase sharedData] deleteClassroomLocation:deleteCourseTag];
        [[ClassDataBase sharedData] deleteProfessorName:deleteCourseTag];
        [weekschedule.TapAddCourse removeObjectAtIndex:0];
        if ([[array objectAtIndex:0] isEqualToString:[NSString string]]) {
            [[ClassDataBase sharedData] deleteColorwhenCourseCountZero];
            [weekschedule restorTheOriginalColor];
            [weekschedule removeAllcourselabel];
            [weekschedule drawRect:CGRectZero];
            return;
        }
    }
    NSSortDescriptor *sortDescriptor=[[NSSortDescriptor alloc]initWithKey:@"tag" ascending:NO];
    NSArray *sortDescriptors=[NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArr=[weekschedule.TapAddCourse sortedArrayUsingDescriptors:sortDescriptors];
    weekschedule.TapAddCourse = [NSMutableArray array];
    int i=0;
    for (ClassLabelBasis* label in sortedArr) {
        if (label.labelID<0)
                label.labelID*=-1;
        if ([weekschedule.TapAddCourse count]==0)
            [weekschedule.TapAddCourse addObject:label];
        else{
            ClassLabelBasis* sortedlabel = [weekschedule.TapAddCourse objectAtIndex:i];
            if (sortedlabel.labelID%10000/100+sortedlabel.labelID%100==label.labelID%10000/100)
                sortedlabel.labelID+=label.labelID%100;
            else{
                [weekschedule.TapAddCourse addObject:label];
                i++;
            }
        }
    }
    for (ClassLabelBasis* label in weekschedule.TapAddCourse) {
        [[ClassDataBase sharedData] UpdataScheduleInfo:[NSNumber numberWithInt:label.labelID] ScheduleInfo:[array objectAtIndex:0]];
        [[ClassDataBase sharedData] UpdataProfessorNameKey:[NSNumber numberWithInt:label.labelID] ProfessorName:[array objectAtIndex:1]];
        [[ClassDataBase sharedData] UpdataClassroomLocationKey:[NSNumber numberWithInt:label.labelID] Classroom:[array objectAtIndex:2]];
        
    }
    [[ClassDataBase sharedData] moodleFromRecordForNewCourse:[array objectAtIndex:0] ForOldCourse:FirstTap.text];
    [[ClassDataBase sharedData] deleteMoodleFromWhenCourseCountZero];
    [[ClassDataBase sharedData] UpdataColorFromFirstTap:[array objectAtIndex:0] ForOldCourse:FirstTap.text];
    [[ClassDataBase sharedData] deleteColorwhenCourseCountZero];
    [weekschedule.TapAddCourse removeAllObjects];
    [weekschedule drawRect:CGRectZero];
}

-(void) DisplayUITextField:(NSArray *)info
{
    addView.classNameField.text = [info objectAtIndex:0];
    addView.teacherNameField.text = [info objectAtIndex:1];
    addView.roomNameField.text = [info objectAtIndex:2];
}

-(void)displayModifyButton:(BOOL)type
{
    [addView displayModifyButton:type];
}

-(void)alterButtonFunction:(BOOL)type
{
    [addView buttonFuntion:type];
}

-(void)ChangeDisplayView
{
    [LeftViewController drawRect:CGRectZero];
    [TopWeekcontroller drawRect:CGRectZero];
    [weekschedule drawRect:CGRectZero];
    scrollView.contentSize = [self scrollContentSize];
}

-(BOOL)NavigationBarHidden
{
    return self.navigationController.navigationBarHidden;
}

-(void)changeTapEnable
{
    static BOOL change = NO;
    if (change) {
        [self.weekschedule.TapAddCourse removeAllObjects];
        [self alterButtonFunction:NO];
        self.weekschedule.WhetherTapped = NO;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height-132);
        change = NO;
    } else {
        self.weekschedule.WhetherTapped = YES;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, self.scrollView.contentSize.height+132);
        change = YES;
    }
}

-(void)NavigationBarShow
{
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    [self.weekschedule drawRect:self.view.bounds];
}

-(IBAction)Add:(id)sender{
    if (iPhone5)
        addView = [[ClassAdd alloc] initWithNibName:@"ClassAddRetina4" bundle:nil];
    else
        addView = [[ClassAdd alloc] initWithNibName:@"ClassAddRetina3.5" bundle:nil];
    addView.delegate = self;
    [self.navigationController.view addSubview:addView.view];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    [self.weekschedule drawRect:self.view.bounds];
}

-(void) addNavRightButton {
    //暫時把加入課程的按鈕取消，因為ios7透明度怪怪 der
   /* UIToolbar *tools = [[UIToolbar alloc]
                        initWithFrame:CGRectMake(0.0f, 0.0f, 103.0f, 44.01f)]; // 44.01 shifts it up 1px for some reason
    tools.clearsContextBeforeDrawing = NO;
    tools.clipsToBounds = NO;
    //tools.tintColor = [UIColor colorWithWhite:0.305f alpha:0.0f]; // closest I could get by eye to black, translucent style.
    // anyone know how to get it perfect?
    [tools setBarStyle:-1];
    //[tools setBackgroundColor:[UIColor clearColor]];
    //NSLog(@"%@",self.navigationController.navigationBar.tintColor);
    self.navigationItem.rightBarButtonItem.tintColor = self.navigationController.navigationBar.tintColor;
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // Create a standard refresh button.
    UIBarButtonItem *bi = [[UIBarButtonItem alloc]
                           initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(Add:)];
    [buttons addObject:bi];
    [bi release];
    
    bi = [[UIBarButtonItem alloc]
           initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [buttons addObject:bi];
    [bi release];*/
    // Add profile button.
    UIBarButtonItem *bi = [[UIBarButtonItem alloc]
          initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(edit)];
    
   // [buttons addObject:bi];
   

    
    // Add buttons to toolbar and toolbar to nav bar.
   /* [tools setItems:buttons animated:NO];
    [buttons release];
    UIBarButtonItem *twoButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    [tools release];*/
    self.navigationItem.rightBarButtonItem = bi;
     [bi release];
    //[twoButtons release];
}
-(void)edit{
    editSchedule = [[EditScheduleViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController* tempNavCon = [[UINavigationController alloc]    initWithRootViewController:editSchedule];
    tempNavCon.navigationBar.tintColor = [UIColor colorWithRed:12.0/255 green:46.0/255 blue:112.0/255 alpha:1];
    [self presentModalViewController:tempNavCon animated:YES];
    [tempNavCon release];
    [editSchedule release];
}

-(CGSize)scrollContentSize
{
    return CGSizeMake(LeftBaseline+(UpperViewWidth-TextLabelborderWidth)*[[ClassDataBase sharedData] FetchWeekTimes], [[UIApplication sharedApplication] statusBarFrame].size.height+NavigationHight+UpperBaseline+(LeftViewHeight-TextLabelborderWidth)*[[ClassDataBase sharedData] FetchClassSessionTimes]);
}

- (void)viewDidLoad
{
    weekschedule = [[[WeekScheduleView alloc]initWithFrame:CGRectMake(0, 0, LeftBaseline+(UpperViewWidth-TextLabelborderWidth)*[[ClassDataBase sharedData] FetchWeekTimes], [[UIApplication sharedApplication] statusBarFrame].size.height+NavigationHight+UpperBaseline+(LeftViewHeight-TextLabelborderWidth)*[[ClassDataBase sharedData] FetchClassSessionTimes])] autorelease];
    [weekschedule getParent_ViewController:self];
    [self addNavRightButton]; 
    scrollView = [[UIScrollView alloc] init];
   
    [scrollView setFrame:[[UIScreen mainScreen] bounds]];
    [scrollView addSubview:weekschedule];
    isWeekScheduleInScrowView = true;
    scrollView.delegate=self;

    scrollView.contentSize = [self scrollContentSize];

    scrollView.bounces = NO;

    [self.view addSubview:scrollView];

    [scrollView release];

    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        
    }
    self.view.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    [super viewDidLoad];
	
}

-(void)scrollViewDidScroll:(UIScrollView *)scroll
{
    
    static CGPoint movement;
    movement.x += scroll.contentOffset.x - scrollView_position.x;
    movement.y += scroll.contentOffset.y - scrollView_position.y;

    scrollView_position.x = scroll.contentOffset.x;
    scrollView_position.y = scroll.contentOffset.y;
    LeftViewController.transform = CGAffineTransformMakeTranslation(0, -movement.y);
    TopWeekcontroller.transform = CGAffineTransformMakeTranslation(-movement.x, 0);

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIDeviceOrientationPortrait);
}



- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self ChangeDisplayView];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController.view addSubview:LeftViewController];
    [self.navigationController.view addSubview:TopWeekcontroller];
    [self.navigationController.view addSubview:UpperleftView];
    [self.navigationController setNavigationBarHidden:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [TopWeekcontroller removeFromSuperview];
    [LeftViewController removeFromSuperview];
    [UpperleftView removeFromSuperview];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [UpperleftView release];
    [TopWeekcontroller release];
    [LeftViewController removeFromSuperview];
    [super dealloc];
}


- (void)determineMove
{
    CGPoint delta;
    delta.y= self.scrollView.contentOffset.y;
    delta.x=self.scrollView.contentOffset.x;
    
    int aWeekWidth = UpperViewWidth-TextLabelborderWidth;
    int aSeesionHeight = LeftViewHeight-TextLabelborderWidth;
    int position_y = round(delta.y / aSeesionHeight );
    int position_x = round(delta.x / aWeekWidth);
    
    CGPoint offset;
    offset.x=aWeekWidth * position_x;
    offset.y = aSeesionHeight * position_y;
    [self.scrollView setContentOffset:offset animated:YES];
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    isScrollingUp=true;
    if (!decelerate)
        [self determineMove];
}




- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //isScrollingUp=true;
    [self determineMove];
    
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
}


@end
