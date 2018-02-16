//
//  MapPriceObject+CoreDataProperties.m
//  
//
//  Created by Xan Kraegor on 16.02.2018.
//
//

#import "MapPriceObject+CoreDataProperties.h"

@implementation MapPriceObject (CoreDataProperties)

+ (NSFetchRequest<MapPriceObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"MapPriceObject"];
}

@dynamic actual;
@dynamic departure;
@dynamic destinationCode;
@dynamic numberOfChanges;
@dynamic originCode;
@dynamic returnDate;
@dynamic value;
@dynamic destination;
@dynamic origin;

@end
