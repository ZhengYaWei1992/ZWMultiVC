//
//  ViewController4.m
//  ZWMultiVC
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ViewController4.h"

@interface ViewController4 ()

@end

@implementation ViewController4

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    UILabel *label = [[UILabel alloc]init];
    label.bounds = CGRectMake(0, 0, 100, 100);
    label.text = @"vc4";
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}



@end
