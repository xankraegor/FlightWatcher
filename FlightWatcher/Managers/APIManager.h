//
// Created by Xan Kraegor on 05.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataManager.h"

@interface APIManager : NSObject

+ (instancetype)sharedInstance;
- (void)cityForCurrentIP:(void (^)(City *city))completion;

@end