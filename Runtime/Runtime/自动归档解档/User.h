//
//  User.h
//  Runtime
//
//  Created by 曲终叶落 on 2017/8/13.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSNumber *age;

@property (nonatomic,copy) NSNumber *phone;

@property (nonatomic,copy) NSString *userid;

@end
