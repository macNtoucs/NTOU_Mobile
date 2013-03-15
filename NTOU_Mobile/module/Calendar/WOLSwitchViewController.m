//
//  WOLSwitchViewController.m
//  NTOUMobile
//
//  Created by NTOUCS on 13/2/20.
//
//

#import "WOLSwitchViewController.h"
#import "WOLChilistViewController.h"
#import "WOLEnglistViewController.h"

@interface WOLSwitchViewController ()
@property (nonatomic) BOOL control;

@end

@implementation WOLSwitchViewController

@synthesize chiViewController;
@synthesize engViewController;
@synthesize control;

-(void)Chichooseitem
{
    if (!self.chiViewController.tableView.editing)
    {
        ((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).title = @"取消";
    }
    else
    {
        ((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).title = @"下載";
    }
    [self.chiViewController chooseitem];
}

-(void)Engchooseitem
{
    
    if (!self.engViewController.tableView.editing)
    {
         ((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).title = @"Cancel";
    }
    else
    {
        ((UIBarButtonItem *)[self.navigationItem.rightBarButtonItems objectAtIndex:0]).title = @"DownLoad";
    }
    [self.engViewController chooseitem];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.engViewController = [[WOLEnglistViewController alloc]initWithStyle:UITableViewStylePlain];
    self.chiViewController = [[WOLChilistViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.view insertSubview:self.chiViewController.view atIndex:0];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"下載"
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(Chichooseitem)];
    
    UIBarButtonItem *EngButton = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Eng."
                                  style:UIBarButtonItemStyleBordered
                                  target:self
                                  action:@selector(switchViews)];
    
    NSArray *buttons = [[NSArray alloc] initWithObjects:addButton,EngButton, nil];
    self.navigationItem.rightBarButtonItems = buttons;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"【NTOU】行事曆 貼心使用提示"
                                                    message:@"點選右上方-下載-按鈕\n可以選擇想要下載的事件\n載入您手機的 行事曆APP 中"
                                                   delegate:self
                                          cancelButtonTitle:@"知道了"
                                          otherButtonTitles:nil];
    [alert show];
    self.chiViewController.switchviewcontroller = self;
    self.engViewController.switchviewcontroller = self;
}


- (void)switchViews
{
    [UIView beginAnimations:@"View Curl" context:nil];      // bold
    [UIView setAnimationDuration:0.75];                     // bold
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   // bold
    if (self.engViewController.view.superview == nil) {
        if (self.engViewController == nil) {
            self.engViewController =
            [[WOLEnglistViewController alloc]initWithStyle:UITableViewStylePlain];
        }
        [UIView setAnimationTransition:                         // bold
         UIViewAnimationTransitionCurlUp                 // bold
                               forView:self.view cache:YES];    // bold
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"DownLoad"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(Engchooseitem)];
        
        UIBarButtonItem *ChiButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"中文"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(switchViews)];
        
        NSArray *buttons = [[NSArray alloc] initWithObjects:addButton,ChiButton, nil];
        self.navigationItem.rightBarButtonItems = buttons;
         
        [self.chiViewController.tableView setEditing:YES animated:NO];
        [self.chiViewController chooseitem];
        [self.chiViewController.view removeFromSuperview];
        [self.view insertSubview:self.engViewController.view atIndex:0];
    } else {
        if (self.chiViewController == nil) {
            self.chiViewController =
            [[WOLChilistViewController alloc] initWithStyle:UITableViewStylePlain];
        }
        [UIView setAnimationTransition:                         // bold
         UIViewAnimationTransitionCurlDown                  // bold
                               forView:self.view cache:YES];    // bold
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"下載"
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(Chichooseitem)];
        
        UIBarButtonItem *EngButton = [[UIBarButtonItem alloc]
                                      initWithTitle:@"Eng."
                                      style:UIBarButtonItemStyleBordered
                                      target:self
                                      action:@selector(switchViews)];
        NSArray *buttons = [[NSArray alloc] initWithObjects:addButton,EngButton, nil];
        self.navigationItem.rightBarButtonItems = buttons;
        
        [self.engViewController.tableView setEditing:YES animated:NO];
        [self.engViewController chooseitem];
        [self.engViewController.view removeFromSuperview];
        [self.view insertSubview:self.chiViewController.view atIndex:0];
    }
    [UIView commitAnimations];                                   // bold
}

@end
