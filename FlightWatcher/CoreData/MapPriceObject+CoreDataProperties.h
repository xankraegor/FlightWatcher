//
//  MapPriceObject+CoreDataProperties.h
//  
//
//  Created by Xan Kraegor on 16.02.2018.
//
//

#import "MapPriceObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface MapPriceObject (CoreDataProperties)

+ (NSFetchRequest<MapPriceObject *> *)fetchRequest;

@property (nonatomic) BOOL actual;
@property (nullable, nonatomic, copy) NSDate *departure;
@property (nullable, nonatomic, copy) NSString *destinationCode;
@property (nonatomic) int16_t numberOfChanges;
@property (nullable, nonatomic, copy) NSString *originCode;
@property (nullable, nonatomic, copy) NSDate *returnDate;
@property (nonatomic) int32_t value;
@property (nullable, nonatomic, retain) CityObject *destination;
@property (nullable, nonatomic, retain) CityObject *origin;

@end

NS_ASSUME_NONNULL_END
