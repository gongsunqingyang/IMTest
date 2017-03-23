//
//  IMMsgVM.h
//  IMTest
//
//  Created by yanglin on 2017/3/16.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#define kTextFont 16

#import <Foundation/Foundation.h>
#import <ImSDK/ImSDK.h>

typedef NS_ENUM(NSInteger, MessageType) {
    MessageType_Text = 0,
    MessageType_Pic,
};

@interface IMMsgVM : NSObject
@property (assign, nonatomic) CGRect avatarFrame;
@property (assign, nonatomic) CGRect bubbleFrame;
@property (assign, nonatomic) CGRect textFrame;
@property (assign, nonatomic) CGRect picFrame;

@property (assign, nonatomic) CGFloat h;

@property (assign, nonatomic) BOOL isSelf;
@property (assign, nonatomic) MessageType messageType;


@property (copy, nonatomic) NSString *text;
@property (copy, nonatomic) NSString *path;     //本地图片路径
@property (strong, nonatomic) NSArray *imgs;    //网络图片路径数组

@property (strong, nonatomic) TIMMessage *msg;

@end
