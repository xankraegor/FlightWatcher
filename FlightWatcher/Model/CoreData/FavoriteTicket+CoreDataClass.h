//
//  FavoriteTicket+CoreDataClass.h
//  
//
//  Created by Xan Kraegor on 16.02.2018.
//
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface FavoriteTicket : NSManagedObject

- (NSString *)recordId;
@end

NS_ASSUME_NONNULL_END

#import "FavoriteTicket+CoreDataProperties.h"
