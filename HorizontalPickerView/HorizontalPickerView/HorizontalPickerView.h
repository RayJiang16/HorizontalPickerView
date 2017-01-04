//
//  HorizontalPickerView.h
//  HorizontalPickerView
//
//  Created by Emily on 2017/1/4.
//  Copyright © 2017年 Ray. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HorizontalPickerViewDelegate <NSObject>
@optional
/**
 * 当HorizontalPickerView向左循环时调用的方法 eg.2016-12 <- 2017-1
 */
- (void)didLoopForward;

/**
 * 当HorizontalPickerView向右循环时调用的方法 eg.2016-12 -> 2017-1
 */
- (void)didLoopBack;

/**
 * 当HorizontalPickerView选中了一个Item时调用的方法
 * @param  index 选中的下标
 */
- (void)didSelectItem:(NSInteger)index;

@end

@interface HorizontalPickerView : UIView
@property (nonatomic, weak) id<HorizontalPickerViewDelegate> delegate;

/**
 * 初始化方法
 * @param  frame 在父视图中的位置(重点的size) 
 * @param  itemsArray item的个数以及内容
 * @param  isLoop 是否循环
 * @return 返回创建好的HorizontalPickerView对象
 */
- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<NSString *> *)itemsArray isLoop:(BOOL)isLoop;

/**
 * 滚动到一个item的位置
 * @param index item的下标
 */
- (void)scrollToItemWithIndex:(NSInteger)index;

@end
