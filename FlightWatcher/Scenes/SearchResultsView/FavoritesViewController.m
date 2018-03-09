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
    self.title = @"Избранные";
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
    self.navigationItem.backBarButtonItem.title = @"Назад";
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
    // N.B. "valueForKey" used by voluntary to work around strange EXC_BAD_ACCESS fault:
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ руб.", [ticket valueForKey:@"price"]];
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
            alertControllerWithTitle:@"Действия с билетом"
                             message:@"Что необходимо сделать с выбранным билетом?"
                      preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *favoriteAction;
    if ([CoreDataHelper.sharedInstance isFavorite:_tickets[(NSUInteger) indexPath.row]]) {
        favoriteAction = [UIAlertAction
                actionWithTitle:@ "Удалить из избранного"
                          style:UIAlertActionStyleDestructive
                        handler:^(UIAlertAction *_Nonnull action) {
                            [CoreDataHelper.sharedInstance removeFromFavorites:_tickets[(NSUInteger) indexPath.row]];
                            __weak typeof(self) welf = self;
                            [welf loadFavoritesIfNeededSortedAndFiltered];
                        }];
    }


    UIAlertAction *notificationAction = [UIAlertAction
            actionWithTitle:@"Напомнить"
                      style:(UIAlertActionStyleDefault)
                    handler:^(UIAlertAction *_Nonnull action) {
                        notificationCell = (TicketCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
                        [_dateTextField becomeFirstResponder];
                    }];
    [alertController addAction:notificationAction];


    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть" style:UIAlertActionStyleCancel handler:nil];
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

// MARK: - Buttons

- (void)doneButtonDidTap:(UIBarButtonItem *)sender {
    logCurrentMethod();
    if (_datePicker.date && notificationCell) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:notificationCell];
        if (!indexPath) return;
        // N.B. "valueForKey" used by voluntary to work around strange EXC_BAD_ACCESS fault:
        NSNumber *price = [_tickets[(NSUInteger) indexPath.row] valueForKey:@"price"];
        NSString *message = [NSString stringWithFormat:@"%@ - %@ за %@ руб.",
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
        Notification notification = NotificationMake(@"Напоминание о билете", message, _datePicker.date, imageURL);
        [[NotificationCenter sharedInstance] sendNotification:notification];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Успешно" message:[NSString stringWithFormat:@"Уведомление будет отправлено - %@", _datePicker.date] preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Закрыть"
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
