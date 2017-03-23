//
//  IMChatCell.h
//  IMTest
//
//  Created by yanglin on 2017/3/16.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMMsgVM.h"

@interface IMChatCell : UITableViewCell

@property (strong, nonatomic) IMMsgVM *msgVM;

@end
