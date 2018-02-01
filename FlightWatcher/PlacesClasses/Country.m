//
// Created by Xan Kraegor on 02.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "Country.h"

@implementation Country

    - (instancetype) initWithDictionary:(NSDictionary *)dictionary {
        self = [super init];
        if (self) {
            _currency  = [ dictionary  valueForKey: @"currency"];
            _translations  = [ dictionary  valueForKey:@  "name_translations"];
            _name  = [ dictionary  valueForKey: @"name"];
            _code  = [ dictionary  valueForKey: @"code"];
        }
        return self;
    }

@end