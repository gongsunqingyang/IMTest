//
//  IMContactsController.m
//  IMTest
//
//  Created by yanglin on 2017/3/2.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMContactsController.h"
#import "IMChatController.h"
#import "IMContactsHeader.h"
#import "MYMacros.h"
#import "MYConstant.h"
#import "IMSearchController.h"

#import <Masonry.h>

@interface IMContactsController ()<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray <TIMGroupInfo *>*groups;

@end

@implementation IMContactsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self setupConstraints];
    [self loadData];
}

- (void)setupViews{
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Left" style:UIBarButtonItemStylePlain target:self action:@selector(clickLeftItem)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"Right" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _tableView = [[UITableView alloc] init];
    _tableView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)setupConstraints{
    __weak __typeof(self) ws = self;
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(ws.view);
    }];
    
}

- (void)loadData{
    [[TIMGroupManager sharedInstance] GetGroupList:^(NSArray *arr) {
        NSLog(@"success");
        _groups = arr;
        [_tableView reloadData];
    } fail:^(int code, NSString *msg) {
        NSLog(@"fail");
    }];
}

- (void)clickLeftItem{
    NSLog(@"ClickLeft");
}

- (void)clickRightItem{
    NSLog(@"ClickRight");
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = kOutStandDate(kMyGroupId);
}

- (void)clickHeader:(NSInteger)tag{
    
    //创建
    if (tag == 0) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"创建聊天室" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *newGroupName = [alert.textFields firstObject].text;
            NSString *myGroupName = kOutStandDate(kMyGroupName);
            if ([newGroupName isEqualToString:myGroupName]) {
                NSLog(@"名字重复");
            }else{
                
                [[TIMGroupManager sharedInstance] CreateAVChatRoomGroup:newGroupName succ:^(NSString *groupId) {
                    NSLog(@"创建音视频聊天室成功 groupID = %@", groupId);
                    kSaveStandDate(newGroupName, kMyGroupName);
                    kSaveStandDate(groupId, kMyGroupId);
                } fail:^(int code, NSString *msg) {
                    NSLog(@"创建音视频聊天室失败 code = %@, msg = %@", @(code), msg);
                }];
            }
        }];
        
        [alert addAction:cancel];
        [alert addAction:confirm];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = @"MYGroupName";
        }];
        [self presentViewController:alert animated:YES completion:nil];
        
    //搜索
    }else if (tag == 1){
        
        IMSearchController *vc = [[IMSearchController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
     
    //申请
    }else if (tag == 2){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"申请进入聊天室" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSString *newGroupName = [alert.textFields firstObject].text;
            [[TIMGroupManager sharedInstance] JoinGroup:newGroupName msg:@"申请理由" succ:^{
                NSLog(@"申请成功");
            } fail:^(int code, NSString *msg) {
                NSLog(@"code = %d, err = %@", code, msg);
            }];
        }];
        
        [alert addAction:cancel];
        [alert addAction:confirm];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = [UIPasteboard generalPasteboard].string;
        }];
        [self presentViewController:alert animated:YES completion:nil];
    }else if (tag == 3){
    }else{
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    TIMGroupInfo *info = _groups[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@, %@", info.groupName, info.group];
    return cell;
}

#pragma mark - UITableViewDelegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    IMContactsHeader *header = [[IMContactsHeader alloc] init];
    __weak __typeof(self) ws = self;
    header.clickBlock = ^(NSInteger tag){
        [ws clickHeader:tag];
    };
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 64;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    IMChatController *vc = [[IMChatController alloc] initWithControllerType:ChatControllerType_AVChatRoomGroup];
    [self.navigationController pushViewController:vc animated:YES];
   
}


@end
