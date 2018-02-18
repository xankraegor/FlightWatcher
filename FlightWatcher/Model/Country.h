//
// Created by Xan Kraegor on 02.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//


@interface Country : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *currency;
@property(nonatomic, strong) NSDictionary *translations;
@property(nonatomic, strong) NSString *countryCode;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end