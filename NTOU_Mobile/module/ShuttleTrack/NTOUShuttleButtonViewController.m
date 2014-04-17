//
//  NTOUShuttleButtonViewController.m
//  NTOU_Mobile
//
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
        self.title = @"交通資訊";
    }
    return self;
}

- (void)showButtons
{
    UIButton *busButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //position button
    busButton.frame = CGRectMake(40, 40, 100, 100);
    [busButton setTitle:@"公車" forState:UIControlStateNormal];
    [busButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    // add targets and actions
    [busButton setTag:0];
    [busButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.view addSubview:busButton];
    
    UIButton *trainButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //position button
    trainButton.frame = CGRectMake(180, 40, 100, 100);
    [trainButton setTitle:@"台鐵" forState:UIControlStateNormal];
    [trainButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    // add targets and actions
    [trainButton setTag:1];
    [trainButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.view addSubview:trainButton];
    
    UIButton *HSRailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //position button
    HSRailButton.frame = CGRectMake(40, 180, 100, 100);
    [HSRailButton setTitle:@"高鐵" forState:UIControlStateNormal];
    [HSRailButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    // add targets and actions
    [HSRailButton setTag:2];
    [HSRailButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.view addSubview:HSRailButton];

    UIButton *passengertrafficButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //position button
    passengertrafficButton.frame = CGRectMake(180, 180, 100, 100);
    [passengertrafficButton setTitle:@"客運" forState:UIControlStateNormal];
    [passengertrafficButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    // add targets and actions
    [passengertrafficButton setTag:3];
    [passengertrafficButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.view addSubview:passengertrafficButton];
    
    UIButton *ntouButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //position button
    ntouButton.frame = CGRectMake(40, 320, 240, 50);
    [ntouButton setTitle:@"海洋專車" forState:UIControlStateNormal];
    [ntouButton.titleLabel setFont:[UIFont systemFontOfSize:20]];
    // add targets and actions
    [ntouButton setTag:4];
    [ntouButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    // add to a view
    [self.view addSubview:ntouButton];
}

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
            setStationViewController.navigationItem.leftBarButtonItem.title = @"Back";
            [setStationViewController release];
            break;
        case 2: //高鐵
            NSLog(@"case 2");
            SetStationViewController *setHSStationViewController = [[SetStationViewController alloc] init];
            [setHSStationViewController initIsHighSpeedTrain:true];
            [self.navigationController pushViewController:setHSStationViewController animated:YES];
            setHSStationViewController.navigationItem.leftBarButtonItem.title = @"Back";
            [setHSStationViewController release];
            break;
        case 3: //客運
            NSLog(@"case 3");
            /*KuoFuhoViewController *kuoFuhoViewController = [[KuoFuhoViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:kuoFuhoViewController animated:YES];
            kuoFuhoViewController.navigationItem.leftBarButtonItem.title = @"Back";
            [kuoFuhoViewController release];*/
            ExpressBusSearchViewController *expressBusViewController = [[ExpressBusSearchViewController alloc] initWithStyle:UITableViewStyleGrouped];
            //expressBusViewController.tableView.frame = CGRectMake(0, 100, 320, 380);
            [self.navigationController pushViewController:expressBusViewController animated:YES];
            expressBusViewController.navigationItem.leftBarButtonItem.title = @"Back";
            [expressBusViewController release];
            break;
        case 4: //海洋專車
            NSLog(@"case 4");
            NTOUBusTableViewController *ntoubusViewController = [[NTOUBusTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController:ntoubusViewController animated:YES];
            ntoubusViewController.navigationItem.leftBarButtonItem.title = @"Back";
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
	// Do any additional setup after loading the view.
    [self showButtons];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
