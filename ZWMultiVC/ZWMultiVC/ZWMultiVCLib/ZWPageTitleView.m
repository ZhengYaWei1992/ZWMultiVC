//
//  ZWPageTitleView.m
//  ZWMultiVC
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWPageTitleView.h"

//指示线的高度
#define kScrollLineH 2
@interface ZWPageTitleView ()

/**
 页面标题
 */
@property(nonatomic,strong)NSArray *titles;
/**
 当前选中的下标
 */
@property(nonatomic,assign)NSInteger currentIndex;


@property(nonatomic,strong)UIScrollView *scrollView;

@property(nonatomic,strong)UIView *scrollLine;

@property(nonatomic,strong)NSMutableArray <UILabel *>*titlesLabel;

@end

@implementation ZWPageTitleView

- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles{
    if (self == [super initWithFrame:frame]) {
        self.titles = titles;
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    //1.添加scrollView
    [self addSubview:self.scrollView];
    //2.添加titles对应的label
    [self setupTitleLabels];
    //3.设置底线和滑块
    [self setupBottomMenuAndScrollLine];
}

- (void)setupTitleLabels{
    CGFloat labelW = self.frame.size.width / (CGFloat)self.titles.count;
    CGFloat labelH = self.frame.size.height - kScrollLineH * 2;
    CGFloat labelY = 0;
    NSInteger i = 0;
    for (NSString *title in self.titles) {
        
        UILabel *label = [[UILabel alloc]init];
        label.text = title;
        label.textColor = self.titleColor;
        label.tag = i;
        label.font = self.font;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = CGRectMake(labelW * i, labelY, labelW, labelH);
        [self.scrollView addSubview:label];
        
        [self.titlesLabel addObject:label];
        //给label添加手势
        label.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleLabelClick:)];
        [label addGestureRecognizer:tap];
        i++;
    }
}
#pragma mark - titleLabel的点击事件
- (void)titleLabelClick:(UITapGestureRecognizer *)tap{
    //1.获取当前点击label
    UILabel *currentLabel = (UILabel *)tap.view;
    //2.获取之前label
    UILabel *oldLabel = self.titlesLabel[_currentIndex];
    //3.切换文字颜色
    currentLabel.textColor = self.selectedTitleColor;
    oldLabel.textColor = self.titleColor;
    //4.保存最新label 的下标
    self.currentIndex = currentLabel.tag;
    //5.滚动条位置变化
    CGFloat scrollLineX = currentLabel.tag * _scrollLine.frame.size.width;
    [UIView animateWithDuration:0.5 animations:^{
        CGRect scrollLineFrame = self.scrollLine.frame;
        scrollLineFrame.origin.x = scrollLineX;
        self.scrollLine.frame = scrollLineFrame;
    }];
    //6.通知代理做事情
    if ([self.delegate respondsToSelector:@selector(pageTitltView:didSelectedIndex:)]) {
        [self.delegate pageTitltView:self didSelectedIndex:self.currentIndex];
    }
}

- (void)setupBottomMenuAndScrollLine{
    //1.添加底线
    UIView *bottomLine = [[UIView alloc]init];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    bottomLine.frame = CGRectMake(0, self.frame.size.height - kScrollLineH, self.frame.size.width, kScrollLineH);
    [self.scrollView addSubview:bottomLine];
    //2.添加scrollLine
    //2.1获取第一个label
    UILabel *firstLabel = [_titlesLabel firstObject];
    firstLabel.textColor = self.selectedTitleColor;
    //2.2设置scrollLine的属性
    self.scrollLine.frame = CGRectMake(firstLabel.frame.origin.x, self.frame.size.height - kScrollLineH, firstLabel.frame.size.width, kScrollLineH);
     [self.scrollView addSubview:self.scrollLine];
}
#pragma mark - 对外暴露的方法
- (void)setTitltWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex{
    //1.取出sourceLabel和targetLabel
    UILabel *sourceLabel = (UILabel *)self.titlesLabel[sourceIndex];
    UILabel *targetLabel = (UILabel *)self.titlesLabel[targetIndex];
    //2.处理滑动的逻辑
    CGFloat moveTotalX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x;
    CGFloat moveX = moveTotalX * progress;
    CGRect scrollLineFrame = self.scrollLine.frame;
    scrollLineFrame.origin.x = sourceLabel.frame.origin.x + moveX;
    self.scrollLine.frame = scrollLineFrame;
    
    //3.颜色的渐变
//    // 3.1.取出变化的范围
//    let colorDelta = (kSelectColor.0 - kNormalColor.0, kSelectColor.1 - kNormalColor.1, kSelectColor.2 - kNormalColor.2)
//    // 3.2.变化sourceLabel
//    sourceLabel.textColor = UIColor(r: kSelectColor.0 - colorDelta.0 * progress, g: kSelectColor.1 - colorDelta.1 * progress, b: kSelectColor.2 - colorDelta.2 * progress)
//    // 3.2.变化targetLabel
//    targetLabel.textColor = UIColor(r: kNormalColor.0 + colorDelta.0 * progress, g: kNormalColor.1 + colorDelta.1 * progress, b: kNormalColor.2 + colorDelta.2 * progress)
    
    // 4.记录最新的index
    _currentIndex = targetIndex;
}

#pragma mark-懒加载方法
-(UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    }
    return _scrollView;
}

- (UIFont *)font{
    if (_font == nil) {
        _font = [UIFont systemFontOfSize:17];
    }
    return _font;
}

- (UIView *)scrollLine{
    if (_scrollLine == nil) {
        _scrollLine = [[UIView alloc]init];
        _scrollLine.backgroundColor = self.selectedTitleColor;
    }
    return _scrollLine;
}
- (NSMutableArray<UILabel *> *)titlesLabel{
    if (_titlesLabel == nil) {
        _titlesLabel = [NSMutableArray array];
    }
    return _titlesLabel;
}
- (UIColor *)titleColor{
    if (_titleColor == nil) {
        //设置默认颜色
        _titleColor = [UIColor blackColor];
    }
    return _titleColor;
}
-(UIColor *)selectedTitleColor{
    if (_selectedTitleColor == nil) {
        _selectedTitleColor = [UIColor orangeColor];
    }
    return _selectedTitleColor;
}
@end
