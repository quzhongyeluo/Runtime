//
//  UIButton+QZ_RepeatClick.m
//  Runtime
//
//  Created by 曲终叶落 on 2017/9/3.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "UIButton+QZ_RepeatClick.h"
#import <objc/message.h>

@interface UIButton ()

/**
 上次点击时间
 */
@property (nonatomic, assign) NSTimeInterval preInterval;

@end

@implementation UIButton (QZ_RepeatClick)


static const char *UIControl_Interval = "UIControl_Interval";
static const char *UIControl_PreInterval = "UIControl_PreInterval";

- (NSTimeInterval)interval {
    return  [objc_getAssociatedObject(self, UIControl_Interval) doubleValue];
}

- (void)setInterval:(NSTimeInterval)interval{
    objc_setAssociatedObject(self, UIControl_Interval, @(interval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSTimeInterval)preInterval {
    return  [objc_getAssociatedObject(self, UIControl_PreInterval) doubleValue];
}

- (void)setPreInterval:(NSTimeInterval)preInterval{
    objc_setAssociatedObject(self, UIControl_PreInterval, @(preInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


// 在load时执行hook : 替换系统方法
+ (void)load {
    Method before   = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method after    = class_getInstanceMethod(self, @selector(qz_sendAction:to:forEvent:));
    method_exchangeImplementations(before, after);
}


- (void)qz_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    
    if ([NSDate date].timeIntervalSince1970 - self.preInterval < self.interval) {
        return;
    }
    
    if (self.interval > 0) {
        self.preInterval = [NSDate date].timeIntervalSince1970;
    }
    
    [self qz_sendAction:action to:target forEvent:event];
}

@end
