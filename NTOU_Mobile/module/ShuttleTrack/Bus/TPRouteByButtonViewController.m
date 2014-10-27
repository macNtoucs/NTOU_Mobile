//
//  TPRouteByButtonViewController.m
//  bus
//  公車號碼查詢按鈕
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
@synthesize screenWidth, screenHeight;
@synthesize buttonTintColor;
@synthesize arrayTaipeiBus, arrayNewTaipeiBus, arrayKeelungBus;
@synthesize depArrayTaipeiBus, depArrayNewTaipeiBus, depArrayKeelungBus;
@synthesize desArrayTaipeiBus, desArrayNewTaipeiBus, desArrayKeelungBus;
@synthesize activityIndicator, partBusNameLabel;
@synthesize path, frequency, dict;

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
    
    self.title = @"公車";
    partBusName = [[NSMutableString alloc] init];
    arrayTaipeiBus = [[NSMutableArray alloc] init];
    arrayNewTaipeiBus = [[NSMutableArray alloc] init];
    arrayKeelungBus = [[NSMutableArray alloc] init];
    depArrayTaipeiBus = [[NSMutableArray alloc] init];
    depArrayNewTaipeiBus = [[NSMutableArray alloc] init];
    depArrayKeelungBus = [[NSMutableArray alloc] init];
    desArrayTaipeiBus = [[NSMutableArray alloc] init];
    desArrayNewTaipeiBus = [[NSMutableArray alloc] init];
    desArrayKeelungBus = [[NSMutableArray alloc] init];
    
    [self showFirstLayerButtons];
    
    /* create plist */
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    //getting the path to document directory for the file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirecotry = [paths objectAtIndex:0];
    path = [documentsDirecotry stringByAppendingString:@"/frequencyBusStation.plist"];
    [path retain];
    
    //checking to see of the file already exist
    if(![fm fileExistsAtPath:path])
    {
        //if doesnt exist get the the file path from bindle
        NSString *correctPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/frequencyBusStation.plist"];
        //copy the file from bundle to document dir
        [fm copyItemAtPath:correctPath toPath:path error:&error];
    }
    
    NSLog(@"RouteByButton.m path = %@", path);
    
    //read data with plist
    dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    if([dict count] != 0)
    {
        NSArray *keys = [dict allKeys];
        for(NSString * route in keys)
        {
            NSMutableDictionary * info = [dict objectForKey:route];
            if([[info objectForKey:@"city"] isEqualToString:@"T"])
            {
                [arrayTaipeiBus addObject:route];
                [depArrayTaipeiBus addObject:[info objectForKey:@"departure"]];
                [desArrayTaipeiBus addObject:[info objectForKey:@"destination"]];
            }
            else if([[info objectForKey:@"city"] isEqualToString:@"N"])
            {
                [arrayNewTaipeiBus addObject:route];
                [depArrayNewTaipeiBus addObject:[info objectForKey:@"departure"]];
                [desArrayNewTaipeiBus addObject:[info objectForKey:@"destination"]];
            }
            else
            {
                [arrayKeelungBus addObject:route];
                [depArrayKeelungBus addObject:[info objectForKey:@"departure"]];
                [desArrayKeelungBus addObject:[info objectForKey:@"destination"]];
            }
            frequency = [[info objectForKey:@"frequency"] intValue];
        } //end for: all keys of dict
        
        [self createTableView];
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
            self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        else
            [tableview applyStandardColors];
        havingTableView = YES;
    } //end if: dict has data
    else
    {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DefaultAlpha.png"]];
        
        havingTableView = NO;
    }
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
    
    UIButton * buttonSeven = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonSeven.layer.cornerRadius = 10;
        buttonSeven.layer.borderWidth = 1.0;
        buttonSeven.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonSeven setTitle:@"7" forState:UIControlStateNormal];
    [buttonSeven setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonSeven setTag:7];
    buttonSeven.frame = CGRectMake(131, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonSeven addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonEight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonEight.layer.cornerRadius = 10;
        buttonEight.layer.borderWidth = 1.0;
        buttonEight.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonEight setTitle:@"8" forState:UIControlStateNormal];
    [buttonEight setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonEight setTag:8];
    buttonEight.frame = CGRectMake(194, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonEight addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNine = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonNine.layer.cornerRadius = 10;
        buttonNine.layer.borderWidth = 1.0;
        buttonNine.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonNine setTitle:@"9" forState:UIControlStateNormal];
    [buttonNine setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonNine setTag:9];
    buttonNine.frame = CGRectMake(257, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonNine addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonRed = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonRed.layer.cornerRadius = 10;
        buttonRed.layer.borderWidth = 1.0;
        buttonRed.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonRed setTitle:@"紅" forState:UIControlStateNormal];
    [buttonRed setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [buttonRed setTag:11];
    buttonRed.frame = CGRectMake(68, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonRed addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBlue= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonBlue.layer.cornerRadius = 10;
        buttonBlue.layer.borderWidth = 1.0;
        buttonBlue.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonBlue setTitle:@"藍" forState:UIControlStateNormal];
    [buttonBlue setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [buttonBlue setTag:21];
    buttonBlue.frame = CGRectMake(5, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonBlue addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFour = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonFour.layer.cornerRadius = 10;
        buttonFour.layer.borderWidth = 1.0;
        buttonFour.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonFour setTitle:@"4" forState:UIControlStateNormal];
    [buttonFour setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonFour setTag:4];
    buttonFour.frame = CGRectMake(131, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonFour addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonFive.layer.cornerRadius = 10;
        buttonFive.layer.borderWidth = 1.0;
        buttonFive.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonFive setTitle:@"5" forState:UIControlStateNormal];
    [buttonFive setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonFive setTag:5];
    buttonFive.frame = CGRectMake(194, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonFive addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSix = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonSix.layer.cornerRadius = 10;
        buttonSix.layer.borderWidth = 1.0;
        buttonSix.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonSix setTitle:@"6" forState:UIControlStateNormal];
    [buttonSix setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonSix setTag:6];
    buttonSix.frame = CGRectMake(257, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonSix addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBrown = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonBrown.layer.cornerRadius = 10;
        buttonBrown.layer.borderWidth = 1.0;
        buttonBrown.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonBrown setTitle:@"棕" forState:UIControlStateNormal];
    [buttonBrown setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [buttonBrown setTag:22];
    buttonBrown.frame = CGRectMake(68, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonBrown addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonGreen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonGreen.layer.cornerRadius = 10;
        buttonGreen.layer.borderWidth = 1.0;
        buttonGreen.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonGreen setTitle:@"綠" forState:UIControlStateNormal];
    [buttonGreen setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [buttonGreen setTag:12];
    buttonGreen.frame = CGRectMake(5, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonGreen addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonOne.layer.cornerRadius = 10;
        buttonOne.layer.borderWidth = 1.0;
        buttonOne.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonOne setTag:1];
    [buttonOne setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonOne setTitle:@"1" forState:UIControlStateNormal];
    buttonOne.frame = CGRectMake(131, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonOne addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonTwo.layer.cornerRadius = 10;
        buttonTwo.layer.borderWidth = 1.0;
        buttonTwo.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonTwo setTitle:@"2" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonTwo setTag:2];
    buttonTwo.frame = CGRectMake(194, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonTwo addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonThree = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonThree.layer.cornerRadius = 10;
        buttonThree.layer.borderWidth = 1.0;
        buttonThree.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonThree setTitle:@"3" forState:UIControlStateNormal];
    [buttonThree setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonThree setTag:3];
    buttonThree.frame = CGRectMake(257, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonThree addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOrange = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonOrange.layer.cornerRadius = 10;
        buttonOrange.layer.borderWidth = 1.0;
        buttonOrange.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonOrange setTitle:@"橘" forState:UIControlStateNormal];
    [buttonOrange setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [buttonOrange setTag:13];
    buttonOrange.frame = CGRectMake(68, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonOrange addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonF= [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonF.layer.cornerRadius = 10;
        buttonF.layer.borderWidth = 1.0;
        buttonF.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonF setTitle:@"F" forState:UIControlStateNormal];
    [buttonF setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonF setTag:24];
    buttonF.frame = CGRectMake(5, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonF addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonZero = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonZero.layer.cornerRadius = 10;
        buttonZero.layer.borderWidth = 1.0;
        buttonZero.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonZero setTitle:@"0" forState:UIControlStateNormal];
    [buttonZero setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonZero setTag:0];
    buttonZero.frame = CGRectMake(257, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonZero addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSmall = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonSmall.layer.cornerRadius = 10;
        buttonSmall.layer.borderWidth = 1.0;
        buttonSmall.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonSmall setTitle:@"小" forState:UIControlStateNormal];
    [buttonSmall setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonSmall setTag:23];
    buttonSmall.frame = CGRectMake(5, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonSmall addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonMore.layer.cornerRadius = 10;
        buttonMore.layer.borderWidth = 1.0;
        buttonMore.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    buttonMore.frame = CGRectMake(68, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonMore setTag:14];
    [buttonMore setTitle:@"更多" forState:UIControlStateNormal];
    [buttonMore setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonMore addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonReset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonReset.layer.cornerRadius = 10;
        buttonReset.layer.borderWidth = 1.0;
        buttonReset.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonReset setTitle:@"重設" forState:UIControlStateNormal];
    [buttonReset setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonReset setTag:34];
    buttonReset.frame = CGRectMake(131, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonReset addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonDEL = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonDEL.layer.cornerRadius = 10;
        buttonDEL.layer.borderWidth = 1.0;
        buttonDEL.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonDEL setTitle:@"DEL" forState:UIControlStateNormal];
    [buttonDEL setTitleColor:[UIColor colorWithRed:116/255.0 green:116/255.0 blue:116/255.0 alpha:100/100.0] forState:UIControlStateNormal];
    [buttonDEL setTag:35];
    buttonDEL.frame = CGRectMake(194, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonDEL addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
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
    [buttonFirstView addSubview:buttonDEL];
    
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
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonMain.layer.cornerRadius = 10;
        buttonMain.layer.borderWidth = 1.0;
        buttonMain.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonMain setTag:223];
    [buttonMain setTitle:@"幹線" forState:UIControlStateNormal];
    [buttonMain setTitleColor:buttonTintColor forState:UIControlStateNormal];
    buttonMain.frame = CGRectMake(8, 5, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonMain addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNeiKe = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonNeiKe.layer.cornerRadius = 10;
        buttonNeiKe.layer.borderWidth = 1.0;
        buttonNeiKe.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonNeiKe setTag:221];
    [buttonNeiKe setTitle:@"內科" forState:UIControlStateNormal];
    [buttonNeiKe setTitleColor:buttonTintColor forState:UIControlStateNormal];
    buttonNeiKe.frame = CGRectMake(164, 5, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonNeiKe addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNanRan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonNanRan.layer.cornerRadius = 10;
        buttonNanRan.layer.borderWidth = 1.0;
        buttonNanRan.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonNanRan setTag:231];
    [buttonNanRan setTitle:@"南軟" forState:UIControlStateNormal];
    [buttonNanRan setTitleColor:buttonTintColor forState:UIControlStateNormal];
    buttonNanRan.frame = CGRectMake(8, 65, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonNanRan addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonCitizen = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonCitizen.layer.cornerRadius = 10;
        buttonCitizen.layer.borderWidth = 1.0;
        buttonCitizen.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonCitizen setTag:212];
    [buttonCitizen setTitle:@"市民" forState:UIControlStateNormal];
    [buttonCitizen setTitleColor:buttonTintColor forState:UIControlStateNormal];
    buttonCitizen.frame = CGRectMake(164, 65, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonCitizen addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOthers = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonOthers.layer.cornerRadius = 10;
        buttonOthers.layer.borderWidth = 1.0;
        buttonOthers.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
    [buttonOthers setTag:222];
    [buttonOthers setTitle:@"其他" forState:UIControlStateNormal];
    [buttonOthers setTitleColor:buttonTintColor forState:UIControlStateNormal];
    buttonOthers.frame = CGRectMake(8, 125, LAYER2_BUT_WIDTH, LAYER2_BUT_HEIGHT);
    [buttonOthers addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        buttonBack.layer.cornerRadius = 10;
        buttonBack.layer.borderWidth = 1.0;
        buttonBack.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    }
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

- (void)createTableView
{
    NSLog(@"CreateTableView");
    havingTableView = YES;
    tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-250) style:UITableViewStyleGrouped];
    tableview.dataSource = self;
    tableview.delegate = self;
    [self.view addSubview:tableview];
}

NSInteger finderSortWithLocale(id string1, id string2, void *locale)
{
    static NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    NSRange string1Range = NSMakeRange(0, [string1 length]);
    return [string1 compare:string2 options:comparisonOptions range:string1Range locale:(NSLocale *)locale];
}

- (void)showTableViewContent
{
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [tableview applyStandardColors];
    
    [depArrayTaipeiBus removeAllObjects];
    [depArrayNewTaipeiBus removeAllObjects];
    [depArrayKeelungBus removeAllObjects];
    [desArrayTaipeiBus removeAllObjects];
    [desArrayNewTaipeiBus removeAllObjects];
    [desArrayKeelungBus removeAllObjects];
    
    // start sqlite3
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ntou_mobile3.db"];
    NSLog(@"defaultDBPath=%@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    if (![db open])
        NSLog(@"Could not open db.");
    else
        NSLog(@"Open db successly.");
    
    if ([partBusName isEqualToString:@"其他"])
    {
        NSArray *array = [[NSArray alloc] initWithObjects:@"景美-榮總(快)", @"貓空右線", @"貓空左線(動物園)", @"貓空左線(指南宮)", @"懷恩專車S31(捷運公館)", @"懷恩專車S31(捷運忠孝復興)", @"花季專車126", @"花季專車127", @"花季專車130", @"花季專車130區", @"花季專車131", nil];
        arrayTaipeiBus = [array mutableCopy];
        NSArray *array2 = [[NSArray alloc] initWithObjects:@"景美女中", @"貓纜貓空站", @"貓纜貓空站", @"茶推廣中心停車場", @"捷運公館站", @"捷運六張犁站", @"八德市場", @"臺北車站", @"捷運劍潭站", @"第二停車場", @"花鐘", @"陽明山第二停車場", nil];
        depArrayTaipeiBus = [array2 mutableCopy];
        NSArray *array3 = [[NSArray alloc] initWithObjects:@"榮總", @"貓纜貓空站", @"捷運動物園", @"貓纜指南宮站", @"青峰活動中心", @"青峰活動中心", @"青峰活動中心", @"陽明山", @"陽明山", @"陽明書屋", @"陽明山站", @"竹子湖", nil];
        desArrayTaipeiBus = [array3 mutableCopy];
        
        [depArrayNewTaipeiBus retain];
        [desArrayNewTaipeiBus retain];
    }
    else
    {
        NSMutableString *query = [NSMutableString stringWithString:@"SELECT * FROM routeinfo WHERE nameZh LIKE '%"];
        [query appendFormat:@"%@", partBusName];
        [query appendString:@"%'"];
        //NSLog(@"query=%@", query);
        FMResultSet *rs = [db executeQuery:query];
        
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
        
        arrayTaipeiBus = [[NSMutableArray alloc]initWithArray:[testT sortedArrayUsingFunction:finderSortWithLocale context:[NSLocale currentLocale]] ];
        
        arrayNewTaipeiBus = [[NSMutableArray alloc]initWithArray:[testN sortedArrayUsingFunction:finderSortWithLocale context:[NSLocale currentLocale]]];
        
        arrayKeelungBus = [[NSMutableArray alloc]initWithArray:[testK sortedArrayUsingFunction:finderSortWithLocale context:[NSLocale currentLocale]]];
        
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
    } //end else: 按下按鈕（除了其他）
    [db close];
    NSLog(@"showTableViewContent");
    //NSLog(@"partBusName = %@", partBusName);
    [arrayTaipeiBus retain];
    [arrayNewTaipeiBus retain];
    //NSLog(@"retainCount=%d",[arrayNewTaipeiBus retainCount]);
    [arrayKeelungBus retain];
    dispatch_async(dispatch_get_main_queue(), ^{
        [tableview reloadData];
    });
    
}

//清除arrayTaipeiBus, arrayNewTaipeiBus, arrayKeelungBus的資料，以便於下次搜尋時新增Table不會用錯資料。
-(void)cleanArrayBusData
{
    NSLog(@"TCount=%lu\n",[arrayTaipeiBus count]);
    NSLog(@"TNCount=%lu\n",[arrayNewTaipeiBus count]);
    NSLog(@"KLCount=%lu\n",[arrayKeelungBus count]);
    if ([arrayTaipeiBus count]>0) {
        [arrayTaipeiBus removeAllObjects];
        //[arrayTaipeiBus retain];
        //NSLog(@"2retainCount=%lu\n",[arrayTaipeiBus retainCount]);
    }
    
    if ([arrayNewTaipeiBus count]>0) {
        [arrayNewTaipeiBus removeAllObjects];
        //[arrayNewTaipeiBus retain];
        //NSLog(@"retainCount=%lu\n",[arrayNewTaipeiBus retainCount]);
    }
    
    if ([arrayKeelungBus count]>0) {
        [arrayKeelungBus removeAllObjects];
        //[arrayKeelungBus retain];
        //NSLog(@"retainCount=%lu\n",[arrayKeelungBus retainCount]);
    }
}


- (void)buttonClicked:(id)sender
{
    NSLog(@"buttonClicked");
    switch ([sender tag])
    {
        case 0:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"0"];
            NSLog(@"partBusName=%@", partBusName);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 1:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"1"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 2:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"2"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 3:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"3"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 4:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"4"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 5:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"5"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 6:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"6"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 7:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"7"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 8:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"8"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 9:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName appendString:@"9"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 11:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"紅"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 12:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"綠"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 13:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"橘"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 14: //更多
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [buttonFirstView removeFromSuperview];
            [buttonFirstView release];
            [self showSecondLayerButtons];
            break;
        case 21:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"藍"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 22:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"棕"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 23:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"小"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 24:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"F"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 34: //重設
            //*
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DefaultAlpha.png"]];
            havingTableView = NO;
            [tableview removeFromSuperview];
            [self cleanArrayBusData];
            //*/
            /*
            //fix 因為常用列表而table生成過快，arrayTaipeiBus arrayNewTaipeiBus arrayKeelungBus來不及更新資料導致overflow
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            havingTableView = NO;
            [tableview removeFromSuperview];
            [self cleanArrayBusData];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DefaultAlpha.png"]];
            /*/
            
            break;
        case 35:    // Delete
            if ([partBusName length] > 1)
            {
                [partBusName deleteCharactersInRange:NSMakeRange([partBusName length]-1, 1)];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self showTableViewContent];
                });
            }
            else
            {
                
                if ([partBusName length] > 0)
                    [partBusName deleteCharactersInRange:NSMakeRange([partBusName length]-1, 1)];
                //*
                self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DefaultAlpha.png"]];
                havingTableView = NO;
                [tableview removeFromSuperview];
                [self cleanArrayBusData];
                //*/
                /*
                [tableview removeFromSuperview];
                [self cleanArrayBusData];
                havingTableView = NO;
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self showTableViewContent];
                });
                self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"DefaultAlpha.png"]];
                /*/
                
            }
            break;
        case 211:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"新北"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 212:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"市民"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 213:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"接駁"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 214: //返回
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
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 222:   // 尚未完成
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"其他"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 223:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"幹線"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 231:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"南軟"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 232:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"花季"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        case 233:
            if (havingTableView == NO)
                [self createTableView];
            [partBusName deleteCharactersInRange:NSMakeRange(0, [partBusName length])];
            [partBusName appendString:@"其他"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showTableViewContent];
            });
            break;
        default:
            break;
    }
    partBusNameLabel.text = partBusName;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        if ([arrayTaipeiBus count] == 0)
            return 0.01f;
        else
            return 30.0f;
    }
    else if (section == 1)
    {
        if ([arrayNewTaipeiBus count] == 0)
            return 0.01f;
    }
    else
    {
        if ([arrayKeelungBus count] == 0)
            return 0.01f;
    }
    
    return 17.0f;
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat rowHeight = 0;
    UIFont *cellFont = [UIFont fontWithName:@"Helvetica" size:14.0];
    CGSize constraintSize = CGSizeMake(270.0f, 2009.0f);
    NSString *cellText = nil;
    //UILineBreakModeWordWrap
    cellText = @"A"; // just something to guarantee one line
    CGSize labelSize = [cellText sizeWithFont:cellFont constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
    //rowHeight = labelSize.height + 20.0f;
    //rowHeight = labelSize.height + 25.0f;
    rowHeight = 44.0f;
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
    
    NSMutableDictionary * data = [NSMutableDictionary new];
    
    if (indexPath.section == 0)
    {
        selectedBusName = [arrayTaipeiBus objectAtIndex:indexPath.row];
        TPRouteDetailViewController * secondLevel = [[TPRouteDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        secondLevel.title = [NSString stringWithFormat:@""];
        [secondLevel setter_busName:selectedBusName andGoBack:0];
        [secondLevel setter_departure:[depArrayTaipeiBus objectAtIndex:indexPath.row] andDestination:[desArrayTaipeiBus objectAtIndex:indexPath.row]];
        [data setObject:[depArrayTaipeiBus objectAtIndex:indexPath.row] forKey:@"departure"];
        [data setObject:[desArrayTaipeiBus objectAtIndex:indexPath.row] forKey:@"destination"];
        [data setObject:@"T" forKey:@"city"];
        [data setObject:[NSNumber numberWithInt:frequency+1] forKey:@"frequency"];
        [dict setObject:data forKey:selectedBusName];
        [dict writeToFile: path atomically:YES];
        [data release];
        [self.navigationController pushViewController:secondLevel animated:YES];
        [secondLevel release];
    }
    else if (indexPath.section == 1)
    {
        selectedBusName = [arrayNewTaipeiBus objectAtIndex:indexPath.row];
        NTRouteDetailViewController *secondLevel = [[NTRouteDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
        secondLevel.title = [NSString stringWithFormat:@"往 %@", [desArrayNewTaipeiBus objectAtIndex:indexPath.row]];
        [secondLevel setter_busName:selectedBusName andGoBack:0];
        [secondLevel setter_departure:[depArrayNewTaipeiBus objectAtIndex:indexPath.row] andDestination:[desArrayNewTaipeiBus objectAtIndex:indexPath.row]];
        [data setObject:[depArrayNewTaipeiBus objectAtIndex:indexPath.row] forKey:@"departure"];
        [data setObject:[desArrayNewTaipeiBus objectAtIndex:indexPath.row] forKey:@"destination"];
        [data setObject:@"N" forKey:@"city"];
        [data setObject:[NSNumber numberWithInt:frequency+1] forKey:@"frequency"];
        [dict setObject:data forKey:selectedBusName];
        [dict writeToFile: path atomically:YES];
        [data release];
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
        [data setObject:[depArrayKeelungBus objectAtIndex:indexPath.row] forKey:@"departure"];
        [data setObject:[desArrayKeelungBus objectAtIndex:indexPath.row] forKey:@"destination"];
        [data setObject:@"K" forKey:@"city"];
        [data setObject:[NSNumber numberWithInt:frequency+1] forKey:@"frequency"];
        [dict setObject:data forKey:selectedBusName];
        [dict writeToFile: path atomically:YES];
        [data release];
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
    [arrayTaipeiBus release];
    [arrayNewTaipeiBus release];
    [arrayKeelungBus release];
    [depArrayTaipeiBus release];
    [depArrayNewTaipeiBus release];
    [depArrayKeelungBus release];
    [desArrayTaipeiBus release];
    [desArrayNewTaipeiBus release];
    [desArrayKeelungBus release];
    [partBusName release];
    [buttonSecondView release];
    [buttonFirstView release];
    [super dealloc];
}

@end
