//
//  PGQBaseCardView.m
//  TanTanAnimation
//
//  Created by Lois_pan on 16/12/19.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

#import "PGQBaseCardView.h"

@implementation PGQBaseCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initConfig];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initConfig];
}

- (void)initConfig {
    self.userInteractionEnabled = YES;
    [self.layer setMasksToBounds:YES];
    [self.layer setCornerRadius:10.0f];
    [self.layer setShouldRasterize:YES];
    [self.layer setRasterizationScale:[[UIScreen mainScreen] scale]];

    CGFloat backgroundColorFloat = 245.0f / 255.0f;
    self.backgroundColor = [UIColor colorWithRed:backgroundColorFloat green:backgroundColorFloat blue:backgroundColorFloat alpha:1];
    
    CGFloat borderColotr = 176.0f / 255.0f;
    [self.layer setBorderWidth:.45];
    [self.layer setBorderColor:[UIColor colorWithRed:borderColotr green:borderColotr blue:borderColotr alpha:1].CGColor];

}

- (void)pgq_creatSubViews{ }
@end
