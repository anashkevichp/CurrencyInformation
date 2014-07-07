//
//  CIViewController.m
//  CurrencyInformation
//
//  Created by Admin on 21.06.14.
//  Copyright (c) 2014 First Group. All rights reserved.
//

#import "CIMapViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface CIMapViewController ()

@end

@implementation CIMapViewController{
    GMSMapView *mapView;
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
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self._mapLatitude
                                                            longitude:self._mapLongitude
                                                                 zoom:17];
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    mapView.settings.myLocationButton = YES;
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(self._mapLatitude, self._mapLongitude);
    
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = self.bankName;
    marker.snippet = self.address;
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;
    [mapView setSelectedMarker:marker];
    self.view = mapView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
