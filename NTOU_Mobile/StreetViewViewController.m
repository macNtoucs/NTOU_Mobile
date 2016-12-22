//
//  StreetViewViewController.m
//  NTOU_Mobile
//
//  Created by Jheng-Chi on 2016/12/22.
//  Copyright © 2016年 NTOUcs_MAC. All rights reserved.
//

#import "StreetViewViewController.h"
@import GoogleMaps;

@interface StreetViewViewController ()

@end

@implementation StreetViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GMSPanoramaView *panoView = [[GMSPanoramaView alloc] initWithFrame:CGRectZero];
    self.view = panoView;
    
    [panoView moveNearCoordinate:CLLocationCoordinate2DMake(m_latitude, m_longitude)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setLatitude:(double)latitude setLongitude:(double)longitude {
    m_latitude = latitude;
    m_longitude = longitude;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
