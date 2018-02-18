//
//  DataManager.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 02.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "DataManager.h"
#import "Country.h"
#import "Airport.h"
#import "DataSourceTypeEnum.h"

@interface DataManager ()
@property(nonatomic, strong) NSMutableArray *countriesArray;
@property(nonatomic, strong) NSMutableArray *citiesArray;
@property(nonatomic, strong) NSMutableArray *airportsArray;
@end

@implementation DataManager

+ (instancetype)sharedInstance {
    logCurrentMethod();
    static DataManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[DataManager alloc] init];
    });
    return instance;
}

- (void)loadData {
    logCurrentMethod();
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0), ^{

        NSSortDescriptor *byName = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:true];

        NSArray *countriesJsonArray = [self arrayFromFileName:@"countries" ofType:@"json"];
        countriesJsonArray = [countriesJsonArray sortedArrayUsingDescriptors:@[byName]];
        _countriesArray = [self createObjectsFromArray:countriesJsonArray withType:DataSourceTypeCountry];

        NSArray *citiesJsonArray = [self arrayFromFileName:@"cities" ofType:@"json"];
        citiesJsonArray = [citiesJsonArray sortedArrayUsingDescriptors:@[byName]];
        _citiesArray = [self createObjectsFromArray:citiesJsonArray withType:DataSourceTypeCity];

        NSArray *airportsJsonArray = [self arrayFromFileName:@"airports" ofType:@"json"];
        airportsJsonArray = [airportsJsonArray sortedArrayUsingDescriptors:@[byName]];
        _airportsArray = [self createObjectsFromArray:airportsJsonArray withType:DataSourceTypeAirport];

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kDataManagerLoadDataDidComplete
                                                                object:nil];
            NSLog(@"Data loading complete");
        });
    });
}


- (NSMutableArray *)createObjectsFromArray:(NSArray *)array withType:(DataSourceType)type {

    logCurrentMethod();
    NSMutableArray *results = [NSMutableArray new];
    for (NSDictionary *jsonObject in array) {
        if (type == DataSourceTypeCountry) {
            Country *country = [[Country alloc] initWithDictionary:jsonObject];
            [results addObject:country];
        } else if (type == DataSourceTypeCity) {
            City *city = [[City alloc] initWithDictionary:jsonObject];
            [results addObject:city];
        } else if (type == DataSourceTypeAirport) {
            Airport *airport = [[Airport alloc] initWithDictionary:jsonObject];
            [results addObject:airport];
        }
    }
    return results;
}

- (NSArray *)arrayFromFileName:(NSString *)fileName ofType:(NSString *)type {
    logCurrentMethod();
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:type];
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers
                                             error:nil];
}

- (NSArray *)countries {
    return _countriesArray;
}

- (NSArray *)cities {
    return _citiesArray;
}

- (NSArray *)airports {
    return _airportsArray;
}


- (City *)cityForCityCode:(NSString *)code {
    logCurrentMethod();
    if (!code) return nil;
    for (City *city in _citiesArray) {
        if (city.code == code) {
            return city;
        }
    }
    NSLog(@"[%@ %@] city not found for code %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd), code);
    return nil;
}

- (City *)cityForLocation:(CLLocation *)location {
    logCurrentMethod();
    for (City *city in _citiesArray) {
        if (ceilf((float) city.coordinate.latitude) == ceilf((float) location.coordinate.latitude) &&
                ceilf((float) city.coordinate.longitude) == ceilf((float) location.coordinate.longitude)) {
            return city;
        }
    }
    return nil;
}
@end
