//
//  PGQCustomCardView.m
//  TanTanAnimation
//
//  Created by Lois_pan on 16/12/19.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

#import "PGQCustomCardView.h"
@interface PGQCustomCardView ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel     *titleLabel;

@end

@implementation PGQCustomCardView

- (instancetype)init {
    if (self = [super init]) {
        [self loadComponent];
    }
    return  self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self loadComponent];
    }
    return self;
}

- (void)loadComponent {
    self.imageView = [[UIImageView alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.imageView.layer setMasksToBounds:YES];
    
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    
    self.backgroundColor = [UIColor colorWithRed:0.951 green:0.951 blue:0.951 alpha:1.00];
}

- (void)pgq_creatSubViews {
    self.imageView.frame   = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 64);
    self.titleLabel.frame = CGRectMake(0, self.frame.size.height - 64, self.frame.size.width, 64);
}

- (void)installData:(NSDictionary *)element {
    self.imageView.image  = [UIImage imageNamed:element[@"image"]];
    self.imageView.transform = CGAffineTransformIdentity;
    self.titleLabel.text = element[@"title"];
    self.titleLabel.transform = CGAffineTransformIdentity;
}


@end
