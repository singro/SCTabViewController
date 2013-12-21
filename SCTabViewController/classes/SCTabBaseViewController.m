//
//  SCTabBaseViewController.m
//  SCTabViewController
//
//  Created by Singro on 12/20/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import "SCTabBaseViewController.h"

#import <BlocksKit.h>
#import <BlocksKit+UIKit.h>
//#import "SPUIImage+Blur.h"
//#import <objc/runtime.h>

#import "SCTabBaseView.h"

#define kTablButtonTagOffset 6666

#define kTabBarTextColorNormal                     0.55f
#define kTabBarTextColorHeighlighted               0.36f
#define kTabBarButtonBackgroundColorNormal         1.00f
#define kTabBarButtonBackgroundColorHeighlighted   0.95f

#define kImageBackgroundHeight                     350.0f

#define kRefreshImageHeight                        18.0f
#define kRefreshImagePositionX                     290.0f

#define kAnimationDuration                         0.3f


static NSString * kRefreshRotationAnimation = @"RefreshRotationAnimation";
static NSString * kLoadingRotationAnimation = @"LoadingRotationAnimation";
static void * AFTaskCountOfBytesReceivedContext = &AFTaskCountOfBytesReceivedContext;


@interface SCTabBaseViewController () <SCTabBaseViewDelegate, UIScrollViewDelegate>

/* Public properties */
@property (nonatomic, strong, readwrite) UIView *topView;
@property (nonatomic, strong, readwrite) NSMutableArray *tabViewArray;
@property (nonatomic, strong, readwrite) NSMutableArray *addedTopViewArray;  // UIView

/* Private properties */
@property (nonatomic, strong) NSMutableArray  *addedTopViewFrameArray;

// Refresh View
@property (nonatomic, strong) UIImageView *refreshImageView;
@property (nonatomic, strong) UIImageView *loadingImageView;
@property (nonatomic, strong) UILabel     *refreshLabel;
@property (nonatomic, assign) BOOL isRefreshing;

// topView
@property (nonatomic, strong) UIImageView     *topBackgroundImageView;
@property (nonatomic, strong) UIView          *topBackgroundContainView;
@property (nonatomic, strong) UIView *backgroundWhiteView;

// tabBarView
@property (nonatomic, strong) UIView          *tabBarView;
@property (nonatomic, strong) UIView          *tabBarSectionLineView;
@property (nonatomic, strong) void           (^tabButtonHandleBlock)(NSInteger);
@property (nonatomic, strong) NSMutableArray  *tabBarButtonArray;
@property (nonatomic, strong) UIColor         *tabBarButtonBackgroundColorNormal;
@property (nonatomic, strong) UIColor         *tabBarButtonBackgroundColorHeighlighted;
@property (nonatomic, strong) UIColor         *tabBarTextColorNormal;
@property (nonatomic, strong) UIColor         *tabBarTextColorHeighlighted;

// tabView
@property (nonatomic, strong) UIScrollView    *scrollView;
@property (nonatomic, assign) NSInteger        currentIndex;
@property (nonatomic, assign) NSInteger        currentIndexTableHeight;
@property (nonatomic, assign) NSInteger        numberOfTabs;

// Status
@property (nonatomic, assign) BOOL isChangingContentInset;


/* Test properties */
@property (nonatomic, strong) UIBarButtonItem *actionBarItem;
@property (nonatomic, strong) UIButton        *testButton;

@end

@implementation SCTabBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabViewArray = [[NSMutableArray alloc] init];
        self.tabBarButtonArray = [[NSMutableArray alloc] init];
        self.addedTopViewArray = [[NSMutableArray alloc] init];
        self.addedTopViewFrameArray = [[NSMutableArray alloc] init];
        
        self.topViewHeight = 230.0f;
        self.tabBarHeight = 36.0f;
        self.topBackgroundImageOffset = 0.0f;
        
        // tabs
        self.tabBarButtonBackgroundColorNormal = [UIColor colorWithWhite:kTabBarButtonBackgroundColorNormal alpha:1.0f];
        self.tabBarButtonBackgroundColorHeighlighted = [UIColor colorWithWhite:kTabBarButtonBackgroundColorHeighlighted alpha:1.000];
        self.tabBarButtonBorderColor = [UIColor colorWithWhite:0.852 alpha:1.000];
        self.tabBarTextColorNormal = [UIColor colorWithWhite:kTabBarTextColorNormal alpha:1.000];
        self.tabBarTextColorHeighlighted = [UIColor colorWithWhite:kTabBarTextColorHeighlighted alpha:1.000];
        self.tabBarSectionLineColor = [UIColor colorWithRed:1.000 green:0.336 blue:0.162 alpha:1.000];
        self.tabBarTextFont = [UIFont systemFontOfSize:13.0f];
        
        self.needBlur = NO;
        
        
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    if (self.tabClassNameArray) {
        if ((self.tabTitles.count > 1) &&(self.tabTitles.count != self.tabClassNameArray.count)) {
            NSLog(@"Properties are invalid.");
            return;
        }
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = YES;
        
        self.numberOfTabs = self.tabClassNameArray.count;
        self.currentIndex = 0;
        self.currentIndexTableHeight = 0.0f;
        self.isChangingContentInset = NO;
        self.isRefreshing = NO;
        
        [self setupTopBackgroundImageView];
        [self setupTopView];
        [self setupTabBarView];
        [self setupTabView];
        [self setupRefreshView];
        
        [self.view addSubview:self.topBackgroundContainView];
        [self.view addSubview:self.topView];
        [self.view addSubview:self.scrollView];
        [self.view addSubview:self.tabBarView];
        [self.view addSubview:self.refreshImageView];
        [self.view addSubview:self.refreshLabel];
        [self.view addSubview:self.loadingImageView];
        
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationItem.rightBarButtonItem = self.actionBarItem;
}

- (void)viewDidAppear:(BOOL)animated {
//    UIButton *tabButton = [self.tabBarButtonArray objectAtIndex:self.currentIndex];
//    tabButton.layer.timeOffset = 1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - setters
- (void)setTask:(NSURLSessionTask *)task {
    [task addObserver:self forKeyPath:@"state" options:0 context:AFTaskCountOfBytesReceivedContext];
    [task addObserver:self forKeyPath:@"countOfBytesReceived" options:0 context:AFTaskCountOfBytesReceivedContext];
}

- (void)setTopViewHeight:(CGFloat)topViewHeight  {
    CGFloat previousTopViewHeight = self.topViewHeight;
    _topViewHeight = topViewHeight;
    
    self.isChangingContentInset = YES;
    
    CGFloat topViewOffset = self.topViewHeight - previousTopViewHeight;
    
    if (self.tabViewArray.count) {
        UITableView *scrollView = [(SCTabBaseView *)self.tabViewArray[0] tableView];
        CGFloat changedOffset = -(scrollView.contentOffset.y - topViewOffset+ self.topViewHeight);
        
        // reset added views
        [self setAddedTopViewFrameWithOffset:changedOffset];
        
        // set background ImageView
        [UIView animateWithDuration:0.3f animations:^{
            if (changedOffset >= 0) {
                self.topBackgroundContainView.frame = (CGRect){0, self.topViewHeight - kImageBackgroundHeight + changedOffset - self.topBackgroundImageOffset, 320, kImageBackgroundHeight};
                self.topBackgroundImageView.frame = (CGRect){0, 60 - (changedOffset / 4), 320, kImageBackgroundHeight};
            } else {
                self.topBackgroundContainView.frame = (CGRect){0, self.topViewHeight - kImageBackgroundHeight + changedOffset - self.topBackgroundImageOffset, 320, kImageBackgroundHeight};
            }
        }];
        
        // set TabBar View
        [UIView animateWithDuration:0.3f animations:^{
            if (changedOffset + self.topViewHeight - self.tabBarHeight < 0) {
                self.tabBarView.frame = (CGRect){0, -1, 320, self.tabBarHeight};
            } else {
                self.tabBarView.frame = (CGRect){0, self.topViewHeight - self.tabBarHeight + changedOffset, 320, self.tabBarHeight};
            }
        }];
    }
    
    // set tableViews
    [self visitTableViews:^(UITableView *tableView, NSInteger index) {
//        if (index == self.currentIndex) {
//            NSLog(@"offset:%.f", tableView.contentOffset.y);
//        }
        CGFloat offsetOriginX = tableView.contentOffset.x;
        CGFloat offsetOriginY = tableView.contentOffset.y;
        [UIView animateWithDuration:0.3f animations:^{
            tableView.contentOffset = (CGPoint){offsetOriginX, offsetOriginY - topViewOffset};
        } completion:^(BOOL finished) {
            tableView.contentInset = UIEdgeInsetsMake(self.topViewHeight, 0., 0., 0.);
            self.isChangingContentInset = NO;
        }];
    }];
    
    
    
}

- (void)addViewToTop:(UIView *)view frame:(CGRect)frame {
    if ([view isKindOfClass:[UIView class]]) {
        [self.view addSubview:view];
        [self.addedTopViewArray addObject:view];
        [self.addedTopViewFrameArray addObject:[NSValue valueWithCGRect:frame]];
        view.frame = frame;
    }
}


#pragma mark - setupViews
- (void)setupTopBackgroundImageView {
    __weak typeof(SCTabBaseViewController) *weakSelf = self;
    
    // BackgroundContainView
    self.topBackgroundContainView = [[UIView alloc] init];
    self.topBackgroundContainView.clipsToBounds = YES;

    // BackgroundImageView
    self.topBackgroundImageView = [[UIImageView alloc] init];
    self.topBackgroundImageView.backgroundColor = [UIColor whiteColor];
    self.backgroundWhiteView = [[UIView alloc] init];
    self.backgroundWhiteView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.70];
    self.backgroundWhiteView.hidden = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (weakSelf.needBlur) {
//            weakSelf.topBackgroundImage = [weakSelf.topBackgroundImage blurredImageWithRadius:50 iterations:5 tintColor:[UIColor whiteColor]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.topBackgroundImageView.image = weakSelf.topBackgroundImage;
            if (weakSelf.needBlur) {
                weakSelf.backgroundWhiteView.hidden = NO;
            }
        });
    });
    [self.topBackgroundContainView addSubview:self.topBackgroundImageView];
    [self.topBackgroundImageView addSubview:self.backgroundWhiteView];
}

- (void)setupRefreshView {
    self.refreshLabel = [[UILabel alloc] init];
    self.refreshLabel.textColor = [UIColor grayColor];
    self.refreshLabel.textAlignment = NSTextAlignmentCenter;
    self.refreshLabel.font = [UIFont systemFontOfSize:13.0f];
    
    self.refreshImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh"]];
    self.refreshImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.loadingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh"]];
    self.loadingImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.loadingImageView];
    self.loadingImageView.hidden = YES;
    
    // Animation
    [self.refreshImageView.layer addAnimation:[self refreshAnimation] forKey:kRefreshRotationAnimation];
    self.refreshImageView.layer.speed = 0.0f;
}

- (void)setupTopView {
    if (self.topClassName) {
        self.topView = [(UIView *)[[NSClassFromString(self.topClassName) class] alloc] init];
    } else {
        self.topViewHeight = self.tabBarHeight;
    }
}

- (void)setupTabBarView {
    __weak typeof(SCTabBaseViewController) *weakSelf = self;
    
    self.tabButtonHandleBlock = ^(NSInteger index) {
        CGRect visibleRect = (CGRect){320*index, 0, 320, weakSelf.scrollView.contentSize.height};
        [weakSelf.scrollView scrollRectToVisible:visibleRect animated:YES];
    };

    self.tabBarView = [[UIView alloc] init];
    self.tabBarView.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < self.tabTitles.count; i ++) {
        UIButton *tabButton = [[UIButton alloc] init];
        tabButton.layer.borderWidth = 1.0f;
        tabButton.layer.borderColor = [self.tabBarButtonBorderColor CGColor];
        [tabButton setTitle:self.tabTitles[i] forState:UIControlStateNormal];
        [tabButton setTitleColor:self.tabBarTextColorNormal forState:UIControlStateNormal];
        tabButton.titleLabel.font = self.tabBarTextFont;
        tabButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        tabButton.tag = kTablButtonTagOffset + i;
        [self.tabBarView addSubview:tabButton];
        [self.tabBarButtonArray addObject:tabButton];
        
        // buttonAction
        [tabButton bk_addEventHandler:^(UIButton* button){
            NSInteger index = button.tag - kTablButtonTagOffset;
            weakSelf.tabButtonHandleBlock(index);
        } forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            tabButton.backgroundColor = self.tabBarButtonBackgroundColorHeighlighted;
            [tabButton setTitleColor:self.tabBarTextColorHeighlighted forState:UIControlStateNormal];
        }
    }
    
    self.tabBarSectionLineView = [[UIView alloc] init];
    self.tabBarSectionLineView.backgroundColor = self.tabBarSectionLineColor;
    [self.tabBarView addSubview:self.tabBarSectionLineView];
    
    if (self.tabClassNameArray.count ==1) {
        self.tabBarView.hidden = YES;
    }
}

- (void)setupTabView {
    // ScrollView
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.bounces = NO;
    
    // tabViews
//    CGFloat naviHeight = CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] applicationFrame]);
    if (self.navigationController.navigationBar.barPosition == UIBarPositionTopAttached) {
        screenHeight -= 44.0f;
    } else {
        screenHeight += 20.0f;
    }
    
//    NSLog(@"load. navi: %.f \n screen: %.f", naviHeight, screenHeight);
    for (int i = 0; i < self.tabClassNameArray.count; i ++) {
        CGRect rect = (CGRect){320 * i, 0, 320, screenHeight};
        UIView *view = [[[NSClassFromString(self.tabClassNameArray[i]) class] alloc] initWithFrame:rect];
        [self.scrollView addSubview:view];
        [self.tabViewArray addObject:view];
    }
    
    CGFloat botomOffset = 0.0f;
    //        if (!self.navigationController.navigationBar.isHidden) {
    //            botomOffset = 20.0f;
    //        }
    
    // tabViews
    NSInteger index = 0;
    for (UIView *view in self.tabViewArray) {
        if ([view isKindOfClass:[SCTabBaseView class]]) {
            SCTabBaseView *baseView = (SCTabBaseView *)view;
            baseView.delegate = self;
            UITableView *tableView = baseView.tableView;
            tableView.contentInset = UIEdgeInsetsMake(self.topViewHeight, 0., botomOffset, 0.);
            tableView.contentOffset = (CGPoint){0, - self.topViewHeight};
            tableView.backgroundColor = [UIColor clearColor];
            tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        }
        index ++;
    }

}

#pragma mark - LayoutSubviews

- (void)viewWillLayoutSubviews {
//    CGFloat naviHeight = 0.0f; //CGRectGetHeight(self.navigationController.navigationBar.frame);
    CGFloat screenHeight = CGRectGetHeight([[UIScreen mainScreen] applicationFrame]);
//    NSLog(@"barPosition: %d height: %.f", self.navigationController.navigationBar.barPosition, screenHeight);
    if (self.navigationController.navigationBar.barPosition == UIBarPositionTopAttached) {
        screenHeight -= 44.0f;
    } else {
        screenHeight += 20.0f;
    }
    
    // backgroundImageView
    self.topBackgroundContainView.frame = (CGRect){0, self.topViewHeight - kImageBackgroundHeight - self.topBackgroundImageOffset, 320, kImageBackgroundHeight};
    self.topBackgroundImageView.frame = (CGRect){0, 60, 320, kImageBackgroundHeight};
    self.backgroundWhiteView.frame = (CGRect){0, 0, 320, kImageBackgroundHeight};

    // Top View
    self.topView.frame = (CGRect){0, 0, 320, self.topViewHeight};
    
    // refreshView
    self.refreshImageView.frame = (CGRect){kRefreshImagePositionX, -30, kRefreshImageHeight, kRefreshImageHeight};
    self.refreshLabel.frame = (CGRect){70, -30, 180, kRefreshImageHeight};
    self.loadingImageView.frame = (CGRect){kRefreshImagePositionX, -30, kRefreshImageHeight, kRefreshImageHeight};
    
    // tabBarView
    self.tabBarView.frame = (CGRect){0, self.topViewHeight - self.tabBarHeight, 320, self.tabBarHeight};
    self.tabBarSectionLineView.frame = (CGRect){0, self.tabBarHeight-2, 320.0f/self.tabClassNameArray.count, 2};
    for (int i = 0; i < self.tabBarButtonArray.count; i ++) {
        UIButton *tabButton = self.tabBarButtonArray[i];
        tabButton.frame = (CGRect){320.0f / self.tabBarButtonArray.count * i, 0, 320.0f / self.tabBarButtonArray.count+1, self.tabBarHeight};
    }
    
    // scroll View
    self.scrollView.frame = (CGRect){0, 0, 320, screenHeight};
    self.scrollView.contentSize = (CGSize){320 * self.tabClassNameArray.count, screenHeight};
}

#pragma mark - SCTabBaseViewDelegate

- (void)SCScrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat changedOffset = -(scrollView.contentOffset.y + self.topViewHeight);
    if (self.isChangingContentInset) {
        return;
    }

    [self visitTableViews:^(UITableView *tableView, NSInteger index) {
        tableView.contentOffset = scrollView.contentOffset;
    }];
    
    if (self.isRefreshing) {
//        self.topLineView.frame = (CGRect){0, 0, 320, kProgressLineHeight};
    } else {
        self.refreshLabel.hidden = NO;
        
        if (changedOffset > 60.0f) {
            
            self.refreshLabel.text = @"Release To Refresh";
            self.refreshImageView.layer.timeOffset = changedOffset / 180.0f;
            self.refreshImageView.frame = (CGRect){kRefreshImagePositionX, -30 + 60.0f * 0.8, kRefreshImageHeight, kRefreshImageHeight};
            self.refreshLabel.frame = (CGRect){70, -30 + 60.0f * 0.8, 180, kRefreshImageHeight};
            
        } else if (changedOffset > 0 && changedOffset <= 60.0f) {
            
            self.refreshLabel.text = @"Pull To Refresh";
            self.refreshImageView.layer.timeOffset = changedOffset / 180.0f;
            self.refreshImageView.frame = (CGRect){kRefreshImagePositionX, -30 + changedOffset * 0.8, kRefreshImageHeight, kRefreshImageHeight};
            self.refreshLabel.frame = (CGRect){70, -30 + changedOffset * 0.8, 180, kRefreshImageHeight};
            
        } else {
            
        }
        
    }
    
    // topBackgroundImageView
    if (changedOffset >= 0) {
        self.topBackgroundContainView.frame = (CGRect){0, self.topViewHeight - kImageBackgroundHeight + changedOffset - self.topBackgroundImageOffset, 320, kImageBackgroundHeight};
        self.topBackgroundImageView.frame = (CGRect){0, 60 - (changedOffset / 4), 320, kImageBackgroundHeight};
    } else {
        self.topBackgroundContainView.frame = (CGRect){0, self.topViewHeight - kImageBackgroundHeight + changedOffset - self.topBackgroundImageOffset, 320, kImageBackgroundHeight};
    }

    // AddedTopView
    [self setAddedTopViewFrameWithOffset:changedOffset];
    
    // topView
    self.topView.frame = (CGRect){0, changedOffset, 320, self.topViewHeight};
    
    // tabBarView
//    NSLog(@"%.f", changedOffset + self.topViewHeight - self.tabBarHeight);
    if (changedOffset + self.topViewHeight - self.tabBarHeight < 0) {
        self.tabBarView.frame = (CGRect){0, -1, 320, self.tabBarHeight};
    } else {
        self.tabBarView.frame = (CGRect){0, self.topViewHeight - self.tabBarHeight + changedOffset, 320, self.tabBarHeight};
    }
    
}

- (void)SCScrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

- (void)SCScrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self visitTableViews:^(UITableView *tableView, NSInteger index) {
        tableView.contentOffset = scrollView.contentOffset;
    }];
}

- (void)SCScrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat yOffset = scrollView.contentOffset.y;
    CGFloat changedOffset = -(yOffset + self.topViewHeight);
    if (changedOffset > 60) {
        if (self.refreshHandleBlock) {
            self.isRefreshing = YES;
            self.refreshHandleBlock(nil);
            [self.loadingImageView.layer addAnimation:[self loadingAnimation] forKey:kLoadingRotationAnimation];
            self.loadingImageView.frame = self.refreshImageView.frame;
            self.loadingImageView.hidden = NO;
            self.loadingImageView.layer.timeOffset = self.refreshImageView.layer.timeOffset;
            self.refreshImageView.hidden = YES;
            [UIView animateWithDuration:kAnimationDuration animations:^{
                self.refreshLabel.alpha = 0.0f;
            } completion:^(BOOL finished) {
                self.refreshLabel.hidden = YES;
                self.refreshLabel.alpha = 1.0f;
            }];
        }
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([scrollView isKindOfClass:[UIScrollView class]]) {
        CGFloat xOffset = scrollView.contentOffset.x;
        CGFloat tabBarLineX = xOffset / self.numberOfTabs;
        self.tabBarSectionLineView.frame = (CGRect){tabBarLineX, self.tabBarSectionLineView.frame.origin.y, self.tabBarSectionLineView.frame.size.width, self.tabBarSectionLineView.frame.size.height};
        NSInteger index = xOffset / 320.0f;
        
        UIButton *currentButton = self.tabBarButtonArray[index];
        UIButton *nextButton;
        if (xOffset > index * 320) {
            nextButton = self.tabBarButtonArray[index + 1];
        }
        if (xOffset < index * 320) {
            nextButton = self.tabBarButtonArray[index - 1];
        }
        
        CGFloat colorOffset = (xOffset - 320*index) / 320.0f;

        CGFloat backgroundColorOffset = kTabBarButtonBackgroundColorNormal - kTabBarButtonBackgroundColorHeighlighted;
        CGFloat textColorOffset = kTabBarTextColorNormal - kTabBarTextColorHeighlighted;
        
        nextButton.backgroundColor = [UIColor colorWithWhite:kTabBarButtonBackgroundColorNormal-backgroundColorOffset*colorOffset alpha:1.0f];
        currentButton.backgroundColor = [UIColor colorWithWhite:kTabBarButtonBackgroundColorHeighlighted+backgroundColorOffset*colorOffset alpha:1.0f];
        currentButton.titleLabel.textColor = [UIColor colorWithWhite:kTabBarTextColorHeighlighted+textColorOffset*colorOffset alpha:1.0f];
        nextButton.titleLabel.textColor = [UIColor colorWithWhite:kTabBarTextColorNormal-textColorOffset*colorOffset alpha:1.0f];
    }
}

#pragma mark - Custom methods
- (void)visitTableViews:(void (^)(UITableView *tableView, NSInteger index))tableView {
    NSInteger index = 0;
    for (UIView *view in self.tabViewArray) {
        if ([view isKindOfClass:[SCTabBaseView class]]) {
            SCTabBaseView *baseView = (SCTabBaseView *)view;
            tableView(baseView.tableView, index);
        }
        index ++;
    }
}

- (void)setAddedTopViewFrameWithOffset:(CGFloat)offset {
    NSInteger index = 0;
    for (UIView *view in self.addedTopViewArray) {
        CGRect frame = [[self.addedTopViewFrameArray objectAtIndex:index] CGRectValue];
        frame.origin.y += offset;
        view.frame = frame;
    }
}

- (CAAnimation *)refreshAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*6];
    rotationAnimation.duration = 1.0f;
    return rotationAnimation;
}

- (CAAnimation *)loadingAnimation {
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI*6];
    rotationAnimation.duration = 1.0f;
    rotationAnimation.repeatCount = 1000;
    rotationAnimation.speed = 0.4;
    return rotationAnimation;
}

#pragma mark - KeyValueObserve

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(__unused NSDictionary *)change
                       context:(void *)context
{
    if (context == AFTaskCountOfBytesReceivedContext) {
        
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(countOfBytesReceived))]) {
            if ([object countOfBytesExpectedToReceive] > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    CGFloat offset = [object countOfBytesReceived] / ([object countOfBytesExpectedToReceive]*1.0f) * 320.0f;
                });
            }
        }
        
        if ([keyPath isEqualToString:NSStringFromSelector(@selector(state))]) {
            if ([(NSURLSessionTask *)object state] == NSURLSessionTaskStateCompleted) {
                @try {
                    [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(state))];
                    
                    if (context == AFTaskCountOfBytesReceivedContext) {
                        [object removeObserver:self forKeyPath:NSStringFromSelector(@selector(countOfBytesReceived))];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.loadingImageView.layer removeAllAnimations];
                            [UIView animateWithDuration:kAnimationDuration animations:^{
                                self.loadingImageView.frame = (CGRect){kRefreshImagePositionX, -30, kRefreshImageHeight, kRefreshImageHeight};
                            } completion:^(BOOL finished) {
                                self.refreshImageView.frame = (CGRect){kRefreshImagePositionX, -30, kRefreshImageHeight, kRefreshImageHeight};
                                self.refreshImageView.hidden = NO;
                                self.loadingImageView.hidden = YES;
                                self.isRefreshing = NO;
                            }];
                        });
                    }
                }
                @catch (NSException * __unused exception) {}
            }
        }
    }
}



// unused method for further testing
- (UIColor *)tabBarBackgroundColorFromOffset:(CGFloat)offset {
    if (offset <= 0.0f) {
        return self.tabBarButtonBackgroundColorNormal;
    }
    if (offset >= 1.0f) {
        return self.tabBarButtonBackgroundColorHeighlighted;
    }
    
    UIColor *fromColor = self.tabBarButtonBackgroundColorNormal;
    UIColor *toColor = self.tabBarButtonBackgroundColorHeighlighted;
    CGFloat fromR, fromG, fromB, fromA;
    CGFloat toR, toG, toB, toA;
    
    const float* fromColors = CGColorGetComponents(fromColor.CGColor );
    fromR = fromColors[0];
    fromG = fromColors[1];
    fromB = fromColors[2];
    fromA = fromColors[3];

    const float* toColors = CGColorGetComponents(toColor.CGColor );
    toR = toColors[0];
    toG = toColors[1];
    toB = toColors[2];
    toA = toColors[3];
    
    CGFloat returnR, returnG, returnB, returnA;
    returnR = (toR - fromR) * offset + fromR;
    returnG = (toG - fromG) * offset + fromG;
    returnB = (toB - fromB) * offset + fromB;
    returnA = (toA - fromA) * offset + fromA;
    
//    NSLog(@"from R: %2f G: %2f B: %2f A: %2f ", fromR, fromG, fromB, fromA);
//    NSLog(@"to   R: %2f G: %2f B: %2f A: %2f ", toR, toG, toB, toA);
    NSLog(@"chan R: %2f G: %2f B: %2f A: %2f ", returnR, returnG, returnB, returnA);
    UIColor *returnColor = [[UIColor alloc] initWithRed:returnR green:returnG blue:returnB alpha:returnA];
    //[UIColor colorWithRed:returnR green:returnG blue:returnB alpha:returnA]
    return returnColor;
}

@end
