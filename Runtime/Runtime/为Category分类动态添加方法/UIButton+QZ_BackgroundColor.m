//
//  UIButton+QZ_BackgroundColor.m
//  Runtime
//
//  Created by 曲终叶落 on 2017/9/3.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "UIButton+QZ_BackgroundColor.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, strong) NSMutableDictionary *backgroundColorDict;

@end



@implementation UIButton (QZ_BackgroundColor)

static const void *qz_key_backgroundColor           = @"qz_key_backgroundColor";

static NSString *qz_forUIControlStateNormal         = @"qz_forUIControlStateNormal";
static NSString *qz_forUIControlStateHighlighted    = @"qz_forUIControlStateHighlighted";
static NSString *qz_forUIControlStateDisabled       = @"qz_forUIControlStateDisabled";
static NSString *qz_forUIControlStateSelected       = @"qz_forUIControlStateSelected";

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state{
    
    if (!self.backgroundColorDict) {
        self.backgroundColorDict = [NSMutableDictionary dictionary];
    }
    
    [self.backgroundColorDict setObject:backgroundColor forKey:[self qz_forUIControlState:state]];
}

- (NSString *)qz_forUIControlState:(UIControlState)state {
    NSString *string;
    switch (state) {
        case UIControlStateNormal:
            string = qz_forUIControlStateNormal;
            break;
        case UIControlStateHighlighted:
            string = qz_forUIControlStateHighlighted;
            break;
        case UIControlStateDisabled:
            string = qz_forUIControlStateDisabled;
            break;
        case UIControlStateSelected:
            string = qz_forUIControlStateSelected;
            break;
        default:
            string = qz_forUIControlStateNormal;
            break;
    }
    return string;
}

- (void)setBackgroundColorDict:(NSMutableDictionary *)backgroundColorDict{
    objc_setAssociatedObject(self, qz_key_backgroundColor, backgroundColorDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



- (NSMutableDictionary *)backgroundColorDict{
    return objc_getAssociatedObject(self, qz_key_backgroundColor);
}


- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = (UIColor *)[self.backgroundColorDict objectForKey:qz_forUIControlStateHighlighted];
    }else{
        self.backgroundColor = (UIColor *)[self.backgroundColorDict objectForKey:qz_forUIControlStateNormal];
    }
}


- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    if (enabled) {
        self.backgroundColor = (UIColor *)[self.backgroundColorDict objectForKey:qz_forUIControlStateNormal];
    }else{
        self.backgroundColor = (UIColor *)[self.backgroundColorDict objectForKey:qz_forUIControlStateDisabled];
    }
    
}

- (void)setSelected:(BOOL)selected{

    [super setSelected:selected];
    
    if (selected) {
        self.backgroundColor = (UIColor *)[self.backgroundColorDict objectForKey:qz_forUIControlStateSelected];
    }else{
        self.backgroundColor = (UIColor *)[self.backgroundColorDict objectForKey:qz_forUIControlStateNormal];
    }
    
}



@end
