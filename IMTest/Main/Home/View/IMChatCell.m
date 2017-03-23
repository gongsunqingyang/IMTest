//
//  IMChatCell.m
//  IMTest
//
//  Created by yanglin on 2017/3/16.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMChatCell.h"
#import "MYConstant.h"
#import "MYMacros.h"
#import <YYKit.h>


@interface IMChatCell ()
@property (strong, nonatomic) UIImageView *avatarIV;
@property (strong, nonatomic) UIImageView *bubbleIV;
@property (strong, nonatomic) UILabel *textL;
@property (strong, nonatomic) UIImageView *picIV;

@end

@implementation IMChatCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.clipsToBounds = YES;
    
    _avatarIV = [[UIImageView alloc] init];
    _avatarIV.backgroundColor = [UIColor blueColor];
    [self.contentView addSubview:_avatarIV];
    
    _bubbleIV = [[UIImageView alloc] init];
    [self.contentView addSubview:_bubbleIV];
    
    _textL = [[UILabel alloc] init];
    _textL.numberOfLines = 0;
    _textL.font = kFont(kTextFont);
    _textL.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_textL];
    
    _picIV = [[UIImageView alloc] init];
    _picIV.contentMode = UIViewContentModeScaleAspectFill;
    _picIV.clipsToBounds = YES;
    [self.contentView addSubview:_picIV];
}

- (void)setMsgVM:(IMMsgVM *)msgVM{
    _msgVM = msgVM;
    
    _avatarIV.frame = msgVM.avatarFrame;
    _bubbleIV.frame = msgVM.bubbleFrame;
    _textL.frame = msgVM.textFrame;
    _picIV.frame = msgVM.picFrame;
    
    UIImage *bubbleImg = msgVM.isSelf ? kImg(@"bubble_0") : kImg(@"bubble_1");
    _bubbleIV.image = [bubbleImg resizableImageWithCapInsets:UIEdgeInsetsMake(bubbleImg.size.height/2, bubbleImg.size.width/2, bubbleImg.size.height/2, bubbleImg.size.width/2) resizingMode:UIImageResizingModeStretch];
    switch (msgVM.messageType) {
        case MessageType_Text:{
            _textL.hidden = NO;
            _picIV.hidden = YES;
            _textL.text = msgVM.text;
        }
            break;
        case MessageType_Pic:{
            _textL.hidden = YES;
            _picIV.hidden = NO;
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:msgVM.path]) {
                
                NSData *data = [fileManager contentsAtPath:msgVM.path];
                UIImage *img = [UIImage imageWithData:data];
                _picIV.image = img;
            }else{
                
                NSString *urlStr = [msgVM.imgs firstObject];
                NSURL *url = [NSURL URLWithString:urlStr];
                [_picIV setImageURL:url];
            }
        }
            break;
        default:
            break;
    }
    _textL.text = msgVM.text;
    
    
}




@end
