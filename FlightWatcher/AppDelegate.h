//
//  AppDelegate.h
//  FlightWatcher
//
//  Created by Xan Kraegor on 30.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(strong, nonatomic) UIWindow *window;

@property(readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;

@end

