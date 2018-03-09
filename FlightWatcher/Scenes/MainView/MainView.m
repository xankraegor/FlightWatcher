//
//  MainView.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 31.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "MainView.h"
#import "UIButton+Style.h"
#import "UIView+GetController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation MainView {
    UIButton *originButton;
    UIButton *destinationButton;
    UIButton *departureDateButton;
    UIButton *returnDateButton;
}

- (id)initWithFrame:(CGRect)frame {
    logCurrentMethod();
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.whiteColor;
    UIViewController *superViewController = [[self superview] getViewController];

// MARK: originButton
    originButton = [[UIButton alloc] initWithFrame:self.bounds title:NSLocalizedString(@"From: required", @"To: нужно указать")];
    [originButton addTarget:superViewController action:@selector(presentOriginSelectionView) forControlEvents:UIControlEventTouchUpInside];
    [originButton setEnabled:false];
    [self addSubview:originButton];

// MARK: destinationButton
    destinationButton = [[UIButton alloc] initWithFrame:self.bounds title:NSLocalizedString(@"To: required", @"Куда: нужно указать")];
    [destinationButton addTarget:superViewController action:@selector(presentDestinationSelectionView) forControlEvents:UIControlEventTouchUpInside];
    [destinationButton setEnabled:false];
    [self addSubview:destinationButton];

// MARK: departure_date
    departureDateButton = [[UIButton alloc] initWithFrame:self.bounds title:NSLocalizedString(@"Departure date: any", @"Дата вылета: любая")];
    [departureDateButton addTarget:superViewController action:@selector(presentDepartureDateBox) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:departureDateButton];

    // MARK: return_date
    returnDateButton = [[UIButton alloc] initWithFrame:self.bounds title:NSLocalizedString(@"Return date: any", @"Дата возвращения: any")];
    [returnDateButton addTarget:superViewController action:@selector(presentReturnDateBox) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:returnDateButton];

    return self;
}

- (void)activateButtons {
    [originButton setEnabled:true];
    [destinationButton setEnabled:true];
}

- (void)setPlaceButtonTitle:(NSString *)title forOriginButton:(BOOL)isOrigin {
    if (isOrigin) {
        [originButton setTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"From: %@", @"From: %@"), title] forState:UIControlStateNormal];
    } else {
        [destinationButton setTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"To: %@", @"Куда: %@"), title] forState:UIControlStateNormal];
    }
}

- (void)setDateButtonTitle:(NSString *)title forDepartureDateButton:(BOOL)isDeparture {
    if (isDeparture) {
        [departureDateButton setTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"Departure date: %@", @"Дата вылета: %@"), title] forState:UIControlStateNormal];
    } else {
        [returnDateButton setTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"Return date: %@", @"Дата возвращения: %@"), title] forState:UIControlStateNormal];
    }
}

- (void)layoutSubviews {
    CGFloat topInset = 24;
    CGFloat leftInset = 24;
    CGFloat rightInset = 24;
    CGFloat internalMarginSize = 24;
    CGFloat elementWidth = self.bounds.size.width - leftInset - rightInset;
    CGFloat buttonHeight = 54;

    CGRect originButtonFrame = CGRectMake(leftInset, 2 * topInset, elementWidth, buttonHeight);
    originButton.frame = originButtonFrame;

    CGRect destinationButtonFrame = CGRectMake(leftInset,
            CGRectGetMaxY(originButtonFrame) + internalMarginSize,
            elementWidth,
            buttonHeight);
    destinationButton.frame = destinationButtonFrame;

    CGRect departureDateButtonFrame = CGRectMake(leftInset,
            CGRectGetMaxY(destinationButtonFrame) + internalMarginSize,
            elementWidth,
            buttonHeight);
    departureDateButton.frame = departureDateButtonFrame;

    CGRect returnDateButtonFrame = CGRectMake(leftInset,
            CGRectGetMaxY(departureDateButtonFrame) + internalMarginSize,
            elementWidth,
            buttonHeight);
    returnDateButton.frame = returnDateButtonFrame;
}


@end

#pragma clang diagnostic pop
