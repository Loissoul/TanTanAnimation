//
//  PGQDragCardContainerView.m
//  TanTanAnimation
//
//  Created by Lois_pan on 16/12/19.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

#import "PGQDragCardContainerView.h"

@implementation PGQDragCardContainerView{
    BOOL               _moving;
    NSInteger          _loadedIndex;
    NSMutableArray    *_currentCards;
    CGAffineTransform  _lastCardTransform;
    CGRect             _lastCardFrame;
    CGRect             _firstCardFrame;
    CGPoint            _cardCenter;
}

//MARK: - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

//MARK: - API
- (void)reloadData {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self initConfig];
    [self initNextItem];
    [self resetVisibleCards];
}

- (void)removeForDirection:(PGQDragCardDirection)direciton {

    if (_moving) {
        return;
    } else {
    
        CGPoint cardCenter = CGPointZero;
        CGFloat flag = 0;
        
        switch (direciton) {
            case PGQDragCardDirectionLeft:
                cardCenter = CGPointMake(-ScreenWidth / 2, _cardCenter.y);
                flag = -1;
                break;
            case PGQDragCardDirectionRight:
                cardCenter = CGPointMake(ScreenWidth * 1.5, _cardCenter.y);
                flag = 1;
                break;
            default:
                break;
        }
        
        UIView * firstView = [_currentCards firstObject];
        [UIView animateWithDuration:0.35 animations:^{
            CGAffineTransform translate = CGAffineTransformTranslate(CGAffineTransformIdentity, flag * 20, 0);
            firstView.transform = CGAffineTransformRotate(translate, flag * M_PI_4 / 4);
            firstView.center = _cardCenter;
        } completion:^(BOOL finished) {
            
            [firstView removeFromSuperview];
            [_currentCards removeObject:firstView];
            [self initNextItem];
            [self resetVisibleCards];
        }];
    }
}

//MARK: - subviews
- (void)initConfig {
    self.direction = PGQDragCardDirectionDefault;
    _currentCards = [NSMutableArray array];
    _loadedIndex = 0;
    _moving = NO;
}

- (CGRect)defaultCardViewFrame {
    CGFloat s_width  = CGRectGetWidth(self.frame);
    CGFloat s_height = CGRectGetHeight(self.frame);
    
    CGFloat c_height = s_height - kContainerEdage * 2 - kCardEdage * 2;
    
    return CGRectMake(
                      kContainerEdage,
                      (s_height - (c_height + kCardEdage * 2)) / 2,
                      s_width  - kContainerEdage * 2,
                      c_height);
}

- (void)initNextItem {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfIndexs)] && [self.dataSource respondsToSelector:@selector(dragCardContainerView:viewForIndex:)]) {
        
        NSInteger indexs = [self.dataSource numberOfIndexs];
        NSInteger preloadViewCount = indexs <= kVisibleCount ? indexs : kVisibleCount;
        
        if (_loadedIndex < indexs) {
            for (long int i = _currentCards.count; i < (_moving ? preloadViewCount + 1: preloadViewCount); i++) {
                
                PGQBaseCardView * cardView = [self.dataSource dragCardContainerView:self viewForIndex:_loadedIndex];
                cardView.frame = [self defaultCardViewFrame];
                [cardView pgq_creatSubViews];
                
                if (_loadedIndex >= 3) {
                    cardView.frame = _lastCardFrame;
                } else {
                
                    CGRect frame = cardView.frame;
                    if (CGRectIsEmpty(_firstCardFrame)) {
                        _firstCardFrame = frame;
                        _cardCenter = cardView.center;
                    }
                }
                cardView.tag = _loadedIndex;
                [self addSubview:cardView];
                [self sendSubviewToBack:cardView];
                [_currentCards addObject:cardView];
                
                //添加手势
                UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureHandle:)];
                [cardView addGestureRecognizer:pan];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHandle:)];
                [cardView addGestureRecognizer:tap];
                
                _loadedIndex += 1;
            }
        }
    } else {
        NSAssert(self.dataSource, @"dataSource can't nil");
    }
}

//MARK: - Action
- (void)panGestureHandle:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        PGQBaseCardView * cardView = (PGQBaseCardView *)gesture.view;
        CGPoint point = [gesture translationInView: self];
        CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
        cardView.center = movedPoint;
        cardView.transform = CGAffineTransformRotate(cardView.originalTransform, (gesture.view.center.x - _cardCenter.x) / _cardCenter.x * (M_PI_4 / 12));
        [gesture setTranslation:CGPointZero inView:self];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(dragCardContainerView:direction:widthScale:heightScale:)]) {
            
            float widthScale = (gesture.view.center.x - _cardCenter.x) / _cardCenter.x;
            float heightScale = (gesture.view.center.y - _cardCenter.y) / _cardCenter.y;
            
            [self judgeMovingState:widthScale];
            
            if (widthScale > 0) {
                self.direction = PGQDragCardDirectionRight;
            } if (widthScale < 0) {
                self.direction = PGQDragCardDirectionLeft;
            } else if (widthScale == 0 ){
                self.direction = PGQDragCardDirectionDefault;
            }
            [self.delegate dragCardContainerView:self direction:self.direction widthScale:widthScale heightScale:heightScale];
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        
        float widthScale = (gesture.view.center.x - _cardCenter.x) / _cardCenter.x;
        float moveWidth = gesture.view.center.x - _cardCenter.x;
        float moveHeight = gesture.view.center.y - _cardCenter.y;
        [self finishedPanGesture:gesture.view direction:self.direction scale:(moveWidth / moveHeight) disappear:fabs(widthScale) > kBoundaryRatio];
    }
}

//消失卡片
- (void)finishedPanGesture:(UIView *)cardView direction:(PGQDragCardDirection)direction scale:(CGFloat)scale disappear:(BOOL)disappear {
    
    if (!disappear) {
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfIndexs)]) {
            
            if (_moving && _currentCards.count > kVisibleCount) {
                UIView * lastView = [_currentCards lastObject];
                [lastView removeFromSuperview];
                [_currentCards removeObject:lastView];
                _loadedIndex = lastView.tag;
            }
            _moving = NO;
            [self resetVisibleCards];
        }
    } else {
    
        NSInteger flag = direction == PGQDragCardDirectionLeft ? -1 : 2;
        [UIView animateWithDuration:0.5f
                              delay:0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             cardView.center = CGPointMake(ScreenWidth * flag, ScreenWidth * flag / scale + _cardCenter.y);
        } completion:^(BOOL finished) {
            
            [cardView removeFromSuperview];
        }];
        
        [_currentCards removeObject:cardView];
        _moving = NO;
        [self resetVisibleCards];
    }
    
}

- (void)judgeMovingState:(CGFloat)scale {
    
    if (!_moving) {
        _moving = YES;
        [self initNextItem];
    } else {
        [self movingVisibleCards: scale];
    }
}

- (void)movingVisibleCards:(CGFloat)scale {
    scale = fabs(scale) >= kBoundaryRatio ? kBoundaryRatio : fabs(scale);
    CGFloat sPoor = kSecondCardScale - kThirdCardScale; // 相邻的两个cardScale差值
    CGFloat tPoor = sPoor / (kBoundaryRatio / scale);
    CGFloat yPoor = kCardEdage / (kBoundaryRatio / scale); //frame y差值
    for (int i = 1; i < _currentCards.count; i++) {
        
        PGQBaseCardView *cardView = [_currentCards objectAtIndex:i];
        switch (i) {
            case 1:
            {
                CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + kSecondCardScale, 1);
                CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -yPoor);
                cardView.transform = translate;
            }
                break;
            case 2:
            {
                CGAffineTransform scale = CGAffineTransformScale(CGAffineTransformIdentity, tPoor + kThirdCardScale, 1);
                CGAffineTransform translate = CGAffineTransformTranslate(scale, 0, -yPoor);
                cardView.transform = translate;
            }
                break;
            case 3:
            {
                cardView.transform = _lastCardTransform;
            }
                break;
            default:
                break;
        }
    }
}

-(void)tapGestureHandle:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCardContainerView:cardView:didSelectIndex:)]) {
        [self.delegate dragCardContainerView:self cardView:(PGQBaseCardView *)tap.view didSelectIndex: tap.view.tag];
    }
}

- (void)resetVisibleCards {

    __weak PGQDragCardContainerView *weakSelf = self;
    
    [UIView animateWithDuration:5
                          delay:0
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.6
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         [weakSelf originalLayout];
    } completion:^(BOOL finished) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(dragCardContainerView:removeLastCard:)]) {
            
            if (_currentCards.count == 0) {
                [weakSelf.delegate dragCardContainerView:self removeLastCard:YES];
            }
        }
    }];
}

- (void)originalLayout {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(dragCardContainerView:direction:widthScale:heightScale:)]) {
        [self.delegate dragCardContainerView:self direction:self.direction widthScale:0 heightScale:0];
    }
    
    for ( int i = 0; i < _currentCards.count; i++) {
        PGQBaseCardView * cardView = [_currentCards objectAtIndex:i];
        cardView.transform = CGAffineTransformIdentity;
        CGRect frame = _firstCardFrame;
        
        switch (i) {
            case 0:
            {
                cardView.frame = frame;
            }
                break;
            case 1:
            {
                frame.origin.y = frame.origin.y + kCardEdage;
                cardView.frame = frame;
                cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kSecondCardScale, 1);
            }
                break;
            case 2:
            {
                frame.origin.y = frame.origin.y + kCardEdage*2;
                cardView.frame = frame;
                cardView.transform = CGAffineTransformScale(CGAffineTransformIdentity, kSecondCardScale, 1);

                if (CGRectIsEmpty(_lastCardFrame)) {
                    
                    _lastCardFrame = frame;
                    _lastCardTransform = cardView.transform;
                }
            }
                break;
                
            default:
                break;
        }
        cardView.originalTransform = cardView.transform;
    }
}

@end











































