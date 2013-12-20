//
//  SCTabBaseView.m
//  SCTabViewController
//
//  Created by Singro on 12/20/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import "SCTabBaseView.h"

@interface SCTabBaseView ()

@end

@implementation SCTabBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SCScrollViewDidScroll:)]) {
        [self.delegate SCScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SCScrollViewWillBeginDragging:)]) {
        [self.delegate SCScrollViewWillBeginDragging:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SCScrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate SCScrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SCScrollViewWillBeginDecelerating:)]) {
        [self.delegate SCScrollViewWillBeginDecelerating:scrollView];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SCScrollViewDidEndDecelerating:)]) {
        [self.delegate SCScrollViewDidEndDecelerating:scrollView];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(SCScrollViewDidEndScrollingAnimation:)]) {
        [self.delegate SCScrollViewDidEndScrollingAnimation:scrollView];
    }
}

@end
