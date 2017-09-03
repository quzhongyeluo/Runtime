//
//  UIImageView+ClickBlock.m
//  Runtime
//
//  Created by 曲终叶落 on 2017/9/3.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "UIImageView+QZ_ClickBlock.h"
#import <objc/message.h>

/*
 objc_setAssociatedObject来把一个对象与另外一个对象进行关联。该函数需要四个参数：源对象，关键字，关联的对象和一个关联策略。
 
 OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。
 
 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；还有这种关联是原子的还是非原子的。这里的关联策略和声明属性时的很类似。这种关联策略是通过使用预先定义好的常量来表示的。
 */

@interface UIImageView ()

@property (nonatomic,strong) UITapGestureRecognizer *tag;

@end

@implementation UIImageView (ClickBlock)

static const void *qz_clickKey = @"qz_clickKey";

- (void)setClickBlock:(ClickBlcok)clickBlock{
    
    objc_setAssociatedObject(self, qz_clickKey, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    self.userInteractionEnabled = true;
    
    if (self.tag) {
        [self removeGestureRecognizer:self.tag];
    }
    
    if (clickBlock) {
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAction)];
        [self addGestureRecognizer:tag];
    }

}

- (ClickBlcok)clickBlock{
    return objc_getAssociatedObject(self, qz_clickKey);
}


- (void)clickAction{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
