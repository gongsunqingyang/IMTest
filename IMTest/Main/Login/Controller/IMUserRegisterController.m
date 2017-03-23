//
//  IMUserRegisterController.m
//  IMTest
//
//  Created by yanglin on 2017/2/23.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMUserRegisterController.h"
#import "IMListener.h"
#import "MYConstant.h"

#import <Masonry.h>
#import <TLSSDK/TLSHelper.h>
#import <SVProgressHUD.h>

@interface IMUserRegisterController ()
@property (strong, nonatomic) UITextField *nameField;
@property (strong, nonatomic) UITextField *pwdField1;
@property (strong, nonatomic) UITextField *pwdField2;
@property (strong, nonatomic) UIButton *registerBtn;

@end

@implementation IMUserRegisterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupConstraints];
}

- (void)setupViews{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _nameField = [[UITextField alloc] init];
    _nameField.layer.borderWidth = 1;
    _nameField.placeholder = @"用户名为小写字母、数字、下划线";
    _nameField.text = kUserName;
    _nameField.keyboardType = UIKeyboardTypeTwitter;
    [self.view addSubview:_nameField];
    
    
    _pwdField1 = [[UITextField alloc] init];
    _pwdField1.layer.borderWidth = 1;
    _pwdField1.placeholder = @"用户密码为6~16个字符";
    _pwdField1.text = @"qwer1234";
    _pwdField1.keyboardType = UIKeyboardTypeTwitter;
    [self.view addSubview:_pwdField1];
    
    _pwdField2 = [[UITextField alloc] init];
    _pwdField2.layer.borderWidth = 1;
    _pwdField2.placeholder = @"确认密码";
    _pwdField2.text = @"qwer1234";
    _pwdField2.keyboardType = UIKeyboardTypeTwitter;
    [self.view addSubview:_pwdField2];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _registerBtn.backgroundColor = [UIColor orangeColor];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_registerBtn];
}

- (void)setupConstraints{
    __weak __typeof(self) ws = self;
    [_nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(ws.mas_topLayoutGuide).offset(10);
        make.height.mas_equalTo(40);
        make.height.equalTo(@[_pwdField1, _pwdField2]);
        make.left.equalTo(ws.view).offset(10);
        make.right.equalTo(ws.view).offset(-10);
        make.left.right.equalTo(@[_pwdField1, _pwdField2, _registerBtn]);
    }];
    
    [_pwdField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nameField.mas_bottom).offset(20);
    }];
    
    [_pwdField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwdField1.mas_bottom).offset(20);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pwdField2.mas_bottom).offset(20);
    }];
}

// 点击注册
- (void)clickRegisterBtn{
    if (_nameField.text.length && _pwdField1.text.length && _pwdField2.text.length && [_pwdField1.text isEqualToString:_pwdField2.text]) {
        [[TLSHelper getInstance] TLSStrAccountReg:_nameField.text andPassword:_pwdField1.text andTLSStrAccountRegListener:[IMListener sharedInstance]];
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入正确的用户名和密码"];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
