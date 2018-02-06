//
//  MainNavigationController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 30.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "MainNavigationController.h"
#import "MainViewController.h"
#import "UIColor+ColorPalette.h"

@interface MainNavigationController ()

@end

@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    MainViewController *firstViewController = [[MainViewController alloc] init];
    [self setupNavigationOutlook];
    [self pushViewController:firstViewController animated:YES];

}

- (void)setupNavigationOutlook {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    self.navigationBar.barTintColor = UIColor.navigationBarFW;
    self.navigationBar.translucent = false;
    self.navigationBar.prefersLargeTitles = true;
}

@end
