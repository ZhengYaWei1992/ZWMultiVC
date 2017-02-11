//
//  ZWPageContentView.m
//  ZWMultiVC
//
//  Created by 郑亚伟 on 2017/2/7.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWPageContentView.h"


@interface ZWPageContentView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation ZWPageContentView

- (instancetype)initWithFrame:(CGRect)frame withChildVCs:(NSArray <UIViewController *> *)childVCs parentViewController:(UIViewController *)parentViewController{
    if (self == [super initWithFrame:frame]) {
        self.childVCs = childVCs;
        self.parentViewController = parentViewController;
        [self setupUI];
    }
    return self;
}
- (void)setupUI{
    //1.将所有的子控制器添加到父控制器中
    for (UIViewController *childVc in self.childVCs) {
        [self.parentViewController addChildViewController:childVc];
    }
    //2.添加UICollectionView，用于在cell上存放控制器的view
    [self addSubview:self.collectionView];
}
#pragma mark-collectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.childVCs.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //UICollectionView只有通过下面的方法查找可复用cell，所以对于UICollectionView，必须注册cell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //设置cell的内容
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    UIViewController *childVC = self.childVCs[indexPath.row];
    childVC.view.frame = cell.contentView.frame;
    [cell.contentView addSubview:childVC.view];
    
    
    return cell;
}

#pragma mark-scrollView的代理方法
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.isForbidScrollDelegate = NO;
    //每次开始滑动的时候，都会先设置self.startOffsetX
    self.startOffsetX = scrollView.contentOffset.x;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //0.判断是否是点击事件
    if (self.isForbidScrollDelegate == YES){
        return;
    }
    //1.获取需要的数据 （滚动的进度、sourceIndex（颜色渐变）、targetIndex（要判断左滑还是右滑））
    CGFloat progress = 0;
    NSInteger sourceIndex = 0;
    NSInteger targetIndex = 0;
    //2.判断是左还是右滑动
    CGFloat currentOffsetX = scrollView.contentOffset.x;
    CGFloat scrollViewW = scrollView.bounds.size.width;
    if (currentOffsetX > self.startOffsetX) {//左滑
        //1.计算progress
        progress = currentOffsetX / scrollViewW - (NSInteger)(currentOffsetX / scrollViewW);
        //2.计算sourceIndex
        sourceIndex = (NSInteger)(currentOffsetX / scrollViewW);
        //3.计算currentIndex
        targetIndex = sourceIndex + 1;
        //防止越界
        if (targetIndex >= _childVCs.count) {
            targetIndex = _childVCs.count - 1;
        }
        //4.如果完全滑过去
        if (currentOffsetX - self.startOffsetX == scrollViewW) {
            progress = 1;
            targetIndex = sourceIndex;
        }
    }else{//右滑
        //1.计算progress
        progress = 1 - (currentOffsetX / scrollViewW - (NSInteger)(currentOffsetX / scrollViewW));
        //2.计算currentIndex
        targetIndex = (NSInteger)(currentOffsetX / scrollViewW);
        //3.计算sourceIndex
        sourceIndex = targetIndex + 1;
        if (targetIndex >= _childVCs.count) {
            targetIndex = _childVCs.count - 1;
        }
    }
    
    //3.将progress/sourceIndex/targetIndex传递给progress
    //print("progress\(progress) sourceIndex\(sourceIndex) targetIndex \(targetIndex)")
    if ([self.delegate respondsToSelector:@selector(pageContentView:progress:sourceIndex:targetIndex:)]) {
        [self.delegate pageContentView:self progress:progress sourceIndex:sourceIndex targetIndex:targetIndex];
    }
    
}

#pragma mark - 对外暴露的方法
- (void)setCurrentIndex:(NSInteger)currentIndex{
    // 1.记录需要进制执行代理方法
    _isForbidScrollDelegate = YES;
    // 2.滚动正确的位置
    CGFloat offSetX = (CGFloat)currentIndex * self.collectionView.frame.size.width;
    [self.collectionView setContentOffset:CGPointMake(offSetX, 0) animated:YES];
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //线性布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //水平方向，元素之间的最小距离
        layout.minimumInteritemSpacing = 0;
        //行之间的最小距离
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置元素的大小
        layout.itemSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
        
//        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.channelView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.channelView.frame));
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView = collectionView;
    }
    return _collectionView;
}


@end
