//
//  SCAppDelegate.h
//  SCTabViewController
//
//  Created by Singro on 12/20/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) UIViewController *mainViewController;
@property (nonatomic, strong) UINavigationController *naviViewController;
@property (nonatomic, strong) UINavigationController *naviTableViewController;

@end
