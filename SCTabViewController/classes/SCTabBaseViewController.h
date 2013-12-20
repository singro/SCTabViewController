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

// Getters
@property (nonatomic, readonly) UIView         *topView;
@property (nonatomic, readonly) NSArray        *viewArray;  // UIView
@property (nonatomic, readonly) NSArray        *tabArray;   // UIButton

@end
