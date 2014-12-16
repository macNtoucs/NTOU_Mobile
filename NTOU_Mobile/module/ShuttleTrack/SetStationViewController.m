//
//  SetStationViewController.m
//  MIT Mobile
//  交通功能：火車
//  Created by MacAir on 12/11/6.
//
//

#import "SetStationViewController.h"

@interface SetStationViewController ()

@end

@implementation SetStationViewController
@synthesize tabBarArrow;
@synthesize tag;
@dynamic  viewControllers;
@synthesize region;
@synthesize  nowSelectedRegion;
@synthesize station;

-(id)initIsHighSpeedTrain:(bool)isHighSpeedTrain{
    ThroughTap *bg = [[ThroughTap alloc]initWithFrame:CGRectMake(0,0,320,[[UIScreen mainScreen] bounds].size.height)];
    startStaion_origin =0;
    depatureStation_origin=0;
    dateSelected=0;
    queryDate = [NSString new];
    trainStyle = [[NSString alloc]initWithString:@"allKindsTrain"];
    isinitData = true;
    downloadView = [DownloadingView new];
    _isHightSpeedTrain = isHighSpeedTrain;
    if (!isHighSpeedTrain){
        startStaion = [[ NSUserDefaults standardUserDefaults]objectForKey:@"startStaion"];
        DepatureStation = [[ NSUserDefaults standardUserDefaults]objectForKey:@"DepatureStaion"];
        if (!startStaion||!DepatureStation) {
            startStaion = [[NSString alloc]initWithFormat:@"基隆"];
            DepatureStation = [[NSString alloc]initWithFormat:@"臺北"];
            [[NSUserDefaults standardUserDefaults]setObject:startStaion forKey:@"startStaion"];
            [[NSUserDefaults standardUserDefaults]setObject:DepatureStation forKey:@"DepatureStaion"];
        }
        view1 = [[SetOriginAndStationViewController alloc] initWithStyle:UITableViewStyleGrouped];
        //view1.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height);
        view1.view.frame = CGRectMake(0, 0, 320, self.view.frame.size.height-self.tabBar.frame.size.height);
        [setStartStationController.view addSubview:bg];
        [setStartStationController.view addSubview:view1.view];
        setStartStationController.tabBarItem.tag=0;
        view1.delegate = self;
        setStartStationController.tabBarItem.image = [UIImage imageNamed:@"bank.png"];
        ///////////////////////////////////////////////////////////
        view2 = [[SetOriginAndStationViewController alloc] initWithStyle:UITableViewStyleGrouped];
        view2.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height);
        [setdepatureStationviewController.view addSubview:bg];
        [setdepatureStationviewController.view addSubview:view2.view];      setdepatureStationviewController.tabBarItem.tag=1;
        view2.delegate = self;
        setdepatureStationviewController.tabBarItem.image = [UIImage imageNamed:@"bank.png"];
        ///////////////////////////////////////////////////////////
    }
    else{
        startStaion = [[NSString alloc]initWithString:@"台北"];
        DepatureStation = [[NSString alloc]initWithString:@"左營"];
        HTView_origin = [[setHTOriginAndTerminalViewController alloc] initWithStyle:UITableViewStyleGrouped];
        HTView_origin.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height);
        [setStartStationController.view addSubview:HTView_origin.view];
        [setStartStationController.view addSubview:bg];
        setStartStationController.tabBarItem.tag=0;
        HTView_origin.delegate = self;
        setStartStationController.tabBarItem.image = [UIImage imageNamed:@"bank.png"];
        ///////////////////////////////////////////////////////////
        HTView_terminal = [[setHTOriginAndTerminalViewController alloc] initWithStyle:UITableViewStyleGrouped];
        HTView_terminal.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height);
        [setdepatureStationviewController.view addSubview:HTView_terminal.view];
        [setdepatureStationviewController.view addSubview:bg];
        HTView_terminal.delegate = self;
        setdepatureStationviewController.tabBarItem.tag=1;
        setdepatureStationviewController.tabBarItem.image = [UIImage imageNamed:@"bank.png"];
        ///////////////////////////////////////////////////////////
    }
    
    calendar = [[CKViewController alloc]init];
    calendar.view.frame = CGRectMake(0, 3, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height);
    [setTimeviewController.view addSubview:calendar.view];
    setTimeviewController.tabBarItem.image = [UIImage imageNamed:@"TimeDrive.png"];
    //////////////////////////////////////////////////////////
    if (!isHighSpeedTrain){ 
    view4 = [[TrainStyleViewController alloc] initWithStyle:UITableViewStyleGrouped];
    view4.title = type4;
    view4.view.frame = CGRectMake(0, 10, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height);
    [setTrainTypeviewController.view addSubview:view4.tableView];
    view4.delegate = self;
    setTrainTypeviewController.tabBarItem.tag=3;
    setTrainTypeviewController.tabBarItem.image = [UIImage imageNamed:@"train.png"];
    }
    else {
    HTTime =[[SetTimeViewController alloc] initWithStyle:UITableViewStyleGrouped];
    HTTime.view.frame = CGRectMake(0, 10, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height);
    HTTime.delegate = self;
    [HTTime initialTime];
    [setHTTimeviewController.view addSubview:HTTime.view];
     setHTTimeviewController.tabBarItem.tag=3;
    setHTTimeviewController.tabBarItem.image = [UIImage imageNamed:@"TimeDrive.png"];
    }
    //////////////////////////////////////////////////////////
    if (!isHighSpeedTrain){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *filePath = [documentsDirectory stringByAppendingString:@"/stationNumber.plist"];
        stationNum = [[NSMutableDictionary alloc]initWithContentsOfFile:filePath];
        view5 = [[StaionInfoTableViewController alloc] init];
        view5.dataSource = self;
        view5.title = type5;
        view5.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height);
        resultViewController.view.frame= CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height+25);
        [resultViewController.view addSubview:view5.tableView];
        resultViewController.tabBarItem.tag=4;
        resultViewController.tabBarItem.image = [UIImage imageNamed:@"magnify.png"];
        //[view5 recieveData];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        view5.selectedDate = [[NSString alloc] init];
        view5.selectedDate=[view5.selectedDate stringByAppendingString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:calendar.selectedDate]]];
        NSLog(@"%@, selectedDate=%@", calendar.selectedDate, [dateFormatter stringFromDate:calendar.selectedDate]);
        view5.selectedTrainStyle = trainStyle;
    }
    else {
        ht_searchResult = [[HTSearchResultViewController alloc]init];
        ht_searchResult.dataSource = self;
        ht_searchResult.view.frame = CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height);
        resultViewController.view.frame= CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height);
        [resultViewController.view addSubview:ht_searchResult.tableView];
        resultViewController.tabBarItem.tag=4;
        resultViewController.tabBarItem.image = [UIImage imageNamed:@"magnify.png"];
        [ht_searchResult recieveData];
    }
    //////////////////////////////////////////////////////////
    if(!isHighSpeedTrain){
        viewControllers = [[NSArray alloc]initWithObjects:setStartStationController, setdepatureStationviewController,setTimeviewController,setTrainTypeviewController ,resultViewController,nil];
    }
    else{
        viewControllers = [[NSArray alloc]initWithObjects:setStartStationController, setdepatureStationviewController,setTimeviewController,setHTTimeviewController,resultViewController,nil];
    }

   // [viewControllers retain];
    [self setViewControllers:viewControllers animated:YES];
    self.delegate=self;
    
    
    self.tabBar.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-self.tabBar.frame.size.height-20, self.tabBar.frame.size.width, self.tabBar.frame.size.height+20);
    
    [self addTabBarArrow];
    [self navAddRightButton];
    [self viewDidLoad];
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        setStartStationController = [[[UIViewController alloc] init]autorelease];
        setStartStationController.title = @"起站";
        setdepatureStationviewController = [[[UIViewController alloc] init]autorelease];
        setdepatureStationviewController.title = @"訖站";
        setTimeviewController = [[[UIViewController alloc] init]autorelease];
        setTimeviewController.title = @"日期";
        setTrainTypeviewController = [[[UIViewController alloc] init]autorelease];
        setTrainTypeviewController.title = @"車種";
        resultViewController = [[[UIViewController alloc] init]autorelease];
        resultViewController.title = @"查詢";
        setHTTimeviewController = [[[UIViewController alloc] init]autorelease];
        setHTTimeviewController.title = @"時間";
    }
    return self;
}



-(void)navAddRightButton{
    UIBarButtonItem * swapStation = [[UIBarButtonItem alloc]initWithTitle:@"往返" style:UIBarButtonItemStylePlain target:self action:@selector(SwapStation)];
    self.navigationItem.rightBarButtonItem = swapStation;
}

-(void)SwapStation{
    NSString * tmpForSwap = [[NSString alloc]initWithString:DepatureStation];
    DepatureStation = [NSString stringWithString:startStaion];
    startStaion = [NSString stringWithString:tmpForSwap];
    
    [self viewDidLoad];
    
    if (self.selectedIndex==4){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMdd"];
        view5.selectedDate = [[NSString alloc] init];
        view5.selectedDate=[view5.selectedDate stringByAppendingString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:calendar.selectedDate]]];
        NSLog(@"selectedDate=%@", [dateFormatter stringFromDate:calendar.selectedDate]);
        view5.selectedTrainStyle = trainStyle;
        [view5 recieveData];
       [ht_searchResult recieveData];
    }
}

-(void)didSwipe:(id)sender{
    UISwipeGestureRecognizer *swipeRecognizer = (UISwipeGestureRecognizer *)sender;
    if(swipeRecognizer.direction == UISwipeGestureRecognizerDirectionLeft ||swipeRecognizer.direction == UISwipeGestureRecognizerDirectionRight ){
        [self SwapStation];
    }
}
- (CGFloat) horizontalLocationFor:(NSUInteger)tabIndex
{
    CGFloat tabItemWidth = self.tabBar.frame.size.width / [viewControllers count];
    CGFloat halfTabItemWidth = (tabItemWidth / 2.0) - (tabBarArrow.frame.size.width / 2.0);
    return (tabIndex * tabItemWidth) + halfTabItemWidth;
}
- (void) addTabBarArrow
{
    UIImage* tabBarArrowImage = [UIImage imageNamed:@"TabBarNipple@2x.png"];
    self.tabBarArrow = [[UIImageView alloc] initWithImage:tabBarArrowImage] ;
    CGFloat verticalLocation = [[UIScreen mainScreen] bounds].size.height-tabBarArrowImage.size.height-self.tabBar.frame.size.height-[[UIApplication sharedApplication] statusBarFrame].size.height-44+5;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>7.0)
    {
        tabBarArrow.frame = CGRectMake([self horizontalLocationFor:0], [[UIScreen mainScreen] bounds].size.height-122, tabBarArrowImage.size.width, tabBarArrowImage.size.height);
    }
    else
    {
        tabBarArrow.frame = CGRectMake([self horizontalLocationFor:0], [[UIScreen mainScreen] bounds].size.height-(self.tabBar.frame.size.height*2)-5, tabBarArrowImage.size.width, tabBarArrowImage.size.height);
    }
    
    [self.view addSubview:tabBarArrow];
}


- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect frame = tabBarArrow.frame;
    frame.origin.x = [self horizontalLocationFor:self.selectedIndex];
    tabBarArrow.frame = frame;
    [UIView commitAnimations];
    if (viewController.tabBarItem.tag==4){
       
        dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMdd"];
            view5.selectedDate = [[NSString alloc] init];
            view5.selectedDate=[view5.selectedDate stringByAppendingString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:calendar.selectedDate]]];
            NSLog(@"selectedDate=%@", [dateFormatter stringFromDate:calendar.selectedDate]);
            view5.selectedTrainStyle = trainStyle;
            [view5 recieveData];
            [ht_searchResult recieveData];
            dispatch_suspend(dispatch_get_current_queue());
        });
        
        // [downloadView AlertViewEnd];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSLog(@"setStation.m viewDidLoad");
   
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0) {
        
        if([[[UIDevice currentDevice]systemVersion]floatValue]>7.0)
        {
            CGRect fullScreenBounds = [[UIScreen mainScreen] bounds];
            [self.tabBar setFrame:CGRectMake(0, self.view.frame.size.height-49, 320, 40)];
            if(fullScreenBounds.size.height != self.view.frame.size.height)
                [self.tabBar setFrame:CGRectMake(0, fullScreenBounds.size.height-113, 320, 49)];
        }
        
        [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor clearColor];
    if(!_isHightSpeedTrain){
        self.title = [NSString stringWithFormat: @" %@ → %@",
                      [[ NSUserDefaults standardUserDefaults]objectForKey:@"startStaion"] ,[[ NSUserDefaults standardUserDefaults]objectForKey:@"DepatureStaion"]];
    }
    else self.title = [NSString stringWithFormat: @" 台北 → 左營"];
    
    if (((startStaion && DepatureStation) &&![startStaion isEqualToString:@""] ))
        self.title = [NSString stringWithFormat: @" %@ → %@",startStaion,DepatureStation];
    
    
    UISwipeGestureRecognizer *swipeRecognizer_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeRecognizer_right setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeRecognizer_right];
    UISwipeGestureRecognizer *swipeRecognizer_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeRecognizer_left setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.view addGestureRecognizer:swipeRecognizer_left];
    //  [swipeRecognizer release];
    
    //[self.view addSubview:self.tabBar];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)SetOriginAndStationViewTableView:(UITableViewController *)tableView nowSelected:(NSString *)_station{
    if (tableView==view1){
        startStaion = [[NSString alloc]initWithFormat:@"%@", _station ] ;
        [[NSUserDefaults standardUserDefaults]setObject:_station forKey:@"startStaion"];
    }
    else if (tableView==view2){
        DepatureStation = [[NSString alloc]initWithFormat:@"%@", _station ] ;
        [[NSUserDefaults standardUserDefaults]setObject:_station forKey:@"DepatureStaion"];
    }
    [self viewDidLoad];
}

-(void)setHTOriginAndTerminalTableView:(UITableViewController*) tableView nowSelected:(NSString*) _station{
    if (tableView==HTView_origin){
        startStaion = [[NSString alloc]initWithFormat:@"%@", _station ] ;
        [[NSUserDefaults standardUserDefaults]setObject:_station forKey:@"HTstartStaion"];
    }
    else if (tableView==HTView_terminal){
        DepatureStation = [[NSString alloc]initWithFormat:@"%@", _station ] ;
        [[NSUserDefaults standardUserDefaults]setObject:_station forKey:@"HTDepatureStaion"];
    }[self viewDidLoad];
    
}

- (NSURL*)StationInfoURL:(StaionInfoTableViewController *)stationInfoTableView{
    //[self CreateStationNumPlist];
    stationInfoTableView_delegate = self;
    if(isinitData) {
        isinitData = false;
        return [NSURL URLWithString:@""];
    }
    
    if (![startStaion isEqualToString:@""] && ![DepatureStation isEqualToString:@""] ){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        NSString *StartStationID = [NSString stringWithFormat:@"%@",[stationNum valueForKey:startStaion]];
        NSString *DepatureStationID= [NSString stringWithFormat:@"%@",[stationNum valueForKey:DepatureStation]];
        // NSArray *arr= [stationNum allKeys];
        //NSString * queryURL = @"http://twtraffic.tra.gov.tw/twrail/SearchResult.aspx?searchtype=0&searchdate=";
        NSString * queryURL = @"http://twtraffic.tra.gov.tw/twrail/SearchResult.aspx?searchtype=0&searchdate=";
        [dateFormatter setDateFormat:@"yyyy"];
        queryURL=[queryURL stringByAppendingString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:calendar.selectedDate]]];
        queryURL= [queryURL stringByAppendingString:@"%2f"];
        
        [dateFormatter setDateFormat:@"MM"];
        queryURL=[queryURL stringByAppendingString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:calendar.selectedDate]]];
        queryURL= [queryURL stringByAppendingString:@"%2f"];
       
        
        [dateFormatter setDateFormat:@"dd"];
        queryURL=[queryURL stringByAppendingString:[NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:calendar.selectedDate]]];
        
        queryURL= [queryURL stringByAppendingString:[NSString stringWithFormat:@"&fromcity=0&tocity=0&fromstation=%@&tostation=%@&",StartStationID,DepatureStationID]];
        queryURL= [queryURL stringByAppendingString:[NSString stringWithFormat:@"trainclass=%@&fromtime=0000&totime=2359",trainStyle]];
       NSLog( @"%@",queryURL);
       // queryURL= @"http://140.121.91.62/Rail_Web_Query.php?searchtype=0&searchdate=2013%2f04%2f02&fromcity=0&tocity=0&fromstation=1001&tostation=1008&trainclass=2&fromtime=0000&totime=2359";
        return [NSURL URLWithString:queryURL];
    }
}


-(void)TrainStyle:(TrainStyleViewController *)tableView nowSelectedRow:(NSInteger)indexPath{
    
    switch(indexPath){
        /*case 0 :
            trainStyle = @"'1100'%2c'1101'%2c'1102'%2c'1110'%2c'1120'"; break;
        case 1 : trainStyle = @"'1131'%2c'1132'%2c'1140'"; break;
        case 2 : trainStyle = @"2"; break;*/
        case 0 : trainStyle = @"expressTrain"; break;
        case 1 : trainStyle = @"noExpressTrain"; break;
        case 2 : trainStyle = @"allKindsTrain"; break;
            
    }
}

- (NSString *)startStationTitile:(StaionInfoTableViewController *)stationInfoTableView{
    if (![startStaion isEqualToString:@""] && startStaion)
        return startStaion;
    else return [[ NSUserDefaults standardUserDefaults]objectForKey:@"startStaion"];
}
- (NSString *)depatureStationTitile:(StaionInfoTableViewController *)stationInfoTableView{
    if (![DepatureStation isEqualToString:@""] && DepatureStation)
        return DepatureStation;
    else return [[ NSUserDefaults standardUserDefaults]objectForKey:@"DepatureStaion"];
}


- (NSURL*)HTStationInfoURL:(HTSearchResultViewController *)stationInfoTableView{
    //http://www.thsrc.com.tw/tw/TimeTable/SearchResult
    stationInfoTableView.selectedDate = calendar.selectedDate;
    stationInfoTableView.selectedHTTime=self->selectedHTTime;
    NSString * queryURL = @"http://www.thsrc.com.tw/tw/TimeTable/SearchResult";
    return [NSURL URLWithString: queryURL] ;
}
- (NSString *)HTstartStationTitile:(HTSearchResultViewController *)stationInfoTableView{
    if (![startStaion isEqualToString:@""] && startStaion)
        return startStaion;
    else return @"台北";
}
- (NSString *)HTdepatureStationTitile:(HTSearchResultViewController *)stationInfoTableView{
    if (![DepatureStation isEqualToString:@""] && DepatureStation)
        return DepatureStation;
    else return @"左營";
}

-(void)HTTime:(SetTimeViewController *) controller nowselectedTime:(NSString *)Time{
    selectedHTTime = Time;
}



@end