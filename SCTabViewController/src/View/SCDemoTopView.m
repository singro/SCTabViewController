//
//  SCDemoTopView.m
//  SCTabViewController
//
//  Created by Singro on 12/20/13.
//  Copyright (c) 2013 Singro. All rights reserved.
//

#import "SCDemoTopView.h"

static CGFloat const kLabelWidth = 280.0f;
static CGFloat const kTopHeight = 80.0f;

@interface SCDemoTopView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, assign) CGFloat labelHeight;

@end

@implementation SCDemoTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor =  [UIColor yellowColor];
        
        self.labelHeight =  50.0f;
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ruler"]];
        [self addSubview:self.imageView];

        self.descriptionLabel = [[UILabel alloc] init];
        self.descriptionLabel.numberOfLines = 0;
        self.descriptionLabel.clipsToBounds = YES;
        self.descriptionLabel.lineBreakMode = NSLineBreakByClipping;
        self.descriptionLabel.font = [UIFont systemFontOfSize:15.0f];
        self.descriptionLabel.text = @"dfsdf ";
        self.descriptionLabel.contentMode = UIViewContentModeTop;
        [self addSubview:self.descriptionLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    self.imageView.frame = (CGRect){0,0,self.frame.size.width, self.frame.size.height};
    if (self.expend) {
        [UIView animateWithDuration:0.3f animations:^{
            self.descriptionLabel.frame = (CGRect){0, kTopHeight, kLabelWidth, self.labelHeight};
        }];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.descriptionLabel.frame = (CGRect){0, kTopHeight, kLabelWidth, 50};
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
