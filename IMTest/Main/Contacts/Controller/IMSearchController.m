//
//  IMSearchController.m
//  IMTest
//
//  Created by yanglin on 2017/3/15.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMSearchController.h"
#import "MYMacros.h"
#import "MYConstant.h"

#import <ImSDK/ImSDK.h>
#import <SVProgressHUD.h>


@interface IMSearchController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg;
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign, nonatomic) SearchType searchType;
@property (strong, nonatomic) NSArray *dataArr;


@end


@implementation IMSearchController
static NSString *cellId = @"UITableViewCell";
- (NSArray *)dataArr{
    if (!_dataArr){
        _dataArr=[NSArray array];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];

}

- (void)setupViews{
    [_seg addTarget:self action:@selector(changeSeg:) forControlEvents:UIControlEventValueChanged];
    
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
}

//改变分段选择器
- (void)changeSeg:(UISegmentedControl *)seg{
    _searchType = (SearchType)seg.selectedSegmentIndex;
}

- (IBAction)clickSearchBtn {
    switch (_searchType) {
        case SearchType_User:{
            
            [[TIMFriendshipManager sharedInstance] GetUsersProfile:@[_searchField.text] succ:^(NSArray <TIMUserProfile *>*friends) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    _dataArr = friends;
                    [_tableView reloadData];
                });
            }fail:^(int code, NSString *msg) {
                
                NSLog(@"code = %@, msg = %@", @(code), msg);
                [[TIMFriendshipManager sharedInstance] SearchUser:_searchField.text pageIndex:0 pageSize:100 succ:^(uint64_t totalNum, NSArray <TIMUserProfile *>*users) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _dataArr = users;
                        [_tableView reloadData];
                    });
                }fail:^(int code, NSString *msg) {
                    
                    NSLog(@"code = %@, msg = %@", @(code), msg);
                }];
                
            }];
        }
            break;
        case SearchType_Group:{
            [[TIMGroupManager sharedInstance] SearchGroup:_searchField.text flags:TIM_GET_GROUP_BASE_INFO_FLAG_NAME custom:nil pageIndex:0 pageSize:100 succ:^(uint64_t totalNum, NSArray <TIMGroupInfo *>*groups) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _dataArr = groups;
                    [_tableView reloadData];
                });
            }fail:^(int code, NSString *msg) {
                NSLog(@"code = %@, msg = %@", @(code), msg);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    id model = _dataArr[indexPath.row];
    switch (_searchType) {
        case SearchType_User:{
            cell.textLabel.text = ((TIMUserProfile *)model).identifier;
            
        }
            break;
        case SearchType_Group:{
            cell.textLabel.text = ((TIMGroupInfo *)model).group;
            
        }
            break;
        default:
            break;
    }
    return cell;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (_searchType) {
        case SearchType_User:{
            TIMUserProfile *model = _dataArr[indexPath.row];
            TIMAddFriendRequest *req = [[TIMAddFriendRequest alloc] init];
            req.identifier = model.identifier;
            req.remark = model.nickname;
            req.addWording = @"申请理由";
            
            [[TIMFriendshipManager sharedInstance] AddFriend:@[req] succ:^(NSArray *friends) {
                for (TIMFriendResult *result in friends) {
                    if (result.status == TIM_FRIEND_STATUS_SUCC) {
                        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"添加成功： %@", result.identifier]];
                    }else{
                        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"添加失败： %@", @(result.status)]];
                    }
                }
            } fail:^(int code, NSString *msg) {
                [SVProgressHUD showErrorWithStatus:@"请求失败"];
            }];
        }
            break;
        case SearchType_Group:{
            TIMGroupInfo *model = _dataArr[indexPath.row];
            
            [[TIMGroupManager sharedInstance] JoinGroup:model.group msg:@"申请理由" succ:^{
                [SVProgressHUD showSuccessWithStatus:@"加入成功"];
            } fail:^(int code, NSString *msg) {
                [SVProgressHUD showErrorWithStatus:@"加入失败"];
            }];
        }
            break;
        default:
            break;
    }
}

@end
