//
//  SDMajletView.h
//  SDMajletManagerDemo
//
//  Created by tianNanYiHao on 2017/5/26.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#pragma mark - 杉德子件View
#import <UIKit/UIKit.h>

typedef void(^SDMajletBlock)(NSMutableArray *inusesTitles , NSMutableArray *unusesTitles);

@interface SDMajletView : UIView



/**
 上半部分数组
 */
@property (nonatomic, strong) NSMutableArray *inUseTitles;

/**
 下半部分数组
 */
@property (nonatomic,strong) NSMutableArray *unUseTitles;


/**
 回调block
 */
@property (nonatomic, weak)SDMajletBlock block;



/**
 初始化
 
 @param frame frame
 @return SDMajletView实例
 */
- (instancetype)initWithFrame:(CGRect)frame;



/**
 回调方法返回上下数组

 @param block 代码块
 */
- (void)callBacktitlesBlock:(SDMajletBlock)block;



@end
