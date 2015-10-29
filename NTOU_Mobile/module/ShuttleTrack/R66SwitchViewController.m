//
//  R66SwitchViewController.m
//  NTOU_Mobile
//
//  Created by NTOUCS on 13/11/20.
//  Copyright (c) 2013年 NTOUcs_MAC. All rights reserved.
//

#import "R66SwitchViewController.h"
#import "R66TableViewController.h"
@interface R66SwitchViewController ()
@end

@implementation R66SwitchViewController
@synthesize r66TableViewController, r66routePicViewController;
@synthesize switchButton, swipeRecognizer, pinchRecognizer, imageView, scrollView, alertView;

- (void)viewDidLoad
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
    }
    NSLog(@"Left & Right Layers");
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    screenHeight = screenBound.size.height;
    screenWidth = screenBound.size.width;
    
    /* ------------------------------------------------------------------------
    NSString *errorDesc = nil;
    NSPropertyListFormat format;
    NSString *plistPath;
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                              NSUserDomainMask, YES) objectAtIndex:0];
    plistPath = [rootPath stringByAppendingPathComponent:@"AlertViewShown.plist"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath]) {
        plistPath = [[NSBundle mainBundle] pathForResource:@"AlertViewShown" ofType:@"plist"];
    }
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSDictionary *temp = (NSDictionary *)[NSPropertyListSerialization
                                          propertyListFromData:plistXML
                                          mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                          format:&format
                                          errorDescription:&errorDesc];
     */
    pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch)];
    
    R66TableViewController *r66TableViewController = [[R66TableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    r66TableViewController.tableView.frame = CGRectMake(0.0, 0.0, screenWidth, screenHeight);
    [self.view insertSubview:r66TableViewController.view atIndex:0];

    switchButton = [[UIBarButtonItem alloc] initWithTitle:@"路線圖" style:UIBarButtonItemStyleBordered target:self action:@selector(showR66RoutePic)];
    switchButton.style = UIBarButtonItemStylePlain;
    self.navigationItem.rightBarButtonItem = switchButton;
    [super viewDidLoad];
    [alertView show];
    [alertView release];
}
- (void)handlePinch
{
    
    NSLog(@"handlePinch");
    if (pinchRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if ([pinchRecognizer scale] < 1.0f)
            [pinchRecognizer setScale:1.0f];
        CGAffineTransform transform = CGAffineTransformMakeScale([pinchRecognizer scale], [pinchRecognizer scale]);
        imageView.transform = transform;
    }
}

- (void)showR66RoutePic
{
    [UIImageView beginAnimations:nil context:nil];
    [UIImageView setAnimationDuration:0.5];
    [UIImageView setAnimationCurve:UIViewAnimationCurveEaseIn];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-60)];
    imageView.image = [UIImage imageNamed:@"R66Route.png"];
    
    
    NSLog(@"%@", self.view);
    if ([switchButton.title isEqualToString:@"路線圖"])
    {
        switchButton.title = @"關閉";
        swipeRecognizer.enabled = NO;
        
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-60)];
        scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"global/body-background.png"]];
        scrollView.delegate = self;
        scrollView.scrollEnabled = YES;
        scrollView.bouncesZoom = YES;
        scrollView.clipsToBounds = YES;
        scrollView.contentSize = imageView.frame.size;
        [scrollView addSubview:imageView];
        scrollView.minimumZoomScale = scrollView.frame.size.width/imageView.frame.size.width;
        scrollView.maximumZoomScale = 2.0;
        [scrollView setZoomScale:scrollView.minimumZoomScale];
        [imageView addGestureRecognizer:pinchRecognizer];
        [self.view addSubview:scrollView];
        //[self.view bringSubviewToFront:scrollView];
        
        [UIImageView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    }
    else
    {
        swipeRecognizer.enabled = YES;
        switchButton.title = @"路線圖";
        //[imageView removeFromSuperview];
        [scrollView removeFromSuperview];
        [UIImageView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view cache:YES];
    }
    [UIImageView commitAnimations];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollViewInside
{
    NSLog(@"viewForZoomingToScollView");
    return self.imageView;
}

- (void)dealloc
{
    [switchButton release];
    [r66TableViewController release];
    [super dealloc];
}

@end

