//
//  IMChatController.h
//  IMTest
//
//  Created by yanglin on 2017/3/2.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ImSDK/ImSDK.h>

typedef enum : NSUInteger {
    ChatControllerType_C2C,
    ChatControllerType_PublicGroup,
    ChatControllerType_AVChatRoomGroup,
} ChatControllerType;

@interface IMChatController : UIViewController
@property (strong, nonatomic) TIMConversation *conversation;
@property (assign, nonatomic) ChatControllerType controllerType;

- (instancetype)initWithControllerType:(ChatControllerType)controllerType;  //单聊会话
@end
