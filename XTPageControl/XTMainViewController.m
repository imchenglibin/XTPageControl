//
//  XTMainViewController.m
//  XTPageControl
//
//  Created by admin on 16/1/27.
//  Copyright © 2016年 xt. All rights reserved.
//

#import "XTMainViewController.h"
#import "XTPageViewController.h"
#import "XTSubPageViewController.h"

@interface XTMainViewController() <XTPageViewControllerDataSource> {
    NSInteger _numberOfPages;
}

@end

@implementation XTMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _numberOfPages = 3;
    
    self.title = @"XTPageControl";
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *titles = @[@"XTPageControl Cursor Underline Style",
                        @"XTPageControl Cursor Solid Style",
                        @"XTPageControl Cursor Hollow Style",
                        @"XTPageControl TabBar Item Left Aligment",
                        @"XTPageControl TabBar Other Properties",
                        @"XTPageControl TabBar With Left Item",
                        @"XTPageControl TabBar With Right Item",
                        @"XTPageControl TabBar Left And Right Item"];
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
        {
            _numberOfPages = 2;
            XTPageViewController *pageViewController = [[XTPageViewController alloc] initWithTabBarStyle:XTTabBarStyleCursorUnderline];
            pageViewController.dataSource = self;
            [self.navigationController pushViewController:pageViewController animated:YES];
        }
            break;
        case 1:
        {
            _numberOfPages = 5;
            XTPageViewController *pageViewController = [[XTPageViewController alloc] initWithTabBarStyle:XTTabBarStyleCursorSolid];
            pageViewController.dataSource = self;
            [self.navigationController pushViewController:pageViewController animated:YES];
        }
            break;
        case 2:
        {
            _numberOfPages = 10;
            XTPageViewController *pageViewController = [[XTPageViewController alloc] initWithTabBarStyle:XTTabBarStyleCursorHollow];
            pageViewController.dataSource = self;
            [self.navigationController pushViewController:pageViewController animated:YES];
        }
            break;
        case 3:
        {
            _numberOfPages = 2;
            XTPageViewController *pageViewController = [[XTPageViewController alloc] initWithTabBarStyle:XTTabBarStyleCursorUnderline];
            pageViewController.dataSource = self;
            pageViewController.forceLeftAligment = YES;
            [self.navigationController pushViewController:pageViewController animated:YES];
        }
            break;
        case 4:
        {
            _numberOfPages = 3;
            XTPageViewController *pageViewController = [[XTPageViewController alloc] initWithTabBarStyle:XTTabBarStyleCursorSolid];
            pageViewController.dataSource = self;
            pageViewController.tabBarBackgroundColor = [UIColor groupTableViewBackgroundColor];
            pageViewController.tabBarTitleColorNormal = [UIColor blueColor];
            pageViewController.tabBarTitleColorSelected = [UIColor redColor];
            pageViewController.tabBarCursorColor = [UIColor greenColor];
            [self.navigationController pushViewController:pageViewController animated:YES];
        }
            break;
        case 5:
        {
            _numberOfPages = 2;
            XTPageViewController *pageViewController = [[XTPageViewController alloc] initWithTabBarStyle:XTTabBarStyleCursorUnderline];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
            imageView.frame = CGRectMake(0, 0, 50, 0);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            pageViewController.tabBarLeftItemView = imageView;
            pageViewController.dataSource = self;
            [self.navigationController pushViewController:pageViewController animated:YES];
        }
            break;
        case 6:
        {
            _numberOfPages = 2;
            XTPageViewController *pageViewController = [[XTPageViewController alloc] initWithTabBarStyle:XTTabBarStyleCursorUnderline];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
            imageView.frame = CGRectMake(0, 0, 50, 0);
            imageView.contentMode = UIViewContentModeScaleAspectFit;
            imageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            pageViewController.tabBarRightItemView = imageView;
            pageViewController.dataSource = self;
            [self.navigationController pushViewController:pageViewController animated:YES];
        }
            break;
        
        case 7:
        {
            _numberOfPages = 2;
            XTPageViewController *pageViewController = [[XTPageViewController alloc] initWithTabBarStyle:XTTabBarStyleCursorHollow];
            UIImageView *leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
            leftImageView.frame = CGRectMake(0, 0, 50, 0);
            leftImageView.contentMode = UIViewContentModeScaleAspectFit;
            leftImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            pageViewController.tabBarLeftItemView = leftImageView;
            
            
            UIImageView *rightImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Logo"]];
            rightImageView.frame = CGRectMake(0, 0, 50, 0);
            rightImageView.contentMode = UIViewContentModeScaleAspectFit;
            rightImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
            pageViewController.tabBarRightItemView = rightImageView;
            
            pageViewController.dataSource = self;
            [self.navigationController pushViewController:pageViewController animated:YES];
        }
            break;
        default:
            break;
    }
}

- (NSInteger)numberOfPages {
    return _numberOfPages;
}

- (NSString*)titleOfPage:(NSInteger)page {
    return [NSString stringWithFormat:@"标题%ld", (long)page];
}

- (UIViewController*)constrollerOfPage:(NSInteger)page {
    XTSubPageViewController *controller = [[XTSubPageViewController alloc] init];
    return controller;
}

@end
