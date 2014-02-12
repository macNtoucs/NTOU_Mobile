//
//  TPRouteByButtonViewController.m
//  bus
//
//  Created by NTOUCS on 12/10/30.
//
//

#import "TPRouteByButtonViewController.h"

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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenWidth = screenSize.width;
    screenHeight = screenSize.height;

    
    self.title = @"北北基公車";
    havingTableView = NO;
    partBusName = [[NSMutableString alloc] init];
    compBusName = [[NSArray alloc] init];
    compDeparName = [[NSMutableArray alloc] init];
    compDestiName = [[NSMutableArray alloc] init];
    cityName = [[NSMutableArray alloc] init];
    [self showFirstLayerButtons];
    
    // Do any additional setup after loading the view.
    
    //NSLog(@"RouteByButton");
    
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)showFirstLayerButtons
{
    buttonFirstView = [[[UIView alloc] initWithFrame:CGRectMake(0, 480, 320, 250)] retain];
    //[buttonFirstView setBackgroundColor:[UIColor colorWithRed:6/255.0 green:227/255.0 blue:251/255.0 alpha:90/100.0]];
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
    havingTableView = YES;
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-250) style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
}

- (void)showTableViewContent
{
    //NSLog(@"partBusName = %@", partBusName);
    [compDeparName removeAllObjects];
    [compDestiName removeAllObjects];
    [cityName removeAllObjects];
    
    NSMutableString *encodedStop = (NSMutableString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)partBusName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    NSString *strURL = [NSString stringWithFormat:@"http://140.121.91.62/RouteByButton_new.php?partBusName=%@", encodedStop];
    
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    NSString *strResult = [[[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding]autorelease];
    
    NSArray * tmpInfo = [[NSArray alloc] init];
    tmpInfo = [strResult componentsSeparatedByString:@";"];
    
    compBusName = [[[tmpInfo objectAtIndex:0] componentsSeparatedByString:@"|"] retain];
    
    NSArray * tmpCompDepar = [[NSArray alloc] init];
    tmpCompDepar = [[tmpInfo objectAtIndex:1] componentsSeparatedByString:@"|"];
    
    for (NSString * str in tmpCompDepar)
        [compDeparName addObject:str];
    [compDeparName removeLastObject];
    
    NSArray * tmpCompDesti = [[NSArray alloc] init];
    tmpCompDesti = [[tmpInfo objectAtIndex:2] componentsSeparatedByString:@"|"];
    for (NSString * str in tmpCompDesti)
        [compDestiName addObject:str];
    [compDestiName removeLastObject];
    
    NSArray * tmpCityName = [[NSArray alloc] init];
    tmpCityName = [[tmpInfo objectAtIndex:3] componentsSeparatedByString:@"|"];
    for (NSString * str in tmpCityName)
        [cityName addObject:str];
    [cityName removeLastObject];
    
    NSLog(@"cityName = %@", cityName);
    
    [tableview reloadData];
}

- (void)buttonClicked:(id)sender
{
    switch ([sender tag])
    {
        case 0:
            if (havingTableView == NO)
                [self createTableView:[sender tag]];
            [partBusName appendString:@"0"];
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
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [compBusName count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [compBusName objectAtIndex:indexPath.row];
    NSString * departDestinInfo = [[NSString alloc] init];
    departDestinInfo = [[compDeparName objectAtIndex:indexPath.row] stringByAppendingString:@" - "];
    cell.detailTextLabel.text = [departDestinInfo stringByAppendingString:[compDestiName objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * selectedBusName = [[NSString alloc] init];
    selectedBusName = [compBusName objectAtIndex:indexPath.row];
    if([[cityName objectAtIndex:indexPath.row] isEqual:@"T"])
    {
        TPRouteGoBackViewController *TProuteGoBack = [[TPRouteGoBackViewController alloc] initWithStyle:UITableViewStyleGrouped];
        TProuteGoBack.title = [selectedBusName stringByAppendingString:@" 公車路線"];
        [TProuteGoBack setter_departure:[compDeparName objectAtIndex:indexPath.row]];
        [TProuteGoBack setter_destination:[compDestiName objectAtIndex:indexPath.row]];
        [TProuteGoBack setter_busName:[compBusName objectAtIndex:indexPath.row]];
        
        [self.navigationController pushViewController:TProuteGoBack animated:YES];
    }
    else if([[cityName objectAtIndex:indexPath.row] isEqual:@"N"])
    {
        NTRouteGoBackViewController *NTrouteGoBack = [[NTRouteGoBackViewController alloc]  initWithStyle:UITableViewStyleGrouped];
        NTrouteGoBack.title = [selectedBusName stringByAppendingString:@" 公車路線"];
        [NTrouteGoBack setter_departure:[compDeparName objectAtIndex:indexPath.row]];
        [NTrouteGoBack setter_destination:[compDestiName objectAtIndex:indexPath.row]];
        [NTrouteGoBack setter_busName:[compBusName objectAtIndex:indexPath.row]];
        
        [self.navigationController pushViewController:NTrouteGoBack animated:YES];
    }
    else
    {
        NSLog(@"這裡要放基隆市的公車資訊");
    }
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [compDestiName release];
    [compDeparName release];
    [cityName release];
    //[compBusName release];
    [partBusName release];
    [buttonSecondView release];
    [buttonFirstView release];
    [super dealloc];
}

@end
