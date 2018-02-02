//
//  PlacesTableViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 02.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "PlacesTableViewController.h"


#pragma clang diagnostic push
#pragma ide diagnostic ignored "OCNotLocalizedStringInspection"
@interface PlacesTableViewController ()

@property (readonly, atomic) BOOL isOrigin;
@property DataSourceType dataSourceType;

@end

@implementation PlacesTableViewController {

}

static NSString *cellId = @"PlaceCell";

#pragma mark - Initialization

-(instancetype)initWithStyle:(UITableViewStyle)style toReturnOrigin:(BOOL)isOrigin {
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

-(void) performViewInitialization {
    [[self tableView] registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];

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
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }

    switch (_dataSourceType) {
        case DataSourceTypeAirport:
            [[cell textLabel] setText:[[[DataManager sharedInstance] airports][(NSUInteger) indexPath.row] name]];
            break;
        case DataSourceTypeCity:
            [[cell textLabel] setText:[[[DataManager sharedInstance] cities][(NSUInteger) indexPath.row] name]];
            break;
        case DataSourceTypeCountry:
            [[cell textLabel] setText:[[[DataManager sharedInstance] countries][(NSUInteger) indexPath.row] name]];
            break;
    }

    return cell;
}






@end

#pragma clang diagnostic pop