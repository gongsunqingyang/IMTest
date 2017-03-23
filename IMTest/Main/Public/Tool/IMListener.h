//
//  IMListener.h
//  IMTest
//
//  Created by yanglin on 2017/2/23.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#warning 所有回调函数不保证返回调用线程或主线程，如需要调度到指定线程，请业务自行调度


#import <Foundation/Foundation.h>
#import <TLSSDK/TLSHelper.h>
#import <ImSDK/ImSDK.h>

@interface IMListener : NSObject<TLSSmsRegListener, TLSSmsLoginListener, TLSPwdLoginListener, TLSStrAccountRegListener, TLSRefreshTicketListener, TIMMessageListener, TIMConnListener, TIMUserStatusListener, TIMCallback>
+ (instancetype)sharedInstance;

@end
