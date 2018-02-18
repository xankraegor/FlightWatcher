//
// Created by Xan Kraegor on 10.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "City.h"

@interface MapPrice : NSObject
@property(strong, nonatomic) City *destination;
@property(strong, nonatomic) City *origin;
@property(strong, nonatomic) NSDate *departure;
@property(strong, nonatomic) NSDate *returnDate;
@property(nonatomic) NSInteger numberOfChanges;
@property(nonatomic) NSInteger value;
@property(nonatomic) NSInteger distance;
@property(nonatomic) BOOL actual;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary withOrigin:(City *)origin;
@end
