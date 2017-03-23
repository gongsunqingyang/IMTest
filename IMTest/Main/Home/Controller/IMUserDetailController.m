//
//  IMUserDetailController.m
//  IMTest
//
//  Created by yanglin on 2017/3/15.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMUserDetailController.h"

#import <SVProgressHUD.h>

@interface IMUserDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *IDLabel;
@property (weak, nonatomic) IBOutlet UITextField *nickNameLabel;

@end

@implementation IMUserDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];

}

- (void)setupViews{
    
    _IDLabel.text = _userProfile.identifier;
    _nickNameLabel.text = _userProfile.nickname;
}

- (IBAction)clickChangeBtn {
    [[TIMFriendshipManager sharedInstance] SetNickname:_nickNameLabel.text succ:^{
        [SVProgressHUD showSuccessWithStatus:@"修改成功"];
    } fail:^(int code, NSString *msg) {
        [SVProgressHUD showErrorWithStatus:@"修改失败"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
