//
// Created by Xan Kraegor on 06.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

@interface Ticket : NSObject

@property(nonatomic, strong) NSNumber *price;
@property(nonatomic, strong) NSString *airline;
@property(nonatomic, strong) NSDate *departure;
@property(nonatomic, strong) NSDate *expires;
@property(nonatomic, strong) NSNumber *flightNumber;
@property(nonatomic, strong) NSDate *returnDate;
@property(nonatomic, strong) NSString *from;
@property(nonatomic, strong) NSString *to;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end