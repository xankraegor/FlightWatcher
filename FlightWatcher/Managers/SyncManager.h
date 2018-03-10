//
//  SyncManager.h
//  FlightWatcher
//
//  Created by Xan Kraegor on 10.03.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SyncManager : NSObject

+ (instancetype)sharedInstance;

- (void)storeRecords;
@end
