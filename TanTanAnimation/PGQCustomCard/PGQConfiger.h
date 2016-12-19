//
//  PGQConfiger.h
//  TanTanAnimation
//
//  Created by Lois_pan on 16/12/19.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

#ifndef PGQConfiger_h
#define PGQConfiger_h

//拖动的方向
typedef NS_ENUM(NSInteger, PGQDragCardDirection){

    PGQDragCardDirectionDefault  = 0,
    PGQDragCardDirectionLeft     = 1 << 0,
    PGQDragCardDirectionRight    = 2 << 1
};

#define ScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

static const CGFloat kBoundaryRatio   = 0.8f;
static const CGFloat kSecondCardScale = 0.95f;
static const CGFloat kThirdCardScale  = 0.9f;

static const CGFloat kCardEdage        = 15.0f;
static const CGFloat kContainerEdage   = 15.0f;
static const CGFloat kNavigationHeight = 64.0f;

static const CGFloat kVisibleCount     = 3;


#endif /* PGQConfiger_h */
