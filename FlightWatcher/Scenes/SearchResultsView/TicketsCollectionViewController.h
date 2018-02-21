//
//  CollectionViewController.h
//  FlightWatcher
//
//  Created by Xan Kraegor on 13.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//


@interface TicketsCollectionViewController : UICollectionViewController
- (instancetype)initWithTickets:(NSArray *)tickets;

- (instancetype)initWithFavoriteTickets;

@property(nonatomic, strong) UIDatePicker *datePicker;
@property(nonatomic, strong) UITextField *dateTextField;
@end
