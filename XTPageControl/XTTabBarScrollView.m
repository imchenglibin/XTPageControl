//
//  XTTabBarScrollView.m
//  XTPageControl
//
//  Created by imchenglibin on 16/1/26.
//  Copyright © 2016年 xt. All rights reserved.
//  https://github.com/imchenglibin/XTPageControl
//

#import "XTTabBarScrollView.h"

#define kXTTabBarTitleColorNormal [UIColor darkGrayColor]
#define kXTTabBarTitleColorSelected [UIColor darkGrayColor]
#define kXTTabBarCursorColor [UIColor colorWithRed:3.0 / 255.0 green:152.0 / 255.0 blue:250.0 / 255 alpha:1.0]

@interface XTTabBarScrollView()

@property (strong, nonatomic) NSArray<NSString*> *titles;
@property (strong, nonatomic) NSArray<NSNumber*> *tabBarItemWidths;
@property (assign, nonatomic) XTTabBarStyle tabBarStyle;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (strong, nonatomic) UIView *cursorView;
@property (assign, nonatomic) NSInteger currentIndex;
@property (assign, nonatomic) BOOL isAnimation;

@end

@implementation XTTabBarScrollView

static CGFloat kXTTabBarItemMargin = 10;
static CGFloat kXTTabBarItemFontSize = 14;
static NSInteger kXTTabBarInvalidIndex = -1;

- (instancetype)initWithTitles:(NSArray<NSString*>*)titles andTabBarItemWidths:(NSArray<NSNumber*>*) tabBarItemWidths andStyle:(XTTabBarStyle)style {
    if (self = [super init]) {
        _tabBarStyle = style;
        _titles = titles;
        _tabBarItemWidths = tabBarItemWidths;
        _titleColorNormal = kXTTabBarTitleColorNormal;
        _titleColorSelected = kXTTabBarTitleColorSelected;
        _cursorColor = kXTTabBarCursorColor;
        _isAnimationEnabled = YES;
        _currentIndex = kXTTabBarInvalidIndex;
        [self setup];
    }
    return self;
}

- (void)setup {
    
    self.frame = CGRectMake(0, 0, 0, kXTTabBarItemMargin);
    
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
    NSMutableArray<NSNumber*> *buttonWidths = [NSMutableArray array];
    self.buttons = [NSMutableArray array];
    for (NSInteger i=0; i<self.titles.count; i++) {
        NSString *title = [self.titles objectAtIndex:i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitleColor:self.titleColorNormal forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:kXTTabBarItemFontSize];
        button.backgroundColor = [UIColor clearColor];
        [button sizeToFit];
        [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [self.buttons addObject:button];
        [buttonWidths addObject:[NSNumber numberWithFloat:button.bounds.size.width + kXTTabBarItemMargin * 2]];
    }
    
    if (!self.tabBarItemWidths || self.tabBarItemWidths.count == 0) {
        self.tabBarItemWidths = buttonWidths;
    }
    
    self.cursorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, kXTTabBarItemMargin)];
    [self insertSubview:self.cursorView atIndex:0];
    
    if (self.tabBarStyle == XTTabBarStyleCursorUnderline) {
        [self createCursorUnderline];
    } else if (self.tabBarStyle == XTTabBarStyleCursorSolid) {
        [self createCursorSolidOrHollow:YES];
    } else if (self.tabBarStyle == XTTabBarStyleCursorHollow) {
        [self createCursorSolidOrHollow:NO];
    }
}

- (void)createCursorUnderline {
    UIView *underline = [[UIView alloc] init];
    underline.backgroundColor = self.cursorColor;
    [self.cursorView addSubview:underline];
    
    underline.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[underline]-0-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(underline)];
    
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[underline(2)]-0-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(underline)];
    
    [self.cursorView addConstraints:hConstraints];
    [self.cursorView addConstraints:vConstraints];
}

- (void)createCursorSolidOrHollow:(BOOL)isSolid {
    UIView *view = [[UIView alloc] init];
    
    [self.cursorView addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    view.clipsToBounds = YES;
    view.layer.borderColor = self.cursorColor.CGColor;
    view.layer.borderWidth = 1;
    
    if (isSolid) {
        view.backgroundColor = self.cursorColor;
    } else {
        view.backgroundColor = [UIColor clearColor];
    }
    
    NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[view]-0-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(view)];
    
    
    
    NSString *visualFormat = [NSString stringWithFormat:@"V:|-%.0f-[view]-%.0f-|", kXTTabBarItemMargin / 2, kXTTabBarItemMargin / 2];
    
    NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                    options:0
                                                                    metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(view)];
    
    [self.cursorView addConstraints:hConstraints];
    [self.cursorView addConstraints:vConstraints];
    
}

- (void)buttonEvent:(UIButton*)sender {
    [self moveToIndex:sender.tag animation:YES];
}

- (void)setTitleColorNormal:(UIColor *)titleColorNormal {
    _titleColorNormal = titleColorNormal;
    
    for (NSInteger i=0; i<self.buttons.count; i++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        if (self.currentIndex == i) {
            [button setTitleColor:self.titleColorSelected forState:UIControlStateNormal];
        } else {
            [button setTitleColor:titleColorNormal forState:UIControlStateNormal];
        }
    }
}

- (void)setTitleColorSelected:(UIColor *)titleColorSelected {
    _titleColorSelected = titleColorSelected;
    
    for (NSInteger i=0; i<self.buttons.count; i++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        if (self.currentIndex == i) {
            [button setTitleColor:titleColorSelected forState:UIControlStateNormal];
        } else {
            [button setTitleColor:self.titleColorNormal forState:UIControlStateNormal];
        }
    }
}

- (void)setCursorColor:(UIColor *)cursorColor {
    _cursorColor = cursorColor;
    
    if (self.tabBarStyle == XTTabBarStyleCursorUnderline) {
        UIView *view = [self.cursorView.subviews firstObject];
        view.backgroundColor = cursorColor;
    } else {
        UIView *view = [self.cursorView.subviews firstObject];
        view.layer.borderColor = cursorColor.CGColor;
        if (self.tabBarStyle == XTTabBarStyleCursorSolid) {
            view.backgroundColor = cursorColor;
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat left = 0;
    for (int i=0; i<self.buttons.count; i++) {
        UIButton *button = [self.buttons objectAtIndex:i];
        CGFloat width = [self tabBarWidth:i];
        button.frame = CGRectMake(left, 0, width, self.bounds.size.height);
        left += width;
    }
    [self setContentSize:CGSizeMake(left, self.bounds.size.height)];
    
    if (!self.isAnimation && self.currentIndex != kXTTabBarInvalidIndex) {
        UIButton *button = [self.buttons objectAtIndex:self.currentIndex];
        CGFloat width = [self tabBarCursorWidth:self.currentIndex];
        self.cursorView.frame = CGRectMake(button.center.x -  width / 2, 0, width, self.bounds.size.height);
    }
    
    if (self.tabBarStyle == XTTabBarStyleCursorSolid || self.tabBarStyle == XTTabBarStyleCursorHollow) {
        UIView *view = [self.cursorView.subviews firstObject];
        view.layer.cornerRadius = (self.bounds.size.height - kXTTabBarItemMargin) / 2;
    }
}

- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation{
    if (index == self.currentIndex || self.isAnimation || index < 0 || index >= self.buttons.count) {
        return;
    }
    NSInteger preIndex = self.currentIndex;
    if (preIndex != kXTTabBarInvalidIndex) {
        UIButton *preButton = [self.buttons objectAtIndex:preIndex];
        [preButton setTitleColor:self.titleColorNormal forState:UIControlStateNormal];
    }
    
    UIButton *nextButton = [self.buttons objectAtIndex:index];
    
    self.isAnimation = YES;
    
    if (self.tabBarScrollViewDelegate) {
        if ([self.tabBarScrollViewDelegate respondsToSelector:@selector(willChanged:nextIndex:)]) {
            [self.tabBarScrollViewDelegate willChanged:preIndex nextIndex:index];
        }
    }
    
    if (animation && self.isAnimationEnabled && preIndex != kXTTabBarInvalidIndex) {
        [UIView animateWithDuration:0.35 animations:^{
            CGFloat width = [self tabBarCursorWidth:index];
            self.cursorView.frame = CGRectMake(nextButton.center.x - width / 2 , 0, width, self.bounds.size.height);
        } completion:^(BOOL finished) {
            self.isAnimation = NO;
            self.currentIndex = index;
            [nextButton setTitleColor:self.titleColorSelected forState:UIControlStateNormal];
            if (self.tabBarScrollViewDelegate) {
                if ([self.tabBarScrollViewDelegate respondsToSelector:@selector(didChanged:nextIndex:)]) {
                    [self.tabBarScrollViewDelegate didChanged:preIndex nextIndex:index];
                }
            }
        }];
    } else {
        CGFloat width = [self tabBarCursorWidth:index];
        self.cursorView.frame = CGRectMake(nextButton.center.x - width / 2 , 0, width, self.bounds.size.height);
        self.isAnimation = NO;
        self.currentIndex = index;
        [nextButton setTitleColor:self.titleColorSelected forState:UIControlStateNormal];
        if (self.tabBarScrollViewDelegate) {
            if ([self.tabBarScrollViewDelegate respondsToSelector:@selector(didChanged:nextIndex:)]) {
                [self.tabBarScrollViewDelegate didChanged:preIndex nextIndex:index];
            }
        }
    }
    
    //adjust content offset
    if (self.contentSize.width > self.bounds.size.width) {
        if (nextButton.center.x + self.bounds.size.width / 2 > self.contentSize.width) {
            [self setContentOffset:CGPointMake(self.contentSize.width - self.bounds.size.width, self.contentOffset.y) animated:YES];
        } else if (nextButton.center.x - self.bounds.size.width / 2 < 0) {
            [self setContentOffset:CGPointMake(0 , self.contentOffset.y) animated:YES];
        } else {
            [self setContentOffset:CGPointMake(nextButton.center.x - self.bounds.size.width / 2, self.contentOffset.y) animated:YES];
        }
    }
}

- (CGFloat)tabBarWidth:(NSInteger)index {
    if (!self.forceLeftAligment) {
        CGFloat maxWidth = 0;
        for (NSInteger i=0; i<self.tabBarItemWidths.count; i++) {
            if (maxWidth < [[self.tabBarItemWidths objectAtIndex:i] floatValue]) {
                maxWidth = [[self.tabBarItemWidths objectAtIndex:i] floatValue];
            }
        }
        if (maxWidth * self.buttons.count < self.bounds.size.width) {
            return self.bounds.size.width / self.buttons.count;
        } else {
            return [[self.tabBarItemWidths objectAtIndex:index] floatValue];
        }
    } else {
        return [[self.tabBarItemWidths objectAtIndex:index] floatValue];
    }
}

- (CGFloat)tabBarCursorWidth:(NSInteger)index {
    return [[self.tabBarItemWidths objectAtIndex:index] floatValue];
}

@end
