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
#import "UIButton+Style.h"
#import "PlacesTableViewController.h"
#import "Airport.h"

@interface MapViewController () <MKMapViewDelegate, PlaceViewControllerDelegate>
@property(nonatomic, strong) MKMapView *mapView;
@property(nonatomic, strong) LocationService *locationService;
@property(nonatomic, strong) City *origin;
@property(nonatomic, strong) NSArray *prices;
@property(nonatomic, strong) UIButton *selectPlaceButton;
@end

@implementation MapViewController

- (void)viewDidLoad {
    logCurrentMethod();
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Prices map", @"Prices map");
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.showsUserLocation = YES;
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    [DataManager.sharedInstance loadData];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(dataLoadedSuccessfully)
                                               name:kDataManagerLoadDataDidComplete object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(updateCurrentLocationWithNotification:)
                                               name:kLocationServiceDidUpdateCurrentLocation object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleLocalNotification)
                                               name:kDidReceiveNotificationResponse object:nil];

    _selectPlaceButton = [[UIButton alloc] initWithFrame:self.view.bounds title:NSLocalizedString(@"Choose departure location", @"Выбрать место вылета")];
    [_selectPlaceButton addTarget:self action:@selector(selectPlaceButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_selectPlaceButton];
}

- (void)viewWillAppear:(BOOL)animated {
    logCurrentMethod();
    [super viewWillAppear:animated];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeNever;
}

- (void)viewWillDisappear:(BOOL)animated {
    logCurrentMethod();
    [super viewWillDisappear:animated];
    self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _mapView.frame = self.view.bounds;
    _selectPlaceButton.frame = CGRectMake(_mapView.bounds.size.width / 2 - 250.0 / 2, CGRectGetMaxY(_mapView.bounds) - 64, 250.0, 48);
}


- (void)dealloc {
    logCurrentMethod();
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dataLoadedSuccessfully {
    logCurrentMethod();
    _locationService = [[LocationService alloc] init];
}

- (void)updateCurrentLocationWithNotification:(NSNotification *)notification {
    logCurrentMethod();
    CLLocation *currentLocation = notification.object;
    [self updateCurrentLocation:currentLocation];

}

-(void)updateCurrentLocationWithCoordinates:(CLLocationCoordinate2D)coordinates {
    logCurrentMethod();
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinates.latitude longitude:coordinates.longitude];
    [self updateCurrentLocation:location];
}

-(void)updateCurrentLocation:(CLLocation *)location {
    logCurrentMethod();
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate,
            1000000, 1000000);
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView setRegion:region animated:YES];
    if (location) {
        _origin = [DataManager.sharedInstance cityForLocation:location];
        if (_origin) {
            [APIManager.sharedInstance mapPricesFor:_origin withCompletion:^(NSArray *prices) {
                self.prices = prices;
            }];
        }
    }

    [_locationService cityNameForLocation:location completeWithName:^(NSString *name) {
        self.navigationItem.title = [NSString stringWithFormat:NSLocalizedString(@"Prices map from %@", @"Prices map from %@"), (name) ?: NSLocalizedString(@"unknown place", @"неизвестного места")];
    }];
}


- (void)setPrices:(NSArray *)prices {
    logCurrentMethod();
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

// MARK: - Button's actions

-(void)selectPlaceButtonPressed {
    logCurrentMethod();
    PlacesTableViewController *controller = [[PlacesTableViewController alloc] initWithStyle:UITableViewStylePlain toReturnOrigin:PlaceSelectionReturnTypeMapOrigin];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

// MARK: - Map view delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    logCurrentMethod();
    if (annotation == mapView.userLocation) {
        return nil;
    }

    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationReuseIdentifier"];

    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    logCurrentMethod();
    for (MapPrice *price in _prices) {
        if (price.destination.name == view.annotation.title) {
            [APIManager.sharedInstance requestTicketWithMapPrice:price completion:^(Ticket *ticket) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:NSLocalizedString(@"Ticket to %@ for %@", @"Билет в %@ за %@"), view.annotation.title, view.annotation.subtitle]
                                                                                         message:NSLocalizedString(@"What to do with the ticket?", @"What to do with the ticket?")
                                                                                  preferredStyle:UIAlertControllerStyleActionSheet];
                UIAlertAction *favoriteAction;
                if ([CoreDataHelper.sharedInstance isFavorite:ticket]) {
                    favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Remove from favorites", @"Remove from favorites")
                                                              style:UIAlertActionStyleDestructive
                                                            handler:^(UIAlertAction *_Nonnull action) {
                                                                [CoreDataHelper.sharedInstance
                                                                        removeFromFavorites:ticket];
                                                            }];
                } else {
                    favoriteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Add to favorites", @"Добавить в избранное")
                                                              style:UIAlertActionStyleDefault
                                                            handler:
                                                                    ^(UIAlertAction *_Nonnull action) {
                                                                        [CoreDataHelper.sharedInstance
                                                                                addToFavorites:ticket fromMap:YES];
                                                                    }];
                }

                UIAlertAction *changeOriginAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Set this as departure location", @"Сделать это местом вылета")
                                                          style:UIAlertActionStyleDefault
                                                        handler:^(UIAlertAction *_Nonnull action) {
                                                            __weak typeof(self) welf = self;
                                                            [welf.mapView deselectAnnotation:view.annotation animated:YES];
                                                            [welf updateCurrentLocationWithCoordinates:view.annotation.coordinate];

                                                        }];

                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", @"Close")
                                                                       style:UIAlertActionStyleCancel
                                                                     handler:nil];
                [alertController addAction:favoriteAction];
                [alertController addAction:changeOriginAction];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
        }
    }
}

// MARK: - Local notification handling

- (void)handleLocalNotification {
    logCurrentMethod();
    [self.tabBarController setSelectedIndex:(NSUInteger) kFavoritesControllerIndex];
}

// MARK: - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceSelectionReturnType)returnType andDataType:(DataSourceType)dataType {
    logCurrentMethod();

    if (returnType == PlaceSelectionReturnTypeMapOrigin) {
        if (dataType == DataSourceTypeCity) {
            City *city = (City *) place;
            [self setNewOrigin:city.coordinate];

        } else if (dataType == DataSourceTypeAirport) {
            Airport *airport = (Airport *) place;
            [self setNewOrigin:airport.coordinate];
        }
    }
}

-(void) setNewOrigin:(CLLocationCoordinate2D)coordinate {
    logCurrentMethod();
    [self updateCurrentLocationWithCoordinates:coordinate];
}

@end
