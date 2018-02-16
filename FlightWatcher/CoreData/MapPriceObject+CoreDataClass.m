//
//  MapPriceObject+CoreDataClass.m
//  
//
//  Created by Xan Kraegor on 16.02.2018.
//
//

#import "MapPriceObject+CoreDataClass.h"

@implementation MapPriceObject

-(instancetype)initWithContext:(NSManagedObjectContext *)moc mapPrice:(MapPrice *)mapPrice{
    self = [super initWithContext:moc];
    self.originCode = mapPrice.origin.code;
    self.destinationCode = mapPrice.destination.code;
    self.numberOfChanges = (int16_t) mapPrice.numberOfChanges;
    self.actual = mapPrice.actual;
    self.departure = mapPrice.departure;
    self.returnDate = mapPrice.returnDate;
    [MapPriceObject resolveDependenciesOfMapPriceObject:self];
    return self;
}

+(void)resolveDependenciesOfMapPriceObject:(MapPriceObject *)object {

}

@end
