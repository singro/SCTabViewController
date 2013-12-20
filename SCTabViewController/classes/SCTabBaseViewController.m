//
//  SCTabBaseViewController.m
//  SCTabViewController
//
//  Created by Singro on 12/20/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import "SCTabBaseViewController.h"

#import "SCTabBaseView.h"

@interface SCTabBaseViewController () <SCTabBaseViewDelegate>

@end

@implementation SCTabBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - SCTabBaseViewDelegate

- (void)SCScrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)SCScrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)SCScrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}

- (void)SCScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}


@end
