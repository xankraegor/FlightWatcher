//
//  CollectionViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 13.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "TicketCollectionViewCell.h"
#import "APIManager.h"
#import "YYWebImageManager.h"
#import "YYWebImage.h"
#import "Ticket.h"

@interface SearchResultsViewController ()
@property(nonatomic, strong) NSArray *tickets;
@end

@implementation SearchResultsViewController

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
    [self.collectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"TicketCellIdentifier"];
    self.view.backgroundColor = UIColor.whiteColor;

    self.navigationItem.title = @"Билеты";
    self.navigationItem.backBarButtonItem.title = @"Назад";
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tickets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TicketCellIdentifier" forIndexPath:indexPath];

    Ticket *ticket = _tickets[(NSUInteger) indexPath.row];
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ руб.", ticket.price];
    cell.placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    cell.dateLabel.text = [dateFormatter stringFromDate:ticket.departure];
    NSURL *urlLogo = [APIManager.sharedInstance urlWithAirlineLogoForIATACode:ticket.airline];
    [cell.airlineLogoView yy_setImageWithURL:urlLogo
                                     options:YYWebImageOptionSetImageWithFadeAnimation];
    return cell;
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
