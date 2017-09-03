//
//  UIButton+QZ_RepeatClick.h
//  Runtime
//
//  Created by 曲终叶落 on 2017/9/3.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 解决重复点击的问题 ：代码注入 ， 把系统方法替换成自己的方法
 
 hook:思想
 
 */

@interface UIButton (QZ_RepeatClick)


/**
 重复点击的间隔
 */
@property (nonatomic, assign) NSTimeInterval interval;

@end
