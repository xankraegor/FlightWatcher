//
//  CityObject+CoreDataProperties.m
//  
//
//  Created by Xan Kraegor on 16.02.2018.
//
//

#import "CityObject+CoreDataProperties.h"

@implementation CityObject (CoreDataProperties)

+ (NSFetchRequest<CityObject *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"CityObject"];
}

@dynamic code;
@dynamic countryCode;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic timezone;

@end
