//
//  IMMsgRegisterController.m
//  IMTest
//
//  Created by yanglin on 2017/2/23.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMMsgRegisterController.h"
#import "MYConstant.h"
#import <Masonry.h>
#import <ImSDK/TIMManager.h>
#import <TLSSDK/TLSHelper.h>
#import <TLSSDK/TLSAccountHelper.h>
#import "IMListener.h"


@interface IMMsgRegisterController ()
@property (strong, nonatomic) UITextField *numberField;
@property (strong, nonatomic) UIButton *msgBtn;
@property (strong, nonatomic) UITextField *msgField;
@property (strong, nonatomic) UIButton *registerBtn;
@end

@implementation IMMsgRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupConstraints];
}

- (void)setupViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _numberField = [[UITextField alloc] init];
    _numberField.layer.borderWidth = 1;
    _numberField.placeholder = @"手机号";
    _numberField.text = @"86-18523972897";
    _numberField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_numberField];
    
    _msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _msgBtn.backgroundColor = [UIColor orangeColor];
    [_msgBtn setTitle:@"发送短信" forState:UIControlStateNormal];
    [_msgBtn addTarget:self action:@selector(clickMsgBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_msgBtn];
    
    _msgField = [[UITextField alloc] init];
    _msgField.layer.borderWidth = 1;
    _msgField.placeholder = @"短信验证码";
    _msgField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_msgField];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.backgroundColor = [UIColor orangeColor];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
}

- (void)setupConstraints{
    __weak __typeof(self) ws = self;
    [_numberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_topLayoutGuide).offset(10);
        make.height.mas_equalTo(40);
        make.left.equalTo(ws.view).offset(10);
        make.left.equalTo(@[_msgField, _registerBtn]);
    }];
    
    [_msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numberField.mas_right).offset(10);
        make.centerY.equalTo(_numberField);
        make.right.equalTo(ws.view).offset(-10);
        make.right.equalTo(@[_msgField, _registerBtn]);
    }];
    
    [_msgField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberField.mas_bottom).offset(20);
        make.height.equalTo(_numberField);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_msgField.mas_bottom).offset(20);
    }];
}

// 发送短信
- (void)clickMsgBtn{
    if (_numberField.text.length) {
        [[TLSHelper getInstance] TLSSmsRegAskCode:_numberField.text andTLSSmsRegListener:[IMListener sharedInstance]];
    }
}

// 注册
- (void)clickRegisterBtn{
    if (_msgField.text.length) {        
        [[TLSHelper getInstance] TLSSmsRegVerifyCode:_msgField.text andTLSSmsRegListener:[IMListener sharedInstance]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
