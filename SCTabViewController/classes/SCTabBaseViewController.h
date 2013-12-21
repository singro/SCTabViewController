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


// Optional Setters
@property (nonatomic)                  CGFloat  topViewHeight;     // 230.0f for default
@property (nonatomic)                  CGFloat  tabBarHeight;      // 36.0f for default
@property (nonatomic)                  UIImage *topBackgroundImage;   // White background for default
@property (nonatomic, assign)          CGFloat  topBackgroundImageOffset;  // 0.0f for default
@property (nonatomic, assign)          BOOL     needBlur;          // no blur for default


// Getters
@property (nonatomic, readonly) UIView         *topView;
@property (nonatomic, readonly) NSMutableArray *tabViewArray;       // UIView
@property (nonatomic, readonly) NSMutableArray *addedTopViewArray;  // UIView

// Costomize setters
//@property (nonatomic) UIColor                  *tabBarButtonBackgroundColorNormal;
//@property (nonatomic) UIColor                  *tabBarButtonBackgroundColorHeighlighted;
@property (nonatomic) UIColor                  *tabBarButtonBorderColor;
//@property (nonatomic) UIColor                  *tabBarTextColorNormal;
//@property (nonatomic) UIColor                  *tabBarTextColorHeighlighted;
@property (nonatomic) UIFont                   *tabBarTextFont;
@property (nonatomic) UIColor                  *tabBarSectionLineColor;

- (void)addViewToTop:(UIView *)view frame:(CGRect)frame;

@end
