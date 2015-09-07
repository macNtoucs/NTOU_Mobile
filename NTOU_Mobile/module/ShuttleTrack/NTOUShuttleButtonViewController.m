//
//  NTOUShuttleButtonViewController.m
//  NTOU_Mobile
//  交通功能首頁
//  Created by iMac on 14/4/7.
//  Copyright (c) 2014年 NTOUcs_MAC. All rights reserved.
//

#import "NTOUShuttleButtonViewController.h"

@interface NTOUShuttleButtonViewController ()

@end

@implementation NTOUShuttleButtonViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:[NSBundle mainBundle]];
    if (self) {
        // Custom initialization
        //self.title = @"交通資訊";
        //[self.view setFrame:CGRectMake(0, 50, 320, 480)];
    }
    return self;
}

- (void)showButtons
{
    UIButton *busButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //position button
    busButton.frame = CGRectMake(40, 40, 100, 100);
    //[busButton setTitle:@"公車" forState:UIControlStateNormal];
    [busButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    // add targets and actions
    [busButton setTag:0];
    [busButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [busButton setBackgroundImage:[UIImage imageNamed:@"bus_100x100.png"] forState:UIControlStateNormal];
    // add to a view
    [self.view addSubview:busButton];
    
    UIButton *trainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //position button
    trainButton.frame = CGRectMake(180, 40, 100, 100);
    //[trainButton setTitle:@"台鐵" forState:UIControlStateNormal];
    [trainButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    // add targets and actions
    [trainButton setBackgroundImage:[UIImage imageNamed:@"train_100x100.png"] forState:UIControlStateNormal];
    [trainButton setTag:1];
    [trainButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.view addSubview:trainButton];
    
    UIButton *HSRailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //position button
    HSRailButton.frame = CGRectMake(40, 180, 100, 100);
    //[HSRailButton setTitle:@"高鐵" forState:UIControlStateNormal];
    [HSRailButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    // add targets and actions
    [HSRailButton setBackgroundImage:[UIImage imageNamed:@"speed-rail_100x100.png"] forState:UIControlStateNormal];
    [HSRailButton setTag:2];
    [HSRailButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.view addSubview:HSRailButton];

    UIButton *passengertrafficButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //position button
    passengertrafficButton.frame = CGRectMake(180, 180, 100, 100);
    //[passengertrafficButton setTitle:@"客運" forState:UIControlStateNormal];
    [passengertrafficButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    // add targets and actions
    [passengertrafficButton setBackgroundImage:[UIImage imageNamed:@"transport_100x100.png"] forState:UIControlStateNormal];
    [passengertrafficButton setTag:3];
    [passengertrafficButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.view addSubview:passengertrafficButton];
    
    UIButton *ntouButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //position button
    ntouButton.frame = CGRectMake(40, 320, 240, 50);
    //[ntouButton setTitle:@"海洋專車" forState:UIControlStateNormal];
    [ntouButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    [ntouButton setBackgroundImage:[UIImage imageNamed:@"NTOU-bus_240x50.png"] forState:UIControlStateNormal];
    // add targets and actions
    [ntouButton setTag:4];
    [ntouButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.view addSubview:ntouButton];
    
    
    //http://140.121.100.103:8080/iNTOU/getBusNews.do
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    NSMutableURLRequest * jsonQuest = [NSMutableURLRequest new];
    NSString * queryURL = @"http://140.121.100.103:8080/iNTOU/getBusNews.do";
    [jsonQuest setURL:[NSURL URLWithString:queryURL]];
    [jsonQuest setHTTPMethod:@"GET"];
    [jsonQuest addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:jsonQuest
                                                 returningResponse:&urlResponse
                                                             error:&error
                            ];
    NSString *news = [NSString stringWithFormat:@"資料來源<br>臺北市公車-臺北市政府交通局<br>新北市公車-我愛巴士5284行動查詢系統<br>基隆市公車-基隆市公車資訊便民服務系統<br>客運-我愛巴士5284行動查詢系統<br>火車-臺灣鐵路管理局<br>高鐵-台灣高鐵<br><br><br>公告<br>%@",responseData?[[NSString alloc]initWithData:responseData encoding:NSUTF8StringEncoding]:@""];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[news dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    UITextView *newsDisplay = [[UITextView alloc]initWithFrame:CGRectMake(40,380,240,100)];
    [newsDisplay setFont:[UIFont systemFontOfSize:10]];
    newsDisplay.attributedText=attrStr;
    [self.view addSubview:newsDisplay];

}

/*-(void)viewDidLoad:(BOOL)animated
{
    [self.view setFrame:CGRectMake(0, 20, 320, 480)];
}*/

- (void)buttonClicked:(id)sender
{
    NSLog(@"buttonClicked");
    switch ([sender tag])
    {
        case 0: //公車
            NSLog(@"case 0");
            TPRouteByButtonViewController *tpRouteByButtonViewController = [[TPRouteByButtonViewController alloc] init];
            [self.navigationController pushViewController:tpRouteByButtonViewController animated:YES];
            [tpRouteByButtonViewController release];
            break;
        case 1: //台鐵
            NSLog(@"case 1");
            SetStationViewController *setStationViewController = [[SetStationViewController alloc] init];
            [setStationViewController initIsHighSpeedTrain:false];
            [self.navigationController pushViewController:setStationViewController animated:YES];
            setStationViewController.navigationItem.leftBarButtonItem.title = @"back";
            [setStationViewController release];
            break;
        case 2: //高鐵
            NSLog(@"case 2");
            SetStationViewController *setHSStationViewController = [[SetStationViewController alloc] init];
            [setHSStationViewController initIsHighSpeedTrain:true];
            [self.navigationController pushViewController:setHSStationViewController animated:YES];
            setHSStationViewController.navigationItem.leftBarButtonItem.title = @"back";
            /*UIBarButtonItem *newBackButton =
            [[UIBarButtonItem alloc] initWithTitle:@"Hi"
                                             style:UIBarButtonItemStyleBordered
                                            target:nil
                                            action:nil];
            [[self navigationItem] setBackBarButtonItem:newBackButton];
            [newBackButton release];*/
            [setHSStationViewController release];
            break;
        case 3: //客運
            NSLog(@"case 3");
            /*KuoFuhoViewController *kuoFuhoViewController = [[KuoFuhoViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:kuoFuhoViewController animated:YES];
            kuoFuhoViewController.navigationItem.leftBarButtonItem.title = @"Back";
            [kuoFuhoViewController release];*/
            ExpressBusSearch2ViewController *expressBusViewController = [[ExpressBusSearch2ViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:expressBusViewController animated:YES];
            expressBusViewController.navigationItem.leftBarButtonItem.title = @"back";
            expressBusViewController.title = @"北北基客運";
            [expressBusViewController release];
            break;
        case 4: //海洋專車
            NSLog(@"case 4");
            NTOUBusTableViewController *ntoubusViewController = [[NTOUBusTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:ntoubusViewController animated:YES];
            ntoubusViewController.navigationItem.leftBarButtonItem.title = @"back";
            [ntoubusViewController release];
            break;
        default:
            NSLog(@"default");
            break;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7.0)
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.view.backgroundColor = [UIColor colorWithWhite:0.88 alpha:1.0];
    }
	// Do any additional setup after loading the view.
    [self showButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
