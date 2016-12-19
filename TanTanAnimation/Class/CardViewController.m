//
//  CardViewController.m
//  TanTanAnimation
//
//  Created by Lois_pan on 16/12/19.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

#import "CardViewController.h"
#import "PGQCustomCardView.h"
#import "PGQDragCardContainerView.h"

@interface CardViewController ()<PGQDragCardContainerViewDelegate, PGQDragCardContainerViewDataSource>

@property (nonatomic, strong) PGQDragCardContainerView *container;
@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self loadData];
}

- (void)createViews {
    self.view.backgroundColor = [UIColor whiteColor];
    self.container = [[PGQDragCardContainerView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenWidth)];
    self.container.delegate = self;
    self.container.dataSource = self;
    self.container.backgroundColor = [UIColor colorWithRed:0.792 green:0.918 blue:0.808 alpha:1.00];
    [self.view addSubview:self.container];
    // 重启加载
    [self.container reloadData];
}

- (void)loadData {
    _dataSources = [NSMutableArray array];
    for (int i = 0; i < 9; i++) {
        NSDictionary *dict = @{@"image" : [NSString stringWithFormat:@"image_%d.jpg",i + 1],
                               @"title" : [NSString stringWithFormat:@"Page %d",i + 1]};
        [_dataSources addObject:dict];
    }
}

//MARK: - dataSource
- (PGQBaseCardView *)dragCardContainerView:(PGQDragCardContainerView *)cardContainerView viewForIndex:(NSInteger)index {

    PGQCustomCardView *cardView = [[PGQCustomCardView alloc] initWithFrame:cardContainerView.bounds];
    [cardView installData:[_dataSources objectAtIndex:index]];
    return cardView;
}

- (NSInteger)numberOfIndexs {
    return  _dataSources.count;
}

//MARK: - delegate
- (void)dragCardContainerView:(PGQDragCardContainerView *)cardContainerView direction:(PGQDragCardDirection)direction widthScale:(CGFloat)widthScale heightScale:(CGFloat)heightScale {
}

- (void)dragCardContainerView:(PGQDragCardContainerView *)cardContainerView cardView:(PGQBaseCardView *)cardView didSelectIndex:(NSInteger)selecrIndex {
    NSLog(@"点击了card");
}

- (void)dragCardContainerView:(PGQDragCardContainerView *)cardContainerView removeLastCard:(BOOL)removeLastCard {

    [cardContainerView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
