
// 全局常量
#import "MYConstant.h"
#import <UIKit/UIKit.h>

#if TARGET_IPHONE_SIMULATOR
#define kUserName @"zhangsan"
#define kC2CName @"zhaosi"
#else
#define kUserName @"zhaosi"
#define kC2CName @"zhangsan"
#endif

//--------------Key------------------
#define kSDKAppID @"1400025150"
#define kAccountType @"10800"
#define kAppVer @"1.0.0.0"

//--------------短信注册通知------------------
#define kSmsRegAskCodeSuccess @"kSmsRegAskCodeSuccess"
#define kSmsRegReaskCodeSuccess @"kSmsRegReaskCodeSuccess"
#define kSmsRegVerifyCodeSuccess @"kSmsRegVerifyCodeSuccess"
#define kSmsRegCommitSuccess @"kSmsRegCommitSuccess"
#define kSmsRegFail @"kSmsRegFail"
#define kSmsRegTimeout @"kSmsRegTimeout"

//--------------短信登录通知------------------
#define kSmsLoginAskCodeSuccess @"kSmsLoginAskCodeSuccess"
#define kSmsLoginReaskCodeSuccess @"kSmsLoginReaskCodeSuccess"
#define kSmsLoginVerifyCodeSuccess @"kSmsLoginVerifyCodeSuccess"
#define kSmsLoginSuccess @"kSmsLoginSuccess"
#define kSmsLoginFail @"kSmsLoginFail"
#define kSmsLoginTimeout @"kSmsLoginTimeout"

//--------------用户名登录通知------------------
#define kPwdLoginSuccess @"kPwdLoginSuccess"

//--------------刷新票据通知------------------
#define kOnRefreshTicketSuccess @"kOnRefreshTicketSuccess"

//新消息
#define kOnNewMessage @"kOnNewMessage"

//
#define kMyGroupName @"kMyGroupName"
#define kMyGroupId @"kMyGroupId"
