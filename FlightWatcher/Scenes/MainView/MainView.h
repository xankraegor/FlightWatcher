//
//  MainView.h
//  FlightWatcher
//
//  Created by Xan Kraegor on 31.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//


@interface MainView : UIView
- (id)initWithFrame:(CGRect)frame;
- (void)activateButtons;
- (void)setPlaceButtonTitle:(NSString *)title forOriginButton:(BOOL)isOrigin;

- (void)setDateButtonTitle:(NSString *)title forDepartureDateButton:(BOOL)isDeparture;
@end
