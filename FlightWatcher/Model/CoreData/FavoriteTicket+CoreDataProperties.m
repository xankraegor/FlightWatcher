//
//  FavoriteTicket+CoreDataProperties.m
//  
//
//  Created by Xan Kraegor on 18.02.2018.
//
//

#import "FavoriteTicket+CoreDataProperties.h"

@implementation FavoriteTicket (CoreDataProperties)

+ (NSFetchRequest<FavoriteTicket *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"FavoriteTicket"];
}

@dynamic airline;
@dynamic created;
@dynamic departure;
@dynamic expires;
@dynamic flightNumber;
@dynamic from;
@dynamic price;
@dynamic returnDate;
@dynamic to;
@dynamic addedFromMap;

@end
