//
//  NTOUGuideSetViewController.m
//  NTOUMobile
//
//  Created by cclin on 1/31/13.
//
//

#import "NTOUGuideSetViewController.h"

@interface NTOUGuideSetViewController ()

@end

@implementation NTOUGuideSetViewController


-(void) setlocation:(CLLocationCoordinate2D) inputloaction latitudeDelta:(double)latitude longitudeDelta:(double)longitude{
    location = inputloaction;
    span.latitudeDelta  = latitude;
    span.longitudeDelta = longitude;
}

- (void)mapView:(MKMapView *)theMapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [theMapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
}


-(id)init{
    self = [super init];
    if (self){
        //self.title= @"Location";
    }
    
    return self;
}



-(void)loadView
{
    [super loadView];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    
    /*
    MKCoordinateRegion region;
    region.center.latitude = location.latitude;
    region.center.longitude = location.longitude;
    region.span = span;
    [self mapView:mapView didUpdateUserLocation:userlocation];
    [self addBusAnnotationNearLatitude :region.center.latitude andLongtitude:region.center.longitude];
    mapView.showsUserLocation = YES;
    mapView.mapType = MKMapTypeHybrid;
    [mapView setRegion:region animated:YES];
    [self.view addSubview:mapView];
    [mapView release];
    [super viewWillAppear:animated];
     */
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(location.latitude, location.longitude);
    marker.title = self.title;
    marker.snippet = self.title;
    marker.map = mapView;
    
}
-(void)switchMapType{
    if (switchButton.title==@"衛星地圖")
    {
        mapView.mapType=kGMSTypeSatellite;
        switchButton.title =@"混合地圖";
    }
    else if (switchButton.title==@"標準地圖")
    {
        mapView.mapType = kGMSTypeNormal;
        //mapView.mapType = MKMapTypeStandard;
        switchButton.title =@"衛星地圖";
        
    }
    else if (switchButton.title==@"混合地圖")
    {
        mapView.mapType = kGMSTypeHybrid;
        //mapView.mapType = MKMapTypeHybrid;
        switchButton.title =@"標準地圖";
        
    }
    [self reloadInputViews];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    MKUserLocation *userlocation = [[MKUserLocation alloc]init];
    [userlocation setCoordinate:location];
    GMSCameraPosition *region=[GMSCameraPosition cameraWithLatitude:location.latitude longitude:location.longitude zoom:17];
    mapView=[GMSMapView mapWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height) camera:region];
    mapView.myLocationEnabled=YES;
    self.view=mapView;
    switchButton = [[UIBarButtonItem alloc] initWithTitle:@"衛星地圖" style:UIBarButtonItemStylePlain target:self action:@selector(switchMapType)];
    self.navigationItem.rightBarButtonItem = switchButton;
    
    // Creates a marker in the center of the map.
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
