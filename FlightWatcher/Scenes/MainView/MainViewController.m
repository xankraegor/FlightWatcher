//
//  MainViewController.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 30.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "MainViewController.h"
#import "DataSourceTypeEnum.h"
#import "TicketsViewController.h"
#import "MainView.h"
#import "DataManager.h"
#import "PlacesTableViewController.h"
#import "SearchRequest.h"
#import "APIManager.h"
#import "Airport.h"
#import "ProgressView.h"
#import "FirstViewController.h"


@interface MainViewController () <PlaceViewControllerDelegate>
@property(nonatomic) SearchRequest searchRequest;
@property(strong) TicketsViewController *searchResultsCollectionViewController;
@end


@implementation MainViewController {
    UIToolbar *keyboardToolbar;
    BOOL selectingDepartureDate;
    NSDateFormatter *dateFormatter;
}

// MARK: - Life cycle

- (void)viewDidLoad {
    logCurrentMethod();
    [super viewDidLoad];
    [DataManager.sharedInstance loadData];
    [self performViewInitialization];
    [self presentFirstViewControllerIfNeeded];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dataLoadingCompletion)
                                                 name:kDataManagerLoadDataDidComplete
                                               object:nil];

    [NSNotificationCenter.defaultCenter addObserver:self
                                           selector:@selector(handleLocalNotification)
                                               name:kDidReceiveNotificationResponse
                                             object:nil];

    selectingDepartureDate = true;
    _datePicker = [[UIDatePicker alloc] init];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    _datePicker.minimumDate = [NSDate date];
    _dateTextField = [[UITextField alloc] initWithFrame:self.view.bounds];
    _dateTextField.hidden = YES;
    _dateTextField.inputView = _datePicker;
    keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *resetBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Не указывать" style:UIBarButtonItemStyleDone target:self action:@selector(resetButtonDidTap)];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
            initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self
                                 action:@selector(doneButtonDidTap:)];
    keyboardToolbar.items = @[resetBarButton, flexBarButton, doneBarButton];
    _dateTextField.inputAccessoryView = keyboardToolbar;
    [self.view addSubview:_dateTextField];

    dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.timeStyle = NSDateFormatterNoStyle;

}


- (void)viewWillAppear:(BOOL)animated {
    logCurrentMethod();
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;

    // 'Bar button remains highlighted' bug workaround:
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeNormal;
    self.navigationController.navigationBar.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kDataManagerLoadDataDidComplete
                                                  object:nil];
    [NSNotificationCenter.defaultCenter removeObserver:self
                                                  name:kDidReceiveNotificationResponse
                                                object:nil];
}

// MARK: - View Initialization

- (void)performViewInitialization {
    logCurrentMethod();
    self.view = [[MainView alloc] initWithFrame:self.view.frame];
    [self.navigationItem setTitle:@"Поиск билетов"];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]
            initWithTitle:@"Найти"
                    style:UIBarButtonItemStylePlain
                   target:self
                   action:@selector(searchButtonPressed)];
    [self.navigationItem setRightBarButtonItem:rightButtonItem animated:NO];
}

// MARK: - Loading data

- (void)dataLoadingCompletion {
    logCurrentMethod();
    [self.view performSelector:@selector(activateButtons)];
    [APIManager.sharedInstance cityForCurrentIP:^(City *city) {
        [self setPlace:city ofType:DataSourceTypeCity isOrigin:YES];
    }];
}


// MARK: - Navigation

- (void)searchButtonPressed {
    logCurrentMethod();
    if (!_searchRequest.origin || !_searchRequest.destination) return;
    [ProgressView.sharedInstance show:^{
        [APIManager.sharedInstance ticketsWithRequest:_searchRequest withCompletion:^(NSArray *tickets) {
            [ProgressView.sharedInstance dismiss:^{
                if (tickets.count > 0) {
                    _searchResultsCollectionViewController =
                            [[TicketsViewController alloc] initWithTickets:tickets];
                    [self.navigationController pushViewController:_searchResultsCollectionViewController animated:YES];
                } else {
                    UIAlertController *alertController =
                            [UIAlertController alertControllerWithTitle:@""
                                                                message:@"По данному направлению билетов не найдено"
                                                         preferredStyle:UIAlertControllerStyleAlert];

                    [alertController addAction:[UIAlertAction actionWithTitle:@"Закрыть"
                                                                        style:(UIAlertActionStyleDefault) handler:nil]];

                    [self presentViewController:alertController animated:YES completion:nil];
                }
            }];
        }];
    }];
}

- (void)presentOriginSelectionView {
    logCurrentMethod();
    PlacesTableViewController *controller = [[PlacesTableViewController alloc] initWithStyle:UITableViewStylePlain toReturnOrigin:PlaceSelectionReturnTypeOrigin];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)presentDestinationSelectionView {
    logCurrentMethod();
    PlacesTableViewController *controller = [[PlacesTableViewController alloc] initWithStyle:UITableViewStylePlain toReturnOrigin:PlaceSelectionReturnTypeDestination];
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
}

// MARK: - Buttons' actions

-(void)presentDepartureDateBox {
    logCurrentMethod();
    selectingDepartureDate = true;
    _datePicker.minimumDate = [NSDate date];
    _datePicker.date = (_searchRequest.departDate) ?: [NSDate date];
    [_dateTextField becomeFirstResponder];
}

-(void)presentReturnDateBox {
    logCurrentMethod();
    selectingDepartureDate = false;
    _datePicker.minimumDate = (_searchRequest.departDate) ?: [NSDate date];
    _datePicker.date = (_searchRequest.returnDate) ?: [NSDate date];
    [_dateTextField becomeFirstResponder];
}

- (void)doneButtonDidTap:(UIBarButtonItem *)sender {
    logCurrentMethod();

    if (selectingDepartureDate) {
        _searchRequest.departDate = _datePicker.date;
        [(MainView *) self.view setDateButtonTitle:[dateFormatter stringFromDate:_datePicker.date] forDepartureDateButton:YES];
    } else {
        _searchRequest.returnDate = _datePicker.date;
        [(MainView *) self.view setDateButtonTitle:[dateFormatter stringFromDate:_datePicker.date] forDepartureDateButton:NO];
    }

    [self.view endEditing:YES];
}


- (void)resetButtonDidTap {
    logCurrentMethod();

    if (selectingDepartureDate) {
        _searchRequest.departDate = nil;
        [(MainView *) self.view setDateButtonTitle:@"любая" forDepartureDateButton:YES];
    } else {
        _searchRequest.returnDate = nil;
        [(MainView *) self.view setDateButtonTitle:@"любая" forDepartureDateButton:NO];
    }

    [self.view endEditing:YES];
}

// MARK: - PlaceViewControllerDelegate

- (void)selectPlace:(id)place withType:(PlaceSelectionReturnType)returnType andDataType:(DataSourceType)dataType {
    logCurrentMethod();

    if (returnType == PlaceSelectionReturnTypeOrigin) {
        [self setPlace:place ofType:dataType isOrigin:YES];
    }

    if (returnType == PlaceSelectionReturnTypeDestination) {
        [self setPlace:place ofType:dataType isOrigin:NO];
    }

}

- (void)setPlace:(id)place ofType:(DataSourceType)dataType isOrigin:(BOOL)isOrigin {
    logCurrentMethod();
    NSString *title;
    NSString *data;
    if (dataType == DataSourceTypeCity) {
        City *city = (City *) place;
        title = city.name;
        data = city.code;
    } else if (dataType == DataSourceTypeAirport) {
        Airport *airport = (Airport *) place;
        title = airport.name;
        data = airport.cityCode;
    }
    if (isOrigin) {
        _searchRequest.origin = data;
    } else {
        _searchRequest.destination = data;
    }

    [(MainView *) self.view setPlaceButtonTitle:title forOriginButton:isOrigin];
}

// MARK: - Initial start presentation

- (void)presentFirstViewControllerIfNeeded {
    BOOL isFirstStart = [[NSUserDefaults standardUserDefaults] boolForKey:@"first_start"];
    if (!isFirstStart) {
        FirstViewController *firstViewController = [[FirstViewController alloc]
                initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                  navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
        [self presentViewController:firstViewController animated:YES completion:nil];
    }
}

// MARK: - Memory management

- (void)didReceiveMemoryWarning {
    logCurrentMethod();
}

// MARK: - Local notification handling

- (void)handleLocalNotification {
    logCurrentMethod();
    [self.tabBarController setSelectedIndex:(NSUInteger) kFavoritesControllerIndex];
}

@end
