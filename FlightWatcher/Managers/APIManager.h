//
// Created by Xan Kraegor on 05.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"
#import "SearchRequest.h"

@interface APIManager : NSObject

+ (instancetype)sharedInstance;

- (void)cityForCurrentIP:(void (^)(City *city))completion;

- (void)ticketsWithRequest:(SearchRequest)request withCompletion:(void (^)(NSArray *tickets))completion;

- (NSURL *)urlWithAirlineLogoForIATACode:(NSString *)code;
@end