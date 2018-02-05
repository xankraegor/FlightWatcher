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

@implementation MainView {
    UIButton *originButton;
    UIButton *destinationButton;
}

- (id)initWithFrame:(CGRect)frame {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.whiteColor;

    UIViewController *superViewController = [[self superview] getViewController];

    CGFloat topInset = 24;
    CGFloat leftInset = 24;
    CGFloat rightInset = 24;
    CGFloat internalMarginSize = 16;
    CGFloat elementWidth = self.bounds.size.width - leftInset - rightInset;
    CGFloat elementHeight = 32;
    CGFloat halfSizeElementWidth = (elementWidth - internalMarginSize) / 2;
    
#pragma mark originButton
    CGRect originButtonFrame = CGRectMake(leftInset, topInset, elementWidth, elementHeight);
    originButton = [[UIButton alloc] initWithFrame:originButtonFrame title:@"Откуда"];
    [originButton addTarget:superViewController action:@selector(presentOriginSelectionView) forControlEvents:UIControlEventTouchUpInside];
    [originButton setEnabled:false];
    [self addSubview:originButton];

#pragma mark destinationButton
    CGRect destinationButtonFrame = CGRectMake(leftInset,
            originButtonFrame.origin.y + originButtonFrame.size.height + internalMarginSize,
            elementWidth, elementHeight);
    destinationButton = [[UIButton alloc] initWithFrame:destinationButtonFrame title:@"Куда"];
    [destinationButton addTarget:superViewController action:@selector(presentDestinationSelectionView) forControlEvents:UIControlEventTouchUpInside];
    [destinationButton setEnabled:false];
    [self addSubview:destinationButton];

#pragma mark PERSON COUNT

#pragma mark adultsCountLabel
    CGRect adultsCountLabelFrame = CGRectMake(leftInset,
            destinationButtonFrame.origin.y + destinationButtonFrame.size.height + 3 * internalMarginSize,
            halfSizeElementWidth,
            elementHeight);
    UILabel *adultsCountLabel = [UILabel newWithFrame:adultsCountLabelFrame usingTitle:@"Количество взрослых"];
    [self addSubview:adultsCountLabel];

#pragma mark childrenCountLabel
    CGRect childrenCountLabelFrame = CGRectMake(leftInset + halfSizeElementWidth + internalMarginSize,
            destinationButtonFrame.origin.y + destinationButtonFrame.size.height + 3 * internalMarginSize,
            halfSizeElementWidth,
            elementHeight);
    UILabel *childrenCountLabel = [UILabel newWithFrame:childrenCountLabelFrame usingTitle:@"Количество детей"];
    [self addSubview:childrenCountLabel];

#pragma mark adultCountStepper
    CGRect adultsCountStepperFrame = CGRectMake(leftInset - internalMarginSize + halfSizeElementWidth / 2,
                                                adultsCountLabelFrame.origin.y + adultsCountLabelFrame.size.height + internalMarginSize,
                                                halfSizeElementWidth / 2,
                                                elementHeight);
    UIStepper *adultCountStepper = [[UIStepper alloc]initWithFrame:adultsCountStepperFrame];
    [self addSubview:adultCountStepper];
    
#pragma mark childrenCountStepper
    CGRect childrenCountStepperFrame = CGRectMake(leftInset + halfSizeElementWidth + halfSizeElementWidth / 2,
                                                  childrenCountLabelFrame.origin.y + childrenCountLabelFrame.size.height + internalMarginSize,
                                                  halfSizeElementWidth / 2,
                                                  elementHeight);
    UIStepper *childrenCountStepper = [[UIStepper alloc]initWithFrame:childrenCountStepperFrame];
    [self addSubview:childrenCountStepper];
    
#pragma mark adultsLabel
    CGRect adultsLabelFrame = CGRectMake(leftInset,
                                         adultsCountLabelFrame.origin.y + adultsCountLabelFrame.size.height + internalMarginSize,
                                         halfSizeElementWidth / 2 - internalMarginSize / 2,
                                         elementHeight);
    UILabel *adultsLabel = [UILabel newWithFrame:adultsLabelFrame usingTitle:@"0"];
    [self addSubview:adultsLabel];
    
#pragma mark childrenLabel
    CGRect childrenLabelFrame = CGRectMake(leftInset + halfSizeElementWidth + internalMarginSize,
                                           adultsCountLabelFrame.origin.y + adultsCountLabelFrame.size.height + internalMarginSize,
                                           halfSizeElementWidth / 2  - internalMarginSize / 2,
                                           elementHeight);
    UILabel *childrenLabel = [UILabel newWithFrame:childrenLabelFrame usingTitle:@"0"];
    [self addSubview:childrenLabel];
    
#pragma mark TRANSFER COUNT
    
#pragma mark transfersCountLabel
    CGRect tansfersCountLabelFrame = CGRectMake(leftInset,
                                                adultsLabelFrame.origin.y + adultsLabelFrame.size.height + 3 * internalMarginSize,
                                                elementWidth * 2/3,
                                                elementHeight);
    UILabel *tansfersCountLabel = [UILabel newWithFrame:tansfersCountLabelFrame usingTitle:@"Количество пересадок:    0"];
    [self addSubview:tansfersCountLabel];
    
#pragma mark transfersCountStepper
    CGRect tansfersCountStepperFrame = CGRectMake(leftInset + elementWidth * 2/3,
                                                  adultsLabelFrame.origin.y + adultsLabelFrame.size.height + 3 * internalMarginSize,
                                                  elementWidth * 1/3,
                                                  elementHeight);
    UIStepper *tansfersCountStepper = [[UIStepper alloc]initWithFrame:tansfersCountStepperFrame];
    [self addSubview:tansfersCountStepper];
    
    return self;
}

-(void)activateButtons {
    [originButton setEnabled:true];
    [destinationButton setEnabled:true];
}

- (void) setTitle:(NSString*)title forOriginButton:(BOOL)isOrigin {
    if (isOrigin) {
        [originButton setTitle:[[NSString alloc] initWithFormat:@"Откуда: %@", title] forState:UIControlStateNormal];
    } else {
        [destinationButton setTitle:[[NSString alloc] initWithFormat:@"Куда: %@", title] forState:UIControlStateNormal];
    }
}


@end
