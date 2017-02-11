//
//  ZWPageTitleView.h
//  ZWMultiVC
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWPageTitleView;
@protocol ZWPageTitleViewDelegate <NSObject>

- (void)pageTitltView:(ZWPageTitleView *)pageTitleView didSelectedIndex:(NSInteger)index;

@end

@interface ZWPageTitleView : UIView


/**
 代理
 */
@property(nonatomic,weak)id<ZWPageTitleViewDelegate>delegate;

/**
 页面标题正常颜色
 */
@property(nonatomic,strong)UIColor *titleColor;

/**
 选中的标题颜色
 */
@property(nonatomic,strong)UIColor *selectedTitleColor;

/**
 正常情况下标题大小
 */
@property(nonatomic,strong)UIFont *font;

/**
 选中情况下标题大小
 */
@property(nonatomic,strong)UIFont *selectedFont;


/**
 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame withTitles:(NSArray *)titles;

//对外暴露的方法，切换当前显示的titleView
- (void)setTitltWithProgress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetInde;
@end
