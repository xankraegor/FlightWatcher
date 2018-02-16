//
//  CollectionViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 13.02.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "TicketsCollectionViewController.h"
#import "TicketCollectionViewCell.h"
#import "APIManager.h"
#import "YYWebImageManager.h"
#import "YYWebImage.h"
#import "Ticket.h"
#import "CoreDataHelper.h"

@interface TicketsCollectionViewController () <UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) NSArray *tickets;
@end

@implementation TicketsCollectionViewController {
    BOOL displayingFavorites;
}

NSDateFormatter *dateFormatter;

// MARK: - Intitalization

- (instancetype)initWithTickets:(NSArray *)tickets {
    return [self initWithTickets:tickets diplayingFavorites:NO];
}

- (instancetype)initWithFavoriteTickets {
    return [self initWithTickets:nil diplayingFavorites:YES];
}

- (instancetype)initWithTickets:(NSArray *)tickets diplayingFavorites:(BOOL)favorites {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    displayingFavorites = favorites;
    _tickets = displayingFavorites ? CoreDataHelper.sharedInstance.favorites : tickets;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";

    self.title = favorites ? @"Избранные" : @"Билеты";

    self = [super initWithCollectionViewLayout:flowLayout];
    return self;
}

// MARK: - Life cycle

- (void)viewDidLoad {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));

    [self.collectionView registerClass:TicketCollectionViewCell.class forCellWithReuseIdentifier:@"TicketCellIdentifier"];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView.delegate = self;
    self.navigationItem.backBarButtonItem.title = @"Назад";
}

-(void)viewWillAppear:(BOOL)animated {

}

// MARK: - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _tickets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TicketCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TicketCellIdentifier" forIndexPath:indexPath];

    Ticket *ticket = _tickets[(NSUInteger) indexPath.row];
    // N.B. "valueForKey" used by voluntairy to work around strange EXC_BAD_ACCESS fault:
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ руб.", [ticket valueForKey:@"price"]];
    cell.placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    cell.dateLabel.text = [dateFormatter stringFromDate:ticket.departure];

    NSURL *urlLogo = [APIManager.sharedInstance urlWithAirlineLogoForIATACode:ticket.airline];
    [cell.airlineLogoView yy_setImageWithURL:urlLogo
                                     options:YYWebImageOptionSetImageWithFadeAnimation];
    return cell;
}

// MARK: - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    if (displayingFavorites) return;

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@ "Действия с билетом"
                                                                             message:@"Что необходимо сделать с выбранным билетом?"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([CoreDataHelper.sharedInstance isFavorite:_tickets[(NSUInteger) indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:@ "Удалить из избранного"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [CoreDataHelper.sharedInstance
                                                            removeFromFavorite:_tickets[(NSUInteger) indexPath.row]];
                                                }];
    } else {
        favoriteAction = [UIAlertAction actionWithTitle:@ "Добавить в избранное"
                                                  style:UIAlertActionStyleDefault
                                                handler:
                                                        ^(UIAlertAction *_Nonnull action) {
                                                            [CoreDataHelper.sharedInstance
                                                                    addToFavorite:_tickets[(NSUInteger) indexPath.row]];
                                                        }];
    }

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.bounds.size.width;
    if (width > 350) width = 350;
    return CGSizeMake(width, 150);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (@available(iOS 11, *)) {
        return self.view.safeAreaInsets;
    } else {
        return UIEdgeInsetsMake(8, 8, 8, 8);
    }
}

// MARK: - Memory management

- (void)didReceiveMemoryWarning {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

@end
