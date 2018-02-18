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


@interface PlacesTableViewController () <UISearchResultsUpdating>

@property(strong, nonatomic) UISegmentedControl *segmentedControl;
@property(readonly, nonatomic) BOOL isOrigin;
@property(nonatomic) DataSourceType dataSourceType;
@property(nonatomic, strong) NSArray *currentArray;
@property(nonatomic, strong) NSArray *searchArray;
@property(nonatomic, strong) UISearchController *searchController;

@end

@implementation PlacesTableViewController {

}

static NSString *cellId = @"PlaceCell";

// MARK: - Initialization

- (instancetype)initWithStyle:(UITableViewStyle)style toReturnOrigin:(BOOL)isOrigin {
    logCurrentMethod();
    self = [super initWithStyle:style];
    _isOrigin = isOrigin;
    _dataSourceType = DataSourceTypeCity;
    [self performViewInitialization];
    return self;
}

- (void)performViewInitialization {
    logCurrentMethod();
    [self.tableView registerClass:PlaceTableViewCell.class forCellReuseIdentifier:cellId];

    self.title = _isOrigin ? @"Откуда" : @"Куда";

    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.searchResultsUpdater = self;
    _searchArray = [NSArray new];

    if (@available(iOS 11.0, *)) {
        self.navigationItem.searchController = _searchController;
        self.navigationItem.hidesSearchBarWhenScrolling = NO;
    } else {
        self.tableView.tableHeaderView = _searchController.searchBar;
    }

    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Города", @"Аэропорты"]];
    [_segmentedControl addTarget:self action:@selector(setSource) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    [self setSource];
}

- (void)setSource {
    logCurrentMethod();
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _currentArray = DataManager.sharedInstance.cities;
            break;
        case 1:
            _currentArray = DataManager.sharedInstance.airports;
            break;
        default:
            break;
    }
    [self.tableView reloadData];
}

// MARK: - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    logCurrentMethod();
    if (searchController.searchBar.text) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[cd] %@",
                                                                  searchController.searchBar.text];

        _searchArray = [_currentArray filteredArrayUsingPredicate:predicate];
        [self.tableView reloadData];
    }
}

-(BOOL)isSearching {
    return _searchController.isActive &&_searchArray.count > 0;
}

// MARK: - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self isSearching] ? [_searchArray count] : [_currentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    NSObject <PlaceProtocol> *place = [self isSearching] ?
            _searchArray[(NSUInteger) indexPath.row] : _currentArray[(NSUInteger) indexPath.row];
    cell.textLabel.text = place.name;
    cell.detailTextLabel.text = place.code;
    return cell;
}

// MARK: - Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    logCurrentMethod();
    id place = (_searchController.isActive &&_searchArray.count > 0) ? _searchArray[(NSUInteger) indexPath.row] : _currentArray[(NSUInteger) indexPath.row];
    [self.delegate selectPlace:place withType:self.isOrigin andDataType:self.dataSourceType];
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: - Memory management

-(void)didReceiveMemoryWarning {
    logCurrentMethod();
}

@end
