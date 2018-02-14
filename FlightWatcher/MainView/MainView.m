//
//  MainView.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 31.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "MainView.h"
#import "UILabel+Style.h"
#import "UIButton+Style.h"
#import "UIView+GetController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

@implementation MainView {
    UIButton *originButton;
    UIButton *destinationButton;
    UILabel *tansfersCountLabel;
    UIStepper *tansfersCountStepper;
}

- (id)initWithFrame:(CGRect)frame {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.whiteColor;

    UIViewController *superViewController = [[self superview] getViewController];


#pragma mark originButton
    originButton = [[UIButton alloc] initWithFrame:self.bounds title:@"Откуда"];
    [originButton addTarget:superViewController action:@selector(presentOriginSelectionView) forControlEvents:UIControlEventTouchUpInside];
    [originButton setEnabled:false];
    [self addSubview:originButton];

#pragma mark destinationButton
    destinationButton = [[UIButton alloc] initWithFrame:self.bounds title:@"Куда"];
    [destinationButton addTarget:superViewController action:@selector(presentDestinationSelectionView) forControlEvents:UIControlEventTouchUpInside];
    [destinationButton setEnabled:false];
    [self addSubview:destinationButton];


#pragma mark TRANSFER COUNT

#pragma mark transfersCountLabel
    tansfersCountLabel = [UILabel newWithFrame:self.bounds usingTitle:@"Количество пересадок: 0"];
    [self addSubview:tansfersCountLabel];

#pragma mark transfersCountStepper
    tansfersCountStepper = [[UIStepper alloc] initWithFrame:self.bounds];
    [self addSubview:tansfersCountStepper];

    return self;
}

- (void)activateButtons {
    [originButton setEnabled:true];
    [destinationButton setEnabled:true];
}

- (void)setTitle:(NSString *)title forOriginButton:(BOOL)isOrigin {
    if (isOrigin) {
        [originButton setTitle:[[NSString alloc] initWithFormat:@"Откуда: %@", title] forState:UIControlStateNormal];
    } else {
        [destinationButton setTitle:[[NSString alloc] initWithFormat:@"Куда: %@", title] forState:UIControlStateNormal];
    }
}

-(void)layoutSubviews {
    CGFloat topInset = 24;
    CGFloat leftInset = 24;
    CGFloat rightInset = 24;
    CGFloat internalMarginSize = 16;
    CGFloat elementWidth = self.bounds.size.width - leftInset - rightInset;
    CGFloat buttonHeight = 54;
    CGFloat elementHeight = 32;

    CGRect originButtonFrame = CGRectMake(leftInset, topInset, elementWidth, buttonHeight);
    originButton.frame = originButtonFrame;

    CGRect destinationButtonFrame = CGRectMake(leftInset,
            originButtonFrame.origin.y + originButtonFrame.size.height + internalMarginSize,
            elementWidth, buttonHeight);
    destinationButton.frame = destinationButtonFrame;

    CGRect tansfersCountLabelFrame = CGRectMake(leftInset,
            destinationButtonFrame.origin.y + destinationButtonFrame.size.height + 3 * internalMarginSize,
            elementWidth * 2 / 3,
            elementHeight);
    tansfersCountLabel.frame = tansfersCountLabelFrame;

    CGRect tansfersCountStepperFrame = CGRectMake(leftInset + elementWidth * 2 / 3,
            destinationButtonFrame.origin.y + destinationButtonFrame.size.height + 3 * internalMarginSize,
            elementWidth * 1 / 3,
            elementHeight);
    tansfersCountStepper.frame = tansfersCountStepperFrame;
}


@end

#pragma clang diagnostic pop
