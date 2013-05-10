//
//  WOLSwitchViewController.m
//  NTOUMobile
//
//  Created by NTOUCS on 13/2/20.
//
//

#import "WOLSwitchViewController.h"
#import "WOLChiListViewController.h"
#import "WOLEnglistViewController.h"
#import "ThroughTap.h"

@interface WOLSwitchViewController ()
@property (nonatomic) BOOL control;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer_switch;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer_add;
@property (nonatomic) BOOL chiMenuShowing;
@property (nonatomic) BOOL EngMenuShowing;
@property (nonatomic, strong) UIView *menuView;
@property (nonatomic) BOOL menushowing;
@end

@implementation WOLSwitchViewController

@synthesize swipeRecognizer;
@synthesize tapRecognizer_switch;
@synthesize tapRecognizer_add;
@synthesize chiViewController;
@synthesize engViewController;
@synthesize control;
@synthesize chiMenuShowing;
@synthesize EngMenuShowing;
@synthesize menuView;
@synthesize menushowing;

-(void)Chichooseitem
{
    if (!self.chiViewController.downLoadEditing)
    {
        //((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).image = [UIImage imageNamed:@"cancel.png"];
        [[menuView viewWithTag:28052525] removeFromSuperview];
        
        UIButton *addButton =[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.tag = 28052525;
        addButton.frame= CGRectMake(260, 10, 40, 40);
        [addButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(Chichooseitem) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:addButton];
    }
    else
    {
        //((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).image = [UIImage imageNamed:@"inbox.png"];
        [[menuView viewWithTag:28052525] removeFromSuperview];
        
        UIButton *addButton =[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.tag = 28052525;
        addButton.frame= CGRectMake(260, 10, 40, 40);
        [addButton setImage:[UIImage imageNamed:@"inbox.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(Chichooseitem) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:addButton];
    }
    [self.chiViewController chooseitem];
}

-(void)Engchooseitem
{
    
    if (!self.engViewController.downLoadEditing)
    {
         //((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).image = [UIImage imageNamed:@"cancel.png"];
        [[menuView viewWithTag:28052525] removeFromSuperview];
        
        UIButton *addButton =[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.tag = 28052525;
        addButton.frame= CGRectMake(260, 10, 40, 40);
        [addButton setImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(Engchooseitem) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:addButton];
    }
    else
    {
        //((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).image = [UIImage imageNamed:@"inbox.png"];
        [[menuView viewWithTag:28052525] removeFromSuperview];
        
        UIButton *addButton =[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.tag = 28052525;
        addButton.frame= CGRectMake(260, 10, 40, 40);
        [addButton setImage:[UIImage imageNamed:@"inbox.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(Engchooseitem) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:addButton];
    }
    [self.engViewController chooseitem];
}


- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    NSInteger screenheight = [[UIScreen mainScreen] bounds].size.height;
    self.view.frame = CGRectMake(0, 0, 320, screenheight);
    
    
    chiViewController.menuHeight = 0;
    engViewController.menuHeight = 0;
    self.engViewController = [[WOLEnglistViewController alloc]initWithStyle:UITableViewStylePlain];
    self.chiViewController = [[WOLChiListViewController alloc]initWithStyle:UITableViewStylePlain];
    engViewController.switchviewcontroller = self;
    chiViewController.switchviewcontroller = self;
    [self.view addSubview:self.chiViewController.view];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                  initWithImage:[UIImage imageNamed:@"tray_full_24.png"]
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(showMenuView)];
    menuButton.style = UIBarButtonItemStylePlain;
    
    self.navigationItem.rightBarButtonItem = menuButton;
    
    swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(switchViews)];
    swipeRecognizer.delegate  = self;
    swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeRecognizer];
    self.title = @"行事曆";
    
   /* if([[NSUserDefaults standardUserDefaults] boolForKey:@"showNotifyCalendar"] != YES)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"【NTOU】行事曆 貼心使用提示"
                                                        message:@"點選右上方-匯入-圖示\n可以選擇想要的事件\n匯入您手機的 行事曆APP 中\n*左右滑動可以切換中英版本*"
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil];
        [alert show];
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"showNotifyCalendar"];
    }*/
    
    self.chiViewController.switchviewcontroller = self;
    self.engViewController.switchviewcontroller = self;
    
    menuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    menuView.backgroundColor = [UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0f];
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton addTarget:self action:@selector(Chichooseitem) forControlEvents:UIControlEventTouchUpInside];
    addButton.tag = 28052525;
    addButton.frame= CGRectMake(260, 10, 40, 40);
    [addButton setImage:[UIImage imageNamed:@"inbox.png"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"inbox_down_24.png"] forState:UIControlStateHighlighted];
    [menuView addSubview:addButton];
    
    UIButton *EngButton =[UIButton buttonWithType:UIButtonTypeCustom];
    [EngButton addTarget:self action:@selector(switchViews) forControlEvents:UIControlEventTouchUpInside];
    EngButton.tag = 22055025;
    [EngButton setFrame:CGRectMake(180, 10, 60, 40)];
    [EngButton setTitle:@"Eng" forState:UIControlStateNormal];
    //EngButton.titleLabel.textColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
    [menuView addSubview:EngButton];
    
    chiMenuShowing = NO;
    EngMenuShowing = NO;

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.chiViewController.downLoadEditing)
        [self Chichooseitem];
    if (self.engViewController.downLoadEditing)
        [self Engchooseitem];
    
    NSInteger screenheight = [[UIScreen mainScreen] bounds].size.height;
    CGRect menuFrame = menuView.frame;
	CGRect chiviewFrame = chiViewController.view.frame;
    CGRect engviewFrame = engViewController.view.frame;
    
    menuFrame.origin.y = menuFrame.size.height * (-1);
    chiviewFrame.size.height = screenheight;
    chiviewFrame.origin.y = 0;
    
    if (self.engViewController.view.superview == nil)   //在中文界面切出
        engviewFrame.size.height = screenheight - 64 - 60;
    else    //在英文界面切出
        engviewFrame.size.height = screenheight - 64;
    engviewFrame.origin.y = 0;
    
    menuView.frame = menuFrame;
    chiViewController.view.frame = chiviewFrame;
    engViewController.view.frame = engviewFrame;
    
    menushowing = NO;
}

- (void)switchViews
{
    
    if ([self.title isEqual: @"行事曆"])
         self.title = @"Calendar";
    else self.title = @"行事曆";
    [UIView beginAnimations:@"View Curl" context:nil];      // bold
    [UIView setAnimationDuration:0.5];                     // bold
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   // bold
    if (self.engViewController.view.superview == nil) {
        if (self.engViewController == nil) {
            self.engViewController =
            [[WOLEnglistViewController alloc]initWithStyle:UITableViewStylePlain];
        }
        [UIView setAnimationTransition:                         // bold
         UIViewAnimationTransitionFlipFromLeft                 // bold
                               forView:self.view cache:YES];    // bold
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"tray_full_24.png"]
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(showMenuView)];
        menuButton.style = UIBarButtonItemStylePlain;
        
        self.navigationItem.rightBarButtonItem = menuButton;
        
        [[menuView viewWithTag:28052525] removeFromSuperview];
        
        UIButton *addButton =[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.tag = 28052525;
        addButton.frame= CGRectMake(260, 10, 40, 40);
        [addButton setImage:[UIImage imageNamed:@"inbox.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(Engchooseitem) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:addButton];
        
        [[menuView viewWithTag:22055025] removeFromSuperview];
        
        UIButton *ChiButton =[UIButton buttonWithType:UIButtonTypeCustom];
        ChiButton.tag = 22055025;
        ChiButton.frame= CGRectMake(180, 10, 60, 40);
        [ChiButton setTitle:@"中文" forState:UIControlStateNormal];
        [ChiButton addTarget:self action:@selector(switchViews) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:ChiButton];
        
        self.chiViewController.downLoadEditing = YES;
        [self.chiViewController chooseitem];
        [self.chiViewController.view removeFromSuperview];
        [self.view insertSubview:self.engViewController.view atIndex:0];
        
        [self.view removeGestureRecognizer:swipeRecognizer];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeRecognizer];
        
        [self showMenuView];
    } else {
        if (self.chiViewController == nil) {
            self.chiViewController =
            [[WOLChiListViewController alloc] initWithStyle:UITableViewStylePlain];
        }
        [UIView setAnimationTransition:                         // bold
         UIViewAnimationTransitionFlipFromRight                  // bold
                               forView:self.view cache:YES];    // bold
        
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"tray_full_24.png"]
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(showMenuView)];
        menuButton.style = UIBarButtonItemStylePlain;
        
        self.navigationItem.rightBarButtonItem = menuButton;
        
        [[menuView viewWithTag:28052525] removeFromSuperview];
        
        UIButton *addButton =[UIButton buttonWithType:UIButtonTypeCustom];
        addButton.tag = 28052525;
        addButton.frame= CGRectMake(260, 10, 40, 40);
        [addButton setImage:[UIImage imageNamed:@"inbox.png"] forState:UIControlStateNormal];
        [addButton addTarget:self action:@selector(Chichooseitem) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:addButton];
        
        [[menuView viewWithTag:22055025] removeFromSuperview];
        
        UIButton *EngButton =[UIButton buttonWithType:UIButtonTypeCustom];
        EngButton.tag = 22055025;
        EngButton.frame= CGRectMake(180, 10, 60, 40);
        [EngButton setTitle:@"Eng" forState:UIControlStateNormal];
        [EngButton addTarget:self action:@selector(switchViews) forControlEvents:UIControlEventTouchUpInside];
        [menuView addSubview:EngButton];
        
        self.engViewController.downLoadEditing = YES;
        [self.engViewController chooseitem];
        [self.engViewController.view removeFromSuperview];
        [self.view insertSubview:self.chiViewController.view atIndex:0];
        
        [self.view removeGestureRecognizer:swipeRecognizer];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeRecognizer];
        
        [self showMenuView];
    }
    [UIView commitAnimations];                                   // bold
}


#pragma mark -
#pragma mark menuView

- (void)showMenuView
{
	CGRect menuFrame = menuView.frame;
    CGRect viewFrame = self.view.frame;
    CGRect chitoolbarFrame = chiViewController.actionToolbar.frame;
    CGRect engtoolbarFrame = engViewController.actionToolbar.frame;
    
    [UIView beginAnimations:nil context:nil];
	[UIView setAnimationBeginsFromCurrentState:YES];
    
	if (!menushowing)          //顯示
	{
		menuFrame.origin.y = 0;
        viewFrame.size.height -= menuFrame.size.height;
        viewFrame.origin.y = menuFrame.size.height;
        
        menuView.frame = menuFrame;
        self.view.frame = viewFrame;
        
        if (self.chiViewController.downLoadEditing)
        {
            chitoolbarFrame.origin.y -= menuFrame.size.height;
            chiViewController.actionToolbar.frame = chitoolbarFrame;
        }
        if (self.engViewController.downLoadEditing)
        {
            engtoolbarFrame.origin.y -= menuFrame.size.height;
            engViewController.actionToolbar.frame = engtoolbarFrame;
        }
        
        menushowing = YES;
        [self.view.superview insertSubview:menuView atIndex:0];
	}
	else if(menushowing)    //隱藏
	{
		menuFrame.origin.y = menuFrame.size.height * (-1);
        viewFrame.size.height += menuFrame.size.height;
        viewFrame.origin.y = 0;
        
        menuView.frame = menuFrame;
        self.view.frame = viewFrame;
        
        if (self.chiViewController.downLoadEditing)
        {
            chitoolbarFrame.origin.y += menuFrame.size.height;
            chiViewController.actionToolbar.frame = chitoolbarFrame;
        }
        if (self.engViewController.downLoadEditing)
        {
            engtoolbarFrame.origin.y += menuFrame.size.height;
            engViewController.actionToolbar.frame = engtoolbarFrame;
        }
        
        menushowing = NO;
        [menuView removeFromSuperview];
	}
	
	[UIView commitAnimations];
}

@end
