//
//  IMContactsHeader.m
//  IMTest
//
//  Created by yanglin on 2017/3/13.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMContactsHeader.h"

#import <Masonry.h>

@interface IMContactsHeader()
@property (strong, nonatomic) NSArray *titles;

@end

@implementation IMContactsHeader

- (NSArray *)titles{
    if (!_titles) {
        _titles = @[@"创建", @"搜索", @"进入", @"null"];
    }
    return _titles;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews{
    self.backgroundColor = [UIColor lightGrayColor];
    
    __weak __typeof(self) ws = self;
    UIButton *lastBtn;
    for (int i=0; i<self.titles.count; i++) {
        NSString *title = _titles[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = i;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(lastBtn ? lastBtn.mas_right : ws);
            make.width.equalTo(lastBtn ? lastBtn.mas_width : btn.mas_width);
            make.top.bottom.equalTo(ws);
        }];
        
        lastBtn = btn;
    }
    
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ws);
    }];
}

- (void)clickBtn:(UIButton *)btn{
    if (self.clickBlock) {
        self.clickBlock(btn.tag);
    }
}

@end
