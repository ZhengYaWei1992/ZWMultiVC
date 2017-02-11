//
//  ViewController.m
//  ZWMultiVC
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
#import "ViewController2.h"
#import "ViewController3.h"
#import "ViewController4.h"

#import "ZWPageTitleView.h"
#import "ZWPageContentView.h"


@interface ViewController ()<ZWPageTitleViewDelegate,ZWPageContentViewDelegate>
@property(nonatomic,strong)ZWPageTitleView *pageTitleView;
@property(nonatomic,strong)ZWPageContentView *pageContentView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //这句代码不写上scrollView中的内容不会显示
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"多视图联动";
    
    NSArray *titles = [NSArray arrayWithObjects:@"推荐",@"游戏",@"娱乐相关",@"趣玩", nil];
    _pageTitleView = [[ZWPageTitleView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 40) withTitles:titles];
    _pageTitleView.delegate = self;
    _pageTitleView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.pageTitleView];
    
    
    CGRect contentFrame = CGRectMake(0, 64 + 40, self.view.frame.size.width, self.view.frame.size.height - 64 - 40);
    NSMutableArray *childVCs = [NSMutableArray array];
    for (NSInteger i = 0; i < 4; i++) {
        if (i == 0) {
            ViewController1 *vc = [[ViewController1 alloc]init];
            [childVCs addObject:vc];
        }else if(i == 1){
            ViewController2 *vc = [[ViewController2 alloc]init];
            [childVCs addObject:vc];
        }else if(i == 2){
            ViewController3 *vc = [[ViewController3 alloc]init];
            [childVCs addObject:vc];
        }else if(i == 3){
            ViewController4 *vc = [[ViewController4 alloc]init];
            [childVCs addObject:vc];
        }
        
    }
    _pageContentView = [[ZWPageContentView alloc]initWithFrame:contentFrame withChildVCs:childVCs parentViewController:self];
    _pageContentView.delegate = self;
    [self.view addSubview:_pageContentView];
}

#pragma mark-ZWPageTitleViewDelegate
- (void)pageTitltView:(ZWPageTitleView *)pageTitleView didSelectedIndex:(NSInteger)index{
    [self.pageContentView setCurrentIndex:index];
}
#pragma mark - ZWPageContentViewDelegate
- (void)pageContentView:(ZWPageContentView *)pageContenView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    [self.pageTitleView setTitltWithProgress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
}



@end
