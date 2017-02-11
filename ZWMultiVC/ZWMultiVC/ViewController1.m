//
//  ViewController1.m
//  ZWMultiVC
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ViewController1.h"

@interface ViewController1 ()

@end

@implementation ViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc]init];
    label.bounds = CGRectMake(0, 0, 100, 100);
    label.text = @"vc1";
    label.center = self.view.center;
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UIViewController *vc = [[UIViewController alloc]init];
    vc.view.backgroundColor = [UIColor whiteColor];
    //下面这两句是让系统的返回按钮的文字为空,从而达到隐藏文字的作用
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"zwback" style:UIBarButtonItemStyleDone target:nil action:nil];
    //注意，因为是多视图联动的情况，所以要添加
    self.parentViewController.navigationItem.backBarButtonItem = backItem;
    //这句就是push了，所以在push前加上这样一句，就保留了系统的自带的“<"，并且文字为空
    [self.navigationController pushViewController:vc animated:YES];
    

}

@end
