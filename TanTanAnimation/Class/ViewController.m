//
//  ViewController.m
//  TanTanAnimation
//
//  Created by Lois_pan on 16/12/19.
//  Copyright © 2016年 Lois_pan. All rights reserved.
//

#import "ViewController.h"
#import "CardViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:button];
}

- (void)buttonClick {

    CardViewController * cardViewController = [[CardViewController alloc] init];
    
    [self.navigationController pushViewController:cardViewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
