//
//  IMContactsHeader.h
//  IMTest
//
//  Created by yanglin on 2017/3/13.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^asdf)(NSString *b);

@interface IMContactsHeader : UIView

@property (copy, nonatomic) void(^clickBlock)(NSInteger tag);

@end
