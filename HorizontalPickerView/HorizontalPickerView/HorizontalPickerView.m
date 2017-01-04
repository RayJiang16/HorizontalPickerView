//
//  HorizontalPickerView.m
//  HorizontalPickerView
//
//  Created by Emily on 2017/1/4.
//  Copyright © 2017年 Ray. All rights reserved.
//

#import "HorizontalPickerView.h"

#define khMaxLoop   20
#define khHalfLoop  (khMaxLoop*0.5)
#define khItemEdge  5
#define khFontSize  17
#define khTextColor [UIColor blackColor]

/**
 * 保存一个Cell左右两端的x
 */
@interface PickerViewCellOrigin : NSObject
/// Cell在HPV(HorizontalPickerView)中最左边的contentOffSet.x
@property (nonatomic, assign) CGFloat begin;
/// Cell在HPV中最右边的contentOffSet.x
@property (nonatomic, assign) CGFloat end;

/**
 * 给定一个begin和end创建一个PickerViewCellOrigin对象
 * @param  begin Cell最左边的x
 * @param  end   Cell最右边的x
 * @return 返回PickerViewCellOrigin对象
 */
+ (instancetype)originWithBegin:(CGFloat)begin end:(CGFloat)end;

/**
 * 判断一个x是否在begin和end中间，判断方法 x>=begin && x<end
 * @param  x 坐标
 * @return YES-x在begin和end中间，NO-不在
 */
- (BOOL)isBetweenCell:(CGFloat)x;
@end

@implementation PickerViewCellOrigin
+ (instancetype)originWithBegin:(CGFloat)begin end:(CGFloat)end {
    PickerViewCellOrigin *origin = [PickerViewCellOrigin new];
    origin.begin = begin;
    origin.end = end;
    return origin;
}

- (BOOL)isBetweenCell:(CGFloat)x {
    return x >= self.begin && x < self.end;
}

@end

/**
 * 自定义CollectionViewCell
 */
@interface PickerViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *label;
@end

@implementation PickerViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _label = [UILabel new];
        _label.numberOfLines = 0;
        _label.frame = self.bounds;
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:khFontSize];
        _label.textColor = khTextColor;
        [self addSubview:_label];
    }
    return self;
}

@end


@interface HorizontalPickerView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<PickerViewCellOrigin *> *originArray;
@property (nonatomic, strong) NSArray<NSString *> *itemsArray;
@property (nonatomic, assign, getter=isLoop) BOOL loop;
@property (nonatomic, strong) NSNumber *loopTimes;

@end

@implementation HorizontalPickerView

static NSString * const reuseIdentifier = @"HorizontalPickerViewCell";

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.loopTimes = @(0);
        self.backgroundColor = [UIColor whiteColor];
        [self initView:frame];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<NSString *> *)itemsArray isLoop:(BOOL)isLoop {
    self.itemsArray = itemsArray;
    self.loop = isLoop;
    return [self initWithFrame:frame];
}

- (void)initView:(CGRect)frame {
    // 初始化collectionView
    self.collectionView = [self createCollectionViewWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    [self addSubview:self.collectionView];
    !self.isLoop ?: [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:self.itemsArray.count*khHalfLoop inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
    // 设置collectionView两边的透明度
    CAGradientLayer *maskLayer = [CAGradientLayer layer];
    maskLayer.frame = self.collectionView.bounds;
    maskLayer.colors = @[(id)[[UIColor clearColor] CGColor],
                         (id)[khTextColor CGColor],
                         (id)[khTextColor CGColor],
                         (id)[[UIColor clearColor] CGColor],];
    maskLayer.locations = @[@0.0, @0.33, @0.66, @1.0];
    maskLayer.startPoint = CGPointMake(0.0, 0.0);
    maskLayer.endPoint = CGPointMake(1.0, 0.0);
    self.collectionView.layer.mask = maskLayer;
}

- (void)drawRect:(CGRect)rect {
    // 绘制中间的黑框
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((CGRectGetWidth(rect)-[self getMaxWidth]-khItemEdge)*0.5, 1, [self getMaxWidth]+khItemEdge, CGRectGetHeight(rect)-2) cornerRadius:10];
    path.lineWidth = 1;
    [[UIColor blackColor] setStroke];
    [path stroke];
}

#pragma mark - 公开方法
- (void)scrollToItemWithIndex:(NSInteger)index {
    if (self.isLoop) {
        index += khHalfLoop * self.itemsArray.count;
    }
    [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
}

#pragma mark <Delegate>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.isLoop ? self.itemsArray.count*khMaxLoop : self.itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item % self.itemsArray.count;
    PickerViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.label.text = self.itemsArray[index];
    //cell.backgroundColor = [UIColor redColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger index = indexPath.item;
    CGFloat begin = 0;
    while (index >= self.itemsArray.count) {
        index -= self.itemsArray.count;
        begin += (([self getMaxWidth]+khItemEdge)*self.itemsArray.count - [self getMaxWidth]*0.5);
        begin += fabs(self.originArray[0].begin);
    }
    begin += self.originArray[index].begin < 0 ? 1 : self.originArray[index].begin;
    [self autoSelectItemWithX:begin];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self callDelegateWithX:scrollView.contentOffset.x];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.collectionView.layer.mask.frame = self.collectionView.bounds;
    [CATransaction commit];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self autoSelectItemWithX:scrollView.contentOffset.x];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    decelerate ?: [self autoSelectItemWithX:scrollView.contentOffset.x];
}

#pragma mark - 私有方法
- (UICollectionView *)createCollectionViewWithFrame:(CGRect)frame {
    UICollectionView *collectionView = nil;
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.itemSize = CGSizeMake([self getMaxWidth], CGRectGetHeight(frame));
    layout.minimumLineSpacing = khItemEdge;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, khItemEdge);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.headerReferenceSize = CGSizeMake(CGRectGetWidth(frame)*0.5-[self getMaxWidth]*0.5, CGRectGetHeight(frame));
    layout.footerReferenceSize = CGSizeMake(CGRectGetWidth(frame)*0.5-[self getMaxWidth]*0.5-khItemEdge, CGRectGetHeight(frame));
    
    collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    [collectionView registerClass:[PickerViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    collectionView.backgroundColor = [UIColor clearColor];
    
    return collectionView;
}

/// 从itemsArray中获取最长文本的宽度
- (CGFloat)getMaxWidth {
    static CGFloat width = 0;
    if (width != 0) return width;
    for (NSString *str in self.itemsArray) {
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:khFontSize]};
        CGSize textSize = [str boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
        width = textSize.width > width ? textSize.width : width;
    }
    return width;
}

/// originArray的get方法，根据itemsArray的数据计算出每一个元素的Origin
- (NSArray<PickerViewCellOrigin *> *)originArray {
    if (!_originArray) {
        NSMutableArray *mutableArray = [NSMutableArray array];
        CGFloat begin = 0-[self getMaxWidth]*0.5;
        for (int i = 0; i < self.itemsArray.count; i++) {
            CGFloat end = begin + [self getMaxWidth] + khItemEdge;
            PickerViewCellOrigin *origin = [PickerViewCellOrigin originWithBegin:begin end:end];
            begin = end;
            [mutableArray addObject:origin];
        }
        _originArray = [mutableArray mutableCopy];
    }
    return _originArray;
}

/// 当HPV滚动到两个Cell中间时，自动选择更贴近中间的Cell
- (void)autoSelectItemWithX:(CGFloat)x {
    int times = 0;
    while (self.originArray[self.itemsArray.count-1].end <= x) {
        x -= (([self getMaxWidth]+khItemEdge)*self.itemsArray.count - [self getMaxWidth]*0.5);
        x -= fabs(self.originArray[0].begin);
        times++;
    }
    int i = 0;
    for (i = 0; i < self.itemsArray.count; i++) {
        PickerViewCellOrigin *origin = self.originArray[i];
        if ([origin isBetweenCell:x]) {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i+self.itemsArray.count*times inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            break;
        }
    }
    // 调用代理
    if ([self.delegate respondsToSelector:@selector(didSelectItem:)]) {
        [self.delegate didSelectItem:i];
    }
    
    // 重定向到中间
    if (!self.isLoop) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:0.5];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:i+self.itemsArray.count*khHalfLoop inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            self.loopTimes = @(0);
        });
    });
}

/// 根据x判断是否向前(向后)循环
- (void)callDelegateWithX:(CGFloat)x {
    if (!self.isLoop) return;
    CGFloat onceLoop = (([self getMaxWidth]+khItemEdge)*self.itemsArray.count - [self getMaxWidth]*0.5);
    CGFloat begin = (khHalfLoop-1) * (onceLoop + fabs(self.originArray[0].begin)) + onceLoop;
    CGFloat end = begin + onceLoop + fabs(self.originArray[0].begin);
    if (x >= begin && x < end) return;
    
    int times = 0;
    BOOL isLoopForward = YES;
    if (x < begin) {      // 向左Loop eg.2016<-2017
        x = begin - x;
        isLoopForward = NO;
    } else if (x > end) { // 向右Loop eg.2016->2017
        x = x - end;
        isLoopForward = YES;
    }
    while (x > 0) {
        x -= (onceLoop+fabs(self.originArray[0].begin));
        times++;
    }
    if (times>[self.loopTimes intValue]) {
        self.loopTimes = @(times);
        if (isLoopForward && [self.delegate respondsToSelector:@selector(didLoopForward)]) {
            [self.delegate didLoopForward];
        } else if (!isLoopForward && [self.delegate respondsToSelector:@selector(didLoopBack)]) {
            [self.delegate didLoopBack];
        }
    }
}

@end
