//
//  SCTabBaseView.h
//  SCTabViewController
//
//  Created by Singro on 12/20/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCTabBaseViewDelegate;

@interface SCTabBaseView : UIView <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *tableView;

@property (nonatomic, assign) id<SCTabBaseViewDelegate> delegate;

@end


@protocol SCTabBaseViewDelegate <NSObject>

@optional
- (void)SCScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)SCScrollViewWillBeginDragging:(UIScrollView *)scrollView;

- (void)SCScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

- (void)SCScrollViewWillBeginDecelerating:(UIScrollView *)scrollView;

- (void)SCScrollViewDidEndDecelerating:(UIScrollView *)scrollView;

- (void)SCScrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;

@end
