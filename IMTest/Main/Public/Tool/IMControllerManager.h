//
//  IMControllerManager.h
//  IMTest
//
//  Created by yanglin on 2017/2/23.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMControllerManager : NSObject

+ (instancetype)sharedInstance;

/**
 根据登录状态自动设置window的根控制器
 */
- (void)autoConfigRootViewController;


/**
 跳转到登录控制器
 */
- (void)jumpToLoginController;

@end
