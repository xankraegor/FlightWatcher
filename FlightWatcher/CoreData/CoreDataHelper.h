//
// Created by Xan Kraegor on 16.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "DataManager.h"
#import "FavoriteTicket+CoreDataClass.h"
#import "Ticket.h"

@interface CoreDataHelper : NSObject
+ (instancetype)sharedInstance;

- (BOOL)isFavorite:(Ticket *)ticket;

- (NSArray *)favorites;

- (void)addToFavorite:(Ticket *)ticket;

- (void)removeFromFavorite:(Ticket *)ticket;
@end