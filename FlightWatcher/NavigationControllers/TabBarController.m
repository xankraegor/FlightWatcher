//
// Created by Xan Kraegor on 13.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "TabBarController.h"
#import "MainViewController.h"
#import "MapViewController.h"
#import "UIColor+ColorPalette.h"
#import "TicketsCollectionViewController.h"


@interface TabBarController () <UITabBarControllerDelegate>
@property(strong) UINavigationController *mainNavigationController;
@property(strong) MainViewController *mainViewController;
@property(strong) UINavigationController *mapNavigationController;
@property(strong) MapViewController *mapViewController;
@property(strong) UINavigationController *favoritesNavigationController;
@property(strong) TicketsCollectionViewController* favoriteViewController;
@end

@implementation TabBarController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.viewControllers = [self createViewControllers];
        self.tabBar.tintColor = [UIColor blackColor];
        self.tabBar.translucent = false;
        self.tabBar.barTintColor = [UIColor navigationBarFW];
        self.delegate = self;
    }
    return self;
}

- (NSArray <UIViewController *> *)createViewControllers {
    _mainViewController = [[MainViewController alloc] init];
    _mainViewController.tabBarItem =
            [[UITabBarItem alloc] initWithTitle:@"Поиск"
                                          image:[UIImage imageNamed:@"search"]
                                  selectedImage:[UIImage imageNamed:@"search_selected"]];
    _mainNavigationController = [[UINavigationController alloc]
            initWithRootViewController:_mainViewController];
    [self configuteNavigationController:_mainNavigationController];

    _mapViewController = [[MapViewController alloc] init];
    _mapViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Карта цен"
                                                                  image:[UIImage imageNamed:@"map"]
                                                          selectedImage:[UIImage imageNamed:@"map_selected"]];
    _mapNavigationController = [[UINavigationController alloc]
            initWithRootViewController:_mapViewController];
    [self configuteNavigationController:_mapNavigationController];

    _favoriteViewController = [[TicketsCollectionViewController alloc] initWithFavoriteTickets];
    _favoriteViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Избранное"
                                                                      image:[UIImage imageNamed:@"favorite"]
                                                              selectedImage:[UIImage imageNamed:@"favorite_selected"]];
    _favoritesNavigationController = [[UINavigationController alloc] initWithRootViewController:_favoriteViewController];

    return @[_mainNavigationController, _mapNavigationController, _favoritesNavigationController];
}

- (void)configuteNavigationController:(__kindof UINavigationController *)controller {
    controller.navigationBar.barTintColor = UIColor.navigationBarFW;
    controller.navigationBar.translucent = false;
    controller.navigationBar.prefersLargeTitles = true;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    NSLog(@"View controller selected: %@ of class %@", viewController, NSStringFromClass(viewController.class));
    NSLog(@"Child view controllers: %@", viewController.childViewControllers);
}

// MARK: - Memory management

- (void)didReceiveMemoryWarning {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

@end
