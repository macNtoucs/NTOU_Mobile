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

@interface WOLSwitchViewController ()
@property (nonatomic) BOOL control;
@property (strong, nonatomic) UISwipeGestureRecognizer *swipeRecognizer;
@end

@implementation WOLSwitchViewController

@synthesize swipeRecognizer;
@synthesize chiViewController;
@synthesize engViewController;
@synthesize control;

-(void)Chichooseitem
{
    if (!self.chiViewController.downLoadEditing)
    {
        ((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).image = [UIImage imageNamed:@"cancel.png"];
    }
    else
    {
        ((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).image = [UIImage imageNamed:@"inbox.png"];
    }
    [self.chiViewController chooseitem];
}

-(void)Engchooseitem
{
    
    if (!self.engViewController.downLoadEditing)
    {
         ((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).image = [UIImage imageNamed:@"cancel.png"];
    }
    else
    {
        ((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).image = [UIImage imageNamed:@"inbox.png"];
    }
    [self.engViewController chooseitem];
}

- (void)popNav {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"上一頁" style:UIBarButtonItemStylePlain target:self action:@selector(popNav)] autorelease];
	// Do any additional setup after loading the view.
    NSInteger screenheight = [[UIScreen mainScreen] bounds].size.height;
    self.view.frame = CGRectMake(0, 0, 320, screenheight);
    
    self.engViewController = [[WOLEnglistViewController alloc]initWithStyle:UITableViewStylePlain];
    self.chiViewController = [[WOLChiListViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.view insertSubview:self.chiViewController.view atIndex:0];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithImage:[UIImage imageNamed:@"inbox.png"]
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(Chichooseitem)];
    
    UIBarButtonItem *EngButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Eng."
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(switchViews)];
    
    NSArray *buttons = [[NSArray alloc] initWithObjects:EngButton, nil]; //刪除addButton
    self.navigationItem.rightBarButtonItems = buttons;
    
    
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
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"inbox.png"]
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(Engchooseitem)];
        
        UIBarButtonItem *ChiButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"中文"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(switchViews)];
        
        NSArray *buttons = [[NSArray alloc] initWithObjects:ChiButton, nil];//刪除addButton
        self.navigationItem.rightBarButtonItems = buttons;
        
        self.chiViewController.downLoadEditing = YES;
        [self.chiViewController chooseitem];
        [self.chiViewController.view removeFromSuperview];
        [self.view insertSubview:self.engViewController.view atIndex:0];
        
        [self.view removeGestureRecognizer:swipeRecognizer];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeRecognizer];
    } else {
        if (self.chiViewController == nil) {
            self.chiViewController =
            [[WOLChiListViewController alloc] initWithStyle:UITableViewStylePlain];
        }
        [UIView setAnimationTransition:                         // bold
         UIViewAnimationTransitionFlipFromRight                  // bold
                               forView:self.view cache:YES];    // bold
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithImage:[UIImage imageNamed:@"inbox.png"]
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(Chichooseitem)];
        
        UIBarButtonItem *EngButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Eng."
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(switchViews)];
        NSArray *buttons = [[NSArray alloc] initWithObjects:EngButton, nil];
        self.navigationItem.rightBarButtonItems = buttons;//刪除addButton
        
        self.engViewController.downLoadEditing = YES;
        [self.engViewController chooseitem];
        [self.engViewController.view removeFromSuperview];
        [self.view insertSubview:self.chiViewController.view atIndex:0];
        
        [self.view removeGestureRecognizer:swipeRecognizer];
        swipeRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeRecognizer];
    }
    [UIView commitAnimations];                                   // bold
}

@end
