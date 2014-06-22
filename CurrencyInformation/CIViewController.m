//
//  CIViewController.m
//  CurrencyInformation
//
//  Created by Admin on 21.06.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface CIViewController ()

@end

@implementation CIViewController{
    GMSMapView *mapView_;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:51.5
                                                            longitude:-0.127
                                                                 zoom:12];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = YES;
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(51.5, -0.127);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = @"title";
    marker.snippet = @"snippet";
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView_;
    self.view = mapView_;

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    // Create a GMSCameraPosition that tells the map to display the
//    // coordinate -33.86,151.20 at zoom level 6.
//    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
//                                                            longitude:151.20
//                                                                 zoom:6];
//    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
//    mapView_.myLocationEnabled = YES;
//    self.view = mapView_;
//    
//    // Creates a marker in the center of the map.
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
//    marker.title = @"Sydney";
//    marker.snippet = @"Australia";
//    marker.map = mapView_;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
