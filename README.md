
# 1.给Category分类添加属性

 objc_setAssociatedObject来把一个对象与另外一个对象进行关联。该函数需要四个参数：源对象，关键字，关联的对象和一个关联策略。

 OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
 关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字。

 关联策略表明了相关的对象是通过赋值，保留引用还是复制的方式进行关联的；还有这种关联是原子的还是非原子的。
 这里的关联策略和声明属性时的很类似。这种关联策略是通过使用预先定义好的常量来表示的。

eg：1、为UIImageView添加点击事件

UIImageView+QZ_ClickBlock.h
```
typedef void(^ClickBlcok)();

@interface UIImageView (ClickBlock)

@property (nonatomic, copy ) ClickBlcok clickBlock;

@end
```
UIImageView+QZ_ClickBlock.m
```

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

```

eg:2、解决重复点击的问题 ：代码注入 ， 把系统方法替换成自己的方法

hook思想
```

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
```

```
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
```


# 2.给Category分类动态添加方法
eg:

为UIButton添加设置 在不同状态下背景色

存在问题：无法根据状态改变文字 （不知道如何解决 - 麻烦知道的告知下）
```

#import <UIKit/UIKit.h>


/**
 为UIButton添加设置 在不同状态下背景色
 缺点：无法根据状态改变文字 （不知道如何解决 - 麻烦知道的告知下）
 */
@interface UIButton (QZ_BackgroundColor)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
```

```

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

```

# 3.字典与模型互转
```
#import <Foundation/Foundation.h>

@interface NSObject (QZ_KeyValues)

- (id)initWithQZ_Dictionary:(NSDictionary *)dictionary;

- (NSDictionary *)qz_ObjectToDictionary;

@end
```

```

#import "NSObject+QZ_KeyValues.h"
#import <objc/message.h>

@implementation NSObject (QZ_KeyValues)

/**
 字典转模型

 @param dictionary 字典
 @return 模型
 */
-(id)initWithQZ_Dictionary:(NSDictionary *)dictionary{

    id objc = [self init];

    for (NSString *key in dictionary.allKeys) {

        id value = dictionary[key];

        // 判断当前属性是否为model
        objc_property_t property = class_getProperty([self class], key.UTF8String);

        unsigned int outCount = 0;

        objc_property_attribute_t *attributeList = property_copyAttributeList(property, &outCount);

        objc_property_attribute_t attribute = attributeList[0];

        NSString *typeString = [NSString stringWithUTF8String:attribute.value];

        NSString *className = NSStringFromClass([self class]);

        if ([typeString isEqualToString:className]) {
            value = [self initWithQZ_Dictionary:value];
        }

        // 当前属性是否为model
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
- (NSDictionary *)qz_ObjectToDictionary{

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
                value = [value qz_ObjectToDictionary];
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
```

# 4.自动归档解档
```
#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSNumber *age;

@property (nonatomic,copy) NSNumber *phone;

@property (nonatomic,copy) NSString *userid;

@end
```

```
#import "User.h"
#import <objc/message.h>


@implementation User



- (instancetype)initWithCoder:(NSCoder *)aDecoder{

    if (self = [super init]) {

        unsigned int outCount = 0;
        // 获取所有成员变量
        Ivar *vars = class_copyIvarList([self class], &outCount);

        for (int i = 0; i < outCount; i++) {

            Ivar var = vars[i];
            // 获取成员变量名称
            const char *name = ivar_getName(var);
            NSString *key = [NSString stringWithUTF8String:name];

            // 注意kvc的特性是，如果能找到key这个属性的setter方法，则调用setter方法
            // 如果找不到setter方法，则查找成员变量key或者成员变量_key，并且为其赋值
            // 所以这里不需要再另外处理成员变量名称的“_”前缀
            id value = [aDecoder decodeObjectForKey:key];

            [self setValue:value forKey:key];

        }
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{

    unsigned int outCount = 0;

    Ivar *vars = class_copyIvarList([self class], &outCount);

    for (int i = 0; i < outCount; i++) {
        Ivar var = vars[i];
        const char *name = ivar_getName(var);
        NSString *key = [NSString stringWithUTF8String:name];
        id value = [self valueForKey:key];
        [aCoder encodeObject:value forKey:key];
    }

}

@end
```
