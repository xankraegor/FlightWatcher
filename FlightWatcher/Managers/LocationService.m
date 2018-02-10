//
// Created by Xan Kraegor on 09.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "LocationService.h"
#import <UIKit/UIKit.h>

@interface LocationService () <CLLocationManagerDelegate>
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(strong, nonatomic) CLLocation *currentLocation;
@end

@implementation LocationService

- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
    }
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [_locationManager startUpdatingLocation];
    } else if (status != kCLAuthorizationStatusNotDetermined) {
        UIAlertController *alertController =
                [UIAlertController alertControllerWithTitle:@"Ошибка"
                                                    message:@"Не удалось определить текущий город!"
                                             preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть"
                                                            style:(UIAlertActionStyleDefault)
                                                          handler:nil]];
        [UIApplication.sharedApplication.keyWindow.rootViewController
                presentViewController:alertController animated:YES completion:nil];
    }
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray < CLLocation *>
*)locations {
    if (!_currentLocation) {
        _currentLocation = [locations firstObject];
        [_locationManager stopUpdatingLocation];
        [[NSNotificationCenter defaultCenter]
                postNotificationName:kLocationServiceDidUpdateCurrentLocation object:_currentLocation];
    }
}



@end