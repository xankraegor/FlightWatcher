//
//  MainNavigationController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 30.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "MainNavigationController.h"
#import "UIColor+ColorPalette.h"



@interface MainNavigationController ()

@end

@implementation MainNavigationController

-(instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    self = [super initWithRootViewController:rootViewController];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationOutlook];
}

- (void)setupNavigationOutlook {
    self.navigationBar.barTintColor = UIColor.navigationBarFW;
    self.navigationBar.translucent = false;
    self.navigationBar.prefersLargeTitles = true;
}

@end
