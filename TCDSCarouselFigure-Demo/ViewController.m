//
//  ViewController.m
//  TCDSCarouselFigure-Demo
//
//  Created by admin on 16/6/16.
//  Copyright © 2016年 TCDS. All rights reserved.
//

#import "ViewController.h"
#import "TCDSCarouselFigure.h"
#import "TCDSViewController.h"

@interface ViewController () <TCDSCarouselFigureDelegate> {
    TCDSCarouselFigure *_carouselFigure;
}

@property (strong, nonatomic) NSMutableArray *images;
@property (weak, nonatomic) IBOutlet UISwitch *loopSwitch;

@end

@implementation ViewController

- (IBAction)urlSourceType:(id)sender {
    TCDSViewController *new = [[TCDSViewController alloc]init];
    new.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:new animated:YES completion:nil];
}

- (IBAction)valueChanged:(id)sender {
    if (_loopSwitch.on) {
        [_carouselFigure startLoop];
    }
    else {
        [_carouselFigure stopLoop];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _carouselFigure = [[TCDSCarouselFigure alloc]initWithImages:self.images frame:CGRectMake(0, 22, self.view.frame.size.width, self.view.frame.size.width * 9 / 16)];
    [self.view addSubview:_carouselFigure];
    _carouselFigure.delegate = self;
    
    
    [_loopSwitch setOn:NO];
    // Do any additional setup after loading the view, typically from a nib.
}


-(NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray arrayWithArray:@[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"],[UIImage imageNamed:@"3"],[UIImage imageNamed:@"4"],[UIImage imageNamed:@"5"],[UIImage imageNamed:@"6"],[UIImage imageNamed:@"7"],[UIImage imageNamed:@"8.jpg"],[UIImage imageNamed:@"9.jpg"]]];
    }
    return _images;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)carouseFigurePageValueDidChanged:(TCDSCarouselFigure *)carouseFigure {
    NSLog(@"当前是第 %ld 页", carouseFigure.pageControl.currentPage + 1);
}

@end
