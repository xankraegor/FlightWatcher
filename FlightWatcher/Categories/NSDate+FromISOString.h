//
// Created by Xan Kraegor on 06.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (FromISOString)

-(instancetype)initWithISOString:(NSString*)dateString;

@end