//
//  IMMsgVM.m
//  IMTest
//
//  Created by yanglin on 2017/3/16.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//



#import "IMMsgVM.h"
#import "MYMacros.h"

#import <UIView+YYAdd.h>

@implementation IMMsgVM

- (void)setMsg:(TIMMessage *)msg{
    _msg = msg;
    _isSelf = [msg isSelf];
    _h = 44;
    
    int elemCount = [msg elemCount];
    for (int i=0; i<elemCount; i++) {
        TIMElem *elem = [msg getElem:i];
        if ([elem isKindOfClass:[TIMTextElem class]]) {
            
            _messageType = MessageType_Text;
            _text = ((TIMTextElem *)elem).text;
            
            CGSize textSize = [_text boundingRectWithSize:CGSizeMake(kMainWidth * 0.6, CGFLOAT_MAX)
                                           options:NSStringDrawingUsesLineFragmentOrigin
                                        attributes:@{NSFontAttributeName : kFont(kTextFont)}
                                           context:nil].size;
            CGSize bubbleSize = CGSizeMake(textSize.width + 20, textSize.height + 20);
            CGSize avatarSize = CGSizeMake(40, 40);
            _h = bubbleSize.height + 20;
            
            if (_isSelf) {
                CGFloat avatarX = kMainWidth - avatarSize.width - 10;
                CGFloat avatarY = _h - avatarSize.height - 10;
                _avatarFrame = (CGRect){{avatarX, avatarY}, avatarSize};
                
                CGFloat bubbleX = avatarX - bubbleSize.width - 10;
                CGFloat bubbleY = _h - bubbleSize.height - 10;
                _bubbleFrame = (CGRect){{bubbleX, bubbleY}, bubbleSize};
                
                CGFloat textX = bubbleX + 10;
                CGFloat textY = bubbleY + 10;
                _textFrame = (CGRect){{textX, textY}, textSize};
            }else{
                CGFloat avatarX = 10;
                CGFloat avatarY = _h - avatarSize.height - 10;
                _avatarFrame = (CGRect){{avatarX, avatarY}, avatarSize};
                
                CGFloat bubbleX = CGRectGetMaxX(_avatarFrame) + 10;
                CGFloat bubbleY = _h - bubbleSize.height - 10;
                _bubbleFrame = (CGRect){{bubbleX, bubbleY}, bubbleSize};
                
                CGFloat textX = bubbleX + 10;
                CGFloat textY = bubbleY + 10;
                _textFrame = (CGRect){{textX, textY}, textSize};
            }
            break;
        }else if ([elem isKindOfClass:[TIMImageElem class]]){
            _messageType = MessageType_Pic;
            {
                TIMImageElem *img_elem = (TIMImageElem *)elem;
                _path = (NSString *)img_elem.path;
                
                NSMutableArray *tempArr = [NSMutableArray array];
                for (TIMImage *img in img_elem.imageList) {
                    if (img.type == TIM_IMAGE_TYPE_THUMB) {
                        [tempArr addObject:img.url];    //暂时只添加缩略图
                    }
                }
                _imgs = tempArr;
            }
            
            CGSize picSize = CGSizeMake(100, 133);
            CGSize bubbleSize = CGSizeMake(picSize.width + 20, picSize.height + 20);
            CGSize avatarSize = CGSizeMake(40, 40);
            _h = bubbleSize.height + 20;
            
            if (_isSelf) {
                CGFloat avatarX = kMainWidth - avatarSize.width - 10;
                CGFloat avatarY = _h - avatarSize.height - 10;
                _avatarFrame = (CGRect){{avatarX, avatarY}, avatarSize};
                
                CGFloat bubbleX = avatarX - bubbleSize.width - 10;
                CGFloat bubbleY = _h - bubbleSize.height - 10;
                _bubbleFrame = (CGRect){{bubbleX, bubbleY}, bubbleSize};
                
                CGFloat picX = bubbleX + 10;
                CGFloat picY = bubbleY + 10;
                _picFrame = (CGRect){{picX, picY}, picSize};
            }else{
                CGFloat avatarX = 10;
                CGFloat avatarY = _h - avatarSize.height - 10;
                _avatarFrame = (CGRect){{avatarX, avatarY}, avatarSize};
                
                CGFloat bubbleX = CGRectGetMaxX(_avatarFrame) + 10;
                CGFloat bubbleY = _h - bubbleSize.height - 10;
                _bubbleFrame = (CGRect){{bubbleX, bubbleY}, bubbleSize};
                
                CGFloat picX = bubbleX + 10;
                CGFloat picY = bubbleY + 10;
                _picFrame = (CGRect){{picX, picY}, picSize};
            }
        }
    }
}

@end
