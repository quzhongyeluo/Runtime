//
//  ViewController.m
//  Runtime
//
//  Created by 曲终叶落 on 2017/8/13.
//  Copyright © 2017年 曲终叶落. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+QZ_ClickBlock.h"
#import "UIButton+QZ_BackgroundColor.h"
#import "UIButton+QZ_RepeatClick.h"

@interface ViewController (){
    int _i;
}

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *pLb;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *clickChangeBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof(self) weakSelf = self;
    _imageView.clickBlock = ^{
        weakSelf.pLb.text = @"图片点击成功";
    };
    
    
    // 根据状态更改文字无效 - 原因未知 - 麻烦知道的告知下
    [_changeBtn setTitle:@"默认状态" forState:(UIControlStateNormal)];
    [_changeBtn setBackgroundColor:[UIColor grayColor] forState:(UIControlStateNormal)];
    
    [_changeBtn setTitle:@"高亮状态" forState:(UIControlStateHighlighted)];
    [_changeBtn setBackgroundColor:[UIColor redColor] forState:(UIControlStateHighlighted)];
    
    [_changeBtn setTitle:@"不可点击状态" forState:(UIControlStateDisabled)];
    [_changeBtn setBackgroundColor:[UIColor greenColor] forState:(UIControlStateDisabled)];
    
    [_changeBtn setTitle:@"选中状态" forState:(UIControlStateSelected)];
    [_changeBtn setBackgroundColor:[UIColor purpleColor] forState:(UIControlStateSelected)];
    
    _changeBtn.backgroundColor = [UIColor grayColor];
    
    _i = 0;
    
    // 点击间隔 2秒
    _clickChangeBtn.interval = 2.0;
}

- (IBAction)changeBtnbackgroundColor:(UIButton *)sender {
    
    if (_i == 0) {
        _changeBtn.enabled = false; 
    }
    
    if (_i == 1) {
        _changeBtn.selected = true;
    }
    
    if (_i == 2) {
        _changeBtn.highlighted = true;
    }
    
    if (_i == 3) {
        _changeBtn.highlighted = false;
    }
    
    _i ++;
    
    if (_i == 4) {
        _i = 0;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
