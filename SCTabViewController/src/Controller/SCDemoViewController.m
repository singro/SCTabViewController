//
//  SCDemoViewController.m
//  SCTabViewController
//
//  Created by Singro on 12/20/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import "SCDemoViewController.h"

#import <BlocksKit+UIKit.h>
#import <AFNetworking.h>

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
        self.topViewHeight = 155.0f;
        self.topBackgroundImage = [UIImage imageNamed:@"image1"];
        
        
        __weak typeof(SCDemoViewController) *weakSelf = self;
        self.refreshBlock = ^() {
            NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
            
            NSURL *URL = [NSURL URLWithString:@"http://daswallpaper.de/wp-content/gallery/das_wallpaper_startseite/science_fiction_18-hd-wallpaper-kostenlos-1920x1080.jpg"];
//            NSURL *URL = [NSURL URLWithString:@"http://img3.douban.com/icon/u73872098-2.jpg"];
            NSURLRequest *request = [NSURLRequest requestWithURL:URL];
            
            NSProgress *progress =[[NSProgress alloc] init];
            NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                NSURL *documentsDirectoryPath = [NSURL fileURLWithPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]];
                return [documentsDirectoryPath URLByAppendingPathComponent:[response suggestedFilename]];
            } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
                NSLog(@"File downloaded to: %@", filePath);
            }];
            
            weakSelf.task = downloadTask;
            
            [downloadTask resume];
        };

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
            self.topViewHeight = 155.0f;
            testButton.frame = CGRectMake(50, 80, 200, 30);
        } else {
            self.topViewHeight = 300.0f;
            testButton.frame = CGRectMake(50, 80, 200, 30);
        }
        topView.expend = !topView.expend;
    }];
    [self addViewToTop:testButton frame:CGRectMake(50, 80, 60, 30)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
