//
//  TPRouteByButtonViewController.m
//  bus
//
//  Created by NTOUCS on 12/10/30.
//
//

#import "TPRouteByButtonViewController.h"
#import "FMDatabase.h"
#import <sqlite3.h>

@interface TPRouteByButtonViewController ()

@end

@implementation TPRouteByButtonViewController
@synthesize buttonFirstView;
@synthesize buttonSecondView;
@synthesize tableview;
@synthesize havingTableView;
@synthesize partBusName;
@synthesize compBusName;
@synthesize compDeparName;
@synthesize compDestiName;
@synthesize cityName;
@synthesize screenWidth, screenHeight;
@synthesize buttonTintColor;
@synthesize arrayTaipeiBus, arrayNewTaipeiBus, arrayKeelungBus;
@synthesize depArrayTaipeiBus, depArrayNewTaipeiBus, depArrayKeelungBus;
@synthesize desArrayTaipeiBus, desArrayNewTaipeiBus, desArrayKeelungBus;
@synthesize urlArrayKeelungBus;
@synthesize activityIndicator, partBusNameLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    partBusNameLabel.text = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    partBusNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(230.0, 27.0, 80.0, 30.0)];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        partBusNameLabel.textColor = [[UIColor alloc] initWithRed:0.0 green:45.0/255.0 blue:153.0/255.0 alpha:100.0];
    }
    else
        partBusNameLabel.textColor = [UIColor whiteColor];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;
    partBusNameLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];  // 透明背景
    partBusNameLabel.textAlignment = NSTextAlignmentCenter;
    partBusNameLabel.text = @"";
    [self.navigationController.view addSubview:partBusNameLabel];
    //NSLog(@"navView=%@", self.navigationController.view);
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
    self.title = @"北北基公車";
    havingTableView = NO;
    partBusName = [[NSMutableString alloc] init];
    compBusName = [[NSArray alloc] init];
    compDeparName = [[NSMutableArray alloc] init];
    compDestiName = [[NSMutableArray alloc] init];
    cityName = [[NSMutableArray alloc] init];
    arrayTaipeiBus = [[NSMutableArray alloc] init];
    arrayNewTaipeiBus = [[NSMutableArray alloc] init];
    arrayKeelungBus = [[NSMutableArray alloc] init];
    urlArrayKeelungBus = [[NSMutableArray alloc] init];
    depArrayTaipeiBus = [[NSMutableArray alloc] init];
    depArrayNewTaipeiBus = [[NSMutableArray alloc] init];
    depArrayKeelungBus = [[NSMutableArray alloc] init];
    desArrayTaipeiBus = [[NSMutableArray alloc] init];
    desArrayNewTaipeiBus = [[NSMutableArray alloc] init];
    desArrayKeelungBus = [[NSMutableArray alloc] init];
    [self showFirstLayerButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)showFirstLayerButtons
{
    buttonFirstView = [[[UIView alloc] initWithFrame:CGRectMake(0, 480, 320, 250)] retain];
    [buttonFirstView setBackgroundColor:[UIColor lightTextColor]];
    
    buttonTintColor = [UIColor blackColor];
    
    UIButton * buttonZero = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonZero setTitle:@"0" forState:UIControlStateNormal];
    [buttonZero setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonZero setTag:0];
    buttonZero.frame = CGRectMake(5, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonZero addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonOne setTitle:@"1" forState:UIControlStateNormal];
    [buttonOne setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonOne setTag:1];
    buttonOne.frame = CGRectMake(68, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonOne addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonTwo setTitle:@"2" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonTwo setTag:2];
    buttonTwo.frame = CGRectMake(131, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonTwo addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonThree = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonThree setTitle:@"3" forState:UIControlStateNormal];
    [buttonThree setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonThree setTag:3];
    buttonThree.frame = CGRectMake(194, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonThree addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFour = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonFour setTitle:@"4" forState:UIControlStateNormal];
    [buttonFour setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonFour setTag:4];
    buttonFour.frame = CGRectMake(257, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonFour addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonFive setTitle:@"5" forState:UIControlStateNormal];
    [buttonFive setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonFive setTag:5];
    buttonFive.frame = CGRectMake(5, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonFive addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSix = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSix setTitle:@"6" forState:UIControlStateNormal];
    [buttonSix setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonSix setTag:6];
    buttonSix.frame = CGRectMake(68, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonSix addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSeven = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSeven setTitle:@"7" forState:UIControlStateNormal];
    [buttonSeven setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonSeven setTag:7];
    buttonSeven.frame = CGRectMake(131, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonSeven addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonEight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonEight setTitle:@"8" forState:UIControlStateNormal];
    [buttonEight setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonEight setTag:8];
    buttonEight.frame = CGRectMake(194, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonEight addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNine = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNine setTitle:@"9" forState:UIControlStateNormal];
    [buttonNine setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonNine setTag:9];
    buttonNine.frame = CGRectMake(257, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonNine addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonRed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonRed setTag:11];
    [buttonRed setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonRed setTitle:@"紅" forState:UIControlStateNormal];
    buttonRed.frame = CGRectMake(5, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonRed addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBlue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonBlue setTitle:@"藍" forState:UIControlStateNormal];
    [buttonBlue setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonBlue setTag:21];
    buttonBlue.frame = CGRectMake(68, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonBlue addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBrown = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonBrown setTitle:@"棕" forState:UIControlStateNormal];
    [buttonBrown setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonBrown setTag:22];
    buttonBrown.frame = CGRectMake(131, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonBrown addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonGreen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonGreen setTitle:@"綠" forState:UIControlStateNormal];
    [buttonGreen setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonGreen setTag:12];
    buttonGreen.frame = CGRectMake(194, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonGreen addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOrange = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonOrange setTitle:@"橘" forState:UIControlStateNormal];
    [buttonOrange setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonOrange setTag:13];
    buttonOrange.frame = CGRectMake(257, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonOrange addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSmall = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSmall setTitle:@"小" forState:UIControlStateNormal];
    [buttonSmall setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonSmall setTag:23];
    buttonSmall.frame = CGRectMake(5, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonSmall addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonF = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonF setTitle:@"F" forState:UIControlStateNormal];
    [buttonF setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonF setTag:24];
    buttonF.frame = CGRectMake(68, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonF addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonMore.frame = CGRectMake(131, 140, 89, LAYER1_BUT_HEIGHT);
    [buttonMore setTag:14];
    [buttonMore setTitle:@"更多" forState:UIControlStateNormal];
    [buttonMore setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonMore addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonReset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonReset setTitle:@"重設" forState:UIControlStateNormal];
    [buttonReset setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonReset setTag:34];
    buttonReset.frame = CGRectMake(226, 140, 89, LAYER1_BUT_HEIGHT);
    [buttonReset addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    [buttonFirstView addSubview:buttonRed];
    [buttonFirstView addSubview:buttonGreen];
    [buttonFirstView addSubview:buttonOrange];
    [buttonFirstView addSubview:buttonMore];
    [buttonFirstView addSubview:buttonBlue];
    [buttonFirstView addSubview:buttonBrown];
    [buttonFirstView addSubview:buttonSmall];
    [buttonFirstView addSubview:buttonReset];
    [buttonFirstView addSubview:buttonOne];
    [buttonFirstView addSubview:buttonFour];
    [buttonFirstView addSubview:buttonSeven];
    [buttonFirstView addSubview:buttonTwo];
    [buttonFirstView addSubview:buttonFive];
    [buttonFirstView addSubview:buttonEight];
    [buttonFirstView addSubview:buttonThree];
    [buttonFirstView addSubview:buttonSix];
    [buttonFirstView addSubview:buttonNine];
    [buttonFirstView addSubview:buttonZero];
    [buttonFirstView addSubview:buttonF];
    
    [self.view addSubview:buttonFirstView];
    
    CGRect firstTopViewFrame = CGRectMake(0, screenHeight-250, screenWidth, 250);
    [UIView animateWithDuration:0.7
                          delay:0.01
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         buttonFirstView.frame = firstTopViewFrame;
                     }
                     completion:nil];
}

- (void)showSecondLayerButtons
{
    buttonSecondView = [[[UIView alloc] initWithFrame:CGRectMake(0, 480, screenWidth, 250)] retain];
    [buttonSecondView setBackgroundColor:[UIColor lightTextColor]];
    
    UIButton * buttonMain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonMain setTag:223];
    [buttonMain setTitle:@"幹線" forState:UIControlStateNormal];
    [buttonMain setTitleColor:buttonTintColor forState:UIControlStateNormal];
    buttonMain.frame = CGRectMake(8, 5, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonMain addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNeiKe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNeiKe setTag:221];
    [buttonNeiKe setTitle:@"內科" forState:UIControlStateNormal];
    [buttonNeiKe setTitleColor:buttonTintColor forState:UIControlStateNormal];
    buttonNeiKe.frame = CGRectMake(164, 5, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonNeiKe addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNanRan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNanRan setTag:231];
    [buttonNanRan setTitle:@"南軟" forState:UIControlStateNormal];
    [buttonNanRan setTitleColor:buttonTintColor forState:UIControlStateNormal];
    buttonNanRan.frame = CGRectMake(8, 65, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonNanRan addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonCitizen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonCitizen setTag:212];
    [buttonCitizen setTitle:@"市民" forState:UIControlStateNormal];
    [buttonCitizen setTitleColor:buttonTintColor forState:UIControlStateNormal];
    buttonCitizen.frame = CGRectMake(164, 65, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonCitizen addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOthers = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonOthers setTag:222];
    [buttonOthers setTitle:@"其他" forState:UIControlStateNormal];
    [buttonOthers setTitleColor:buttonTintColor forState:UIControlStateNormal];
    buttonOthers.frame = CGRectMake(8, 125, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonOthers addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonBack setTag:214];
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    buttonBack.frame = CGRectMake(164, 125, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonBack addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    [buttonSecondView addSubview:buttonCitizen];
    [buttonSecondView addSubview:buttonBack];
    [buttonSecondView addSubview:buttonNeiKe];
    [buttonSecondView addSubview:buttonOthers];
    [buttonSecondView addSubview:buttonMain];
    [buttonSecondView addSubview:buttonNanRan];
    
    [self.view addSubview:buttonSecondView];
    CGRect secondTopViewFrame = CGRectMake(0, screenHeight-250, screenWidth, 250);
    [UIView animateWithDuration:0.7
                          delay:0.01
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         buttonSecondView.frame = secondTopViewFrame;
                     }
                     completion:nil];
}

- (void)createTableView:(int)tag
{
    NSLog(@"CreateTableView");
    havingTableView = YES;
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-250) style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
}

int finderSortWithLocale(id string1, id string2, void *locale)
{
    static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSRange string1Range = NSMakeRange(0, [string1 length]);
    return [string1 compare:string2 options:comparisonOptions range:string1Range locale:(NSLocale *)locale];
}

- (void)KLFetchRouteWithWeb:(NSString *)routeNo
{
    NSString *strURL = [NSString stringWithFormat:@"http://ebus.klcba.gov.tw/KLBusWeb/pda/estimate_route.jsp?rid=%@", routeNo];
    
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    //NSString *strResult = [[[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding]autorelease];
    
    //NSLog(@"strResult = %@", strResult);
    
    TFHpple* parser = [[TFHpple alloc] initWithHTMLData:dataURL];
    NSArray *tmpRoute  = [parser searchWithXPathQuery:@"//body//div//table//tr//td"]; // get the title
    
    for(int i=1; i<[tmpRoute count]; i++)
    {
        TFHppleElement* routeData = [tmpRoute objectAtIndex:i];
        NSArray * attributes = [routeData children];
        TFHppleElement* urlAndRouteName = [attributes objectAtIndex:0];
        
        NSMutableString *url = [NSMutableString stringWithString:@"http://ebus.klcba.gov.tw/KLBusWeb/pda/"];
        [url appendFormat:@"%@", [[urlAndRouteName attributes] objectForKey:@"href"]];
        
        //NSLog(@"url = %@", url);
        
        [urlArrayKeelungBus addObject:url];
        [arrayKeelungBus addObject:[[[urlAndRouteName children] objectAtIndex:0] content]];
        
        //NSLog(@"attribute: %@, child: %@", [[urlAndRouteName attributes] objectForKey:@"href"], [[[urlAndRouteName children] objectAtIndex:0] content]);
    }
}

- (void)showTableViewContent
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:NTOUImageNameBackground]];
    [tableview applyStandardColors];
    
    [depArrayTaipeiBus removeAllObjects];
    [depArrayNewTaipeiBus removeAllObjects];
    [depArrayKeelungBus removeAllObjects];
    [desArrayTaipeiBus removeAllObjects];
    [desArrayNewTaipeiBus removeAllObjects];
    [desArrayKeelungBus removeAllObjects];
    //[urlArrayKeelungBus removeAllObjects];
    //[arrayKeelungBus removeAllObjects];
    
    // start sqlite3
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ntou_mobile3.db"];
    NSLog(@"defaultDBPath=%@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    if (![db open])
        NSLog(@"Could not open db.");
    else
        NSLog(@"Open db successly.");
    // 按了其他再按別的會壞掉;先按別的再按其他會壞掉
    if ([partBusName isEqualToString:@"其他"])
    {
        NSArray *array = [[NSArray alloc] initWithObjects:@"景美-榮總(快)", @"貓空右線", @"貓空左線(動物園)", @"貓空左線(指南宮)", @"懷恩專車S31(捷運公館)", @"懷恩專車S31(捷運忠孝復興)", @"花季專車126", @"花季專車127", @"花季專車130", @"花季專車130區", @"花季專車131", nil];
        arrayTaipeiBus = [array mutableCopy];
        NSArray *array2 = [[NSArray alloc] initWithObjects:@"景美女中", @"貓纜貓空站", @"貓纜貓空站", @"茶推廣中心停車場", @"捷運公館站", @"捷運六張犁站", @"八德市場", @"臺北車站", @"捷運劍潭站", @"第二停車場", @"花鐘", @"陽明山第二停車場", nil];
        depArrayTaipeiBus = [array2 mutableCopy];
        NSArray *array3 = [[NSArray alloc] initWithObjects:@"榮總", @"貓纜貓空站", @"捷運動物園", @"貓纜指南宮站", @"青峰活動中心", @"青峰活動中心", @"青峰活動中心", @"陽明山", @"陽明山", @"陽明書屋", @"陽明山站", @"竹子湖", nil];
        desArrayTaipeiBus = [array3 mutableCopy];
        //NSLog(@"retainCount=%d",[arrayNewTaipeiBus retainCount]);
        //[arrayNewTaipeiBus retain];

        [depArrayNewTaipeiBus retain];
        [desArrayNewTaipeiBus retain];
        /*[arrayTaipeiBus arrayByAddingObject:@"景美-榮總(快)"];
        [depArrayTaipeiBus arrayByAddingObject:@"景美女中"];
        [desArrayTaipeiBus arrayByAddingObject:@"榮總"];
        [arrayTaipeiBus retain];
        [depArrayTaipeiBus retain];
        [desArrayTaipeiBus retain];*/
        //NSLog(@"%@", arrayTaipeiBus);
        //NSLog(@"Here");
        /*[arrayTaipeiBus addObject:@"景美-榮總(快)"];
        [arrayTaipeiBus addObject:@"貓空右線"];
        [arrayTaipeiBus addObject:@"貓空左線(動物園)"];
        [arrayTaipeiBus addObject:@"貓空左線(指南宮)"];
        [arrayTaipeiBus addObject:@"懷恩專車S31(捷運公館)"];
        [arrayTaipeiBus addObject:@"懷恩專車S31(捷運六張犁)"];
        [arrayTaipeiBus addObject:@"懷恩專車S31(捷運忠孝復興)"];
        [arrayTaipeiBus addObject:@"花季專車126"];
        [arrayTaipeiBus addObject:@"花季專車127"];
        [arrayTaipeiBus addObject:@"花季專車130"];
        [arrayTaipeiBus addObject:@"花季專車130區"];
        [arrayTaipeiBus addObject:@"花季專車131"];*/
        
        /*[arrayNewTaipeiBus addObject:@"三鶯捷運先導公車"];
        [arrayNewTaipeiBus addObject:@"淡海捷運先導公車"];
        [arrayNewTaipeiBus addObject:@"萬大樹林先導公車"];*/
        
        
        /*[depArrayTaipeiBus addObject:@"景美女中"];
        [depArrayTaipeiBus addObject:@"貓纜貓空站"];
        [depArrayTaipeiBus addObject:@"貓纜貓空站"];
        [depArrayTaipeiBus addObject:@"茶推廣中心停車場"];
        [depArrayTaipeiBus addObject:@"捷運公館站"];
        [depArrayTaipeiBus addObject:@"捷運六張犁站"];
        [depArrayTaipeiBus addObject:@"八德市場"];
        [depArrayTaipeiBus addObject:@"臺北車站"];
        [depArrayTaipeiBus addObject:@"捷運劍潭站"];
        [depArrayTaipeiBus addObject:@"第二停車場"];
        [depArrayTaipeiBus addObject:@"花鐘"];
        [depArrayTaipeiBus addObject:@"陽明山第二停車場"];*/
        
        /*[depArrayNewTaipeiBus addObject:@"文昌街口"];
        [depArrayNewTaipeiBus addObject:@"龍騰區"];
        [depArrayNewTaipeiBus addObject:@"捷運輔大站"];*/
        
        /*[desArrayTaipeiBus addObject:@"榮總"];
        [desArrayTaipeiBus addObject:@"貓纜貓空站"];
        [desArrayTaipeiBus addObject:@"捷運動物園"];
        [desArrayTaipeiBus addObject:@"貓纜指南宮站"];
        [desArrayTaipeiBus addObject:@"青峰活動中心"];
        [desArrayTaipeiBus addObject:@"青峰活動中心"];
        [desArrayTaipeiBus addObject:@"青峰活動中心"];
        [desArrayTaipeiBus addObject:@"陽明山"];
        [desArrayTaipeiBus addObject:@"陽明山"];
        [desArrayTaipeiBus addObject:@"陽明書屋"];
        [desArrayTaipeiBus addObject:@"陽明山站"];
        [desArrayTaipeiBus addObject:@"竹子湖"];*/
        
        /*[desArrayNewTaipeiBus addObject:@"中鶯"];
        [desArrayNewTaipeiBus addObject:@"太子廟"];
        [desArrayNewTaipeiBus addObject:@"捷運龍山寺站"];*/
    }
    else
    {
        NSMutableString *query = [NSMutableString stringWithString:@"SELECT * FROM routeinfo WHERE nameZh LIKE '%"];
        [query appendFormat:@"%@", partBusName];
        [query appendString:@"%'"];
        //NSLog(@"query=%@", query);
        FMResultSet *rs = [db executeQuery:query];
        
        /*NSMutableString *KLquery = [NSMutableString stringWithString:@"SELECT * FROM routeinfo WHERE city LIKE 'K' AND Id LIKE '"];
        //NSMutableString *KLquery = [NSMutableString stringWithString:@"SELECT * FROM routeinfo WHERE city LIKE 'K'"];
        [KLquery appendFormat:@"%@", partBusName];
        [KLquery appendString:@"%'"];
        //NSLog(@"KLquery=%@", KLquery);
        FMResultSet *KLrs = [db executeQuery:KLquery];*/
        
        NSMutableArray *testT = [[NSMutableArray alloc] init];
        NSMutableArray *testN = [[NSMutableArray alloc] init];
        NSMutableArray *testK = [[NSMutableArray alloc] init];
        
        while ([rs next])
        {
            if ([[rs stringForColumn:@"city"] isEqualToString:@"T"])
                [testT addObject:[rs stringForColumn:@"nameZh"]];
            else if ([[rs stringForColumn:@"city"] isEqualToString:@"N"])
                [testN addObject:[rs stringForColumn:@"nameZh"]];
            else
                [testK addObject:[rs stringForColumn:@"nameZh"]];
        }
        [rs close];
        
        /*while ([KLrs next])
         {
         //NSLog(@"基隆的資料放這裡: %@", [KLrs stringForColumn:@"Id"]);
         [testK addObject:[KLrs stringForColumn:@"nameZh"]];
         }
         [KLrs close];*/
        
        //NSArray * routeNos = [[NSArray alloc]initWithObjects:@"101", @"103", @"104", @"105", @"107", @"108", @"109", @"201", @"202", @"203", @"204", @"205", @"301", @"302", @"303", @"304", @"305", @"306", @"307", @"308", @"402", @"403", @"406", @"407", @"408", @"409", @"410", @"501", @"502", @"503", @"505", @"508", @"509", @"510", @"601", @"602", @"603", @"605", @"606", @"607", @"608", @"701", @"702", @"703", @"705", @"801", @"802", nil];
        
        //NSMutableArray *matchRouteNos = [[NSMutableArray alloc] init];
        
        //for(NSString * routeNo in routeNos)
        //{
            /*if ([routeNo rangeOfString:partBusName].location == NSNotFound) {
                NSLog(@"string does not contain %@", partBusName);
            } else {
                NSLog(@"string contains %@", partBusName);*/
            //if ([routeNo rangeOfString:partBusName].location != NSNotFound) {
                //[matchRouteNos addObject:routeNo];
                //NSLog(@"match: %@", matchRouteNos);
            //}
        //}
        
        //NSMutableArray *tmp = [[NSMutableArray alloc] init];
        //for(NSString * routeNo in matchRouteNos)
        //{
            //[testK addObject:[self KLFetchRouteWithWeb:routeNo]];
            //[self KLFetchRouteWithWeb:routeNo];
            //NSLog(@"tmp = %@", tmp);
        //}
        //[urlArrayKeelungBus retain];
        
        //NSLog(@"urlArray = %@", urlArrayKeelungBus);
        
        // end sqlite3
        
        // start natural sorting
        
        arrayTaipeiBus = [testT sortedArrayUsingFunction:finderSortWithLocale context:[NSLocale currentLocale]];
        
        arrayNewTaipeiBus = [testN sortedArrayUsingFunction:finderSortWithLocale context:[NSLocale currentLocale]];
        
        arrayKeelungBus = [testK sortedArrayUsingFunction:finderSortWithLocale context:[NSLocale currentLocale]];
        
        // end natural sorting
        
        // start sqlite3
        
        for (NSString *str in arrayTaipeiBus)
        {
            [query setString:@""];
            [query appendString:@"SELECT * FROM routeinfo where nameZh = '"];
            [query appendFormat:@"%@", str];
            [query appendString:@"'"];
            //NSLog(@"query=%@", query);
            rs = [db executeQuery:query];
            while ([rs next])
            {
                [depArrayTaipeiBus addObject:[rs stringForColumn:@"departureZh"]];
                [desArrayTaipeiBus addObject:[rs stringForColumn:@"destinationZh"]];
                //NSLog(@"%@ - %@", [rs stringForColumn:@"departureZh"], [rs stringForColumn:@"destinationZh"]);
            }
            [rs close];
        }
        
        for (NSString *str in arrayNewTaipeiBus)
        {
            [query setString:@""];
            [query appendString:@"SELECT * FROM routeinfo where nameZh = '"];
            [query appendFormat:@"%@", str];
            [query appendString:@"'"];
            //NSLog(@"query=%@", query);
            rs = [db executeQuery:query];
            while ([rs next])
            {
                [depArrayNewTaipeiBus addObject:[rs stringForColumn:@"departureZh"]];
                [desArrayNewTaipeiBus addObject:[rs stringForColumn:@"destinationZh"]];
                //NSLog(@"%@ - %@", [rs stringForColumn:@"departureZh"], [rs stringForColumn:@"destinationZh"]);
            }
            [rs close];
        }
        
        for (NSString *str in arrayKeelungBus)
        {
            [query setString:@""];
            [query appendString:@"SELECT * FROM routeinfo where nameZh = '"];
            [query appendFormat:@"%@", str];
            [query appendString:@"'"];
            //NSLog(@"query=%@", query);
            rs = [db executeQuery:query];
            while ([rs next])
            {
                [depArrayKeelungBus addObject:[rs stringForColumn:@"departureZh"]];
                [desArrayKeelungBus addObject:[rs stringForColumn:@"destinationZh"]];
                //NSLog(@"KL: %@ - %@", [rs stringForColumn:@"departureZh"], [rs stringForColumn:@"destinationZh"]);
            }
            [rs close];
        }
        // end sqlite3
    }
    [db close];
    NSLog(@"showTableViewContent");
    //NSLog(@"partBusName = %@", partBusName);
    [arrayTaipeiBus retain];
    [arrayNewTaipeiBus retain];
    //NSLog(@"retainCount=%d",[arrayNewTaipeiBus retainCount]);
    [arrayKeelungBus retain];
    [tableview reloadData];
}

- (void)buttonClicked:(id)sender
{
    NSLog(@"buttonClicked");
    switch ([sender tag])
    {
        case 0:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"0"];
            NSLog(@"partBusName=%@", partBusName);
            [self showTableViewContent];
            break;
        case 1:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"1"];
            [self showTableViewContent];
            break;
        case 2:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"2"];
            [self showTableViewContent];
            break;
        case 3:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"3"];
            [self showTableViewContent];
            break;
        case 4:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"4"];
            [self showTableViewContent];
            break;
        case 5:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"5"];
            [self showTableViewContent];
            break;
        case 6:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"6"];
            [self showTableViewContent];
            break;
        case 7:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"7"];
            [self showTableViewContent];
            break;
        case 8:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"8"];
            [self showTableViewContent];
            break;
        case 9:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"9"];
            [self showTableViewContent];
            break;
        case 11:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"紅"];
            [self showTableViewContent];
            break;
        case 12:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"綠"];
            [self showTableViewContent];
            break;
        case 13:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"橘"];
            [self showTableViewContent];
            break;
        case 14:
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [buttonFirstView removeFromSuperview];
            [buttonFirstView release];
            [self showSecondLayerButtons];
            break;
        case 21:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"藍"];
            [self showTableViewContent];
            break;
        case 22:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"棕"];
            [self showTableViewContent];
            break;
        case 23:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"小"];
            [self showTableViewContent];
            break;
        case 24:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"F"];
            [self showTableViewContent];
            break;
        case 34:
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Default.png"]];
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            havingTableView = NO;
            [tableview removeFromSuperview];
            break;
        case 211:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"新北"];
            [self showTableViewContent];
            break;
        case 212:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"市民"];
            [self showTableViewContent];
            break;
        case 213:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"接駁"];
            [self showTableViewContent];
            break;
        case 214:
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [buttonSecondView removeFromSuperview];
            [buttonSecondView release];
            [self showFirstLayerButtons];
            break;
        case 221:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"內科"];
            [self showTableViewContent];
            break;
        case 222:   // 尚未完成
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"其他"];
            [self showTableViewContent];
            break;
        case 223:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"幹線"];
            [self showTableViewContent];
            break;
        case 231:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"南軟"];
            [self showTableViewContent];
            break;
        case 232:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"花季"];
            [self showTableViewContent];
            break;
        case 233:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"其他"];
            [self showTableViewContent];
            break;
        default:
            break;
    }
    partBusNameLabel.text = partBusName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if ([arrayTaipeiBus count] != 0)
            return @"台北市";
        else
            return @"";
    }
    else if (section == 1)
    {
        if ([arrayNewTaipeiBus count] != 0)
            return @"新北市";
        else
            return @"";
    }
    else
    {
        if ([arrayKeelungBus count] != 0)
            return @"基隆市";
        else
            return @"";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        //NSLog(@"section0:%lu", (unsigned long)[arrayTaipeiBus count]);
        return [arrayTaipeiBus count];
    }
    else if (section == 1)
    {
        //NSLog(@"section1:%lu", (unsigned long)[arrayNewTaipeiBus count]);
        return [arrayNewTaipeiBus count];
    }
    else
    {
        //NSLog(@"section2:%lu", (unsigned long)[arrayKeelungBus count]);
        return [arrayKeelungBus count];
    }
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    
    cellText = @"A"; // just something to guarantee one line
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:UILineBreakModeWordWrap];
    rowHeight = labelSize.height + 20.0f;
    
    return rowHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //NSLog(@"indexPath=%@", indexPath);
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSString * departDestinInfo = [[NSString alloc] init];
    cell.textLabel.font = [UIFont systemFontOfSize:20.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15.0];
    if (indexPath.section == 0)
    {
        cell.textLabel.text = [arrayTaipeiBus objectAtIndex:indexPath.row];
        departDestinInfo = [[depArrayTaipeiBus objectAtIndex:indexPath.row] stringByAppendingString:@" - "];
        cell.detailTextLabel.text = [departDestinInfo stringByAppendingString:[desArrayTaipeiBus objectAtIndex:indexPath.row]];
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = [arrayNewTaipeiBus objectAtIndex:indexPath.row];
        departDestinInfo = [[depArrayNewTaipeiBus objectAtIndex:indexPath.row] stringByAppendingString:@" - "];
        cell.detailTextLabel.text = [departDestinInfo stringByAppendingString:[desArrayNewTaipeiBus objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.textLabel.text = [arrayKeelungBus objectAtIndex:indexPath.row];
        departDestinInfo = [[depArrayKeelungBus objectAtIndex:indexPath.row] stringByAppendingString:@" - "];
        cell.detailTextLabel.text = [departDestinInfo stringByAppendingString:[desArrayKeelungBus objectAtIndex:indexPath.row]];
        //cell.detailTextLabel.text = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * selectedBusName = [[NSString alloc] init];
    partBusNameLabel.text = @"";
    //[partBusNameLabel release];  // Releasing makes app crashes.
    if (indexPath.section == 0)
    {
        selectedBusName = [arrayTaipeiBus objectAtIndex:indexPath.row];
        TPRouteDetailViewController * secondLevel = [[TPRouteDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        secondLevel.title = [NSString stringWithFormat:@"往 %@", [desArrayTaipeiBus objectAtIndex:indexPath.row]];
        [secondLevel setter_busName:selectedBusName andGoBack:0];
        [secondLevel setter_departure:[depArrayTaipeiBus objectAtIndex:indexPath.row] andDestination:[desArrayTaipeiBus objectAtIndex:indexPath.row]];
        //NSLog(@"before push view.");
        [self.navigationController pushViewController:secondLevel animated:YES];
        [secondLevel release];
        //NSLog(@"after push view.");
    }
    else if (indexPath.section == 1)
    {
        selectedBusName = [arrayNewTaipeiBus objectAtIndex:indexPath.row];
        NTRouteDetailViewController *secondLevel = [[NTRouteDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        secondLevel.title = [NSString stringWithFormat:@"往 %@", [desArrayNewTaipeiBus objectAtIndex:indexPath.row]];
        [secondLevel setter_busName:selectedBusName andGoBack:0];
        [secondLevel setter_departure:[depArrayNewTaipeiBus objectAtIndex:indexPath.row] andDestination:[desArrayNewTaipeiBus objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:secondLevel animated:YES];
        [secondLevel release];
    }
    else
    {
        //NSLog(@"基隆市公車資訊");
        selectedBusName = [arrayKeelungBus objectAtIndex:indexPath.row];
        KLRouteDetailViewController *secondLevel = [[KLRouteDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        secondLevel.title = [NSString stringWithFormat:@"%@ - %@", [depArrayKeelungBus objectAtIndex:indexPath.row], [desArrayKeelungBus objectAtIndex:indexPath.row]];
        [secondLevel setter_busName:selectedBusName andGoBack:0];
        [secondLevel setter_departure:[depArrayKeelungBus objectAtIndex:indexPath.row] andDestination:[desArrayKeelungBus objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:secondLevel animated:YES];
        [secondLevel release];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [partBusNameLabel release];
    [compDestiName release];
    [compDeparName release];
    [cityName release];
    //[arrayTaipeiBus release];
    //[arrayNewTaipeiBus release];
    [arrayKeelungBus release];
    [depArrayTaipeiBus release];
    [depArrayNewTaipeiBus release];
    [depArrayKeelungBus release];
    [desArrayTaipeiBus release];
    [desArrayNewTaipeiBus release];
    [desArrayKeelungBus release];
    //[compBusName release];
    [partBusName release];
    [buttonSecondView release];
    [buttonFirstView release];
    [super dealloc];
}

@end
