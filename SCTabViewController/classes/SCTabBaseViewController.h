//
//  SCTabBaseViewController.h
//  SCTabViewController
//
//  Created by Singro on 12/20/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCTabBaseViewController : UIViewController

// Required Setters
@property (nonatomic, copy)           NSString *topClassName;
@property (nonatomic, copy)            NSArray *tabClassNameArray;
@property (nonatomic, copy)            NSArray *tabTitles;    // count 1 for no tab

// Network
@property (nonatomic, strong) NSURLSessionTask *task;
@property (nonatomic, strong) void (^refreshBlock)();

// Optional Setters
@property (nonatomic)                  CGFloat  topViewHeight;     // 230.0f for default
@property (nonatomic)                  CGFloat  tabBarHeight;      // 36.0f for default
@property (nonatomic)                  UIImage *topBackgroundImage;   // White background for default
@property (nonatomic, assign)          CGFloat  topBackgroundImageOffset;  // 0.0f for default
@property (nonatomic, assign)          BOOL     needBlur;          // no blur for default

// NavigationBar Item
@property (nonatomic, strong) void (^actionBarItemBlock)();
@property (nonatomic, strong) UIBarButtonItem  *actionBarItem;
@property (nonatomic, strong) UIBarButtonItem  *backBarItem;

// TabBar
@property (nonatomic, assign) NSInteger         currentIndex;

// Getters
@property (nonatomic, readonly) UIView         *topView;
@property (nonatomic, readonly) NSMutableArray *tabViewArray;       // UIView
@property (nonatomic, readonly) NSMutableArray *addedTopViewArray;  // UIView

// Costomize setters
@property (nonatomic) UIColor                  *tabBarButtonBorderColor;
@property (nonatomic) UIFont                   *tabBarTextFont;
@property (nonatomic) UIColor                  *tabBarSectionLineColor;

- (void)addViewToTop:(UIView *)view frame:(CGRect)frame;
- (void)resetView:(UIView *)view withFrame:(CGRect)frame;

- (void)beginRefreshing;
- (void)endRefreshing;

- (UIBarButtonItem *)createBackBarItem;
- (UIBarButtonItem *)createActionBarItem;

@end
