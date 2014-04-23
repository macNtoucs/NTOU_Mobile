//
//  ExpressBusSearchViewController.m
//  NTOU_Mobile
//
//  Created by iMac on 14/4/17.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "ExpressBusSearchViewController.h"
#import "FMDatabase.h"

@interface ExpressBusSearchViewController ()

@end

@implementation ExpressBusSearchViewController

@synthesize searchResults;
@synthesize searchBar;
@synthesize myKeyboardView, buttonTintColor, buttonPartBusName;

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
    myKeyboardView = [[[UIView alloc] initWithFrame:CGRectMake(0, 250, 320, 185)] retain];
    [myKeyboardView setBackgroundColor:[UIColor lightTextColor]];
    
    buttonTintColor = [UIColor blackColor];
    
    UIButton * buttonKeelung = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonKeelung setTitle:@"基" forState:UIControlStateNormal];
    [buttonKeelung setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonKeelung setTag:10];
    buttonKeelung.frame = CGRectMake(5, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonKeelung addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonCenter = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonCenter setTitle:@"中" forState:UIControlStateNormal];
    [buttonCenter setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonCenter setTag:14];
    buttonCenter.frame = CGRectMake(68, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonCenter addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonOne = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonOne setTitle:@"1" forState:UIControlStateNormal];
    [buttonOne setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonOne setTag:1];
    buttonOne.frame = CGRectMake(131, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonOne addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonTwo = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonTwo setTitle:@"2" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonTwo setTag:2];
    buttonTwo.frame = CGRectMake(194, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonTwo addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonThree = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonThree setTitle:@"3" forState:UIControlStateNormal];
    [buttonThree setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonThree setTag:3];
    buttonThree.frame = CGRectMake(257, 5, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonThree addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNorth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNorth setTitle:@"北" forState:UIControlStateNormal];
    [buttonNorth setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonNorth setTag:11];
    buttonNorth.frame = CGRectMake(5, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonNorth addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSouth = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSouth setTitle:@"南" forState:UIControlStateNormal];
    [buttonSouth setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonSouth setTag:15];
    buttonSouth.frame = CGRectMake(68, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonSouth addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFour = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonFour setTitle:@"4" forState:UIControlStateNormal];
    [buttonFour setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonFour setTag:4];
    buttonFour.frame = CGRectMake(131, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonFour addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonFive = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonFive setTitle:@"5" forState:UIControlStateNormal];
    [buttonFive setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonFive setTag:5];
    buttonFive.frame = CGRectMake(194, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonFive addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSix = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSix setTitle:@"6" forState:UIControlStateNormal];
    [buttonSix setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonSix setTag:6];
    buttonSix.frame = CGRectMake(257, 50, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonSix addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonTaoyuan = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonTaoyuan setTag:12];
    [buttonTaoyuan setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonTaoyuan setTitle:@"桃" forState:UIControlStateNormal];
    buttonTaoyuan.frame = CGRectMake(5, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonTaoyuan addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonKaohsiung = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonKaohsiung setTitle:@"高" forState:UIControlStateNormal];
    [buttonKaohsiung setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonKaohsiung setTag:16];
    buttonKaohsiung.frame = CGRectMake(68, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonKaohsiung addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonSeven = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonSeven setTitle:@"7" forState:UIControlStateNormal];
    [buttonSeven setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonSeven setTag:7];
    buttonSeven.frame = CGRectMake(131, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonSeven addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonEight = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonEight setTitle:@"8" forState:UIControlStateNormal];
    [buttonEight setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonEight setTag:8];
    buttonEight.frame = CGRectMake(194, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonEight addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonNine = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonNine setTitle:@"9" forState:UIControlStateNormal];
    [buttonNine setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonNine setTag:9];
    buttonNine.frame = CGRectMake(257, 95, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonNine addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonHsinchu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonHsinchu setTitle:@"竹" forState:UIControlStateNormal];
    [buttonHsinchu setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonHsinchu setTag:13];
    buttonHsinchu.frame = CGRectMake(5, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonHsinchu addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonEast = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonEast setTitle:@"東" forState:UIControlStateNormal];
    [buttonEast setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonEast setTag:17];
    buttonEast.frame = CGRectMake(68, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonEast addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonMore = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonMore setTitle:@"換" forState:UIControlStateNormal];
    [buttonMore setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonMore setTag:100];
    buttonMore.frame = CGRectMake(131, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonMore addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonReset = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [buttonReset setTitle:@"DEL" forState:UIControlStateNormal];
    [buttonReset setTitleColor:buttonTintColor forState:UIControlStateNormal];
    [buttonReset setTag:34];
    buttonReset.frame = CGRectMake(194, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonReset addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
    UIButton * buttonZero = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    buttonZero.frame = CGRectMake(257, 140, LAYER1_BUT_WIDTH, LAYER1_BUT_HEIGHT);
    [buttonZero setTag:14];
    [buttonZero setTitle:@"0" forState:UIControlStateNormal];
    [buttonZero addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
    
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
    [myKeyboardView addSubview:buttonTaoyuan];
    [myKeyboardView addSubview:buttonHsinchu];
    [myKeyboardView addSubview:buttonCenter];
    [myKeyboardView addSubview:buttonSouth];
    [myKeyboardView addSubview:buttonKaohsiung];
    [myKeyboardView addSubview:buttonEast];
    [myKeyboardView addSubview:buttonMore];
    [myKeyboardView addSubview:buttonReset];
}

/*- (void)buttonClicked:(id)sender
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
        default:
            break;
    }
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView applyStandardColors];
    /*UITapGestureRecognizer *myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
    [self.view addGestureRecognizer:myTap];
    [myTap release];*/
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
    
    //NSLog(@"searchResults: %@", searchResults);

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/*- (void)tapPress:(UIGestureRecognizer *)gestureRecognizer
{
    NSLog(@"ViewAttached:%@", gestureRecognizer.view);
    if ([gestureRecognizer.view isEqual:UITableViewCellStyleSubtitle])
    {
        NSLog(@"tapCell");
    }
    else
    {
        [self.searchBar resignFirstResponder];
        NSLog(@"tapPress");
    }
}*/

- (void)viewDidAppear:(BOOL)animated
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.searchBar setTintColor:[UIColor lightGrayColor]];
    self.searchBar.placeholder = @"請輸入路線編號或名稱";
    [self initializeMyKeyboardView];
    [[searchBar.subviews objectAtIndex:1] setInputView:myKeyboardView];
    //[self.searchBar reloadInputViews];
    
    self.tableView.tableHeaderView = searchBar;
    self.searchBar.delegate = (id)self;
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText
{
    //NSLog(@"search bar text = %@", theSearchBar.text);
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
    ExpressBusDetailViewController * secondLevel = [[ExpressBusDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    NSString * selectedShortRouteName = [[NSString alloc] initWithString:[searchResults objectAtIndex:indexPath.row]];
    secondLevel.title = [[NSString alloc] initWithString:[selectedShortRouteName substringWithRange:NSMakeRange(0, 4)]];
    [secondLevel setCompleteRouteName:selectedShortRouteName];
    [self.navigationController pushViewController:secondLevel animated:YES];
    [secondLevel release];
}

@end
