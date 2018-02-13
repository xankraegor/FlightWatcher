//
// Created by Xan Kraegor on 13.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "MainNavigationController.h"
#import "UIColor+ColorPalette.h"

@implementation TabBarController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor blackColor];
        self.tabBar.translucent = false;
        self.tabBar.barTintColor = [UIColor navigationBarFW];

    }
    return self;
}

- (NSArray <UIViewController *> *)createViewControllers {
    NSMutableArray < UIViewController * > *controllers = [NSMutableArray new];
    MainViewController *mainViewController = [[MainViewController alloc] init];
    mainViewController.tabBarItem =
            [[UITabBarItem alloc] initWithTitle:@"Поиск"
                                          image:[UIImage imageNamed:@"search"]
                                  selectedImage:[UIImage imageNamed:@"search_selected"]];
    MainNavigationController *mainNavigationController = [[MainNavigationController alloc]
            initWithRootViewController:mainViewController];
    [controllers addObject:mainNavigationController];
    MapViewController *mapViewController = [[MapViewController alloc] init];
    mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Карта цен"
                                                                 image:[UIImage imageNamed:@"map"] selectedImage:[UIImage imageNamed:@"map_selected"]];
    MainNavigationController *mapNavigationController = [[MainNavigationController alloc]
            initWithRootViewController:mapViewController];
    [controllers addObject:mapNavigationController];
    return controllers;
}

@end