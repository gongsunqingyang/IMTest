//
//  IMUserLoginController.m
//  IMTest
//
//  Created by yanglin on 2017/2/23.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMUserLoginController.h"
#import <Masonry.h>
#import <TLSSDK/TLSHelper.h>
#import "MYConstant.h"
#import "MYMacros.h"
#import "IMUserRegisterController.h"
#import "IMListener.h"

@interface IMUserLoginController ()
@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *pwdField;
@property (strong, nonatomic) UIButton *loginBtn;
@property (strong, nonatomic) UIButton *registerNewBtn;

@end

@implementation IMUserLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupConstraints];
}

- (void)setupViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _nameField = [[UITextField alloc] init];
    _nameField.layer.borderWidth = 1;
    _nameField.placeholder = @"用户名";
    _nameField.text = kUserName;
    _nameField.keyboardType = UIKeyboardTypeTwitter;
    [self.view addSubview:_nameField];
    
    _pwdField = [[UITextField alloc] init];
    _pwdField.layer.borderWidth = 1;
    _pwdField.placeholder = @"密码";
    _pwdField.text = @"qwer1234";
    _pwdField.keyboardType = UIKeyboardTypeTwitter;
    [self.view addSubview:_pwdField];
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.backgroundColor = [UIColor orangeColor];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _registerNewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerNewBtn.backgroundColor = [UIColor orangeColor];
    [_registerNewBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
    [_registerNewBtn addTarget:self action:@selector(clickRegisterNewBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerNewBtn];
}

- (void)setupConstraints{
    __weak __typeof(self) ws = self;
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_topLayoutGuide).offset(10);
        make.height.mas_equalTo(40);
        make.left.equalTo(ws.view).offset(10);
        make.left.equalTo(@[_pwdField, _loginBtn]);
        make.right.equalTo(ws.view).offset(-10);
        make.right.equalTo(@[_pwdField, _loginBtn, _registerNewBtn]);
    }];
    
    [_pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameField.mas_bottom).offset(20);
        make.height.equalTo(_nameField);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwdField.mas_bottom).offset(20);
    }];
    
    [_registerNewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).offset(20);
    }];
    
}

// 登录
- (void)clickLoginBtn{
    BOOL needLogin = [[TLSHelper getInstance] needLogin:_nameField.text];
    if (needLogin) {
        [[TLSHelper getInstance] TLSPwdLogin:_nameField.text andPassword:_pwdField.text andTLSPwdLoginListener:[IMListener sharedInstance]];
    }else{
        // 无需登录，刷新表单
        NSString *identifier = [[TLSHelper getInstance] getLastUserInfo].identifier;
        [[TLSHelper getInstance] TLSRefreshTicket:identifier andTLSRefreshTicketListener:[IMListener sharedInstance]];
    }
}

// 注册新用户
- (void)clickRegisterNewBtn{
    IMUserRegisterController *vc = [[IMUserRegisterController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
