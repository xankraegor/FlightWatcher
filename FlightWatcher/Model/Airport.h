//
// Created by Xan Kraegor on 02.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "PlaceProtocol.h"

@interface Airport : NSObject <PlaceProtocol>
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *timezone;
@property(nonatomic, strong) NSDictionary *translations;
@property(nonatomic, strong) NSString *countryCode;
@property(nonatomic, strong) NSString *cityCode;
@property(nonatomic, strong) NSString *code;
@property(nonatomic, getter =isFlightable) BOOL flightable;
@property(nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end