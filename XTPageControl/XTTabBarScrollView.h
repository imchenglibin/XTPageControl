//
//  XTTabBarScrollView.h
//  XTPageControl
//
//  Created by imchenglibin on 16/1/26.
//  Copyright © 2016年 xt. All rights reserved.
//  https://github.com/imchenglibin/XTPageControl
//

#import <UIKit/UIKit.h>
#import "XTTabBarStyle.h"

@protocol XTTabBarScrollViewDelegate <NSObject>

@optional
- (void)willChanged:(NSInteger)preIndex nextIndex:(NSInteger)nextIndex;
- (void)didChanged:(NSInteger)preIndex nextIndex:(NSInteger)nextIndex;

@end

@interface XTTabBarScrollView : UIScrollView

- (instancetype)initWithTitles:(NSArray<NSString*>*)titles andTabBarItemWidths:(NSArray<NSNumber*>*) tabBarItemWidths andStyle:(XTTabBarStyle)style;
- (void)moveToIndex:(NSInteger)index animation:(BOOL)animation;

@property (assign, nonatomic) BOOL forceLeftAligment;
@property (strong, nonatomic) UIColor *titleColorNormal;
@property (strong, nonatomic) UIColor *titleColorSelected;
@property (strong, nonatomic) UIColor *cursorColor;
@property (assign, nonatomic) BOOL isAnimationEnabled;
@property (weak, nonatomic) id<XTTabBarScrollViewDelegate> tabBarScrollViewDelegate;

@end
