//
// Created by Xan Kraegor on 19.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "ProgressView.h"


@implementation ProgressView {
    BOOL isActive;
}

+ (instancetype)sharedInstance {
    static ProgressView *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ProgressView alloc] initWithFrame:UIApplication.sharedApplication.keyWindow.bounds];
        [instance setup];
    });
    return instance;
}

- (void)setup {
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    backgroundImageView.clipsToBounds = YES;
    backgroundImageView.image = [UIImage imageNamed:@"clouds"];
    [self addSubview:backgroundImageView];
    [self createPlanes];
}

- (void)createPlanes {
    for (int i = 1; i < 6; i++) {
        UIImageView *plane = [[UIImageView alloc] initWithFrame:CGRectMake(-100.0, ((float) i * 100.0) +
                                                                           50.0, 100.0, 100.0)];
        plane.tag = i;
        plane.contentMode = UIViewContentModeScaleAspectFit;
        plane.image = [UIImage imageNamed:@"plane"];
        [self addSubview:plane];
    }
}

- (void)startAnimating:(NSInteger)planeId {
    if (!isActive) return;
    if (planeId >= 6) planeId = 1;
    UIImageView *plane = [self viewWithTag:planeId];
    if (plane) {
        [UIView animateWithDuration:1.0 animations:^{
            plane.frame = CGRectMake(self.bounds.size.width, plane.frame.origin.y, 100.0, 100.0);
        }                completion:^(BOOL finished) {
            plane.frame = CGRectMake(-100.0, plane.frame.origin.y, 100.0, 100.0);
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.3 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [self startAnimating:planeId + 1];
                       });
    }
}

- (void)show:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.alpha = 0.0;
        isActive = YES;
        [self startAnimating:1];
        [UIApplication.sharedApplication.keyWindow addSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1.0;
        } completion:^(BOOL finished) {
            completion();
        }];
    });
}

- (void)dismiss:(void (^)(void))completion {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            isActive = NO;
            if (completion) completion();
        }];
    });
}

@end
