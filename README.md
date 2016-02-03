# XTPageControl
An easy solution to page controllers

## Overview
<img height=500 src="https://github.com/imchenglibin/XTPageControl/blob/master/Images/usage_0.png">
<img height=500 src="https://github.com/imchenglibin/XTPageControl/blob/master/Images/usage_1.png">
<img height=500 src="https://github.com/imchenglibin/XTPageControl/blob/master/Images/usage_2.png">
<img height=500 src="https://github.com/imchenglibin/XTPageControl/blob/master/Images/usage_3.png">
<img height=500 src="https://github.com/imchenglibin/XTPageControl/blob/master/Images/usage_4.png">
<img height=500 src="https://github.com/imchenglibin/XTPageControl/blob/master/Images/usage_5.png">
<img height=500 src="https://github.com/imchenglibin/XTPageControl/blob/master/Images/usage_6.png">
<img height=500 src="https://github.com/imchenglibin/XTPageControl/blob/master/Images/usage_7.png">
<img height=500 src="https://github.com/imchenglibin/XTPageControl/blob/master/Images/usage_8.png">

## Usage
Drag the folder to your project.<br>
<img height=200 src="https://github.com/imchenglibin/XTPageControl/blob/master/Images/Folder.png">

```objective-c
#import "XTPageViewController.h"
```

Create a controller of XTPageViewController: <br>
```objective-c
- (instancetype)initWithTabBarStyle:(XTTabBarStyle)style;
```
you can easily change the style by setting different style, currently there are three styles:<br>
```objective-c
typedef NS_ENUM(NSInteger, XTTabBarStyle) {
    XTTabBarStyleCursorUnderline = 0,
    XTTabBarStyleCursorSolid = 1,
    XTTabBarStyleCursorHollow = 2
};
```
Then you have to implements the data source delegate to customize the pages and tabBar items:<br>
```objective-c
@protocol XTPageViewControllerDataSource <NSObject>

//the number of pages
- (NSInteger)numberOfPages;

//the title for the page
- (NSString*)titleOfPage:(NSInteger)page;

//the controller for the page
- (UIViewController*)constrollerOfPage:(NSInteger)page;

@end
```
If you want to customize the tabbar item width you should implement XTPageViewControllerDelegate
```objective-c
@protocol XTPageViewControllerDelegate <NSObject>

//the custom width of tab bar item for page
- (CGFloat)widthOfTabBarItemForPage:(NSInteger)page;

@end
```

For more detail usage of the XTPageViewController refer to the demo in this project.

## Pod Support
pod 'XTPageControl', :git => 'https://github.com/imchenglibin/XTPageControl.git'

## License
This project use `MIT` license, for more details refer to `LICENSE` file
