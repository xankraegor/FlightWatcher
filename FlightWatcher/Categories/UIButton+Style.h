//
// Created by Xan Kraegor on 02.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Style)

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title background:(UIColor *)bgcolor tint:(UIColor *)tintClr;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;
@end