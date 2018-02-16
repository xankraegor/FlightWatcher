//
//  CollectionViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 13.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "SearchResultsCollectionViewController.h"
#import "TicketCollectionViewCell.h"
#import "APIManager.h"
#import "YYWebImageManager.h"
#import "YYWebImage.h"
#import "Ticket.h"

@interface SearchResultsCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) NSArray *tickets;
@end

@implementation SearchResultsCollectionViewController

NSDateFormatter *dateFormatter;

#pragma mark Life cycle

- (instancetype)initWithTickets:(NSArray *)tickets {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self = [super initWithCollectionViewLayout:flowLayout];
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";
    _tickets = tickets;

    return self;
}

-(void)viewDidLoad {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    [self.collectionView registerClass:TicketCollectionViewCell.class forCellWithReuseIdentifier:@"TicketCellIdentifier"];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView.delegate = self;
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

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.bounds.size.width;
    if (width > 350) width = 350;
    return CGSizeMake(width, 150);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (@available(iOS 11, *)) {
        return self.view.safeAreaInsets;
    } else {
        return UIEdgeInsetsMake(8, 8, 8, 8);
    }
}

// MARK: - Memory management

-(void)didReceiveMemoryWarning {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

@end