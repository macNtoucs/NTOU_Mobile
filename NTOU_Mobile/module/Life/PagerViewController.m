//
//  ViewController.m
//  PageViewController
//
//  Created by Tom Fewster on 11/01/2012.
//

#import "PagerViewController.h"
#import "LifeButton.h"
#import "NTOUGuideSetViewController.h"

@interface PagerViewController ()
@property (assign) BOOL pageControlUsed;
@property (assign) NSUInteger page;
@property (assign) BOOL rotating;
@end

@implementation PagerViewController

@synthesize lifeScrollView;
@synthesize pageControl;
@synthesize pageControlUsed = _pageControlUsed;
@synthesize page = _page;
@synthesize rotating = _rotating;
@synthesize buttonAlertTempData;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        
        
    }
    
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View1"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View2"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View3"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View4"]];
    [self addChildViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"View5"]];

    
    [self getNSDictionaryFromServer];
    
    self.view.backgroundColor = [UIColor blackColor];
    offset = 0.0;
    
    self.lifeScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(-20, 0, 360, [[UIScreen mainScreen] bounds].size.height-100)];
    self.lifeScrollView.showsHorizontalScrollIndicator = NO;
    self.lifeScrollView.backgroundColor = [UIColor clearColor];
    self.lifeScrollView.scrollEnabled = YES;
    self.lifeScrollView.pagingEnabled = YES;
    self.lifeScrollView.delegate = self;
    self.lifeScrollView.contentSize = CGSizeMake(360*[self.childViewControllers count], [[UIScreen mainScreen] bounds].size.height-100);
    
    //--------------------- Streets informations-------------------
    //由於圖片會被壓縮成剛好顯示 所以需要streetsPixelY來計算壓縮比例 來換算button座標
    //streetsInfo 裝了各個街道的資料
    //st 裝了各個符號的各別資料
    //一個符號配三個數字 (原點x,原點y,初始編號)
    //S符號數字另外標記 EX:S01、S02、S87
    const int streets = 5;
    NSArray * streetsNames = [[NSArray alloc]initWithObjects:@"祥豐街",@"中正路",@"北寧路",@"新豐街",@"深溪路", nil];
    int streetsPixelY[streets] = {1130,1702,1068,1592,1466};
    int streetsPixelX[streets] = {662,814,662,662,662};
    NSDictionary *st1 = [NSDictionary dictionaryWithObjectsAndKeys:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:40],[NSNumber numberWithInt:235],[NSNumber numberWithInt:0], nil],@"L", nil];
    NSDictionary *st2 = [NSDictionary dictionaryWithObjectsAndKeys:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:452],[NSNumber numberWithInt:212],[NSNumber numberWithInt:26], nil],@"R",[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:70],[NSNumber numberWithInt:212],[NSNumber numberWithInt:26], nil],@"L",[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:70],[NSNumber numberWithInt:946],[NSNumber numberWithInt:0], nil],@"S0",[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:540],[NSNumber numberWithInt:1459],[NSNumber numberWithInt:0], nil],@"S1",[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:240],[NSNumber numberWithInt:1459],[NSNumber numberWithInt:0], nil],@"S2", nil];
    NSDictionary *st3 = [NSDictionary dictionaryWithObjectsAndKeys:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:350],[NSNumber numberWithInt:255],[NSNumber numberWithInt:66], nil],@"R", nil];
    NSDictionary *st4 = [NSDictionary dictionaryWithObjectsAndKeys:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:379],[NSNumber numberWithInt:117],[NSNumber numberWithInt:86], nil],@"R",[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:40],[NSNumber numberWithInt:117],[NSNumber numberWithInt:86], nil],@"L", nil];
    NSDictionary *st5 = [NSDictionary dictionaryWithObjectsAndKeys:[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:380],[NSNumber numberWithInt:160],[NSNumber numberWithInt:131], nil],@"R",[[NSArray alloc] initWithObjects:[NSNumber numberWithInt:30],[NSNumber numberWithInt:160],[NSNumber numberWithInt:131], nil],@"L", nil];
    NSArray * streetsInfo = [[NSArray alloc]initWithObjects:st1,st2,st3,st4,st5, nil];
    //-------------------------------------------------------------
    
    // the data in device
    NSArray* streetsSouce = [[NSUserDefaults standardUserDefaults]arrayForKey:@"LifeStore"];
    if(!streetsSouce)
        streetsSouce = [[[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LifeDefaultData" ofType:@"plist"]]objectForKey:@"store"];
    
    for (int i = 0; i<[self.childViewControllers count]; i++){
        UITapGestureRecognizer *doubleTap =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        [doubleTap setNumberOfTapsRequired:2];
        
        UIScrollView *s = [[UIScrollView alloc] initWithFrame:CGRectMake(360*i, 0, 360, [[UIScreen mainScreen] bounds].size.height-100)];
        s.backgroundColor = [UIColor clearColor];
        s.contentSize = CGSizeMake(360, [[UIScreen mainScreen] bounds].size.height-100);
        s.showsHorizontalScrollIndicator = NO;
        s.showsVerticalScrollIndicator = NO;
        s.delegate = self;
        s.minimumZoomScale = 1.0;
        s.maximumZoomScale = 3.0;
        s.tag = i+1;
        [s setZoomScale:1.0];
        
        UIViewController *controller = [self.childViewControllers objectAtIndex:i];
        
        controller.view.frame = CGRectMake(20, 0, 320, [[UIScreen mainScreen] bounds].size.height-100);
        [controller.view setContentMode:UIViewContentModeScaleAspectFit];
        controller.view.userInteractionEnabled = YES;
        controller.view.tag = i+1;
        [controller.view addGestureRecognizer:doubleTap];
        [s addSubview:controller.view];
        
        double ratio = ([[UIScreen mainScreen] bounds].size.height-100) / streetsPixelY[i] ; // 壓縮比
        double newOrg = (320-streetsPixelX[i]*ratio)/2; //新原點
        double diffy = 31*ratio; // button.y都是 31 pixels 這裡先計算 節省後面的計算步驟
        double diffx = 300*ratio; // 同上 button.x 都是 300pixels
        
        
            for(int j=0;j<[streetsSouce count];j++)
            {
                NSDictionary * ptr = [streetsSouce objectAtIndex:j];
                NSString * ptr_id = [ptr objectForKey:@"id"];
                
                if([[ptr objectForKey:@"street"] isEqualToString: [streetsNames objectAtIndex:i]])
                {
                    if([ptr_id length] > 0 && [ptr_id characterAtIndex:0] != 'E')
                    {
                        NSArray *temp;
                        int pos;
                        if([ptr_id characterAtIndex:0] == 'S' )
                            //Special tag
                        {
                            temp = [[streetsInfo objectAtIndex:i]objectForKey:ptr_id];
                            pos =0;
                        }
                        else
                            //Normal tag
                        {
                            temp = [[streetsInfo objectAtIndex:i]objectForKey:[NSString stringWithFormat:@"%c",[ptr_id characterAtIndex:0]]];
                            pos = ([[ptr_id substringFromIndex:1] intValue] - [[temp objectAtIndex:2]intValue]);
                        }
                        LifeButton * btn = [LifeButton buttonWithType:UIButtonTypeCustom];
                        [btn setFrame:CGRectMake(newOrg + [[temp objectAtIndex:0] intValue] *ratio, [[temp objectAtIndex:1] intValue] *ratio + pos*diffy, diffx, diffy)];
                        [btn setTitle:[ptr objectForKey:@"name"] forState:UIControlStateNormal];
                        btn.titleLabel.font = [UIFont systemFontOfSize:9];
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [btn addTarget:self action:@selector(lifeButtonPressedHandler:) forControlEvents:UIControlEventTouchUpInside];
                        btn.data = ptr ;
                        [btn setContentMode:UIViewContentModeLeft];
                        //[controller.view addSubview:btn];
                        
                        UIImageView * btnIcon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[[ptr objectForKey:@"type"] stringByReplacingOccurrencesOfString:@"/" withString:@""],@".png"]]];
                        [btnIcon setFrame:CGRectMake(btn.frame.origin.x - 31 *ratio, btn.frame.origin.y, diffy, diffy)];
                        //[controller.view addSubview:btnIcon];
                        
                        [controller.view addSubview:btn];
                        [controller.view addSubview:btnIcon];
                        
                        [btn release];
                        [btnIcon release];

                    }
                }
            }
        
            [self.lifeScrollView addSubview:s];
            [s release];
        
    }

    [self.view addSubview:self.lifeScrollView];

}


- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if ([self.childViewControllers count]) {
		UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		if (viewController.view.superview != nil) {
			[viewController viewDidAppear:animated];
		}
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	if ([self.childViewControllers count]) {
		UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		if (viewController.view.superview != nil) {
			[viewController viewWillDisappear:animated];
		}
	}
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	if (viewController.view.superview != nil) {
		[viewController viewDidDisappear:animated];
	}
	[super viewDidDisappear:animated];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
	UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	[oldViewController viewDidDisappear:YES];
	[newViewController viewDidAppear:YES];
	
	_page = self.pageControl.currentPage;
}

-(void)getNSDictionaryFromServer
{
    NSURL *url = [NSURL URLWithString:@"http://140.121.100.103:8080/CircleServlet/CircleServlet.do"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:600.0];
    
    [request setHTTPMethod:@"POST"];
    NSString *postString = @"version=0&dataType=jason";
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(data)
        {
            NSDictionary *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: nil];
            
            NSString *version = [[NSUserDefaults standardUserDefaults] stringForKey:@"LifeVersion"];
            if(version != [jsonArray objectForKey:@"version"])
            {
                [[NSUserDefaults standardUserDefaults]setObject:[jsonArray objectForKey:@"version"] forKey:@"LifeVersion"];
                [[NSUserDefaults standardUserDefaults]setObject:[jsonArray objectForKey:@"store"] forKey:@"LifeStore"];
            }

        }
    }];
    [task resume];
}


-(void)lifeButtonPressedHandler:(LifeButton*)button
{
    NSLog(@"%@",button.data);
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:[button.data objectForKey:@"name"] message:[button.data objectForKey:@"phone"]
                                                   delegate:self cancelButtonTitle:@"確定" otherButtonTitles:@"撥號",@"地圖", nil];
    buttonAlertTempData = button.data;
    
    [alert show];
    [alert release];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        NSURL* url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@",alertView.message]];
        [[ UIApplication sharedApplication]openURL:url];
    }
    else if(buttonIndex == 2)
    {
        NTOUGuideSetViewController  * stopsLocation = [[NTOUGuideSetViewController  alloc]init];
        CLLocationCoordinate2D location ;
        location.longitude = [[buttonAlertTempData objectForKey:@"longitude"] doubleValue];
        location.latitude = [[buttonAlertTempData objectForKey:@"latitude"] doubleValue];
        [stopsLocation setlocation:location latitudeDelta:0.002 longitudeDelta:0.002];
        stopsLocation.view.hidden = NO;
        stopsLocation.title = [buttonAlertTempData objectForKey:@"name"];
        [self.navigationController pushViewController:stopsLocation animated:YES];
        stopsLocation.navigationItem.leftBarButtonItem.title=@"back";
        [stopsLocation release];
    }
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed || _rotating) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = self.lifeScrollView.frame.size.width;
    int page = floor((self.lifeScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	if (self.pageControl.currentPage != page) {
		UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
		[oldViewController viewWillDisappear:YES];
		[newViewController viewWillAppear:YES];
		self.pageControl.currentPage = page;
		[oldViewController viewDidDisappear:YES];
		[newViewController viewDidAppear:YES];
		_page = page;
	}
}

#pragma mark - ScrollView delegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)View{
    
    for (UIView *v in View.subviews){
        return v;
    }
    return nil;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)View{
    _pageControlUsed = NO;
    if (View == self.lifeScrollView){
        CGFloat x = lifeScrollView.contentOffset.x;
        if (x==offset){
            
        }
        else {
            offset = x;
            for (UIScrollView *s in View.subviews){
                if ([s isKindOfClass:[UIScrollView class]]){
                    [s setZoomScale:1.0];
                    UIImageView *image = [[s subviews] objectAtIndex:0];
                    image.frame = CGRectMake(20, 0, 320, [[UIScreen mainScreen] bounds].size.height-100);
                }
            }
        }
    }
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{

}

-(void)handleDoubleTap:(UIGestureRecognizer *)gesture{
    
    float newScale = [(UIScrollView*)gesture.view.superview zoomScale] * 1.5;
    CGRect zoomRect = [self zoomRectForScale:newScale  inView:(UIScrollView*)gesture.view.superview withCenter:[gesture locationInView:gesture.view]];
    UIView *view = gesture.view.superview;
    if ([view isKindOfClass:[UIScrollView class]]){
        UIScrollView *s = (UIScrollView *)view;
        [s zoomToRect:zoomRect animated:YES];
    }
}

-(CGRect)zoomRectForScale:(float)scale inView:(UIScrollView*)scrollView withCenter:(CGPoint)center {
    
    CGRect zoomRect;
    
    zoomRect.size.height = scrollView.frame.size.height / scale;
    zoomRect.size.width  = scrollView.frame.size.width  / scale;
    
    zoomRect.origin.x    = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height / 2.0);
    
    return zoomRect;
}

- (IBAction)changePage:(id)sender {
    int page = (int)((UIPageControl *)sender).currentPage;
    
    // update the scroll view to the appropriate page
    CGRect frame = self.lifeScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
    UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
    UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
    [oldViewController viewWillDisappear:YES];
    [newViewController viewWillAppear:YES];
    
    [self.lifeScrollView scrollRectToVisible:frame animated:YES];
    
    // Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

@end



