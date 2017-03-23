//
//  IMSettingController.m
//  IMTest
//
//  Created by yanglin on 2017/2/24.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMSettingController.h"
#import "MYConstant.h"
#import "IMListener.h"
#import <Masonry.h>
#import <ImSDK/ImSDK.h>

@interface IMSettingController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation IMSettingController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self setupViews];
    [self setupConstraints];
}

- (void)setupViews{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
 
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)setupConstraints{
    
    __weak __typeof(self) ws = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
}

- (void)clickRightItem{
    NSLog(@"ClickRight");

}

- (void)logout{
    [[TIMManager sharedInstance] logout:^{
        NSLog(@"登出成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"登出失败, msg = %@", msg);
    }];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = @"退出登录";
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self logout];
}

@end
