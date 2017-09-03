//
//  PigeonholeViewController.m
//  Runtime
//
//  Created by 曲终叶落 on 2017/8/13.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "PigeonholeViewController.h"
#import "User.h"
#import "NSObject+QZ_KeyValues.h"

@interface PigeonholeViewController ()

@property (nonatomic,copy) NSString *path;

@property (nonatomic,copy) NSDictionary *userDict;

@property (weak, nonatomic) IBOutlet UILabel *content;

@end

@implementation PigeonholeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    _path = [path stringByAppendingPathComponent:@"user"];
    
    _userDict = @{
                  @"name":@"quzhongyeluo",
                  @"age":@21,
                  @"phone":@10086,
                  @"userid":@"1",
                  };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/**
 归档

 @param sender sender description
 */
- (IBAction)pigenoholeAction:(UIButton *)sender {
    
    // 通过字典初始化
    User *user = [[User alloc] initWithQZ_Dictionary:_userDict];

    // 归档
    [NSKeyedArchiver archiveRootObject:user toFile:_path];
}


/**
 解档

 @param sender sender description
 */
- (IBAction)unarchiveAction:(UIButton *)sender {
    
    // 解档
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:_path];

    // 模型转成字典
    NSDictionary *dict = [user qz_ObjectToDictionary];
    NSLog(@"%@",dict);
    
    _content.text = [NSString stringWithFormat:@"%@",dict];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
