//
// Created by Xan Kraegor on 19.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ProgressView : UIView
+ (instancetype)sharedInstance;

- (void)show:(void (^)(void))completion;

- (void)dismiss:(void (^)(void))completion;
@end