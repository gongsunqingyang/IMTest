//
//  IMHomeController.m
//  IMTest
//
//  Created by yanglin on 2017/2/22.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMHomeController.h"
#import "MYConstant.h"
#import "IMControllerManager.h"
#import "IMChatController.h"
#import "IMUserDetailController.h"

#import <ImSDK/ImSDK.h>
#import <TLSSDK/TLSHelper.h>
#import <Masonry.h>
#import <SVProgressHUD.h>


@interface IMHomeController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray <TIMConversation *>*conversations;

@end

@implementation IMHomeController

-(NSMutableArray *)conversations{
    if (!_conversations){
        
        //单聊
        TIMConversation *c2c_conversation = [[TIMManager sharedInstance] getConversation:TIM_C2C receiver:kC2CName];
        
        //群聊
        TIMConversation * grp_conversation = [[TIMManager sharedInstance] getConversation:TIM_GROUP receiver:@"@TGS#aO4SSUNEC"];
        
        _conversations = [NSMutableArray arrayWithObjects:c2c_conversation, grp_conversation, nil];

    }
    return _conversations;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setupConstraints];
    [self login];
}

- (void)setupViews{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"我" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _tableView = [[UITableView alloc] init];
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)setupConstraints{
    __weak __typeof(self) ws = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];

}

- (void)login{
    //获取登录状态信息
    TIMLoginStatus status = [[TIMManager sharedInstance] getLoginStatus];
    if (status != TIM_STATUS_LOGOUT) {
        NSLog(@"错误，status = %@", @(status));
        return;
    }
    
    //用户信息
    TLSUserInfo *userInfo = [[TLSHelper getInstance] getLastUserInfo];
    
    //登录参数
    TIMLoginParam *param = [[TIMLoginParam alloc] init];
    param.accountType = kAccountType;
    param.identifier = userInfo.identifier;
    param.userSig = [[TLSHelper getInstance] getTLSUserSig:userInfo.identifier];
    param.appidAt3rd = [NSString stringWithFormat:@"%@", kSDKAppID];
    param.sdkAppId = [kSDKAppID intValue];
    
    //登录
    [SVProgressHUD showWithStatus:@"正在登陆"];
    [[TIMManager sharedInstance] login:param succ:^{
        NSLog(@"登陆成功");
        [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
        
        //获取会话列表
        NSArray *conversations = [[TIMManager sharedInstance] getConversationList];
        _conversations = [conversations mutableCopy];
        [_tableView reloadData];
        
    } fail:^(int code, NSString *msg) {
        NSLog(@"登录失败, code = %@, %@",@(code), msg);
        [SVProgressHUD showErrorWithStatus:@"登录失败"];
    }];

}


- (void)clickLeftItem{
    [[IMControllerManager sharedInstance] jumpToLoginController];
}

- (void)clickRightItem{
    [[TIMFriendshipManager sharedInstance] GetSelfProfile:^(TIMUserProfile *profile) {
        IMUserDetailController *vc = [[IMUserDetailController alloc] init];
        vc.userProfile = profile;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:vc animated:YES];
            
        });
    } fail:^(int code, NSString *msg) {
        NSLog(@"code = %@, msg = %@", @(code), msg);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.conversations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TIMConversation *conversation = _conversations[indexPath.row];
    cell.textLabel.text = [conversation getReceiver];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TIMConversation *conversation = _conversations[indexPath.row];
    IMChatController *vc = [[IMChatController alloc] initWithControllerType:ChatControllerType_C2C];
    vc.conversation = conversation;
    [self.navigationController pushViewController:vc animated:YES];
    
}

@end
