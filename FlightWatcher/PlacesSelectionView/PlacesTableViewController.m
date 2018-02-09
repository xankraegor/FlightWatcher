//
//  PlacesTableViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 02.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "PlacesTableViewController.h"
#import "PlaceTableViewCell.h"
#import "DataManager.h"
#import "Airport.h"

@interface PlacesTableViewController ()

@property(strong, nonatomic) UISegmentedControl *segmentedControl;
@property(readonly, nonatomic) BOOL isOrigin;
@property(nonatomic) DataSourceType dataSourceType;

@end

@implementation PlacesTableViewController {

}

static NSString *cellId = @"PlaceCell";

#pragma mark - Initialization

- (instancetype)initWithStyle:(UITableViewStyle)style toReturnOrigin:(BOOL)isOrigin {
    self = [super initWithStyle:style];
    _isOrigin = isOrigin;
    _dataSourceType = DataSourceTypeCity;
    return self;
}

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self performViewInitialization];

}

#pragma mark - View initialization

- (void)performViewInitialization {
    [self.tableView registerClass:PlaceTableViewCell.class forCellReuseIdentifier:cellId];

    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Города", @"Аэропорты"]];
    [_segmentedControl addTarget:self action:@selector(changeSource)
                forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self changeSource];

}

- (void)changeSource {
    switch ([_segmentedControl selectedSegmentIndex]) {
        case (0):
            _dataSourceType = DataSourceTypeCity;
            [[self tableView] reloadData];
            break;
        case (1):
            _dataSourceType = DataSourceTypeAirport;
            [[self tableView] reloadData];
            break;
        default:
            break;
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (_dataSourceType) {
        case DataSourceTypeAirport:
            return [[[DataManager sharedInstance] airports] count];
        case DataSourceTypeCity:
            return [[[DataManager sharedInstance] cities] count];
        case DataSourceTypeCountry:
            return [[[DataManager sharedInstance] countries] count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    DataManager *manager = DataManager.sharedInstance;
    switch (_dataSourceType) {
        case DataSourceTypeAirport:
            cell.textLabel.text = [manager.airports[(NSUInteger) indexPath.row] name];
            cell.detailTextLabel.text = [manager.airports[(NSUInteger) indexPath.row] cityCode];
            break;
        case DataSourceTypeCity:

            cell.textLabel.text = [manager.cities[(NSUInteger) indexPath.row] name];
            cell.detailTextLabel.text = [manager.cities[(NSUInteger) indexPath.row] cityCode];
            break;
        case DataSourceTypeCountry:
            cell.textLabel.text = [manager.countries[(NSUInteger) indexPath.row] name];
            break;
    }

    return cell;
}


#pragma mark - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id place;
    switch (_dataSourceType) {
        case DataSourceTypeAirport:
            place = DataManager.sharedInstance.airports[(NSUInteger) indexPath.row];
            break;
        case DataSourceTypeCity:
            place = DataManager.sharedInstance.cities[(NSUInteger) indexPath.row];
            break;
        case DataSourceTypeCountry:
            place = DataManager.sharedInstance.countries[(NSUInteger) indexPath.row];
            break;
    }

    [self.delegate selectPlace:place withType:self.isOrigin andDataType:self.dataSourceType];
    [self.navigationController popViewControllerAnimated:YES];

}
@end
