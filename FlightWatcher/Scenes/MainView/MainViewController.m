//
//  MainViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 30.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "MainViewController.h"
#import "DataSourceTypeEnum.h"
#import "TicketsViewController.h"
#import "MainView.h"
#import "DataManager.h"
#import "PlacesTableViewController.h"
#import "SearchRequest.h"
#import "APIManager.h"
#import "Airport.h"
#import "ProgressView.h"
#import "FirstViewController.h"


@interface MainViewController () <PlaceViewControllerDelegate>
@property(nonatomic) SearchRequest searchRequest;
@property(strong) TicketsViewController *searchResultsCollectionViewController;
@end


@implementation MainViewController

// MARK: - Life cycle

- (void)viewDidLoad {
    logCurrentMethod();
    [super viewDidLoad];
    [DataManager.sharedInstance loadData];
    [self performViewInitialization];
    [self presentFirstViewControllerIfNeeded];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadingCompletion)
                                                 name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    logCurrentMethod();
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;

    // 'Bar button remains highlighted' bug workaround:
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete
                                                  object:nil];
}

// MARK: - View Initialization

- (void)performViewInitialization {
    logCurrentMethod();
    self.view = [[MainView alloc] initWithFrame:self.view.frame];
    [self.navigationItem setTitle:@"Поиск билетов"];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]
            initWithTitle:@"Найти"
                    style:UIBarButtonItemStylePlain
                   target:self
                   action:@selector(searchButtonPressed)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem animated:NO];
}

// MARK: - Loading data

- (void)dataLoadingCompletion {
    logCurrentMethod();
    [self.view performSelector:@selector(activateButtons)];
    [APIManager.sharedInstance cityForCurrentIP:^(City *city) {
        [self setPlace:city ofType:DataSourceTypeCity isOrigin:YES];
    }];
}


// MARK: - Navigation

- (void)searchButtonPressed {
    logCurrentMethod();
    if (!_searchRequest.origin || !_searchRequest.destination) return;
    [ProgressView.sharedInstance show:^{
        [APIManager.sharedInstance ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
            [ProgressView.sharedInstance dismiss:^{
                if (tickets.count > 0) {
                    _searchResultsCollectionViewController =
                            [[TicketsViewController alloc] initWithTickets:tickets];
                    [self.navigationController pushViewController:_searchResultsCollectionViewController animated:YES];
                } else {
                    UIAlertController *alertController =
                            [UIAlertController alertControllerWithTitle:@""
                                                                message:@"По данному направлению билетов не найдено"
                                                         preferredStyle:UIAlertControllerStyleAlert];

                    [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть"
                                                                        style:(UIAlertActionStyleDefault) handler:nil]];

                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }];
    }];
}

- (void)presentOriginSelectionView {
    logCurrentMethod();
    PlacesTableViewController *controller = [[PlacesTableViewController alloc]
            initWithStyle:UITableViewStylePlain
           toReturnOrigin:true];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)presentDestinationSelectionView {
    logCurrentMethod();
    PlacesTableViewController *controller = [[PlacesTableViewController alloc]
            initWithStyle:UITableViewStylePlain
           toReturnOrigin:false];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

// MARK: - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(BOOL)isOrigin andDataType:(DataSourceType)dataType {
    logCurrentMethod();
    [self setPlace:place ofType:dataType isOrigin:isOrigin];
}

- (void)setPlace:(id)place ofType:(DataSourceType)dataType isOrigin:(BOOL)isOrigin {
    logCurrentMethod();
    NSString *title;
    NSString *data;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *) place;
        title = city.name;
        data = city.code;
    } else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *) place;
        title = airport.name;
        data = airport.cityCode;
    }
    if (isOrigin) {
        _searchRequest.origin = data;
    } else {
        _searchRequest.destination = data;
    }

    [(MainView *) self.view setTitle:title forOriginButton:isOrigin];
}

// MARK: - Initial start presentation

- (void)presentFirstViewControllerIfNeeded {
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
    if (!isFirstStart) {
        FirstViewController *firstViewController = [[FirstViewController alloc]
                initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [self presentViewController:firstViewController animated:YES completion:nil];
    }
}

// MARK: - Memory management

- (void)didReceiveMemoryWarning {
    logCurrentMethod();
}

@end
