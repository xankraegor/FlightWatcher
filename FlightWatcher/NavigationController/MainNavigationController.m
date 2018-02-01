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
    NSLog(@"[MainNavigationController viewDidLoad]");
    MainViewController *firstViewController = [[MainViewController alloc] init];
    [self setupNavigationOutlook];
    [self pushViewController:firstViewController animated:YES];

}

- (void) setupNavigationOutlook {
    self.navigationBar.barTintColor = UIColor.navigationBarColor;
}

@end
