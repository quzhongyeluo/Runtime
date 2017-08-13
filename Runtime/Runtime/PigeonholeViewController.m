//
//  PigeonholeViewController.m
//  Runtime
//
//  Created by 曲终叶落 on 2017/8/13.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "PigeonholeViewController.h"
#import "User.h"
@interface PigeonholeViewController ()

@property (nonatomic,copy) NSString *path;

@end

@implementation PigeonholeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    _path = [path stringByAppendingPathComponent:@"user"];

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
    
    User *user = [[User alloc] init];
    user.name = @"quzhongyeluo";
    user.age = @20;
    user.phone = @10086;
    user.userid = @"1";
    
    [NSKeyedArchiver archiveRootObject:user toFile:_path];
}


/**
 解档

 @param sender sender description
 */
- (IBAction)unarchiveAction:(UIButton *)sender {
    
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:_path];
    
    NSLog(@"%@",user.name);
    NSLog(@"%@",user.age);
    NSLog(@"%@",user.phone);
    NSLog(@"%@",user.userid);
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
