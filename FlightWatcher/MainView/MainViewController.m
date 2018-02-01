//
//  MainViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 30.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "MainViewController.h"
#import "SearchResultsTableViewController.h"
#import "MainView.h"

@interface MainViewController ()

@end

@implementation MainViewController

#pragma mark Life cycle

- (void)viewDidLoad {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [super viewDidLoad];
    [self performViewInitialization];
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"Поиск билетов"];

    // 'Bar button remains highlighted' bug workaround:
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
}

#pragma mark - View Initialization

- (void) performViewInitialization {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    self.view = [[MainView alloc]initWithFrame:self.view.frame];

    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]
                                        initWithTitle:@"Найти"
                                        style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(presentSearchResultsController)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem animated:NO];

}



#pragma mark - Navigation

- (void) presentSearchResultsController {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [self.navigationItem setTitle:nil];
    SearchResultsTableViewController *resultsController = [[SearchResultsTableViewController alloc] init];
    [self.navigationController pushViewController:resultsController animated:YES];
}

@end
