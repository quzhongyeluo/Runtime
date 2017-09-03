//
//  UIImageView+ClickBlock.m
//  Runtime
//
//  Created by 曲终叶落 on 2017/9/3.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "UIImageView+ClickBlock.h"
#import <objc/message.h>



@interface UIImageView ()

@property (nonatomic,strong) UITapGestureRecognizer *tag;

@end

@implementation UIImageView (ClickBlock)

static const void *clickKey = @"clickKey";

- (void)setClickBlock:(ClickBlcok)clickBlock{
    
    objc_setAssociatedObject(self, clickKey, clickBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
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
    return objc_getAssociatedObject(self, clickKey);
}


- (void)clickAction{
    if (self.clickBlock) {
        self.clickBlock();
    }
}

@end
