//
//  SCDemoTopView.m
//  SCTabViewController
//
//  Created by Singro on 12/20/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import "SCDemoTopView.h"

static CGFloat const kLabelWidth = 280.0f;
static CGFloat const kLabelHeightDefault = 35.79f;
static CGFloat const kTopHeight = 80.0f;

@interface SCDemoTopView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIView *descriptionContainView;
@property (nonatomic, assign) CGFloat labelHeight;
@property (nonatomic, assign) CGFloat labelHeightDefault;

@end

@implementation SCDemoTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =  [UIColor clearColor];
        
        self.labelHeight =  50.0f;
        self.expend = NO;
        
//        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ruler"]];
//        [self addSubview:self.imageView];
        
        self.descriptionContainView = [[UIView alloc] init];
        self.descriptionContainView.clipsToBounds = YES;
        [self addSubview:self.descriptionContainView];

        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.clipsToBounds = YES;
        self.descriptionLabel.lineBreakMode = NSLineBreakByClipping;
        self.descriptionLabel.font = [UIFont systemFontOfSize:15.0f];
        self.descriptionLabel.text = @"dfsdf ";
        self.descriptionLabel.contentMode = UIViewContentModeTop;
        [self.descriptionContainView addSubview:self.descriptionLabel];
        
        self.descriptionLabel.frame = (CGRect){0, 0, kLabelWidth, kLabelHeightDefault};
        self.descriptionContainView.frame = (CGRect){0, kTopHeight, kLabelWidth, kLabelHeightDefault};

//        NSDictionary *attributes = @{
//                                     NSFontAttributeName: self.descriptionLabel.font,
//                                     };
//        CGRect expectedLabelRect = [@"This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function.This method returns fractional sizes (in the size component of the returned CGRect); to use a returned size to size views, you must use raise its value to the nearest higher integer using the ceil function." boundingRectWithSize:(CGSize){kLabelWidth, kLabelHeightDefault}
//                                                                      options:NSStringDrawingUsesLineFragmentOrigin
//                                                                   attributes:attributes
//                                                                      context:nil];
//        self.labelHeightDefault = CGRectGetHeight(expectedLabelRect);
//        NSLog(@"size: %@", NSStringFromCGRect(expectedLabelRect));
        
}
    return self;
}

- (void)layoutSubviews {
//    self.imageView.frame = (CGRect){0,0,self.frame.size.width, self.frame.size.height};
    if (self.expend) {
        [UIView animateWithDuration:0.53f animations:^{
            self.descriptionContainView.frame = (CGRect){0, kTopHeight, kLabelWidth, self.labelHeight};
        }];
    } else {
        [UIView animateWithDuration:0.5f animations:^{
            self.descriptionContainView.frame = (CGRect){0, kTopHeight, kLabelWidth, kLabelHeightDefault};
        }];
    }
//    self.descriptionText = @"dfas sfas asdfasdfas 1 fasfasd fasd fasdf asfda 2 fas fasdfasdfasdfas fas 3 fasdfasdfasdfas fas fasdfasd 4 fasdfasdfasdf afsad fas";
}


- (void)setDescriptionText:(NSString *)descriptionText {
    _descriptionText =  descriptionText;
    NSDictionary *attributes = @{
                                 NSFontAttributeName: self.descriptionLabel.font,
                                 };
    CGRect expectedLabelRect = [self.descriptionText boundingRectWithSize:(CGSize){kLabelWidth, CGFLOAT_MAX}
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:attributes
                                                                  context:nil];
    NSLog(@"size: %@", NSStringFromCGRect(expectedLabelRect));
    self.labelHeight = CGRectGetHeight(expectedLabelRect);
    self.descriptionLabel.text = self.descriptionText;
    self.descriptionLabel.frame = (CGRect){0, 0, kLabelWidth, CGRectGetHeight(expectedLabelRect)};
}

- (void)setExpend:(BOOL)expend {
    if (self.expend == expend) {
        return;
    }
    _expend = expend;
    if (expend) {
        ;
    } else {
        ;
    }
    [self setNeedsLayout];
}

@end
