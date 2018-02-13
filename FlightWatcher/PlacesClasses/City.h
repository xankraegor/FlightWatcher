//
// Created by Xan Kraegor on 02.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Place.h"

@interface City : NSObject <Place>
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *timezone;
@property(nonatomic, strong) NSDictionary *translations;
@property(nonatomic, strong) NSString *countryCode;
@property(nonatomic, strong) NSString *code;
@property(nonatomic) CLLocationCoordinate2D coordinate;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
