//
//  XTPageViewController.m
//  XTPageControl
//
//  Created by admin on 16/1/26.
//  Copyright © 2016年 xt. All rights reserved.
//

#import "XTPageViewController.h"
#import "XTTabBar.h"

@interface XTPageViewController() <XTTabBarScrollViewDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *pageScrollView;
@property (strong, nonatomic) UIView *underlineView;
@property (strong, nonatomic) XTTabBar *tabBar;
@property (strong, nonatomic) NSMutableDictionary *cachedControllers;
@property (strong, nonatomic) UIViewController *currentController;
@property (assign, nonatomic) XTTabBarStyle style;
@property (assign, nonatomic) NSInteger nextIndex;
@property (assign, nonatomic) NSInteger currentPage;
@property (assign, nonatomic) BOOL forceToShowControllerWhenFirstTime;
@property (assign, nonatomic) BOOL disableScroll;
@property (assign, nonatomic) BOOL isFromTabBarItemWillChanged;
@end

@implementation XTPageViewController

static CGFloat kXTDefaultTabBarHeight = 35;

- (instancetype)init {
    if (self = [super init]) {
        _style = XTTabBarStyleCursorUnderline;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _style = XTTabBarStyleCursorUnderline;
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _style = XTTabBarStyleCursorUnderline;
    }
    return self;
}

- (instancetype)initWithTabBarStyle:(XTTabBarStyle)style {
    if (self = [super init]) {
        _style = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup:self.style];
}

- (void)didReceiveMemoryWarning {
    [self clearCache];
}

- (void)clearCache {
    [self.cachedControllers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj != self.currentController) {
            UIViewController *controller = (UIViewController*)obj;
            [controller willMoveToParentViewController:nil];
            [controller removeFromParentViewController];
            [controller.view removeFromSuperview];
            [controller didMoveToParentViewController:nil];
        }
    }];
    [self.cachedControllers removeAllObjects];
    
    [self.cachedControllers setObject:self.currentController forKey:@(self.currentPage)];
}

- (void)setup:(XTTabBarStyle)style {
    self.view.backgroundColor = [UIColor whiteColor];
    NSAssert(self.dataSource != nil, @"XTPageViewController必须设置dataSource");
    self.nextIndex = -1;
    self.cachedControllers = [NSMutableDictionary dictionary];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.parentViewController) {
        self.parentViewController.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tabBarHeight = kXTDefaultTabBarHeight;
    NSInteger numberOfPages = [self.dataSource numberOfPages];
    NSMutableArray *titles = [NSMutableArray array];
    for (NSInteger i=0; i<numberOfPages; i++) {
        [titles addObject:[self.dataSource titleOfPage:i]];
    }
    self.tabBar = [self createTabBar:titles style:style];
    [self.view addSubview:self.tabBar];
    
    self.underlineView = [[UIView alloc] init];
    self.underlineView.backgroundColor = [UIColor colorWithWhite:.9 alpha:1.0];
    [self.view addSubview:self.underlineView];
    
    self.pageScrollView = [[UIScrollView alloc] init];
    self.pageScrollView.showsHorizontalScrollIndicator = NO;
    self.pageScrollView.showsVerticalScrollIndicator = NO;
    self.pageScrollView.bounces = NO;
    [self.pageScrollView setPagingEnabled:YES];
    self.pageScrollView.delegate = self;
    [self.view addSubview:self.pageScrollView];
    
    self.forceToShowControllerWhenFirstTime = YES;
    [self.tabBar moveToIndex:0];
}

- (XTTabBar*)createTabBar:(NSArray<NSString*>*)titles style:(XTTabBarStyle)style {
    XTTabBar* tabBar = [[XTTabBar alloc] initWithTitles:titles andStyle:style];
    tabBar.tabBarDelegate = self;
    tabBar.forceLeftAligment = self.forceLeftAligment;
    if (self.tabBarCursorColor) {
        tabBar.cursorColor = self.tabBarCursorColor;
    }
    if (self.tabBarTitleColorNormal) {
        tabBar.titleColorNormal = self.tabBarTitleColorNormal;
    }
    if (self.tabBarTitleColorSelected) {
        tabBar.titleColorSelected = self.tabBarTitleColorSelected;
    }
    if (self.tabBarLeftItemView) {
        tabBar.leftItemView = self.tabBarLeftItemView;
    }
    if (self.tabBarRightItemView) {
        tabBar.rightItemView = self.tabBarRightItemView;
    }
    if (self.tabBarBackgroundColor) {
        tabBar.backgroundColor = self.tabBarBackgroundColor;
    }
    return tabBar;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.tabBar.frame = CGRectMake(0, [self.topLayoutGuide length], self.view.bounds.size.width, self.tabBarHeight);
    
    self.underlineView.frame = CGRectMake(0, [self.topLayoutGuide length] + self.tabBarHeight, self.view.bounds.size.width, 1.0);
    
    self.pageScrollView.frame = CGRectMake(0, [self.topLayoutGuide length] + self.tabBarHeight + 1.0, self.view.bounds.size.width, self.view.bounds.size.height - self.tabBarHeight - 1.0);
    
    if (self.dataSource) {
        NSInteger numberOfPages = [self.dataSource numberOfPages];
        self.pageScrollView.contentSize = CGSizeMake(numberOfPages * self.pageScrollView.bounds.size.width, self.pageScrollView.bounds.size.height);
    }
}

#pragma mark tabbar delegate 
- (void)willChanged:(NSInteger)preIndex nextIndex:(NSInteger)nextIndex {
    if (self.forceToShowControllerWhenFirstTime) {
        self.forceToShowControllerWhenFirstTime = NO;
        self.pageScrollView.scrollEnabled = NO;
        [self showNextController:nextIndex];
    } else {
        if (!self.disableScroll) {
            self.pageScrollView.scrollEnabled = NO;
            self.nextIndex = nextIndex;
            self.isFromTabBarItemWillChanged = YES;
            [self.pageScrollView setContentOffset:CGPointMake(nextIndex * self.pageScrollView.bounds.size.width, 0) animated:YES];
        }
        self.disableScroll = NO;
    }
}

- (void)didChanged:(NSInteger)preIndex nextIndex:(NSInteger)nextIndex {
    self.pageScrollView.scrollEnabled = YES;
}

#pragma mark scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger page = (NSInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width + .5);
    if (self.nextIndex != -1) {
        [self showNextController:self.nextIndex];
        self.nextIndex = -1;
    } else {
        if (self.currentPage != page && !self.isFromTabBarItemWillChanged) {
            self.disableScroll = YES;
            [self showNextController:page];
            [self.tabBar moveToIndex:page];
        }
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.isFromTabBarItemWillChanged = NO;
}

- (void)showNextController:(NSInteger)nextPage {
    self.currentPage = nextPage;
    UIViewController *nextController = [self.cachedControllers objectForKey:@(nextPage)];
    if (nextController == nil) {
        nextController = [self.dataSource constrollerOfPage:nextPage];
        [nextController willMoveToParentViewController:self];
        [self addChildViewController:nextController];
        [self.pageScrollView addSubview:nextController.view];
        nextController.view.frame = CGRectMake(nextPage * self.pageScrollView.bounds.size.width, 0, self.pageScrollView.bounds.size.width, self.pageScrollView.bounds.size.height);
        [nextController didMoveToParentViewController:self];
        
        [self.cachedControllers setObject:nextController forKey:@(nextPage)];
    } else {
        nextController.view.frame = CGRectMake(nextPage * self.pageScrollView.bounds.size.width, 0, self.pageScrollView.bounds.size.width, self.pageScrollView.bounds.size.height);
    }
    self.currentController = nextController;
}

@end
