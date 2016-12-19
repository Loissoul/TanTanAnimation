//
//  PGQDragCardContainerView.h
//  TanTanAnimation
//
//  Created by Lois_pan on 16/12/19.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PGQConfiger.h"
#import "PGQBaseCardView.h"

@class PGQDragCardContainerView;

@protocol PGQDragCardContainerViewDelegate <NSObject>

- (void)dragCardContainerView:(PGQDragCardContainerView*)cardContainerView
                    direction:(PGQDragCardDirection)direction
                   widthScale:(CGFloat)widthScale
                  heightScale:(CGFloat)heightScale;

- (void)dragCardContainerView:(PGQDragCardContainerView*)cardContainerView
                     cardView:(PGQBaseCardView *)cardView
               didSelectIndex:(NSInteger)selecrIndex;

- (void)dragCardContainerView:(PGQDragCardContainerView*)cardContainerView
               removeLastCard:(BOOL)removeLastCard;
@end

@protocol PGQDragCardContainerViewDataSource <NSObject>

@required
- (PGQBaseCardView *)dragCardContainerView:(PGQDragCardContainerView*)cardContainerView
                              viewForIndex:(NSInteger)index;

- (NSInteger)numberOfIndexs;

@end


@interface PGQDragCardContainerView : UIView

@property (nonatomic, weak) id<PGQDragCardContainerViewDelegate> delegate;
@property (nonatomic, weak) id<PGQDragCardContainerViewDataSource> dataSource;

@property (nonatomic, assign) PGQDragCardDirection direction;

- (void)reloadData;
- (void)removeForDirection:(PGQDragCardDirection)direciton;
@end
