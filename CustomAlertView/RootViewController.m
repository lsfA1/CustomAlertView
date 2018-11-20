//
//  RootViewController.m
//  CustomAlertView
//
//  Created by 李少锋 on 2018/11/20.
//  Copyright © 2018年 李少锋. All rights reserved.
//

#import "RootViewController.h"
#import "CustomAlertView.h"
#import <Masonry.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    button.backgroundColor=[UIColor redColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.centerY.equalTo(self.view.mas_centerY);
    }];
}

-(void)buttonClick{
    [CustomAlertView initAlertView:@"温馨提示" andShowViewController:self andContent:@"大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件大事件" andSureBtnTitle:@"确定" andCancalBtnTitle:@"取消" andSureBlock:^{
        
    } andCancal:^{
        
    }];
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
