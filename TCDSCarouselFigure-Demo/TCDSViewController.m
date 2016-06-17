//
//  TCDSViewController.m
//  TCDSCarouselFigure-Demo
//
//  Created by admin on 16/6/16.
//  Copyright © 2016年 TCDS. All rights reserved.
//

#import "TCDSViewController.h"
#import "TCDSCarouselFigure.h"

@interface TCDSViewController () {
    NSMutableArray *_arr;
}

@end

@implementation TCDSViewController
- (void)goBackToFirstPage:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, self.view.frame.size.height / 2, 100, 40);
    [button setTitle:@"Go Back" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(goBackToFirstPage:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _arr = [NSMutableArray arrayWithObjects:@"http://bt.img.17gwx.com/topic/0/4/dllf/600x330", @"http://bt.img.17gwx.com/topic/0/5/d1he/600x330", @"http://bt.img.17gwx.com/topic/0/12/c1NdYQ/600x330", @"http://bt.img.17gwx.com/topic/0/6/dFVY/600x330", @"http://bt.img.17gwx.com/topic/0/2/cFdZ/600x330", @"http://bt.img.17gwx.com/topic/0/21/cFBYZQ/600x330", nil];
    
    
    TCDSCarouselFigure *carouselFigure = [[TCDSCarouselFigure alloc]initWithImageURLs:_arr frame:CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.width * 9 / 16)];
    carouselFigure.pageControl.pageIndicatorTintColor = [UIColor purpleColor];
    carouselFigure.pageControl.currentPageIndicatorTintColor = [UIColor cyanColor];
    
    [self.view addSubview:carouselFigure];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
