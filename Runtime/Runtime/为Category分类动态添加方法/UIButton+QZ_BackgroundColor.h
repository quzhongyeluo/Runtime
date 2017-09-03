//
//  UIButton+QZ_BackgroundColor.h
//  Runtime
//
//  Created by 曲终叶落 on 2017/9/3.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 为UIButton添加设置 在不同状态下背景色
 缺点：无法根据状态改变文字 （不知道如何解决 - 麻烦知道的告知下）
 */
@interface UIButton (QZ_BackgroundColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
