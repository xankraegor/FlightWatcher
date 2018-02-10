//
// Created by Xan Kraegor on 09.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#define kLocationServiceDidUpdateCurrentLocation @"LocationServiceDidUpdateCurrentLocation"

@interface LocationService : NSObject
- (void)cityNameForLocation:(CLLocation *)location completeWithName:(void (^)(NSString *))completion;
@end