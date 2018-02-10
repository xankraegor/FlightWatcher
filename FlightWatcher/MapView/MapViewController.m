//
// Created by Xan Kraegor on 10.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "LocationService.h"
#import "APIManager.h"
#import "DataManager.h"
#import "MapViewController.h"
#import "MapPrice.h"

@interface MapViewController () <MKMapViewDelegate>
@property(nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong) LocationService *locationService;
@property(nonatomic, strong) City *origin;
@property(nonatomic, strong) NSArray *prices;
@property(strong) UILabel *currentLocationLabel;
@end

@implementation MapViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Карта цен";
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    [DataManager.sharedInstance loadData];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(dataLoadedSuccessfully)
                                               name:kDataManagerLoadDataDidComplete object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateCurrentLocation:)
                                               name:kLocationServiceDidUpdateCurrentLocation object:nil];

    CGRect currentLocationFrame = CGRectMake(16, 16, _mapView.bounds.size.width - 32, 24.0);
    _currentLocationLabel = [[UILabel alloc] initWithFrame:currentLocationFrame];
    _currentLocationLabel.backgroundColor = [UIColor.whiteColor colorWithAlphaComponent:0.5];
    _currentLocationLabel.layer.cornerRadius = 10.0;
    _currentLocationLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_currentLocationLabel];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    _locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    CLLocation *currentLocation = notification.object;

    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(currentLocation.coordinate,
            1000000, 1000000);
    [_mapView setRegion:region animated:YES];
    if (currentLocation) {
        _origin = [DataManager.sharedInstance cityForLocation:currentLocation];
        if (_origin) {
            [APIManager.sharedInstance mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }

    [_locationService cityNameForLocation:currentLocation completeWithName:^(NSString *name) {
        _currentLocationLabel.text = name;
    }];
}

- (void)setPrices:(NSArray *)prices {
    _prices = prices;
    [_mapView removeAnnotations:_mapView.annotations];
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@ (%@)", price.destination.name,
                                                          price.destination.cityCode];
            annotation.subtitle = [NSString stringWithFormat:@"%ld руб.", (long) price.value];
            annotation.coordinate = price.destination.coordinate;
            [_mapView addAnnotation:annotation];
        });
    }
}

// MARK: - Map view delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == mapView.userLocation) {
        return nil;
    }

    MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationReuseIdentifier"];
    annotationView.canShowCallout = true;
    annotationView.enabled = true;

    return annotationView;
}
@end