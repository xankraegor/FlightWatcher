//
//  CityObject+CoreDataClass.h
//  
//
//  Created by Xan Kraegor on 16.02.2018.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "City.h"

@class City;

NS_ASSUME_NONNULL_BEGIN

@interface CityObject : NSManagedObject

- (instancetype)initWithContext:(NSManagedObjectContext *)moc city:(City *)city;
@end

NS_ASSUME_NONNULL_END

#import "CityObject+CoreDataProperties.h"
