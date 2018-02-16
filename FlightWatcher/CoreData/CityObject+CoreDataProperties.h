//
//  CityObject+CoreDataProperties.h
//  
//
//  Created by Xan Kraegor on 16.02.2018.
//
//

#import "CityObject+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface CityObject (CoreDataProperties)

+ (NSFetchRequest<CityObject *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *code;
@property (nullable, nonatomic, copy) NSString *countryCode;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *timezone;

@end

NS_ASSUME_NONNULL_END
