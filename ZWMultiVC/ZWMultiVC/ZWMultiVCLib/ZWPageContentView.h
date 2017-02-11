//
//  ZWPageContentView.h
//  ZWMultiVC
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWPageContentView;
@protocol ZWPageContentViewDelegate <NSObject>
- (void)pageContentView:(ZWPageContentView *)pageContenView progress:(CGFloat)progress sourceIndex:(NSInteger)sourceIndex targetIndex:(NSInteger)targetIndex;

@end


@interface ZWPageContentView : UIView

/**
 代理
 */
@property(nonatomic,weak)id<ZWPageContentViewDelegate>delegate;
/**
 子视图控制器
 */
@property(nonatomic,strong)NSArray <UIViewController *>*childVCs;

/**
 父视图控制器
 */
@property(nonatomic,strong)UIViewController *parentViewController;

 /// 为了防止点击label时，先调用label的点击方法，然后scrollView滚动方法（这个是没有必要调用的），scrollView滚动进而又会调用pageTitleView对外公开的方法。所以用了这个属性进行判断
@property(nonatomic,assign)BOOL isForbidScrollDelegate;
//用于保存滑动开始那一刻的偏移量，进而和滚动完成后的偏移量比较，判断是左滑动还是右滑
@property(nonatomic,assign)CGFloat startOffsetX;


- (instancetype)initWithFrame:(CGRect)frame withChildVCs:(NSArray <UIViewController *> *)childVCs parentViewController:(UIViewController *)parentViewController;

//设置collection的contentOffset
- (void)setCurrentIndex:(NSInteger)currentIndex;
@end
