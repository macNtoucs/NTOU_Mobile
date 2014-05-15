//
//  ExpressBusSearchViewController.m
//  NTOU_Mobile
//
//  Created by iMac on 14/4/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "ExpressBusSearch2ViewController.h"
#import "FMDatabase.h"

@interface ExpressBusSearch2ViewController ()

@end

@implementation ExpressBusSearch2ViewController

@synthesize searchResults;
@synthesize searchBar;
@synthesize myKeyboardView, myKeyboardView2, buttonTintColor, buttonPartBusName;
@synthesize searchDisplayController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initializeMyKeyboardView
{
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    
    myKeyboardView = [[[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-140, screenWidth, 140)] retain];
    [myKeyboardView setBackgroundColor:[UIColor lightTextColor]];
    myKeyboardView2 = [[[UIView alloc] initWithFrame:CGRectMake(0, screenHeight-140, screenWidth, 140)] retain];
    [myKeyboardView2 setBackgroundColor:[UIColor lightTextColor]];
    buttonTintColor = [UIColor blackColor];
    
    UIButton * buttonZero = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonZero.frame = CGRectMake(5, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonZero setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonZero setTag:0];
    [buttonZero setTitle:@"0" forState:UIControlStateNormal];
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
    
    UIButton * buttonKeelung = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonKeelung setTitle:@"基隆" forState:UIControlStateNormal];
    [buttonKeelung setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonKeelung setTag:10];
    buttonKeelung.frame = CGRectMake(5, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonKeelung addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNorth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNorth setTitle:@"台北" forState:UIControlStateNormal];
    [buttonNorth setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonNorth setTag:11];
    buttonNorth.frame = CGRectMake(68, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonNorth addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonDelete = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonDelete setTitle:@"DEL" forState:UIControlStateNormal];
    [buttonDelete setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonDelete setTag:12];
    buttonDelete.frame = CGRectMake(131, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonDelete addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonMore setTitle:@"更多" forState:UIControlStateNormal];
    [buttonMore setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonMore setTag:13];
    buttonMore.frame = CGRectMake(194, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonMore addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonDismiss = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonDismiss setTitle:@"↓" forState:UIControlStateNormal];
    [buttonDismiss setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonDismiss setTag:14];
    buttonDismiss.frame = CGRectMake(257, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonDismiss addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNewTaipei = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonNewTaipei.frame = CGRectMake(5, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonNewTaipei setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonNewTaipei setTag:15];
    [buttonNewTaipei setTitle:@"新北" forState:UIControlStateNormal];
    [buttonNewTaipei addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonTaoyuan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonTaoyuan setTitle:@"桃園" forState:UIControlStateNormal];
    [buttonTaoyuan setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonTaoyuan setTag:16];
    buttonTaoyuan.frame = CGRectMake(68, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonTaoyuan addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonHsinchu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonHsinchu setTitle:@"新竹" forState:UIControlStateNormal];
    [buttonHsinchu setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonHsinchu setTag:17];
    buttonHsinchu.frame = CGRectMake(131, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonHsinchu addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMiaoli = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonMiaoli setTitle:@"苗栗" forState:UIControlStateNormal];
    [buttonMiaoli setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonMiaoli setTag:18];
    buttonMiaoli.frame = CGRectMake(194, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonMiaoli addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonTaichung = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonTaichung setTitle:@"台中" forState:UIControlStateNormal];
    [buttonTaichung setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonTaichung setTag:19];
    buttonTaichung.frame = CGRectMake(257, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonTaichung addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNantou = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNantou setTitle:@"南投" forState:UIControlStateNormal];
    [buttonNantou setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonNantou setTag:20];
    buttonNantou.frame = CGRectMake(5, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonNantou addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonChanghua = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonChanghua setTitle:@"彰化" forState:UIControlStateNormal];
    [buttonChanghua setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonChanghua setTag:21];
    buttonChanghua.frame = CGRectMake(68, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonChanghua addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonYunlin = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonYunlin setTitle:@"雲林" forState:UIControlStateNormal];
    [buttonYunlin setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonYunlin setTag:22];
    buttonYunlin.frame = CGRectMake(131, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonYunlin addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonChiayi = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonChiayi setTitle:@"嘉義" forState:UIControlStateNormal];
    [buttonChiayi setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonChiayi setTag:23];
    buttonChiayi.frame = CGRectMake(194, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonChiayi addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonTainan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonTainan setTitle:@"台南" forState:UIControlStateNormal];
    [buttonTainan setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonTainan setTag:24];
    buttonTainan.frame = CGRectMake(257, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonTainan addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonKaohsiung = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonKaohsiung setTitle:@"高雄" forState:UIControlStateNormal];
    [buttonKaohsiung setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonKaohsiung setTag:25];
    buttonKaohsiung.frame = CGRectMake(5, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonKaohsiung addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonPingtung = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonPingtung setTitle:@"屏東" forState:UIControlStateNormal];
    [buttonPingtung setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonPingtung setTag:26];
    buttonPingtung.frame = CGRectMake(68, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonPingtung addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonIlan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonIlan setTitle:@"宜蘭" forState:UIControlStateNormal];
    [buttonIlan setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonIlan setTag:27];
    buttonIlan.frame = CGRectMake(131, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonIlan addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonBack = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonBack setTitle:@"返回" forState:UIControlStateNormal];
    [buttonBack setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonBack setTag:28];
    buttonBack.frame = CGRectMake(194, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonBack addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonDismiss2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonDismiss2 setTitle:@"↓" forState:UIControlStateNormal];
    [buttonDismiss2 setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonDismiss2 setTag:14];
    buttonDismiss2.frame = CGRectMake(257, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonDismiss2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    [myKeyboardView addSubview:buttonZero];
    [myKeyboardView addSubview:buttonOne];
    [myKeyboardView addSubview:buttonTwo];
    [myKeyboardView addSubview:buttonThree];
    [myKeyboardView addSubview:buttonFour];
    [myKeyboardView addSubview:buttonFive];
    [myKeyboardView addSubview:buttonSix];
    [myKeyboardView addSubview:buttonSeven];
    [myKeyboardView addSubview:buttonEight];
    [myKeyboardView addSubview:buttonNine];
    [myKeyboardView addSubview:buttonKeelung];
    [myKeyboardView addSubview:buttonNorth];
    [myKeyboardView addSubview:buttonDelete];
    [myKeyboardView addSubview:buttonMore];
    [myKeyboardView addSubview:buttonDismiss];
    
    [myKeyboardView2 addSubview:buttonNewTaipei];
    [myKeyboardView2 addSubview:buttonTaoyuan];
    [myKeyboardView2 addSubview:buttonHsinchu];
    [myKeyboardView2 addSubview:buttonMiaoli];
    [myKeyboardView2 addSubview:buttonTaichung];
    [myKeyboardView2 addSubview:buttonNantou];
    [myKeyboardView2 addSubview:buttonChanghua];
    [myKeyboardView2 addSubview:buttonYunlin];
    [myKeyboardView2 addSubview:buttonChiayi];
    [myKeyboardView2 addSubview:buttonTainan];
    [myKeyboardView2 addSubview:buttonKaohsiung];
    [myKeyboardView2 addSubview:buttonPingtung];
    [myKeyboardView2 addSubview:buttonIlan];
    [myKeyboardView2 addSubview:buttonBack];
    [myKeyboardView2 addSubview:buttonDismiss2];
}

- (void)showSearchFMDatabase:(NSArray *)searchArray
{
    if([searchResults count] > 0)
        [searchResults removeAllObjects];
    
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ntou_mobile3.db"];
    NSLog(@"defaultDBPath=%@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    if (![db open])
        NSLog(@"Could not open db.");
    else
        NSLog(@"Open db successly.");
    for (NSString *str in searchArray)
        NSLog(@"%@", str);
    for (int i = 0; i < [searchArray count]; i ++)
    {
        NSLog(@"[%d]:%@", i, [searchArray objectAtIndex:i]);
        NSMutableString *query = [NSMutableString stringWithString:@"SELECT shortRouteName FROM expressinfo WHERE shortRouteName LIKE '%"];
        [query appendString:[searchArray objectAtIndex:i]];
        [query appendString:@"%'"];
            //NSLog(@"query=%@", query);
        FMResultSet *rs = [db executeQuery:query];
        while ([rs next])
        {
            [searchResults addObject:[rs stringForColumn:@"shortRouteName"]];
        }
        [rs close];
    }
}

- (void)searchFMDatabase:(NSString *)searchString
{
    searchBar.text = searchString;
    if([searchResults count] > 0)
        [searchResults removeAllObjects];
    
    if ([searchString isEqualToString:@"基隆"])
    {
        NSArray *keelungs = [NSArray arrayWithObjects:@"基隆", nil];
        [self showSearchFMDatabase:keelungs];
    }
    if ([searchString isEqualToString:@"台北"])
    {
        NSArray *taipeis = [NSArray arrayWithObjects:@"台北", @"臺北", @"中崙", @"福和橋", @"木柵", @"內湖", @"國立護院", @"松山", @"南港", @"圓山", @"中崙", @"內湖", nil];
        [self showSearchFMDatabase:taipeis];
    }
    else if ([searchString isEqualToString:@"新北"])
    {
        NSArray *newTaipeis = [NSArray arrayWithObjects:@"新北", @"板橋", @"新店", @"金山青年活動中心", @"三重", @"瑞芳", nil];
        [self showSearchFMDatabase:newTaipeis];
    }
    else if ([searchString isEqualToString:@"桃園"])
    {
        NSArray *taoyuans = [NSArray arrayWithObjects:@"桃園", @"公西", @"中壢", @"大溪", @"大園", @"楊梅", nil];
        [self showSearchFMDatabase:taoyuans];
    }
    else if ([searchString isEqualToString:@"新竹"])
    {
        NSArray *shinchus = [NSArray arrayWithObjects:@"新竹", @"竹東", @"竹南", @"六福村", nil];
        [self showSearchFMDatabase:shinchus];
    }
    else if ([searchString isEqualToString:@"苗栗"])
    {
        NSArray *miaolis = [NSArray arrayWithObjects:@"苗栗", nil];
        [self showSearchFMDatabase:miaolis];
    }
    else if ([searchString isEqualToString:@"台中"])
    {
        NSArray *taichungs = [NSArray arrayWithObjects:@"台中", @"臺中", @"東勢", @"豐原", nil];
        [self showSearchFMDatabase:taichungs];
    }
    else if ([searchString isEqualToString:@"南投"])
    {
        NSArray *nantous = [NSArray arrayWithObjects:@"南投", @"竹山", @"埔里", @"日月潭", nil];
        [self showSearchFMDatabase:nantous];
    }
    else if ([searchString isEqualToString:@"彰化"])
    {
        NSArray *changhuas = [NSArray arrayWithObjects:@"彰化", @"員林", @"芳苑", @"北斗", nil];
        [self showSearchFMDatabase:changhuas];
    }
    else if ([searchString isEqualToString:@"雲林"])
    {
        NSArray *yunlins = [NSArray arrayWithObjects:@"雲林", @"三條崙", @"北港", @"四湖", nil];
        [self showSearchFMDatabase:yunlins];
    }
    else if ([searchString isEqualToString:@"嘉義"])
    {
        NSArray *chaiyis = [NSArray arrayWithObjects:@"嘉義", @"東石", @"布袋", @"阿里山", @"梅山", nil];
        [self showSearchFMDatabase:chaiyis];
    }
    else if ([searchString isEqualToString:@"台南"])
    {
        NSArray *tainans = [NSArray arrayWithObjects:@"台南", @"臺南", @"漚汪", @"苓子寮", @"西港", @"新營", nil];
        [self showSearchFMDatabase:tainans];
    }
    else if ([searchString isEqualToString:@"高雄"])
    {
        NSArray *kaoshungs = [NSArray arrayWithObjects:@"高雄", nil];
        [self showSearchFMDatabase:kaoshungs];
    }
    else if ([searchString isEqualToString:@"屏東"])
    {
        NSArray *pingtungs = [NSArray arrayWithObjects:@"屏東", nil];
        [self showSearchFMDatabase:pingtungs];
    }
    else if ([searchString isEqualToString:@"宜蘭"])
    {
        NSArray *ilans = [NSArray arrayWithObjects:@"宜蘭", @"羅東", @"礁溪", @"南方澳", nil];
        [self showSearchFMDatabase:ilans];
    }
    else
    {
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ntou_mobile3.db"];
        NSLog(@"defaultDBPath=%@", defaultDBPath);
        FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
        if (![db open])
            NSLog(@"Could not open db.");
        else
            NSLog(@"Open db successly.");
        NSMutableString *query = [NSMutableString stringWithString:@"SELECT shortRouteName FROM expressinfo WHERE shortRouteName LIKE '%"];
        [query appendString:searchString];
        [query appendString:@"%'"];
        //NSLog(@"query=%@", query);
        FMResultSet *rs = [db executeQuery:query];
        while ([rs next])
        {
            [searchResults addObject:[rs stringForColumn:@"shortRouteName"]];
        }
        [rs close];
    }
    [self.tableView reloadData];
    //NSLog(@"searchString=%@", searchString);
}

- (void)buttonClicked:(id)sender
{
    NSLog(@"buttonClicked");
    NSArray *searchBarSubViews = [[self.searchBar.subviews objectAtIndex:0] subviews];
    switch ([sender tag])
    {
        case 0:
            [buttonPartBusName appendString:@"0"];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 1:
            [buttonPartBusName appendString:@"1"];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 2:
            [buttonPartBusName appendString:@"2"];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 3:
            [buttonPartBusName appendString:@"3"];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 4:
            [buttonPartBusName appendString:@"4"];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 5:
            [buttonPartBusName appendString:@"5"];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 6:
            [buttonPartBusName appendString:@"6"];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 7:
            [buttonPartBusName appendString:@"7"];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 8:
            [buttonPartBusName appendString:@"8"];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 9:
            [buttonPartBusName appendString:@"9"];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 10:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"基隆"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 11:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"台北"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 12:
            if (![buttonPartBusName isEqualToString:@""])
                [buttonPartBusName deleteCharactersInRange:NSMakeRange([buttonPartBusName length]-1, 1)];
            [self searchFMDatabase:buttonPartBusName];
            break;
        case 13: //更多
            if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
            {
                for (UIView *view in searchBarSubViews) {
                    if([view isKindOfClass:[UITextField class]])
                    {
                        UITextField* search=(UITextField*)view;
                        [search setFont:[UIFont fontWithName:@"MyCustomFont" size:15]];
                        
                        [search setInputView:self.myKeyboardView2];
                    }
                }
            }
            else
            {
                [[searchBar.subviews objectAtIndex:1] setInputView:myKeyboardView2];
            }
            [self.searchBar reloadInputViews];
            break;
        case 14:
            [searchBar resignFirstResponder];
            break;
        case 15:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"新北"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 16:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"桃園"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 17:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"新竹"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 18:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"苗栗"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 19:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"台中"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 20:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"南投"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 21:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"彰化"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 22:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"雲林"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 23:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"嘉義"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 24:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"台南"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 25:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"高雄"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 26:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"屏東"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 27:
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            [buttonPartBusName appendString:@"宜蘭"];
            [self searchFMDatabase:buttonPartBusName];
            [buttonPartBusName deleteCharactersInRange:NSMakeRange(0, [buttonPartBusName length])];
            break;
        case 28:
            if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
            {
                for (UIView *view in searchBarSubViews) {
                    if([view isKindOfClass:[UITextField class]])
                    {
                        UITextField* search=(UITextField*)view;
                        [search setFont:[UIFont fontWithName:@"MyCustomFont" size:15]];
                        
                        [search setInputView:self.myKeyboardView];
                    }
                }
            }
            else
            {
                [[searchBar.subviews objectAtIndex:1] setInputView:myKeyboardView];
            }
            [self.searchBar reloadInputViews];
            break;
        default:
            break;
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [buttonPartBusName setString:@""];
}

#pragma mark - UISearDisplayController delegate methods
-(void)searchDisplayController:(UISearchDisplayController *)controller didShowSearchResultsTableView:(UITableView *)tableView {
    
    tableView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0];
    tableView.frame=CGRectZero;//This must be set to prevent the result tables being shown
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    buttonPartBusName = [[NSMutableString alloc] init];
    self.searchResults =[[NSMutableArray alloc] init];
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ntou_mobile3.db"];
    NSLog(@"defaultDBPath=%@", defaultDBPath);
    FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
    if (![db open])
        NSLog(@"Could not open db.");
    else
        NSLog(@"Open db successly.");
    
    NSMutableString *query = [NSMutableString stringWithString:@"SELECT shortRouteName FROM expressinfo"];
    //NSLog(@"query=%@", query);
    FMResultSet *rs = [db executeQuery:query];
    
    while ([rs next])
    {
        [searchResults addObject:[rs stringForColumn:@"shortRouteName"]];
    }
    [rs close];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        NSArray *searchBarSubViews = [[self.searchBar.subviews objectAtIndex:0] subviews];
        for (UIView *view in searchBarSubViews) {
            if([view isKindOfClass:[UITextField class]])
            {
                UITextField* search=(UITextField*)view;
                [search setFont:[UIFont fontWithName:@"MyCustomFont" size:15]];
                [search setInputView:self.myKeyboardView];
            }
        }
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 38)];
    }
    else
    {
        [[searchBar.subviews objectAtIndex:1] setInputView:myKeyboardView];
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    }
    
    [self.searchBar setTintColor:[UIColor lightGrayColor]];
    self.searchBar.placeholder = @"請輸入路線編號或名稱";
    [self initializeMyKeyboardView];
    
    [self.searchBar reloadInputViews];
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
        [self.tableView addSubview:searchBar];
    else
        self.tableView.tableHeaderView = searchBar;
    self.searchBar.delegate = (id)self;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
    [buttonPartBusName setString:theSearchBar.text];
    NSLog(@"search bar text = %@", buttonPartBusName);
    if(searchText.length != 0)
    {
        if([searchResults count] > 0)
            [searchResults removeAllObjects];
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"ntou_mobile3.db"];
        NSLog(@"defaultDBPath=%@", defaultDBPath);
        FMDatabase *db = [FMDatabase databaseWithPath:defaultDBPath];
        if (![db open])
            NSLog(@"Could not open db.");
        else
            NSLog(@"Open db successly.");
        
        NSMutableString *query = [NSMutableString stringWithString:@"SELECT shortRouteName FROM expressinfo WHERE shortRouteName LIKE '%"];
        [query appendString:searchText];
        [query appendString:@"%'"];
        //NSLog(@"query=%@", query);
        FMResultSet *rs = [db executeQuery:query];
        
        while ([rs next])
        {
            [searchResults addObject:[rs stringForColumn:@"shortRouteName"]];
        }
        [rs close];
        
        [self.tableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
    // You can write search code Here
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [searchResults count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSArray * tmpArr = [[searchResults objectAtIndex:indexPath.row] componentsSeparatedByString:@"["];
    NSString * text = [tmpArr objectAtIndex:0];
    NSString * detail = @"";
    if([tmpArr count] == 2)
        detail = [[[tmpArr objectAtIndex:1] componentsSeparatedByString:@"]"] objectAtIndex:0];
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detail;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExpressBusDetail2ViewController * secondLevel = [[ExpressBusDetail2ViewController alloc] initWithStyle:UITableViewStyleGrouped];
    NSString * selectedShortRouteName = [[NSString alloc] initWithString:[searchResults objectAtIndex:indexPath.row]];
    secondLevel.title = [[NSString alloc] initWithString:[selectedShortRouteName substringWithRange:NSMakeRange(0, 4)]];
    [secondLevel setCompleteRouteName:selectedShortRouteName];
    [self.navigationController pushViewController:secondLevel animated:YES];
    [secondLevel release];
}

@end
