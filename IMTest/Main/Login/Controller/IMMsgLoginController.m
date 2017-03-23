//
//  IMLoginController.m
//  IMTest
//
//  Created by yanglin on 2017/2/22.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMMsgLoginController.h"
#import "MYConstant.h"
#import <Masonry.h>
#import <ImSDK/TIMManager.h>
#import <TLSSDK/TLSHelper.h>
#import "IMMsgRegisterController.h"
#import "IMUserLoginController.h"
#import "MYConstant.h"
#import "MYMacros.h"
#import "IMListener.h"

@interface IMMsgLoginController ()
@property (strong, nonatomic) UITextField *numberField;
@property (strong, nonatomic) UIButton *msgBtn;
@property (strong, nonatomic) UITextField *msgField;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *userLoginBtn;//用户名登录
@property (strong, nonatomic) UIButton *registerNewBtn;//注册新用户

@end

@implementation IMMsgLoginController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kAddNotification(self, @selector(login), kSmsLoginVerifyCodeSuccess, nil);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    kRemoveAllNotification;
}

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
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.backgroundColor = [UIColor orangeColor];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _userLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userLoginBtn.backgroundColor = [UIColor orangeColor];
    [_userLoginBtn setTitle:@"用户名登录" forState:UIControlStateNormal];
    [_userLoginBtn addTarget:self action:@selector(ClickUserLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_userLoginBtn];
    
    _registerNewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerNewBtn.backgroundColor = [UIColor orangeColor];
    [_registerNewBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
    [_registerNewBtn addTarget:self action:@selector(clickRegisterNewBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerNewBtn];
}

- (void)setupConstraints{
    __weak __typeof(self) ws = self;
    [_numberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_topLayoutGuide).offset(10);
        make.height.mas_equalTo(40);
        make.left.equalTo(ws.view).offset(10);
        make.left.equalTo(@[_msgField, _loginBtn, _userLoginBtn]);
    }];
    
    [_msgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_numberField.mas_right).offset(10);
        make.centerY.equalTo(_numberField);
        make.right.equalTo(ws.view).offset(-10);
        make.right.equalTo(@[_msgField, _loginBtn, _registerNewBtn]);
    }];
    
    [_msgField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_numberField.mas_bottom).offset(20);
        make.height.equalTo(_numberField);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_msgField.mas_bottom).offset(20);
    }];
    
    [_userLoginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(20);
    }];
    
    [_registerNewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(20);
    }];
    
}

// 发送短信
- (void)clickMsgBtn{
    if (_numberField.text.length) {
        [[TLSHelper getInstance] TLSSmsAskCode:_numberField.text  andTLSSmsLoginListener:[IMListener sharedInstance]];
    }
}

// 点击登录（校验验证码）
- (void)clickLoginBtn{
    [[TLSHelper getInstance] TLSSmsVerifyCode:_numberField.text andCode:_msgField.text andTLSSmsLoginListener:[IMListener sharedInstance]];
}

// 登录
- (void)login{
    [[TLSHelper getInstance] TLSSmsLogin:_numberField.text andTLSSmsLoginListener:[IMListener sharedInstance]];
}

// 点击用户名登录
- (void)ClickUserLoginBtn{
    IMUserLoginController *vc = [[IMUserLoginController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

// 点击注册新用户
- (void)clickRegisterNewBtn{
    IMMsgRegisterController *vc = [[IMMsgRegisterController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
