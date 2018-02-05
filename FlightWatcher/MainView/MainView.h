//
//  MainView.h
//  FlightWatcher
//
//  Created by Xan Kraegor on 31.01.2018.
//  Copyright © 2018 Xan Kraegor. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UILabel+Style.h"
#import "UIButton+Style.h"
#import "UIView+GetController.h"

@interface MainView : UIView


- (id)initWithFrame:(CGRect)frame;
- (void)activateButtons;
- (void)setTitle:(NSString*)title forOriginButton:(BOOL)isOrigin;
@end
