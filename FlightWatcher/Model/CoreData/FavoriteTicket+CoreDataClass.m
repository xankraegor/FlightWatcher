//
//  FavoriteTicket+CoreDataClass.m
//  
//
//  Created by Xan Kraegor on 16.02.2018.
//
//

#import "FavoriteTicket+CoreDataClass.h"

@implementation FavoriteTicket

-(NSString *)recordId {
    return [NSString stringWithFormat:@"%lu%lu%lu%lu%lu%lu",
                    self.airline.hash,
                    self.from.hash,
                    self.to.hash,
                    self.departure.hash,
                    @(self.flightNumber).hash,
                    @(self.price).hash];
}

@end
