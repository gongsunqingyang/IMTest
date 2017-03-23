//
//  IMControllerManager.m
//  IMTest
//
//  Created by yanglin on 2017/2/23.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMControllerManager.h"
#import "MYBaseTabBarController.h"
#import "IMMsgLoginController.h"
#import "MYBaseNavController.h"
#import "MYConstant.h"
#import "MYMacros.h"
#import "MYBaseNavController.h"

#import <TLSSDK/TLSHelper.h>

@implementation IMControllerManager

static IMControllerManager *_instance = nil;

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken ;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init] ;
    }) ;
    return _instance ;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        kAddNotification(self, @selector(autoConfigRootViewController), kSmsLoginSuccess, nil);
        kAddNotification(self, @selector(autoConfigRootViewController), kPwdLoginSuccess, nil);
        kAddNotification(self, @selector(autoConfigRootViewController), kOnRefreshTicketSuccess, nil);
    }
    return self;
}

- (void)dealloc{
    kRemoveAllNotification;
}


- (void)autoConfigRootViewController{

    NSString *identifier = [[TLSHelper getInstance] getLastUserInfo].identifier;
    BOOL needLogin = [[TLSHelper getInstance] needLogin:identifier];
//    BOOL needLogin = YES;
    NSLog(@"用户ID: %@, 是否需要登录: %@", identifier, @(needLogin));
    UIViewController *rootVC = nil;
    if (needLogin) {
        IMMsgLoginController *vc = [[IMMsgLoginController alloc] init];
        rootVC = [[MYBaseNavController alloc] initWithRootViewController:vc];
    }else{
        rootVC = [[MYBaseTabBarController alloc] init];
    }
    
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController = rootVC;
}

- (void)jumpToLoginController{
    IMMsgLoginController *vc = [[IMMsgLoginController alloc] init];
    MYBaseNavController *nav = [[MYBaseNavController alloc] initWithRootViewController:vc];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    window.rootViewController = nav;
}

@end
