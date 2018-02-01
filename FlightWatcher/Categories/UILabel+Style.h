//
// Created by Xan Kraegor on 01.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel (Style)

+(instancetype)newWithFrame:(CGRect)frame usingTitle:(NSString *__nullable)title alignment:(NSTextAlignment)alignment;
+(instancetype)newWithFrame:(CGRect)frame usingTitle:(NSString* __nullable)title;

@end