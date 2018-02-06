//
// Created by Xan Kraegor on 05.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "APIManager.h"

#define API_URL_CHEAP @ "https://api.travelpayouts.com/v1/prices/cheap"
#define API_URL_IP_ADDRESS @ "https://api.ipify.org/?format=json"
#define API_URL_CITY_FROM_IP @ "https://www.travelpayouts.com/whereami?ip="


@interface APIManager ()
@property(nonatomic, strong) id apikey;
@end

@implementation APIManager {

}

+ (instancetype)sharedInstance {
    static APIManager *shared;
    static dispatch_once_t dispatchOperation;
    dispatch_once(&dispatchOperation, ^{
        shared = [[APIManager alloc] init];

        NSString *path = [NSBundle.mainBundle pathForResource:@"apikey"
                                                        ofType:@"plist"];
        NSDictionary *apiPlist = [NSDictionary dictionaryWithContentsOfFile:path];
        shared.apikey = apiPlist[@"apiToken"];
    });
    return shared;
}

- (void)cityForCurrentIP:(void (^)(City *city))completion {
    [self IPAddressWithCompletion:^(NSString *ipAddress) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", API_URL_CITY_FROM_IP, ipAddress];
        [self load:urlString withCompletion:^(id result) {
            NSDictionary *json = result;
            NSString *cityCode = [json valueForKey:@"iata"];
            if (!cityCode) return;
            City *city = [DataManager.sharedInstance cityForCityCode:cityCode];
            if (!city) return;
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(city);
            });
        }];
    }];
}

- (void)IPAddressWithCompletion:(void (^)(NSString *ipAddress))completion {
    [self load:API_URL_IP_ADDRESS withCompletion:^(id _Nullable result) {
        NSDictionary *json = result;
        NSLog(@"My ip address is: %@", [json valueForKey:@"ip"]);
        completion([json valueForKey:@"ip"]);
    }];
}

- (void)load:(NSString *)urlString withCompletion:(void (^)(id _Nullable result))completion {
    NSURL *url = [NSURL URLWithString:urlString];
    [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:YES];
    [[NSURLSession.sharedSession
            dataTaskWithURL:url
          completionHandler:^(
                  NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [UIApplication.sharedApplication setNetworkActivityIndicatorVisible:NO];
              });
              completion([NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingMutableContainers
                                                           error:nil]);
          }] resume];
}


@end