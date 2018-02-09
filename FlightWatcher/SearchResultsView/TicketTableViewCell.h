//
// Created by Xan Kraegor on 06.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketTableViewCell : UITableViewCell
@property(nonatomic, strong) UILabel *priceLabel;
@property(nonatomic, strong) UILabel *placesLabel;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UIImageView *airlineLogoView;
@end