//
// Created by Xan Kraegor on 03.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct SearchRequest {
    __unsafe_unretained NSString *origin;
    __unsafe_unretained NSString *destionation;
    __unsafe_unretained NSDate *departDate;
    __unsafe_unretained NSDate *returnDate;
} SearchRequest;