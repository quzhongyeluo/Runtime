//
//  NSObject+keyValues.h
//  Runtime
//
//  Created by 曲终叶落 on 2017/8/13.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (QZ_KeyValues)

- (id)initWithQZ_Dictionary:(NSDictionary *)dictionary;

- (NSDictionary *)qz_ObjectToDictionary;

@end
