//
// Created by Xan Kraegor on 21.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "FavoritesViewController.h"
#import "TicketCollectionViewCell.h"
#import "APIManager.h"
#import "YYWebImageManager.h"
#import "YYWebImage.h"
#import "Ticket.h"
#import "CoreDataHelper.h"
#import "NotificationCenter.h"

@interface FavoritesViewController () <UICollectionViewDelegateFlowLayout>
@property(nonatomic, strong) NSArray <Ticket *> *tickets;
@property(nonatomic, strong) UISegmentedControl *segmentedControl;
@property(nonatomic, strong) UIBarButtonItem *sortButton;

@property TicketSortOrder sortOrder;
@property BOOL sortAscending;
@property TicketFilter ticketFilter;
@end

@implementation FavoritesViewController {

    TicketCollectionViewCell *notificationCell;
    UIToolbar *keyboardToolbar;
}

NSDateFormatter *favoritesDateFormatter;

// MARK: - Intitalization


- (instancetype)initWithFavoriteTickets {
    logCurrentMethod();

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.minimumLineSpacing = 0;

    self = [super initWithCollectionViewLayout:flowLayout];
    self.title = NSLocalizedString(@"Favorites", @"Favorites");
    _tickets = CoreDataHelper.sharedInstance.favorites;
    favoritesDateFormatter = [NSDateFormatter new];
    favoritesDateFormatter.dateFormat = @"dd MMMM yyyy hh:mm";

    _sortOrder = TicketSortOrderCreated;
    _sortAscending = YES;
    _ticketFilter = TicketFilterAll;
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    _datePicker.minimumDate = [NSDate date];
    _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
    _dateTextField.hidden = YES;
    _dateTextField.inputView = _datePicker;
    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                 action:@selector(doneButtonDidTap:)];
    keyboardToolbar.items = @[flexBarButton, doneBarButton];
    _dateTextField.inputAccessoryView = keyboardToolbar;
    [self.view addSubview:_dateTextField];

    return self;
}

// MARK: - Life cycle

- (void)viewDidLoad {
    logCurrentMethod();
    [super viewDidLoad];
    [self setupAdditionalFavoritesViews];
    [self.collectionView registerClass:TicketCollectionViewCell.class forCellWithReuseIdentifier:@"TicketCellIdentifier"];
    self.collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView.delegate = self;
    self.navigationItem.backBarButtonItem.title = NSLocalizedString(@"Back", @"Back");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadFavoritesIfNeededSortedAndFiltered];
}

- (void)loadFavoritesIfNeededSortedAndFiltered {
    _tickets = [CoreDataHelper.sharedInstance
            favoritesSortedBy:_sortOrder
                    ascending:_sortAscending
                    fiteredBy:_ticketFilter];
    [self.collectionView reloadData];
}

- (void)setupAdditionalFavoritesViews {
    logCurrentMethod();
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[NSLocalizedString(@"All", @"All"), NSLocalizedString(@"From map", @"From map"), NSLocalizedString(@"From search", @"From search")]];
    [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged) forControlEvents:UIControlEventValueChanged];
    _segmentedControl.tintColor = [UIColor blackColor];
    self.navigationItem.titleView = _segmentedControl;
    _segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = _segmentedControl;

    _sortButton = [[UIBarButtonItem alloc]
            initWithTitle:NSLocalizedString(@"Sort", @"Sort")
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
    // N.B. "valueForKey" used by voluntary to work around strange EXC_BAD_ACCESS fault:
    cell.priceLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ RUR", @"%@ RUR"), [ticket valueForKey:@"price"]];
    cell.placesLabel.text = [NSString stringWithFormat:@"%@ - %@", ticket.from, ticket.to];
    cell.dateLabel.text = [favoritesDateFormatter stringFromDate:ticket.departure];

    NSURL *urlLogo = [APIManager.sharedInstance urlWithAirlineLogoForIATACode:ticket.airline];
    [cell.airlineLogoView yy_setImageWithURL:urlLogo
                                     options:YYWebImageOptionSetImageWithFadeAnimation];
    return cell;
}

// MARK: - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    logCurrentMethod();

    UIAlertController *alertController = [UIAlertController
            alertControllerWithTitle:NSLocalizedString(@"Ticket actions", @"Ticket actions")
                             message:NSLocalizedString(@"What to do with the ticket?", @"What to do with the ticket?")
                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([CoreDataHelper.sharedInstance isFavorite:_tickets[(NSUInteger) indexPath.row]]) {
        favoriteAction = [UIAlertAction
                actionWithTitle:NSLocalizedString(@"Remove from favorites", @"Remove from favorites")
                          style:UIAlertActionStyleDestructive
                        handler:^(UIAlertAction *_Nonnull action) {
                            [CoreDataHelper.sharedInstance removeFromFavorites:_tickets[(NSUInteger) indexPath.row]];
                            __weak typeof(self) welf = self;
                            [welf loadFavoritesIfNeededSortedAndFiltered];
                        }];
    }


    UIAlertAction *notificationAction = [UIAlertAction
            actionWithTitle:NSLocalizedString(@"Remind me", @"Remind me")
                      style:(UIAlertActionStyleDefault)
                    handler:^(UIAlertAction *_Nonnull action) {
                        notificationCell = (TicketCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
                        [_dateTextField becomeFirstResponder];
                    }];
    [alertController addAction:notificationAction];


    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", @"Close") style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:favoriteAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    CATransform3D rotationAnimation = CATransform3DMakeRotation(1.178097 * M_PI / 2, 1.0, 1.0, 1.0);
    CATransform3D transitionAnimation = CATransform3DMakeTranslation(-cell.frame.size.width, 0, -cell.frame.size.width);
    CATransform3D animation = CATransform3DConcat(rotationAnimation, transitionAnimation);
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    transformAnimation.duration = 0.2;
    NSValue *startValue = [NSValue valueWithCATransform3D:animation];
    NSValue *endValue = [NSValue valueWithCATransform3D:cell.layer.transform];
    [transformAnimation setFromValue:startValue];
    [transformAnimation setToValue:endValue];
    [cell.layer addAnimation:transformAnimation forKey:@"transform"];
}

// MARK: - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = self.collectionView.bounds.size.width;
    if (width > 350) width = 350;
    return CGSizeMake(width, 150);
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (@available(iOS 11, *)) {
        return UIEdgeInsetsMake(8, super.view.safeAreaInsets.left, 8, super.view.safeAreaInsets.right);
    } else {
        return UIEdgeInsetsMake(8, 8, 8, 8);
    }
}


// MARK: - Filter and sorting

- (void)segmentedControlValueChanged {
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

- (void)filterButtonPressed {
    logCurrentMethod();
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Sort tickets", @"Sort tickets")
                                                                             message:NSLocalizedString(@"Select the preferred sort order", @"Select the preferred sort order")
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *sortByPriceAsc = [UIAlertAction actionWithTitle:NSLocalizedString(@"By price (asc.)", @"By price (asc.)")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                               __weak typeof(self) welf = self;
                                                               welf.sortOrder = TicketSortOrderPrice;
                                                               welf.sortAscending = YES;
                                                               [welf loadFavoritesIfNeededSortedAndFiltered];
                                                           }];
    [alertController addAction:sortByPriceAsc];

    UIAlertAction *sortByPriceDes = [UIAlertAction actionWithTitle:NSLocalizedString(@"By price (desc.)", @"By price (desc.)")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                               __weak typeof(self) welf = self;
                                                               welf.sortOrder = TicketSortOrderPrice;
                                                               welf.sortAscending = NO;
                                                               [welf loadFavoritesIfNeededSortedAndFiltered];
                                                           }];
    [alertController addAction:sortByPriceDes];

    UIAlertAction *sortByAddedAsc = [UIAlertAction actionWithTitle:NSLocalizedString(@"Date added (asc.)", @"Date added (asc.)")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                               __weak typeof(self) welf = self;
                                                               welf.sortOrder = TicketSortOrderCreated;
                                                               welf.sortAscending = YES;
                                                               [welf loadFavoritesIfNeededSortedAndFiltered];
                                                           }];
    [alertController addAction:sortByAddedAsc];

    UIAlertAction *sortByAddedDes = [UIAlertAction actionWithTitle:NSLocalizedString(@"Date added (desc.)", @"Date added (desc.)")
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction *_Nonnull action) {
                                                               __weak typeof(self) welf = self;
                                                               welf.sortOrder = TicketSortOrderCreated;
                                                               welf.sortAscending = NO;
                                                               [welf loadFavoritesIfNeededSortedAndFiltered];
                                                           }];

    [alertController addAction:sortByAddedDes];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", @"Close")
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alertController addAction:cancelAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

// MARK: - Buttons

- (void)doneButtonDidTap:(UIBarButtonItem *)sender {
    logCurrentMethod();
    if (_datePicker.date && notificationCell) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:notificationCell];
        if (!indexPath) return;
        // N.B. "valueForKey" used by voluntary to work around strange EXC_BAD_ACCESS fault:
        NSNumber *price = [_tickets[(NSUInteger) indexPath.row] valueForKey:@"price"];
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"%@ - %@ for %@ RUR", @"%@ - %@ for %@ RUR"),
                                                       _tickets[(NSUInteger) indexPath.row].from,
                                                       _tickets[(NSUInteger) indexPath.row].to,
                                                       price];
        NSURL *imageURL;
        if (notificationCell.airlineLogoView.image) {

            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
                    stringByAppendingString:[NSString stringWithFormat:@"/%@.png", _tickets[(NSUInteger) indexPath.row].airline]];

            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
                UIImage *logo = notificationCell.airlineLogoView.image;
                NSData *pngData = UIImagePNGRepresentation(logo);
                [pngData writeToFile:path atomically:YES];
            }
            imageURL = [NSURL fileURLWithPath:path];
        }
        Notification notification = NotificationMake(NSLocalizedString(@"Ticket reminder", @"Ticket reminder"), message, _datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", @"Success") message:[NSString stringWithFormat:NSLocalizedString(@"Remainder set at %@", "Remainder set at %@"), _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Close", @"Close")
                                                               style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [self.view endEditing:YES];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    _datePicker.date = [NSDate date];
    notificationCell = nil;
    [self.view endEditing:YES];
}

@end
