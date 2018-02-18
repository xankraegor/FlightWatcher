//
// Created by Xan Kraegor on 10.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "LocationService.h"
#import "APIManager.h"
#import "DataManager.h"
#import "MapViewController.h"
#import "MapPrice.h"
#import "CoreDataHelper.h"

@interface MapViewController () <MKMapViewDelegate>
@property(nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong) LocationService *locationService;
@property(nonatomic, strong) City *origin;
@property(nonatomic, strong) NSArray *prices;
@property(strong) UILabel *currentLocationLabel;
@end

@implementation MapViewController

- (void)viewDidLoad {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
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

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _mapView.frame = self.view.bounds;
    _currentLocationLabel.frame = CGRectMake(16, 16, _mapView.bounds.size.width - 32, 24.0);
}


- (void)dealloc {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    _locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocation:(NSNotification *)notification {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
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
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    _prices = prices;
    [_mapView removeAnnotations:_mapView.annotations];
    for (MapPrice *price in prices) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            annotation.title = [NSString stringWithFormat:@"%@", price.destination.name];
            annotation.subtitle = [NSString stringWithFormat:@"%ld₽", price.value];
            annotation.coordinate = price.destination.coordinate;
            [_mapView addAnnotation:annotation];
        });
    }
}

// MARK: - Map view delegate

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    if (annotation == mapView.userLocation) {
        return nil;
    }
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationReuseIdentifier"];

    return annotationView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    for (MapPrice *price in _prices) {
        if (price.destination.name == view.annotation.title) {
            [APIManager.sharedInstance requestTicketWithMapPrice:price completion:^(Ticket *ticket) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@ "Действия с билетом"
                                                                                         message:@"Что необходимо сделать с выбранным билетом?"
                                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *favoriteAction;
                if ([CoreDataHelper.sharedInstance isFavorite:ticket]) {
                    favoriteAction = [UIAlertAction actionWithTitle:@ "Удалить из избранного"
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction *_Nonnull action) {
                                                                [CoreDataHelper.sharedInstance
                                                                        removeFromFavorite:ticket];
                                                            }];
                } else {
                    favoriteAction = [UIAlertAction actionWithTitle:@ "Добавить в избранное"
                                                              style:UIAlertActionStyleDefault
                                                            handler:
                                                                    ^(UIAlertAction *_Nonnull action) {
                                                                        [CoreDataHelper.sharedInstance
                                                                                addToFavorite:ticket];
                                                                    }];
                }

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть"
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:nil];
                [alertController addAction:favoriteAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        }
    }
}

// MARK: - Memory management

-(void)didReceiveMemoryWarning {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}
@end
