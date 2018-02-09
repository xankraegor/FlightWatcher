//
// Created by Xan Kraegor on 06.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "TicketTableViewCell.h"
#import "UIColor+ColorPalette.h"

@interface TicketTableViewCell ()
@end

@implementation TicketTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;

    self.contentView.layer.shadowColor = [[UIColor cellShadowColorFW] CGColor];
    self.contentView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.contentView.layer.shadowRadius = 7.0;
    self.contentView.layer.shadowOpacity = 1;
    self.contentView.layer.cornerRadius = 15;
    self.contentView.backgroundColor = [UIColor whiteColor];

    _priceLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _priceLabel.font = [UIFont systemFontOfSize:24.0 weight:UIFontWeightBold];
    [self.contentView addSubview:_priceLabel];

    _airlineLogoView = [[UIImageView alloc] initWithFrame:self.bounds];
    _airlineLogoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_airlineLogoView];

    _placesLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _placesLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightLight];
    _placesLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_placesLabel];

    _dateLabel = [[UILabel alloc] initWithFrame:self.bounds];
    _dateLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightRegular];
    [self.contentView addSubview:_dateLabel];

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(10.0, 10.0,
            [UIScreen mainScreen].bounds.size.width - 20.0, self.frame.size.height - 20.0);
    _airlineLogoView.frame = CGRectMake(self.contentView.frame.size.width - 110, 10.0, 100.0, 100.0);
    _priceLabel.frame = CGRectMake(10.0, 10.0, self.contentView.frame.size.width - _airlineLogoView.frame.size.width - 20, 40.0);
    _placesLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_priceLabel.frame) + 16.0, self.contentView.frame.size.width - _airlineLogoView.frame.size.width - 20, 20.0);
    _dateLabel.frame = CGRectMake(10.0, CGRectGetMaxY(_placesLabel.frame) + 8.0,
            self.contentView.frame.size.width - _airlineLogoView.frame.size.width - 20, 20.0);
}

@end