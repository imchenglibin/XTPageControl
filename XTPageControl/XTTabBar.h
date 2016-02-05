//
//  XTTabBar.h
//  XTPageControl
//
//  Created by imchenglibin on 16/1/26.
//  Copyright © 2016年 xt. All rights reserved.
//  https://github.com/imchenglibin/XTPageControl
//

#import <UIKit/UIKit.h>
#import "XTTabBarStyle.h"
#import "XTTabBarScrollView.h"

@interface XTTabBar : UIView

- (instancetype)initWithTitles:(NSArray<NSString*>*)titles andTabBarItemWidths:(NSArray<NSNumber*>*) tabBarItemWidths andStyle:(XTTabBarStyle)style;
- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation;

@property (strong, nonatomic) UIView *leftItemView;
@property (strong, nonatomic) UIView *rightItemView;

@property (strong, nonatomic) UIColor *titleColorNormal;
@property (strong, nonatomic) UIColor *titleColorSelected;
@property (strong, nonatomic) UIColor *cursorColor;
@property (assign, nonatomic) BOOL forceLeftAligment;
@property (weak, nonatomic) id<XTTabBarScrollViewDelegate> tabBarDelegate;

@end
