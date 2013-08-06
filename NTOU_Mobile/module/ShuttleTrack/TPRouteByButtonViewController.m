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
    self.title = @"雙北公車";
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
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSLog(@"screenSize:%f, %f", screenSize.size.width, screenSize.size.height);
    buttonFirstView = [[[UIView alloc] initWithFrame:CGRectMake(0, 480, 320, screenSize.size.height-230)] retain];
    [buttonFirstView setBackgroundColor:[UIColor lightTextColor]];
    
    UIButton * buttonRed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonRed setTag:11];
    [buttonRed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [buttonRed setTitle:@"紅" forState:UIControlStateNormal];
    
    buttonRed.frame = CGRectMake(5, 5, 58, 40);
    [buttonRed addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonGreen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonGreen setTitle:@"綠" forState:UIControlStateNormal];
    [buttonGreen setTitleColor:[UIColor colorWithRed:0/255.0 green:128/255.0 blue:64/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonGreen setTag:12];
    buttonGreen.frame = CGRectMake(5, 50, 58, 40);
    [buttonGreen addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOrange = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonOrange setTitle:@"橘" forState:UIControlStateNormal];
    [buttonOrange setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [buttonOrange setTag:13];
    buttonOrange.frame = CGRectMake(5, 95, 58, 40);
    [buttonOrange addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonMore.frame = CGRectMake(5, 140, 121, 40);
    [buttonMore setTag:14];
    [buttonMore setTitle:@"更多" forState:UIControlStateNormal];
    [buttonMore setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonMore addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBlue = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonBlue setTitle:@"藍" forState:UIControlStateNormal];
    [buttonBlue setTitleColor:[UIColor colorWithRed:10/255.0 green:86/255.0 blue:255/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonBlue setTag:21];
    buttonBlue.frame = CGRectMake(68, 5, 58, 40);
    [buttonBlue addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBrown = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonBrown setTitle:@"棕" forState:UIControlStateNormal];
    [buttonBrown setTitleColor:[UIColor colorWithRed:106/255.0 green:53/255.0 blue:0/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonBrown setTag:22];
    buttonBrown.frame = CGRectMake(68, 50, 58, 40);
    [buttonBrown addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSmall = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSmall setTitle:@"小" forState:UIControlStateNormal];
    [buttonSmall setTitleColor:[UIColor colorWithRed:245/255.0 green:30/255.0 blue:242/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonSmall setTag:23];
    buttonSmall.frame = CGRectMake(68, 95, 58, 40);
    [buttonSmall addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonReset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonReset setTitle:@"重設" forState:UIControlStateNormal];
    [buttonReset setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonReset setTag:34];
    buttonReset.frame = CGRectMake(131, 140, 121, 40);
    [buttonReset addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonOne setTitle:@"1" forState:UIControlStateNormal];
    [buttonOne setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonOne setTag:1];
    buttonOne.frame = CGRectMake(131, 5, 58, 40);
    [buttonOne addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFour = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonFour setTitle:@"4" forState:UIControlStateNormal];
    [buttonFour setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonFour setTag:4];
    buttonFour.frame = CGRectMake(131, 50, 58, 40);
    [buttonFour addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSeven = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSeven setTitle:@"7" forState:UIControlStateNormal];
    [buttonSeven setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSeven setTag:7];
    buttonSeven.frame = CGRectMake(131, 95, 58, 40);
    [buttonSeven addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonTwo setTitle:@"2" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonTwo setTag:2];
    buttonTwo.frame = CGRectMake(194, 5, 58, 40);
    [buttonTwo addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonFive setTitle:@"5" forState:UIControlStateNormal];
    [buttonFive setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonFive setTag:5];
    buttonFive.frame = CGRectMake(194, 50, 58, 40);
    [buttonFive addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonEight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonEight setTitle:@"8" forState:UIControlStateNormal];
    [buttonEight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonEight setTag:8];
    buttonEight.frame = CGRectMake(194, 95, 58, 40);
    [buttonEight addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonThree = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonThree setTitle:@"3" forState:UIControlStateNormal];
    [buttonThree setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonThree setTag:3];
    buttonThree.frame = CGRectMake(257, 5, 58, 40);
    [buttonThree addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSix = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSix setTitle:@"6" forState:UIControlStateNormal];
    [buttonSix setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSix setTag:6];
    buttonSix.frame = CGRectMake(257, 50, 58, 40);
    [buttonSix addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNine = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNine setTitle:@"9" forState:UIControlStateNormal];
    [buttonNine setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonNine setTag:9];
    buttonNine.frame = CGRectMake(257, 95, 58, 40);
    [buttonNine addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonZero = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    
    CGRect firstTopViewFrame = CGRectMake(0, 230, 320, screenSize.size.height-230);
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
    CGRect screenSize = [[UIScreen mainScreen] bounds];
    NSLog(@"screenSize:%f, %f", screenSize.size.width, screenSize.size.height);
    buttonSecondView = [[[UIView alloc] initWithFrame:CGRectMake(0, 480, 320, screenSize.size.height-230)] retain];
    [buttonSecondView setBackgroundColor:[UIColor lightTextColor]];
    
    UIButton * buttonNewPei = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNewPei setTag:211];
    [buttonNewPei setTitle:@"新北" forState:UIControlStateNormal];
    buttonNewPei.frame = CGRectMake(5, 5, 100, 40);
    [buttonNewPei addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonCitizen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonCitizen setTag:212];
    [buttonCitizen setTitle:@"市民" forState:UIControlStateNormal];
    buttonCitizen.frame = CGRectMake(5, 50, 100, 40);
    [buttonCitizen addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonShuttle = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonShuttle setTag:213];
    [buttonShuttle setTitle:@"接駁" forState:UIControlStateNormal];
    buttonShuttle.frame = CGRectMake(5, 95, 100, 40);
    [buttonShuttle addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonBack setTag:214];
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    buttonBack.frame = CGRectMake(5, 140, 310, 40);
    [buttonBack addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNeiKe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNeiKe setTag:221];
    [buttonNeiKe setTitle:@"內科" forState:UIControlStateNormal];
    buttonNeiKe.frame = CGRectMake(110, 5, 100, 40);
    [buttonNeiKe addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMaoKom = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonMaoKom setTag:222];
    [buttonMaoKom setTitle:@"貓空" forState:UIControlStateNormal];
    buttonMaoKom.frame = CGRectMake(110, 50, 100, 40);
    [buttonMaoKom addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMain = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonMain setTag:223];
    [buttonMain setTitle:@"幹線" forState:UIControlStateNormal];
    buttonMain.frame = CGRectMake(110, 95, 100, 40);
    [buttonMain addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNanRan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNanRan setTag:231];
    [buttonNanRan setTitle:@"南軟" forState:UIControlStateNormal];
    buttonNanRan.frame = CGRectMake(215, 5, 100, 40);
    [buttonNanRan addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFlower = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonFlower setTag:232];
    [buttonFlower setTitle:@"花季" forState:UIControlStateNormal];
    buttonFlower.frame = CGRectMake(215, 50, 100, 40);
    [buttonFlower addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOthers = [UIButton buttonWithType:UIButtonTypeRoundedRect];
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
    
    CGRect secondTopViewFrame = CGRectMake(0, 230, 320, screenSize.size.height-230);
    [UIView animateWithDuration:0.7
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
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenSize.size.width, 230) style:UITableViewStylePlain];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
}

- (void)showTableViewContent
{
    [compDeparName removeAllObjects];
    [compDestiName removeAllObjects];
    [cityName removeAllObjects];
    
    NSMutableString *encodedStop = (NSMutableString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)partBusName, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8);
    
    NSString *strURL = [NSString stringWithFormat:@"http://140.121.91.62/RouteByButton.php?partBusName=%@", encodedStop];
    
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
            [tableview removeFromSuperview];
            //NSLog(@"partBusName = %@", partBusName);
            break;
        case 211:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"新北"];
            [self showTableViewContent];
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
            [self showTableViewContent];
            break;
        case 233:
            if (havingTableView == NO)
                [self createTableView];
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
        TPRouteGoBackViewController *TProuteGoBack = [TPRouteGoBackViewController new];
        TProuteGoBack.title = [selectedBusName stringByAppendingString:@" 公車路線"];
        [TProuteGoBack setter_departure:[compDeparName objectAtIndex:indexPath.row]];
        [TProuteGoBack setter_destination:[compDestiName objectAtIndex:indexPath.row]];
        [TProuteGoBack setter_busName:[compBusName objectAtIndex:indexPath.row]];
        
        [self.navigationController pushViewController:TProuteGoBack animated:YES];
        //[compBusName release];
    }
    else if([[cityName objectAtIndex:indexPath.row] isEqual:@"N"])
    {
        NTRouteGoBackViewController *NTrouteGoBack = [NTRouteGoBackViewController new];
        NTrouteGoBack.title = [selectedBusName stringByAppendingString:@" 公車路線"];
        [NTrouteGoBack setter_departure:[compDeparName objectAtIndex:indexPath.row]];
        [NTrouteGoBack setter_destination:[compDestiName objectAtIndex:indexPath.row]];
        [NTrouteGoBack setter_busName:[compBusName objectAtIndex:indexPath.row]];
        
        [self.navigationController pushViewController:NTrouteGoBack animated:YES];
        //[compBusName release];
    }
    else
    {
        NSLog(@"一尺方吉");
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
