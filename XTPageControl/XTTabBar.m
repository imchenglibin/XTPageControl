//
//  XTTabBar.m
//  XTPageControl
//
//  Created by imchenglibin on 16/1/26.
//  Copyright © 2016年 xt. All rights reserved.
//  https://github.com/imchenglibin/XTPageControl
//

#import "XTTabBar.h"

@interface XTTabBar()

@property (strong, nonatomic) XTTabBarScrollView *tabBarScrollView;
@property (assign, nonatomic) XTTabBarStyle tabBarStyle;
@property (strong, nonatomic) NSArray<NSString*> *titles;
@property (strong, nonatomic) NSArray<NSNumber*> *tabBarItemWidths;

@end

@implementation XTTabBar

- (instancetype)initWithTitles:(NSArray<NSString*>*)titles andTabBarItemWidths:(NSArray<NSNumber*>*) tabBarItemWidths andStyle:(XTTabBarStyle)style {
    if (self = [super init]) {
        _tabBarStyle = style;
        _titles = titles;
        _tabBarItemWidths = tabBarItemWidths;
        [self setup];
    }
    return self;
}

- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    self.tabBarScrollView = [[XTTabBarScrollView alloc] initWithTitles:self.titles andTabBarItemWidths:self.tabBarItemWidths andStyle:self.tabBarStyle];
    [self addSubview:self.tabBarScrollView];
}

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation {
   [self.tabBarScrollView moveToIndex:index animation:animation];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat left = 0;
    if (self.leftItemView) {
        self.leftItemView.frame = CGRectMake(left, 0, self.leftItemView.bounds.size.width, self.bounds.size.height);
        left += self.leftItemView.bounds.size.width;
    }
    if (self.rightItemView) {
        self.rightItemView.frame = CGRectMake(self.bounds.size.width - self.rightItemView.bounds.size.width, 0, self.rightItemView.bounds.size.width, self.bounds.size.height);
        self.tabBarScrollView.frame = CGRectMake(left, 0, self.bounds.size.width - self.rightItemView.bounds.size.width - left, self.bounds.size.height);
    } else {
        self.tabBarScrollView.frame = CGRectMake(left, 0, self.bounds.size.width - left, self.bounds.size.height);
    }
}

- (void)setLeftItemView:(UIView *)leftItemView {
    if (_leftItemView) {
        [_leftItemView removeFromSuperview];
    }
    _leftItemView = leftItemView;
    [self addSubview:_leftItemView];
}

- (void)setRightItemView:(UIView *)rightItemView {
    if (_rightItemView) {
        [_rightItemView removeFromSuperview];
    }
    _rightItemView = rightItemView;
    [self addSubview:_rightItemView];
}

- (void)setTitleColorNormal:(UIColor *)titleColorNormal {
    self.tabBarScrollView.titleColorNormal = titleColorNormal;
}

- (void)setTitleColorSelected:(UIColor *)titleColorSelected {
    self.tabBarScrollView.titleColorSelected = titleColorSelected;
}

- (void)setCursorColor:(UIColor *)cursorColor {
    self.tabBarScrollView.cursorColor = cursorColor;
}

- (void)setTabBarDelegate:(id<XTTabBarScrollViewDelegate>)tabBarDelegate {
    self.tabBarScrollView.tabBarScrollViewDelegate = tabBarDelegate;
}

- (id<XTTabBarScrollViewDelegate>)tabBarDelegate {
    return self.tabBarScrollView.tabBarScrollViewDelegate;
}

- (void)setForceLeftAligment:(BOOL)forceLeftAligment {
    self.tabBarScrollView.forceLeftAligment = forceLeftAligment;
}

- (BOOL)forceLeftAligment {
    return self.tabBarScrollView.forceLeftAligment;
}

@end
