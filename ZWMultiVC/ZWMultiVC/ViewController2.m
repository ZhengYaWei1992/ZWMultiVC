//
//  ViewController2.m
//  ZWMultiVC
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ViewController2.h"

@interface ViewController2 ()

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc]init];
    label.bounds = CGRectMake(0, 0, 100, 100);
    label.text = @"vc2";
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}



@end
