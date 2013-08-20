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
@synthesize enteringCounter;
@synthesize partBusName;
@synthesize compBusName;
@synthesize cityName;
@synthesize taipeiDeparName;
@synthesize taipeiDestiName;
@synthesize taipeiBusName;
@synthesize nTaipeiDeparName;
@synthesize nTaipeiDestiName;
@synthesize nTaipeiBusName;
@synthesize sectionNumber;
@synthesize noDataView;
@synthesize noDataLabel;

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
    
    NSLog(@"Hi");
    
    self.title = @"雙北公車";
    havingTableView = NO;
    partBusName = [[NSMutableString alloc] init];
    compBusName = [[NSArray alloc] init];
    cityName = [[NSMutableArray alloc] init];
    taipeiDeparName = [[NSMutableArray alloc] init];
    taipeiDestiName = [[NSMutableArray alloc] init];
    taipeiBusName = [[NSMutableArray alloc] init];
    nTaipeiDeparName = [[NSMutableArray alloc] init];
    nTaipeiDestiName = [[NSMutableArray alloc] init];
    nTaipeiBusName = [[NSMutableArray alloc] init];
    noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, (CURRENT_IPHONE_SIZE-250)/2-NO_DATA_LABEL_HEIGHT/2, NO_DATA_LABEL_WIDTH, NO_DATA_LABEL_HEIGHT)];
    //enteringCounter = 0;
    noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, CURRENT_IPHONE_SIZE-250)];
    noDataView.tag = CHECK_SUBVIEW_TAG;
    [self showFirstLayerButtons];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)showFirstLayerButtons
{
    buttonFirstView = [[[UIView alloc] initWithFrame:CGRectMake(0, CURRENT_IPHONE_SIZE, 320, 250)] retain];
    [buttonFirstView setBackgroundColor:BUTTON_PLATE_COLOR];
    /*CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = {0.0, 0.0, 205/255, 1.0,
        0.0, 0.0, 238/255, 1.0};
    CGFloat locations[] = {0.0, 125.0};
    size_t count = 2;
    
    CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, components, locations, count);
    CGColorSpaceRelease(rgb);
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, 250)];
    UIGraphicsBeginImageContext(imageView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawLinearGradient(context, gradient, CGPointMake(0.0, 0.0), CGPointMake(320.0, 250.0), 0);
    CGContextSaveGState(context);
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [buttonFirstView addSubview:imageView];
    [imageView release];*/
    
    UIButton * buttonRed = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonRed setTag:11];
    [buttonRed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [buttonRed setTitle:@"紅" forState:UIControlStateNormal];
    [buttonRed setTintColor:BUTTON_SELECTED_COLOR];
    //[buttonRed setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0]];
    buttonRed.frame = CGRectMake(5, 5, 58, 40);
    [buttonRed addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonGreen = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonGreen setTitle:@"綠" forState:UIControlStateNormal];
    [buttonGreen setTitleColor:[UIColor colorWithRed:0/255.0 green:128/255.0 blue:64/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonGreen setTag:12];
    [buttonGreen setTintColor:BUTTON_SELECTED_COLOR];
    buttonGreen.frame = CGRectMake(5, 50, 58, 40);
    [buttonGreen addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOrange = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonOrange setTitle:@"橘" forState:UIControlStateNormal];
    [buttonOrange setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [buttonOrange setTag:13];
    buttonOrange.frame = CGRectMake(5, 95, 58, 40);
    [buttonOrange addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMore = [UIButton buttonWithType:BUTTON_STYLE];
    buttonMore.frame = CGRectMake(5, 140, 121, 40);
    [buttonMore setTag:14];
    [buttonMore setTitle:@"更多" forState:UIControlStateNormal];
    [buttonMore setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonMore addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBlue = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonBlue setTitle:@"藍" forState:UIControlStateNormal];
    [buttonBlue setTitleColor:[UIColor colorWithRed:10/255.0 green:86/255.0 blue:255/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonBlue setTag:21];
    buttonBlue.frame = CGRectMake(68, 5, 58, 40);
    [buttonBlue addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBrown = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonBrown setTitle:@"棕" forState:UIControlStateNormal];
    [buttonBrown setTitleColor:[UIColor colorWithRed:106/255.0 green:53/255.0 blue:0/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonBrown setTag:22];
    buttonBrown.frame = CGRectMake(68, 50, 58, 40);
    [buttonBrown addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSmall = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonSmall setTitle:@"小" forState:UIControlStateNormal];
    [buttonSmall setTitleColor:[UIColor colorWithRed:245/255.0 green:30/255.0 blue:242/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonSmall setTag:23];
    buttonSmall.frame = CGRectMake(68, 95, 58, 40);
    [buttonSmall addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonReset = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonReset setTitle:@"重設" forState:UIControlStateNormal];
    [buttonReset setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonReset setTag:34];
    buttonReset.frame = CGRectMake(131, 140, 121, 40);
    [buttonReset addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOne = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonOne setTitle:@"1" forState:UIControlStateNormal];
    [buttonOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonOne setTag:1];
    buttonOne.frame = CGRectMake(131, 5, 58, 40);
    [buttonOne addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFour = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonFour setTitle:@"4" forState:UIControlStateNormal];
    [buttonFour setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonFour setTag:4];
    buttonFour.frame = CGRectMake(131, 50, 58, 40);
    [buttonFour addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSeven = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonSeven setTitle:@"7" forState:UIControlStateNormal];
    [buttonSeven setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSeven setTag:7];
    buttonSeven.frame = CGRectMake(131, 95, 58, 40);
    [buttonSeven addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonTwo = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonTwo setTitle:@"2" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonTwo setTag:2];
    buttonTwo.frame = CGRectMake(194, 5, 58, 40);
    [buttonTwo addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFive = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonFive setTitle:@"5" forState:UIControlStateNormal];
    [buttonFive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonFive setTag:5];
    buttonFive.frame = CGRectMake(194, 50, 58, 40);
    [buttonFive addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonEight = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonEight setTitle:@"8" forState:UIControlStateNormal];
    [buttonEight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonEight setTag:8];
    buttonEight.frame = CGRectMake(194, 95, 58, 40);
    [buttonEight addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonThree = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonThree setTitle:@"3" forState:UIControlStateNormal];
    [buttonThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonThree setTag:3];
    buttonThree.frame = CGRectMake(257, 5, 58, 40);
    [buttonThree addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSix = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonSix setTitle:@"6" forState:UIControlStateNormal];
    [buttonSix setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSix setTag:6];
    buttonSix.frame = CGRectMake(257, 50, 58, 40);
    [buttonSix addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNine = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonNine setTitle:@"9" forState:UIControlStateNormal];
    [buttonNine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonNine setTag:9];
    buttonNine.frame = CGRectMake(257, 95, 58, 40);
    [buttonNine addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonZero = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonZero setTitle:@"0" forState:UIControlStateNormal];
    [buttonZero setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonZero setTag:0];
    buttonZero.frame = CGRectMake(257, 140, 58, 40);
    [buttonZero addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
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
    
    [self.view addSubview:buttonFirstView];
    
    CGRect firstTopViewFrame = CGRectMake(0, CURRENT_IPHONE_SIZE-250, 320, 250);
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0.01
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         buttonFirstView.frame = firstTopViewFrame;
                     }
                     completion:nil];
}

- (void)showSecondLayerButtons
{
    buttonSecondView = [[[UIView alloc] initWithFrame:CGRectMake(0, CURRENT_IPHONE_SIZE, 320, 250)] retain];
    [buttonSecondView setBackgroundColor:BUTTON_PLATE_COLOR];
    
    UIButton * buttonNewPei = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonNewPei setTag:211];
    [buttonNewPei setTitle:@"新北" forState:UIControlStateNormal];
    buttonNewPei.frame = CGRectMake(5, 5, 100, 40);
    [buttonNewPei addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonCitizen = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonCitizen setTag:212];
    [buttonCitizen setTitle:@"市民" forState:UIControlStateNormal];
    buttonCitizen.frame = CGRectMake(5, 50, 100, 40);
    [buttonCitizen addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonShuttle = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonShuttle setTag:213];
    [buttonShuttle setTitle:@"接駁" forState:UIControlStateNormal];
    buttonShuttle.frame = CGRectMake(5, 95, 100, 40);
    [buttonShuttle addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBack = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonBack setTag:214];
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    buttonBack.frame = CGRectMake(5, 140, 310, 40);
    [buttonBack addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNeiKe = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonNeiKe setTag:221];
    [buttonNeiKe setTitle:@"內科" forState:UIControlStateNormal];
    buttonNeiKe.frame = CGRectMake(110, 5, 100, 40);
    [buttonNeiKe addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMaoKom = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonMaoKom setTag:222];
    [buttonMaoKom setTitle:@"貓空" forState:UIControlStateNormal];
    buttonMaoKom.frame = CGRectMake(110, 50, 100, 40);
    [buttonMaoKom addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMain = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonMain setTag:223];
    [buttonMain setTitle:@"幹線" forState:UIControlStateNormal];
    buttonMain.frame = CGRectMake(110, 95, 100, 40);
    [buttonMain addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNanRan = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonNanRan setTag:231];
    [buttonNanRan setTitle:@"南軟" forState:UIControlStateNormal];
    buttonNanRan.frame = CGRectMake(215, 5, 100, 40);
    [buttonNanRan addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFlower = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonFlower setTag:232];
    [buttonFlower setTitle:@"花季" forState:UIControlStateNormal];
    buttonFlower.frame = CGRectMake(215, 50, 100, 40);
    [buttonFlower addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOthers = [UIButton buttonWithType:BUTTON_STYLE];
    [buttonOthers setTag:233];
    [buttonOthers setTitle:@"其他" forState:UIControlStateNormal];
    buttonOthers.frame = CGRectMake(215, 95, 100, 40);
    [buttonOthers addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    [buttonSecondView addSubview:buttonNewPei];
    [buttonSecondView addSubview:buttonCitizen];
    [buttonSecondView addSubview:buttonShuttle];
    [buttonSecondView addSubview:buttonBack];
    [buttonSecondView addSubview:buttonNeiKe];
    [buttonSecondView addSubview:buttonMaoKom];
    [buttonSecondView addSubview:buttonMain];
    [buttonSecondView addSubview:buttonNanRan];
    [buttonSecondView addSubview:buttonFlower];
    [buttonSecondView addSubview:buttonOthers];
    
    [self.view addSubview:buttonSecondView];
    
    CGRect secondTopViewFrame = CGRectMake(0, CURRENT_IPHONE_SIZE-250, 320, 250);
    [UIView animateWithDuration:ANIMATION_DURATION
                          delay:0.01
                        options:UIViewAnimationCurveEaseOut
                     animations:^{
                         buttonSecondView.frame = secondTopViewFrame;
                     }
                     completion:nil];
}

- (void)createTableView
{
    havingTableView = YES;
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.size.width, CURRENT_IPHONE_SIZE-250) style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
}

- (void)showTableViewContent
{
    NSLog(@"showTableViewContent");
    [cityName removeAllObjects];
    [taipeiDeparName removeAllObjects];
    [taipeiDestiName removeAllObjects];
    [taipeiBusName removeAllObjects];
    [nTaipeiDeparName removeAllObjects];
    [nTaipeiDestiName removeAllObjects];
    [nTaipeiBusName removeAllObjects];
    
    //enteringCounter  = enteringCounter + 1;
    
    NSMutableString *encodedStop = (NSMutableString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)partBusName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    NSString *strURL = [NSString stringWithFormat:@"http://140.121.91.62/RouteByButton.php?partBusName=%@", encodedStop];
    
    NSData *dataURL = [NSData dataWithContentsOfURL:[NSURL URLWithString:strURL]];
    
    NSString *strResult = [[[NSString alloc] initWithData:dataURL encoding:NSUTF8StringEncoding]autorelease];
    
    NSArray * tmpInfo = [[NSArray alloc] init];
    tmpInfo = [strResult componentsSeparatedByString:@";"];
    
    compBusName = [[[tmpInfo objectAtIndex:0] componentsSeparatedByString:@"|"] retain];
    
    NSArray * tmpCompDepar = [[NSArray alloc] init];
    tmpCompDepar = [[tmpInfo objectAtIndex:1] componentsSeparatedByString:@"|"];
    
    NSArray * tmpCompDesti = [[NSArray alloc] init];
    tmpCompDesti = [[tmpInfo objectAtIndex:2] componentsSeparatedByString:@"|"];
    
    NSArray * tmpCityName = [[NSArray alloc] init];
    tmpCityName = [[tmpInfo objectAtIndex:3] componentsSeparatedByString:@"|"];
    
    countT = countN = countAll = 0;
    for (NSString * str in tmpCityName)
    {
        if ([str isEqual:@"T"])
        {
            [taipeiDeparName addObject:[tmpCompDepar objectAtIndex:countAll]];
            [taipeiDestiName addObject:[tmpCompDesti objectAtIndex:countAll]];
            [taipeiBusName addObject:[compBusName objectAtIndex:countAll]];
            countT = countT + 1;
        }
        else if ([str isEqual:@"N"])
        {
            [nTaipeiDeparName addObject:[tmpCompDepar objectAtIndex:countAll]];
            [nTaipeiDestiName addObject:[tmpCompDesti objectAtIndex:countAll]];
            [nTaipeiBusName addObject:[compBusName objectAtIndex:countAll]];
            countN = countN + 1;
        }
        [cityName addObject:str];
        countAll = countAll + 1;
    }
    [cityName removeLastObject];
    [taipeiBusName retain];
    [nTaipeiBusName retain];
    
    /*NSLog(@"countT:%d", countT);
    NSLog(@"countN:%d", countN);*/
    
    // 判斷若無資料，則顯示"無資料"
    if (countT != 0 || countN != 0)
    {
        for (UIView *checkSubview in self.view.subviews)
        {
            if (checkSubview.tag == CHECK_SUBVIEW_TAG)
                [checkSubview removeFromSuperview];
        }
    }
    else
    {
        [self noDataCurrently];
    }
    [tableview reloadData];
}

- (void)buttonClicked:(id)sender
{
    switch ([sender tag])
    {
        case 0:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"0"];
            [self showTableViewContent];
            break;
        case 1:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"1"];
            [self showTableViewContent];
            break;
        case 2:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"2"];
            [self showTableViewContent];
            break;
        case 3:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"3"];
            [self showTableViewContent];
            break;
        case 4:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"4"];
            [self showTableViewContent];
            break;
        case 5:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"5"];
            [self showTableViewContent];
            break;
        case 6:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"6"];
            [self showTableViewContent];
            break;
        case 7:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"7"];
            [self showTableViewContent];
            break;
        case 8:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"8"];
            [self showTableViewContent];
            break;
        case 9:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"9"];
            [self showTableViewContent];
            break;
        case 11:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"紅"];
            [self showTableViewContent];
            break;
        case 12:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"綠"];
            [self showTableViewContent];
            break;
        case 13:
            if (havingTableView == NO)
                [self createTableView];
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
                [self createTableView];
            [partBusName appendString:@"藍"];
            [self showTableViewContent];
            break;
        case 22:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"棕"];
            [self showTableViewContent];
            break;
        case 23:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"小"];
            [self showTableViewContent];
            break;
        case 34:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            havingTableView = NO;
            for (UIView *checkSubview in self.view.subviews)
                if (checkSubview.tag == CHECK_SUBVIEW_TAG)
                    [checkSubview removeFromSuperview];
            [tableview removeFromSuperview];
            //NSLog(@"partBusName = %@", partBusName);
            break;
        case 211:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"新北"];
            //[self showTableViewContent];
            [self noDataCurrently];
            break;
        case 212:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"市民"];
            [self showTableViewContent];
            break;
        case 213:
            if (havingTableView == NO)
                [self createTableView];
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
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"內科"];
            [self showTableViewContent];
            break;
        case 222:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"貓空"];
            [self showTableViewContent];
            break;
        case 223:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"幹線"];
            [self showTableViewContent];
            break;
        case 231:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"南軟"];
            [self showTableViewContent];
            break;
        case 232:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"花季"];
            //[self showTableViewContent];
            [self noDataCurrently];
            break;
        case 233:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"其他"];
            //[self showTableViewContent];
            [self noDataCurrently];
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSLog(@"viewForSection");
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(10, 0, tableView.bounds.size.width, 20);
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)] autorelease];
        [headerView setBackgroundColor:[UIColor colorWithRed:154/255.0 green:192/255.0 blue:205/255.0 alpha:0.9]];
    [headerView addSubview:label];
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section) {
        case 0:
            sectionName = @"台北市";
            break;
        case 1:
            sectionName = @"新北市";
            break;
        default:
            sectionName = @"Error";
            break;
    }
    return sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return countT;
    else
        return countN;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellForRow");
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0)
    {
        if([taipeiBusName count] == 0) NSLog(@"Nothing");
        cell.textLabel.text = [taipeiBusName objectAtIndex:indexPath.row];
        NSString * departDestinInfo = [[NSString alloc] init];
        departDestinInfo = [[taipeiDeparName objectAtIndex:indexPath.row] stringByAppendingString:@" - "];
        cell.detailTextLabel.text = [departDestinInfo stringByAppendingString:[taipeiDestiName objectAtIndex:indexPath.row]];

    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = [nTaipeiBusName objectAtIndex:indexPath.row];
        NSString * departDestinInfo = [[NSString alloc] init];
        departDestinInfo = [[nTaipeiDeparName objectAtIndex:indexPath.row] stringByAppendingString:@" - "];
        cell.detailTextLabel.text = [departDestinInfo stringByAppendingString:[nTaipeiDestiName objectAtIndex:indexPath.row]];

    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * selectedBusName = [[NSString alloc] init];
    
    if (indexPath.section == 0)     // 台北市
    {
        selectedBusName = [taipeiBusName objectAtIndex:indexPath.row];
        [selectedBusName retain];
        NSLog(@"Taipei: %d, %d", indexPath.section, indexPath.row);
        NSLog(@"Taipei selectBusName = %@", selectedBusName);
        TPRouteGoBackViewController *TProuteGoBack = [[TPRouteGoBackViewController alloc] initWithStyle:UITableViewStyleGrouped];
        TProuteGoBack.title = [selectedBusName stringByAppendingString:@" 公車路線"];
        [TProuteGoBack setter_departure:[taipeiDeparName objectAtIndex:indexPath.row]];
        [TProuteGoBack setter_destination:[taipeiDestiName objectAtIndex:indexPath.row]];
        [TProuteGoBack setter_busName:[taipeiBusName objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:TProuteGoBack animated:YES];
        //[compBusName release];
    }
    else if (indexPath.section == 1)    // 新北市
    {
        selectedBusName = [nTaipeiBusName objectAtIndex:indexPath.row];
        [selectedBusName retain];
        NTRouteGoBackViewController *NTrouteGoBack = [[NTRouteGoBackViewController alloc] initWithStyle:UITableViewStyleGrouped];
        NTrouteGoBack.title = [selectedBusName stringByAppendingString:@" 公車路線"];
        [NTrouteGoBack setter_departure:[nTaipeiDeparName objectAtIndex:indexPath.row]];
        [NTrouteGoBack setter_destination:[nTaipeiDestiName objectAtIndex:indexPath.row]];
        [NTrouteGoBack setter_busName:[nTaipeiBusName objectAtIndex:indexPath.row]];
        
        [self.navigationController pushViewController:NTrouteGoBack animated:YES];
        //[compBusName release];
    }
    else    // 基隆市
    {
        NSLog(@"一尺方吉");
    }
}

- (void)noDataCurrently
{
    if (![self.view isEqual:noDataView])
    {
        noDataView.backgroundColor = NO_DATA_COLOR;
        noDataLabel.backgroundColor = NO_DATA_COLOR;
        noDataLabel.text = @"暫無資料";
        noDataLabel.textAlignment = NSTextAlignmentCenter;
        noDataLabel.textColor = [UIColor whiteColor];
        [noDataView addSubview:noDataLabel];
        [self.view addSubview:noDataView];
    }
    else
    {
        // do nothing;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc
{
    [buttonFirstView release];
    [tableview release];
    [cityName release];
    [taipeiDeparName release];
    [taipeiDestiName release];
    [nTaipeiDeparName release];
    [nTaipeiDestiName release];
    //[compBusName release];
    [partBusName release];
    [buttonSecondView release];
    //[buttonFirstView release];
    [super dealloc];
}

@end
