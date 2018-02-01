//
//  DataManager.h
//  FlightWatcher
//
//  Created by Xan Kraegor on 02.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "Country.h"
#import "City.h"
#import "Airport.h"
#define  kDataManagerLoadDataDidComplete  @"DataManagerLoadDataDidComplete"

typedef  enum  DataSourceType {
    DataSourceTypeCountry,
    DataSourceTypeCity,
    DataSourceTypeAirport
}  DataSourceType;

@interface  DataManager: NSObject
+ (instancetype) sharedInstance;
- (void)loadData;
@property (nonatomic, strong, readonly) NSArray *countries;
@property (nonatomic, strong, readonly) NSArray *cities;
@property (nonatomic, strong, readonly) NSArray *airports;
@end
