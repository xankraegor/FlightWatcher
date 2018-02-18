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
@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UIBarButtonItem *sortButton;

@property TicketSortOrder sortOrder;
@property BOOL sortAscending;
@property TicketFilter ticketFilter;
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
    logCurrentMethod();

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;


    self = [super initWithCollectionViewLayout:flowLayout];
    self.title = favorites ? @"Избранные" : @"Билеты";
    displayingFavorites = favorites;
    _tickets = displayingFavorites ? CoreDataHelper.sharedInstance.favorites : tickets;
    dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";

    _sortOrder = TicketSortOrderCreated;
    _sortAscending = YES;
    _ticketFilter = TicketFilterAll;

    return self;
}

// MARK: - Life cycle

- (void)viewDidLoad {
    logCurrentMethod();
    if (displayingFavorites) [self setupAdditionalFavoritesViews];
    [self.collectionView registerClass:TicketCollectionViewCell.class forCellWithReuseIdentifier:@"TicketCellIdentifier"];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView.delegate = self;
    self.navigationItem.backBarButtonItem.title = @"Назад";
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadFavoritesIfNeededSortedAndFiltered];
}

- (void)loadFavoritesIfNeededSortedAndFiltered {
    if (displayingFavorites) {
        _tickets = [CoreDataHelper.sharedInstance
                favoritesSortedBy:_sortOrder
                        ascending:_sortAscending
                        fiteredBy:_ticketFilter];
        [self.collectionView reloadData];
    }
}

- (void)setupAdditionalFavoritesViews {
    logCurrentMethod();
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Все", @"С карты", @"Из поиска"]];
    [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segmentedControl;

    _sortButton = [[UIBarButtonItem alloc]
            initWithTitle:@"Сортировка"
                    style:UIBarButtonItemStylePlain
                   target:self
                   action:@selector(filterButtonPressed)];

    self.navigationItem.rightBarButtonItem = _sortButton;
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
    logCurrentMethod();


    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@ "Действия с билетом"
                                                                             message:@"Что необходимо сделать с выбранным билетом?"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([CoreDataHelper.sharedInstance isFavorite:_tickets[(NSUInteger) indexPath.row]]) {
        favoriteAction = [UIAlertAction actionWithTitle:@ "Удалить из избранного"
                                                  style:UIAlertActionStyleDestructive
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [CoreDataHelper.sharedInstance
                                                            removeFromFavorites:_tickets[(NSUInteger) indexPath.row]];
                                                    __weak typeof(self) welf = self;
                                                    if (displayingFavorites) {
                                                        [welf loadFavoritesIfNeededSortedAndFiltered];
                                                    }
                                                }];
    } else if (!displayingFavorites) {
        favoriteAction = [UIAlertAction actionWithTitle:@ "Добавить в избранное"
                                                  style:UIAlertActionStyleDefault
                                                handler:
                                                        ^(UIAlertAction *_Nonnull action) {
                                                            [CoreDataHelper.sharedInstance
                                                                    addToFavorites:_tickets[(NSUInteger) indexPath.row] fromMap:NO];
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



-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (@available(iOS 11, *)) {
        return UIEdgeInsetsMake(8, super.view.safeAreaInsets.left, 8, super.view.safeAreaInsets.right);
    } else {
        return UIEdgeInsetsMake(8, 8, 8, 8);
    }
}


// MARK: - Filter and sorting

-(void)segmentedControlValueChanged {
    logCurrentMethod();
    switch (_segmentedControl.selectedSegmentIndex) {
        case 0:
            _ticketFilter = TicketFilterAll;
            break;
        case 1:
            _ticketFilter = TicketFilterFromMap;
            break;
        case 2:
            _ticketFilter = TicketFilterManual;
            break;
        default:
            break;
    }
    [self loadFavoritesIfNeededSortedAndFiltered];
}

-(void)filterButtonPressed{
    logCurrentMethod();
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Сортировка билетов"
                                                                             message:@"Выберите предпочитаемую сортировку"
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sortByPriceAsc = [UIAlertAction actionWithTitle:@ "По цене (по возр.)"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    __weak typeof(self) welf = self;
                                                    welf.sortOrder = TicketSortOrderPrice;
                                                    welf.sortAscending = YES;
                                                    [welf loadFavoritesIfNeededSortedAndFiltered];
                                                }];
    [alertController addAction:sortByPriceAsc];

    UIAlertAction *sortByPriceDes = [UIAlertAction actionWithTitle:@ "По цене (по убыв.)"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                               __weak typeof(self) welf = self;
                                                               welf.sortOrder = TicketSortOrderPrice;
                                                               welf.sortAscending = NO;
                                                               [welf loadFavoritesIfNeededSortedAndFiltered];
                                                           }];
    [alertController addAction:sortByPriceDes];

    UIAlertAction *sortByAddedAsc = [UIAlertAction actionWithTitle:@ "По дате добавления (по возр.)"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                               __weak typeof(self) welf = self;
                                                               welf.sortOrder = TicketSortOrderCreated;
                                                               welf.sortAscending = YES;
                                                               [welf loadFavoritesIfNeededSortedAndFiltered];
                                                           }];
    [alertController addAction:sortByAddedAsc];

    UIAlertAction *sortByAddedDes = [UIAlertAction actionWithTitle:@ "По дате добавления (по убыв.)"
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                               __weak typeof(self) welf = self;
                                                               welf.sortOrder = TicketSortOrderCreated;
                                                               welf.sortAscending = NO;
                                                               [welf loadFavoritesIfNeededSortedAndFiltered];
                                                           }];

    [alertController addAction:sortByAddedDes];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}


// MARK: - Memory management

- (void)didReceiveMemoryWarning {
    logCurrentMethod();
}



@end
