//
//  MainView.m
//  FlightWatcher
//
//  Created by Xan Kraegor on 31.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import "MainView.h"

@implementation MainView

- (id)initWithFrame:(CGRect)frame {
    NSLog(@"%@ %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
    self = [super initWithFrame:frame];
    self.backgroundColor = UIColor.whiteColor;
    
    CGFloat topInset = 100;
    CGFloat leftInset = 32;
    CGFloat rightInset = 32;
    CGFloat internalMarginSize = 16;
    CGFloat elementWidth = self.bounds.size.width - leftInset - rightInset;
    CGFloat elementHeight = 30;
    CGFloat halfSizeElementWidth = (elementWidth - internalMarginSize) / 2;
    
#pragma mark originLabel
    CGRect originLabelFrame = CGRectMake(leftInset, topInset, elementWidth, elementHeight);
    UILabel *originLabel = [[UILabel alloc] initWithFrame:originLabelFrame];
    [self applyLabelStyleTo:originLabel usingTitle:@"Откуда"];
    [self addSubview:originLabel];
    
#pragma mark originTextField
    CGRect originTextFieldFrame = CGRectMake(leftInset,
                                             originLabelFrame.origin.y + originLabelFrame.size.height + internalMarginSize,
                                             elementWidth,
                                             elementHeight);
    UITextField *originTextField = [[UITextField alloc] initWithFrame:originTextFieldFrame];
    [self applyTextFieldStyleTo:originTextField usingPlaceholder:@"Город или название аэропорта"];
    [self addSubview:originTextField];
    
#pragma mark destinationLabel
    CGRect destinationLabelFrame = CGRectMake(leftInset,
                                              originTextFieldFrame.origin.y + originTextFieldFrame.size.height + internalMarginSize,
                                              elementWidth, elementHeight);
    UILabel *destinationLabel = [[UILabel alloc] initWithFrame:destinationLabelFrame];
    [self applyLabelStyleTo:destinationLabel usingTitle:@"Куда"];
    [self addSubview:destinationLabel];
    
#pragma mark destinationTextField
    CGRect destinationTextFieldFrame = CGRectMake(leftInset,
                                                  destinationLabelFrame.origin.y + destinationLabelFrame.size.height + internalMarginSize,
                                                  elementWidth,
                                                  elementHeight);
    UITextField *destinationTextField = [[UITextField alloc] initWithFrame:destinationTextFieldFrame];
    [self applyTextFieldStyleTo:destinationTextField usingPlaceholder:@"Город или название аэропорта"];
    [self addSubview:destinationTextField];
    
#pragma mark PERSON COUNT
    
#pragma mark adultsCountLabel
    CGRect adultsCountLabelFrame = CGRectMake(leftInset,
                                              destinationTextFieldFrame.origin.y + destinationTextFieldFrame.size.height + 3 * internalMarginSize,
                                              halfSizeElementWidth,
                                              elementHeight);
    UILabel *adultsCountLabel = [[UILabel alloc] initWithFrame:adultsCountLabelFrame];
    [self applyLabelStyleTo:adultsCountLabel usingTitle:@"Количество взрослых"];
    [self addSubview:adultsCountLabel];
    
#pragma mark childrenCountLabel
    CGRect childrenCountLabelFrame = CGRectMake(leftInset + halfSizeElementWidth + internalMarginSize,
                                                destinationTextFieldFrame.origin.y + destinationTextFieldFrame.size.height + 3 * internalMarginSize,
                                                halfSizeElementWidth,
                                                elementHeight);
    UILabel *childrenCountLabel = [[UILabel alloc] initWithFrame:childrenCountLabelFrame];
    [self applyLabelStyleTo:childrenCountLabel usingTitle:@"Количество детей"];
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
    UILabel *adultsLabel = [[UILabel alloc] initWithFrame:adultsLabelFrame];
    [self applyLabelStyleTo:adultsLabel usingTitle:@"0"];
    [self addSubview:adultsLabel];
    
#pragma mark childrenLabel
    CGRect childrenLabelFrame = CGRectMake(leftInset + halfSizeElementWidth + internalMarginSize,
                                           adultsCountLabelFrame.origin.y + adultsCountLabelFrame.size.height + internalMarginSize,
                                           halfSizeElementWidth / 2  - internalMarginSize / 2,
                                           elementHeight);
    UILabel *childrenLabel = [[UILabel alloc] initWithFrame:childrenLabelFrame];
    [self applyLabelStyleTo:childrenLabel usingTitle:@"0"];
    [self addSubview:childrenLabel];
    
#pragma mark TRANSFER COUNT
    
#pragma mark transfersCountLabel
    CGRect tansfersCountLabelFrame = CGRectMake(leftInset,
                                                adultsLabelFrame.origin.y + adultsLabelFrame.size.height + 3 * internalMarginSize,
                                                elementWidth * 2/3,
                                                elementHeight);
    UILabel *tansfersCountLabel = [[UILabel alloc]initWithFrame:tansfersCountLabelFrame];
    [self applyLabelStyleTo:tansfersCountLabel usingTitle:@"Количество пересадок:    0"];
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

-(void)applyLabelStyleTo: (UILabel*)label usingTitle:(NSString* __nullable)title {
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = UIColor.blackColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
}

-(void)applyTextFieldStyleTo: (UITextField*)textField usingPlaceholder:(NSString* __nullable)placeholder {
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.font = [UIFont systemFontOfSize:14];
    textField.placeholder = placeholder;
}

@end
