//
//  DataManager.h
//  FlightWatcher
//
//  Created by Xan Kraegor on 02.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "City.h"

#define kDataManagerLoadDataDidComplete  @"DataManagerLoadDataDidComplete"


@interface DataManager : NSObject
@property(nonatomic, strong, readonly) NSArray *countries;
@property(nonatomic, strong, readonly) NSArray *cities;
@property(nonatomic, strong, readonly) NSArray *airports;
+ (instancetype)sharedInstance;
- (void)loadData;
- (City *)cityForCityCode:(NSString *)iata;

- (City *)cityForLocation:(CLLocation *)location;
@end
