//
//  SearchResultsTableViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 30.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "TicketTableViewCell.h"

@interface SearchResultsTableViewController ()
@property (nonatomic, strong) NSArray *tickets;
@end

@implementation SearchResultsTableViewController

#pragma mark Life cycle

-(instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (!self) return nil;
    _tickets = tickets;
    [self performViewInitialization];
    return self;
}

#pragma mark - View Initialization

- (void)performViewInitialization {
    self.view.backgroundColor = UIColor.whiteColor;
    [self.navigationItem setTitle:@"Билеты"];
    [self.navigationItem.backBarButtonItem setTitle:@"Назад"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

#pragma mark - Table view delegate


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketCellIdentifier"
                                                                forIndexPath:indexPath];
    cell.ticket = _tickets[(NSUInteger) indexPath.row];
    return cell;
}

-(CGFloat)tableView :(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}



@end
