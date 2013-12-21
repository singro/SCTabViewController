//
//  SCDemoViewController.m
//  SCTabViewController
//
//  Created by Singro on 12/20/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import "SCDemoViewController.h"

#import <BlocksKit+UIKit.h>

#import "SCDemoTopView.h"

@interface SCDemoViewController ()

@end

@implementation SCDemoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabClassNameArray = @[@"SCDemoTabOneView", @"SCDemoTabTwoView", @"SCDemoTabThreeView"];
        self.tabTitles = @[@"One", @"Two", @"Three"];
        self.topClassName = @"SCDemoTopView";
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    SCDemoTopView *topView = (SCDemoTopView *)self.topView;
    topView.descriptionText = @"This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.";
    topView.expend = NO;

    UIButton *testButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [testButton setTitle:@"Demo" forState:UIControlStateNormal];
    testButton.backgroundColor = [UIColor colorWithRed:0.215 green:0.702 blue:1.000 alpha:1.000];
    [testButton bk_whenTapped:^{
        if (topView.expend) {
            self.topViewHeight = 230.0f;
        } else {
            self.topViewHeight = 300.0f;
        }
        topView.expend = !topView.expend;
    }];
    [self addViewToTop:testButton frame:CGRectMake(50, 100, 60, 30)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
