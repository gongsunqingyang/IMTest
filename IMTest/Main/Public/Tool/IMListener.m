//
//  IMListener.m
//  IMTest
//
//  Created by yanglin on 2017/2/23.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMListener.h"
#import <SVProgressHUD.h>
#import "MYMacros.h"
#import "MYConstant.h"

@implementation IMListener

static IMListener *_instance = nil;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    return _instance ;
}

#pragma mark - TLSSmsRegListener （短信注册）
/**
 *  请求短信验证码成功
 *
 *  @param reaskDuration 下次请求间隔
 *  @param expireDuration 验证码有效期
 */
-(void)	OnSmsRegAskCodeSuccess:(int)reaskDuration andExpireDuration:(int) expireDuration{
    NSLog(@"请求短信验证码成功,间隔：%@", @(expireDuration));
}

/**
 *  刷新短信验证码请求成功
 *
 *  @param reaskDuration 下次请求间隔
 *  @param expireDuration 验证码有效期
 */
-(void)	OnSmsRegReaskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration{
    NSLog(@"刷新短信验证码请求成功");
}

/**
 *  验证短信验证码成功
 */
-(void)	OnSmsRegVerifyCodeSuccess{
    NSLog(@"验证短信验证码成功, 并提交注册");
    [[TLSHelper getInstance] TLSSmsRegCommit:nil];
}

/**
 *  提交注册成功
 *
 *  @param userInfo 用户信息
 */
-(void)	OnSmsRegCommitSuccess:(TLSUserInfo *)userInfo{
    NSLog(@"提交注册成功: %@", userInfo);
    [SVProgressHUD showSuccessWithStatus:@"短信注册成功"];
}

/**
 *  短信注册失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnSmsRegFail:(TLSErrInfo *) errInfo{
    NSLog(@"短信注册失败, errInfo = %@", errInfo);
    [SVProgressHUD showErrorWithStatus:@"短信注册失败"];
}

/**
 *  短信注册超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnSmsRegTimeout:(TLSErrInfo *) errInfo{
    NSLog(@"短信注册超时, errInfo = %@", errInfo);
}


#pragma mark - TLSSmsLoginListener (短信登录)
/**
 *  请求短信验证码成功
 *
 *  @param reaskDuration 下次请求间隔
 *  @param expireDuration 验证码有效期
 */
-(void) OnSmsLoginAskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration{
    NSLog(@"请求短信验证码成功 reaskDuration:%@, expireDuration:%@", @(reaskDuration), @(expireDuration));
}

/**
 *  刷新短信验证码请求成功
 *
 *  @param reaskDuration 下次请求间隔
 *  @param expireDuration 验证码有效期
 */
-(void)	OnSmsLoginReaskCodeSuccess:(int)reaskDuration andExpireDuration:(int)expireDuration{
    NSLog(@"刷新短信验证码请求成功 reaskDuration:%@, expireDuration:%@", @(reaskDuration), @(expireDuration));
}

/**
 *  验证短信验证码成功
 */
-(void)	OnSmsLoginVerifyCodeSuccess{
    NSLog(@"验证短信验证码成功");
    kPostFastNotification(kSmsLoginVerifyCodeSuccess, nil);
}

/**
 *  短信登陆成功
 *
 *  @param userInfo 用户信息
 */
-(void)	OnSmsLoginSuccess:(TLSUserInfo *) userInfo{
    NSLog(@"短信登陆成功:%@", userInfo);
    [SVProgressHUD showSuccessWithStatus:@"短信登陆成功"];
    kPostFastNotification(kSmsLoginSuccess, nil);
}

/**
 *  短信登陆失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnSmsLoginFail:(TLSErrInfo *) errInfo{
    NSLog(@"短信登陆失败:%@", errInfo);
    [SVProgressHUD showErrorWithStatus:@"短信登录失败"];
}

/**
 *  短信登陆超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnSmsLoginTimeout:(TLSErrInfo *)errInfo{
    NSLog(@"登录超时：%@", errInfo);
}


#pragma mark - TLSPwdLoginListener (密码登录)
/**
 *  密码登陆要求验证图片验证码
 *
 *  @param picData 图片验证码
 *  @param errInfo 错误信息
 */
-(void)	OnPwdLoginNeedImgcode:(NSData *)picData andErrInfo:(TLSErrInfo *)errInfo{
    NSLog(@"密码登陆要求验证图片验证码: %@", errInfo);
}

/**
 *  密码登陆请求图片验证成功
 *
 *  @param picData 图片验证码
 */
-(void)	OnPwdLoginReaskImgcodeSuccess:(NSData *)picData{
    NSLog(@"密码登陆请求图片验证成功：%@", picData);
}

/**
 *  密码登陆成功
 *
 *  @param userInfo 用户信息
 */
-(void)	OnPwdLoginSuccess:(TLSUserInfo *)userInfo{
    NSLog(@"密码登陆成功: %@", userInfo);
    [SVProgressHUD showSuccessWithStatus:@"密码登陆成功"];
    kPostFastNotification(kPwdLoginSuccess, nil);
}

/**
 *  密码登陆失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnPwdLoginFail:(TLSErrInfo *)errInfo{
    NSLog(@"密码登陆失败：%@", errInfo);
    [SVProgressHUD showErrorWithStatus:@"密码登陆失败"];
}

/**
 *  密码登录超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnPwdLoginTimeout:(TLSErrInfo *)errInfo{
    NSLog(@"密码登录超时: %@", errInfo);
}


#pragma mark - TLSStrAccountRegListener (用户名注册)
/**
 *  注册成功
 */
-(void)	OnStrAccountRegSuccess:(TLSUserInfo*)userInfo{
    NSLog(@"注册成功: %@", userInfo);
    [SVProgressHUD showSuccessWithStatus:@"注册成功"];
}


/**
 *  注册失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnStrAccountRegFail:(TLSErrInfo *) errInfo{
    NSLog(@"注册失败: %@", errInfo);
    [SVProgressHUD showErrorWithStatus:@"注册失败"];
}

/**
 *  注册超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnStrAccountRegTimeout:(TLSErrInfo *) errInfo{
    NSLog(@"注册超时");
}


#pragma mark - TLSRefreshTicketListener (换票回调)
/**
 *  刷新票据成功
 *
 *  @param userInfo 用户信息
 */
-(void)	OnRefreshTicketSuccess:(TLSUserInfo *)userInfo{
    NSLog(@"刷新票据成功: %@", userInfo);
    [SVProgressHUD showSuccessWithStatus:@"刷新票据成功"];
    kPostFastNotification(kOnRefreshTicketSuccess, nil);
}

/**
 *  刷新票据失败
 *
 *  @param errInfo 错误信息
 */
-(void)	OnRefreshTicketFail:(TLSErrInfo *)errInfo{
    NSLog(@"刷新票据失败: %@", errInfo);
}

/**
 *  刷新票据超时
 *
 *  @param errInfo 错误信息
 */
-(void)	OnRefreshTicketTimeout:(TLSErrInfo *)errInfo{
    NSLog(@"刷新票据超时");
}


#pragma mark - TIMMessageListener (消息回调)
/**
 *  新消息回调通知
 *
 *  @param msgs 新消息列表，TIMMessage 类型数组
 */
- (void)onNewMessage:(NSArray *) msgs{
    NSLog(@"新消息回调通知: %@, count = %@", msgs, @(msgs.count));
    for (TIMMessage *msg in msgs) {
        kPostFastNotification(kOnNewMessage, msg);
    }
}


#pragma mark - TIMConnListener (连接通知回调)
/**
 *  网络连接成功
 */
- (void)onConnSucc{
    NSLog(@"网络连接成功");
}

/**
 *  网络连接失败
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onConnFailed:(int)code err:(NSString*)err{
    NSLog(@"网络连接失败 code: %@, err: %@",@(code), err);
}

/**
 *  网络连接断开（断线只是通知用户，不需要重新登陆，重连以后会自动上线）
 *
 *  @param code 错误码
 *  @param err  错误描述
 */
- (void)onDisconnect:(int)code err:(NSString*)err{
    NSLog(@"网络连接断开（断线只是通知用户，不需要重新登陆，重连以后会自动上线） code: %@, err: %@",@(code), err);
}

/**
 *  连接中
 */
- (void)onConnecting{
    NSLog(@"连接中");
}


#pragma mark - TIMUserStatusListener (用户在线状态通知)
/**
 *  踢下线通知
 */
- (void)onForceOffline{
    NSLog(@"踢下线通知");
}

/**
 *  断线重连失败
 */
- (void)onReConnFailed:(int)code err:(NSString*)err{
    NSLog(@"断线重连失败 code: %@, err:%@", @(code), err);
}

/**
 *  用户登录的userSig过期（用户需要重新获取userSig后登录）
 */
- (void)onUserSigExpired{
    NSLog(@"用户登录的userSig过期（用户需要重新获取userSig后登录）");
}


#pragma mark - TIMCallback (登录回调)
/**
 *  成功
 */
- (void) onSucc{
    NSLog(@"成功");
}

/**
 *  消息发送失败
 *
 *  @param errCode 失败错误码
 *  @param errMsg  失败错误描述
 */
- (void)onErr:(int)errCode errMsg:(NSString*)errMsg{
    NSLog(@"消息发送失败, code = %@, errMsg = %@", @(errCode), errMsg);
}



@end
