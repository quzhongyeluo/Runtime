//
//  NSObject+keyValues.m
//  Runtime
//
//  Created by 曲终叶落 on 2017/8/13.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "NSObject+keyValues.h"
#import <objc/message.h>

@implementation NSObject (keyValues)

/**
 字典转模型

 @param aDictionary 字典
 @return 模型
 */
-(id)initWithDictionary:(NSDictionary *)aDictionary{
    
    id objc = [self init];
    
    for (NSString *key in aDictionary.allKeys) {
        
        id value = aDictionary[key];
        
        // 判断当前属性是否为model
        objc_property_t property = class_getProperty([self class], key.UTF8String);
        
        unsigned int outCount = 0;
        
        objc_property_attribute_t *attributeList = property_copyAttributeList(property, &outCount);
        
        objc_property_attribute_t attribute = attributeList[0];
        
        NSString *typeString = [NSString stringWithUTF8String:attribute.value];
        
        NSString *className = NSStringFromClass([self class]);
        
        if ([typeString isEqualToString:className]) {
            value = [self initWithDictionary:value];
        }
        
        // 当前不是model
        NSString *methodName = [NSString stringWithFormat:@"set%@%@:",[key substringToIndex:1].uppercaseString,[key substringFromIndex:1]];
        SEL setter = sel_registerName(methodName.UTF8String);
        
        if ([objc respondsToSelector:setter]) {
            ((void (*) (id,SEL,id)) objc_msgSend) (objc,setter,value);
        }
        
        free(attributeList);
        
    }

    return objc;
}


/**
 模型转字典

 @return 字典
 */
- (NSDictionary *)objectToDictionary{
    
    unsigned int outCount = 0;
    
    objc_property_t *propertyList = class_copyPropertyList([self class], &outCount);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < outCount; i ++) {
        objc_property_t property = propertyList[i];
        
        //生成getter方法，并用objc_msgSend调用
        const char *propertyName = property_getName(property);
        SEL getter = sel_registerName(propertyName);
        if ([self respondsToSelector:getter]) {
            
            id value = ((id (*) (id,SEL)) objc_msgSend) (self,getter);
            
            // 判断当前属性是不是Model
            if ([value isKindOfClass:[self class]] && value) {
                value = [value objectToDictionary];
            }

            if (value) {
                NSString *key = [NSString stringWithUTF8String:propertyName];
                [dict setObject:value forKey:key];
            }
        }
    }
    free(propertyList);
    return dict;
}

@end
