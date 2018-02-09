//
//  SearchResultsTableViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 30.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "SearchResultsTableViewController.h"
#import "TicketTableViewCell.h"
#import "APIManager.h"
#import "YYWebImageManager.h"
#import "YYWebImage.h"
#import "Ticket.h"

@interface SearchResultsTableViewController ()
@property(nonatomic, strong) NSArray *tickets;
@end

@implementation SearchResultsTableViewController

NSDateFormatter *dateFormatter;

#pragma mark Life cycle

- (instancetype)initWithTickets:(NSArray *)tickets {
    self = [super init];
    if (!self) return nil;
    _tickets = tickets;
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    [self performViewInitialization];
    return self;
}

#pragma mark - View Initialization

- (void)performViewInitialization {
    [self.tableView registerClass:TicketTableViewCell.class forCellReuseIdentifier:@"TicketCellIdentifier"];
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.navigationItem.title = @"Билеты";
    self.navigationItem.backBarButtonItem.title = @"Назад";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tickets.count;
}

#pragma mark - Table view delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TicketCellIdentifier"
                                                                forIndexPath:indexPath];
    Ticket *ticket = _tickets[(NSUInteger) indexPath.row];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
    cell.placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    cell.dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    NSURL *urlLogo = [APIManager.sharedInstance urlWithAirlineLogoForIATACode:ticket.airline];
    [cell.airlineLogoView yy_setImageWithURL:urlLogo
                                 options:YYWebImageOptionSetImageWithFadeAnimation];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}


@end
