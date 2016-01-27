//
//  XTPageViewController.h
//  XTPageControl
//
//  Created by admin on 16/1/26.
//  Copyright © 2016年 xt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XTTabBarStyle.h"

@protocol XTPageViewControllerDataSource <NSObject>

- (NSInteger)numberOfPages;
- (NSString*)titleOfPage:(NSInteger)page;
- (UIViewController*)constrollerOfPage:(NSInteger)page;

@end

@interface XTPageViewController : UIViewController

- (instancetype)initWithTabBarStyle:(XTTabBarStyle)style;

@property (weak, nonatomic) id<XTPageViewControllerDataSource> dataSource;

@property (strong, nonatomic) UIView *tabBarLeftItemView;
@property (strong, nonatomic) UIView *tabBarRightItemView;

@property (strong, nonatomic) UIColor *tabBarTitleColorNormal;
@property (strong, nonatomic) UIColor *tabBarTitleColorSelected;
@property (strong, nonatomic) UIColor *tabBarCursorColor;
@property (assign, nonatomic) CGFloat tabBarHeight;
@property (strong, nonatomic) UIColor *tabBarBackgroundColor;
@property (assign, nonatomic) BOOL forceLeftAligment;

@end
