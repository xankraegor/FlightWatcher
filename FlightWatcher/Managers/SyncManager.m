//
//  SyncManager.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 10.03.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import "SyncManager.h"
#import "CoreDataHelper.h"
#import "FavoriteTicket+CoreDataClass.h"

@implementation SyncManager

+ (instancetype)sharedInstance {
    logCurrentMethod();
    static SyncManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[SyncManager alloc] init];
    });
    return instance;
}

- (void)storeRecords {
    logCurrentMethod();
    CKContainer  *container = CKContainer.defaultContainer;
    CKDatabase *privateDatabase = container.privateCloudDatabase;

    for (FavoriteTicket *item in CoreDataHelper.sharedInstance.favorites) {
        CKRecordID *publicationRecordID = [[CKRecordID alloc] initWithRecordName:[item recordId]];
        CKRecord *publicationRecord = [[CKRecord alloc] initWithRecordType:@"favoriteTicket" recordID:publicationRecordID];
        publicationRecord[@"addedFromMap"] = item.addedFromMap ? @(1) : @(0);
        publicationRecord[@"airline"] = item.airline;
        publicationRecord[@"created"] = item.created;
        publicationRecord[@"departure"] = item.departure;
        publicationRecord[@"expires"] = item.expires;
        publicationRecord[@"flightNumber"] = @(item.flightNumber);
        publicationRecord[@"from"] = item.from;
        publicationRecord[@"price"] = @(item.price);
        publicationRecord[@"returnDate"] = item.returnDate;
        publicationRecord[@"to"] = item.to;

        [privateDatabase saveRecord:publicationRecord completionHandler:^(CKRecord *record, NSError *error) {
            if (error) {
                NSLog(@"%@", error);
                return;
            } else {
                NSLog(@"Record %@ added", record.recordID);
            }
        }];
    }




}

@end
