//
//  CityObject+CoreDataClass.m
//  
//
//  Created by Xan Kraegor on 16.02.2018.
//
//

#import "CityObject+CoreDataClass.h"

@implementation CityObject

-(instancetype)initWithContext:(NSManagedObjectContext *)moc city:(City*)city {
    self = [super initWithContext:moc];
    self.code = city.code;
    self.countryCode = city.countryCode;
    self.latitude = city.coordinate.latitude;
    self.longitude = city.coordinate.longitude;
    self.name = city.name;
    self.timezone = city.timezone;
    return self;
}

@end
