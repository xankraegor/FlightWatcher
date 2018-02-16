//
//  MapPriceObject+CoreDataClass.h
//  
//
//  Created by Xan Kraegor on 16.02.2018.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "MapPrice.h"

@class CityObject;

NS_ASSUME_NONNULL_BEGIN

@interface MapPriceObject : NSManagedObject

- (instancetype)initWithContext:(NSManagedObjectContext *)moc mapPrice:(MapPrice *)mapPrice;
@end

NS_ASSUME_NONNULL_END

#import "MapPriceObject+CoreDataProperties.h"
