//
//  MainViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 30.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "MainViewController.h"
#import "DataSourceTypeEnum.h"
#import "TicketsCollectionViewController.h"
#import "MainView.h"
#import "DataManager.h"
#import "PlacesTableViewController.h"
#import "SearchRequest.h"
#import "APIManager.h"
#import "Airport.h"


@interface MainViewController () <PlaceViewControllerDelegate>
@property (nonatomic) SearchRequest searchRequest;
@property (strong) TicketsCollectionViewController *searchResultsCollectionViewController;
@end


@implementation MainViewController

// MARK: - Life cycle

- (void)viewDidLoad {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [super viewDidLoad];
    [DataManager.sharedInstance loadData];
    [self performViewInitialization];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadingCompletion)
                                                 name:kDataManagerLoadDataDidComplete object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
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
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
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
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [self.view performSelector:@selector(activateButtons)];
    [APIManager.sharedInstance cityForCurrentIP:^(City *city) {
        [self setPlace:city ofType:DataSourceTypeCity isOrigin:YES];
    }];
}


// MARK: - Navigation

- (void)searchButtonPressed {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [APIManager.sharedInstance ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
        if (tickets.count > 0) {
            _searchResultsCollectionViewController =
                    [[TicketsCollectionViewController alloc] initWithTickets:tickets];
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


}

- (void)presentOriginSelectionView {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    PlacesTableViewController *controller = [[PlacesTableViewController alloc]
            initWithStyle:UITableViewStylePlain
           toReturnOrigin:true];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)presentDestinationSelectionView {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    PlacesTableViewController *controller = [[PlacesTableViewController alloc]
            initWithStyle:UITableViewStylePlain
           toReturnOrigin:false];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

// MARK: - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(BOOL)isOrigin andDataType:(DataSourceType)dataType {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [self setPlace:place ofType:dataType isOrigin:isOrigin];
}

- (void)setPlace:(id)place ofType:(DataSourceType)dataType isOrigin:(BOOL)isOrigin {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
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

// MARK: - Memory management

-(void)didReceiveMemoryWarning {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

@end
