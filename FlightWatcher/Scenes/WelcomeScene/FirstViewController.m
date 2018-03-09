//
// Created by Xan Kraegor on 19.02.2018.
// Copyright (c) 2018 Xan Kraegor. All rights reserved.
//

#import "FirstViewController.h"
#import "ContentViewController.h"

#define PAGES_COUNT 4

@interface FirstViewController ()
@property(strong, nonatomic) UIButton *nextButton;
@property(strong, nonatomic) UIPageControl *pageControl;
@end

@implementation FirstViewController {
    struct firstContentData {
        __unsafe_unretained NSString *title;
        __unsafe_unretained NSString *contentText;
        __unsafe_unretained NSString *imageName;
    } contentData[PAGES_COUNT];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self createContentDataArray];
    self.dataSource = self;
    self.delegate = self;
    ContentViewController *startViewController = [self viewControllerAtIndex:0];
    [self setViewControllers:@[startViewController]
                   direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height -
            50.0, self.view.bounds.size.width, 50.0)];
    _pageControl.numberOfPages = PAGES_COUNT;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor darkGrayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
    [self.view addSubview:_pageControl];
    _nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _nextButton.frame = CGRectMake(self.view.bounds.size.width - 100.0, self.view.bounds.size.height -
            50.0, 100.0, 50.0);
    [_nextButton addTarget:self action:@selector(nextButtonDidTap:)
          forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setTintColor:[UIColor blackColor]];
    [self updateButtonWithIndex:0];
    [self.view addSubview:_nextButton];
}

- (void)createContentDataArray {
    NSArray *titles = @[
            NSLocalizedString(@"About", @"About"),
            NSLocalizedString(@"Flight tickets", @"Flight tickets"),
            NSLocalizedString(@"Price map", @"Price map"),
            NSLocalizedString(@"Favorites", @"Favorites")];
    NSArray *contents = @[
            NSLocalizedString(@"Flight tickets search done easily", @"Flight tickets search done easily"),
            NSLocalizedString(@"Find the cheapest tickets", @"Find the cheapest tickets"),
            NSLocalizedString(@"Observe prices on the map", @"Observe prices on the map"),
            NSLocalizedString(@"Make ticket favorite to save", @"Make ticket favorite to save")];
    for (int i = 0; i < 4; ++i) {
        contentData[i].title = titles[(NSUInteger) i];
        contentData[i].contentText = contents[(NSUInteger) i];
        contentData[i].imageName = [NSString stringWithFormat:@"first_%d", i + 1];
    }
}

- (ContentViewController *)viewControllerAtIndex:(int)index {
    if (index < 0 || index >= PAGES_COUNT) return nil;
    ContentViewController *contentViewController = [[ContentViewController alloc] init];
    contentViewController.title = contentData[index].title;
    contentViewController.contentText = contentData[index].contentText;
    contentViewController.image = [UIImage imageNamed:contentData[index].imageName];
    contentViewController.index = index;
    return contentViewController;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray <UIViewController*> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        int index = ((ContentViewController *) [pageViewController.viewControllers firstObject]).index;
        _pageControl.currentPage = index;
        [self updateButtonWithIndex:index];
    }
}

- (void)updateButtonWithIndex:(int)index {
    switch (index) {
        case 0 ... 2:
            [_nextButton setTitle:NSLocalizedString(@"Next", @"Next") forState:UIControlStateNormal];
            _nextButton.tag = 0;
            break;
        case 3:
            [_nextButton setTitle:NSLocalizedString(@"Done", @"Done") forState:UIControlStateNormal];
            _nextButton.tag = 1;
            break;
        default:
            break;
    }
}

- (void)nextButtonDidTap:(UIButton *)sender {
    int index = ((ContentViewController *) [self.viewControllers firstObject]).index;
    if (sender.tag) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"first_start"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        __weak typeof(self) welf = self;
        [self setViewControllers:@[[self viewControllerAtIndex:index + 1]]
                       direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
                    welf.pageControl.currentPage = index + 1;
                    [welf updateButtonWithIndex:index + 1];
                }];
    }
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    int index = ((ContentViewController *) viewController).index;
    index--;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    int index = ((ContentViewController *) viewController).index;
    index++;
    return [self viewControllerAtIndex:index];
}
@end
