//
//  UIImageView+ClickBlock.h
//  Runtime
//
//  Created by 曲终叶落 on 2017/9/3.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import <UIKit/UIKit.h>


/*
 
 为UIImageView添加点击事件
 */

typedef void(^ClickBlcok)();

@interface UIImageView (ClickBlock)

@property (nonatomic, copy ) ClickBlcok clickBlock;

@end
