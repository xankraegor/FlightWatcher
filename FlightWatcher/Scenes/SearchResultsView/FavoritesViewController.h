//
// Created by Xan Kraegor on 21.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FavoritesViewController : UICollectionViewController
- (instancetype)initWithFavoriteTickets;
@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, strong) UITextField *dateTextField;
@end