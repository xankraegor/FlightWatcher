//
//  MainViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 30.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController () <PlaceViewControllerDelegate>

@property (nonatomic) SearchRequest searchRequest;

@end

@implementation MainViewController

#pragma mark Life cycle

- (void)viewDidLoad {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [[DataManager sharedInstance] loadData];
    [super viewDidLoad];
    [self performViewInitialization];
}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:@"Поиск билетов"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataLoadingCompletion)
                                                 name:kDataManagerLoadDataDidComplete object:nil];

    // 'Bar button remains highlighted' bug workaround:
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDataManagerLoadDataDidComplete
                                                  object:nil];
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

#pragma mark - Loading data

- (void)dataLoadingCompletion {
    [self.view performSelector:@selector(activateButtons)];
}


#pragma mark - Navigation

- (void) presentSearchResultsController {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [self.navigationItem setTitle:nil];
    SearchResultsTableViewController *controller = [[SearchResultsTableViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)presentOriginSelectionView {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [self.navigationItem setTitle:nil];
    PlacesTableViewController *controller = [[PlacesTableViewController alloc]
            initWithStyle:UITableViewStylePlain
           toReturnOrigin:true];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}


-(void)presentDestinationSelectionView {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [self.navigationItem setTitle:nil];
    PlacesTableViewController *controller = [[PlacesTableViewController alloc]
            initWithStyle:UITableViewStylePlain
           toReturnOrigin:false];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - PlaceViewControllerDelegate
- ( void )selectPlace:(id)place withType:(BOOL)isOrigin andDataType:(DataSourceType)dataType {
    [ self setPlace:place withDataType:dataType andPlaceType:isOrigin];
}
- (void)setPlace:( id )place withDataType:(DataSourceType)dataType andPlaceType:(BOOL)isOrigin {
    NSString *title;
    NSString *data;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *)place;
        title = city.name;
        data = city.code;
    } else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *)place;
        title = airport.name;
        data = airport.cityCode;
    }
    if (isOrigin) {
        _searchRequest.origin = data;
    } else {
        _searchRequest.destination = data;
    }

    [(MainView *)self.view setTitle:title forOriginButton:isOrigin];
}

@end
