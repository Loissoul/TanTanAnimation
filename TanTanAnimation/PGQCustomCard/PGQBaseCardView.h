//
//  PGQBaseCardView.h
//  TanTanAnimation
//
//  Created by Lois_pan on 16/12/19.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGQConfiger.h"

@interface PGQBaseCardView : UIView

@property (nonatomic) CGAffineTransform originalTransform;

- (void)pgq_creatSubViews;

@end
