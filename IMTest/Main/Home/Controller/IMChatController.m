//
//  IMChatController.m
//  IMTest
//
//  Created by yanglin on 2017/3/2.
//  Copyright © 2017年 瓦普时代. All rights reserved.
//

#import "IMChatController.h"
#import "IMListener.h"
#import "MYMacros.h"
#import "MYConstant.h"
#import "IMChatCell.h"
#import "IMMsgVM.h"

#import <Masonry.h>
#import <SVProgressHUD.h>

@interface IMChatController ()<UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITextView *inputView;
@property (strong, nonatomic) UIButton *imgBtn;
@property (strong, nonatomic) UIButton *sendBtn;

@property (strong, nonatomic) NSMutableArray <IMMsgVM *>*msgs;

@end


@implementation IMChatController

static NSString * cellId = @"IMChatCell";

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kAddNotification(self, @selector(receiveMsg:), kOnNewMessage, nil);
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    kRemoveAllNotification;
}

- (instancetype)initWithControllerType:(ChatControllerType)controllerType{
    self = [super init];
    if (self) {
        _controllerType = controllerType;
    }
    return self;
}

- (NSMutableArray<IMMsgVM *> *)msgs{
    if (!_msgs) {
        _msgs = [NSMutableArray array];
    }
    return _msgs;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupViews];
    [self setupConstraints];
    [self config];
    [self loadData];

}

- (void)setupViews{

    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    
    _tableView = [[UITableView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerClass:[IMChatCell class] forCellReuseIdentifier:cellId];
    [self.view addSubview:_tableView];
    
    _inputView = [[UITextView alloc] init];
    _inputView.font = [UIFont systemFontOfSize:16];
    _inputView.returnKeyType = UIReturnKeySend;
    _inputView.backgroundColor = [UIColor whiteColor];
    _inputView.delegate = self;
    [self.view addSubview:_inputView];
    
    _imgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_imgBtn setTitle:@"表情" forState:UIControlStateNormal];
    [_imgBtn addTarget:self action:@selector(clickEmotion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_imgBtn];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sendBtn setTitle:@"图片" forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(clickImgBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendBtn];
    
    
}

- (void)setupConstraints{
    __weak __typeof(self) ws = self;
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(ws.view);
        make.bottom.equalTo(_inputView.mas_top).offset(-10);
    }];
    
    [_inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view).offset(10);
        make.bottom.equalTo(ws.view).offset(-10);
        make.height.mas_equalTo(40);
    }];
    
    [_imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_inputView.mas_right).offset(10);
        make.centerY.equalTo(_inputView);
        make.centerY.equalTo(@[_sendBtn]);
    }];
    
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imgBtn.mas_right).offset(10);
        make.right.equalTo(ws.view).offset(-10);
    }];
}

//配置控制器
- (void)config{
    switch (_controllerType) {
        case ChatControllerType_C2C:{
            
            [[TIMManager sharedInstance] setMessageListener:[IMListener sharedInstance]];
        }
            break;
        case ChatControllerType_PublicGroup:{
            
        }
            break;
        case ChatControllerType_AVChatRoomGroup:{
            
            _imgBtn.enabled = NO;

            
        }
            break;
        default:
            break;
    }
}

//请求聊天记录
- (void)loadData{
    
    [_conversation getLocalMessage:20 last:nil succ:^(NSArray *msgs) {
        [self.msgs removeAllObjects];
        [_tableView reloadData];
        for (TIMMessage *msg in msgs) {
            [self addMsg:msg];
        }
    } fail:^(int code, NSString *msg) {
        NSLog(@"请求聊天记录失败，code = %@, msg = %@", @(code), msg);
    }];
}

//添加文字
- (void)sendText:(NSString *)text{
    TIMMessage *msg = [[TIMMessage alloc] init];
    TIMTextElem *text_elm = [[TIMTextElem alloc] init];
    text_elm.text = text;
    [msg addElem:text_elm];
    [self send:msg];
}

//添加图片
- (void)sendImg:(NSString *)path{
    TIMMessage *msg = [[TIMMessage alloc] init];
    TIMImageElem *img_elm = [[TIMImageElem alloc] init];
    img_elm.path = path;
    [msg addElem:img_elm];
    [self send:msg];
}

//点击表情
- (void)clickEmotion{
    NSLog(@"暂未实现");
}

//点击照片
- (void)clickImgBtn{
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.allowsEditing = YES;
    vc.delegate = self;
    [self presentViewController:vc animated:YES completion:nil];
}

//发送消息
- (void)send:(TIMMessage *)message{
    [self addMsg:message];
    [_conversation sendMessage:message succ:^{
        NSLog(@"发送成功");
    } fail:^(int code, NSString *msg) {
        NSLog(@"发送失败，code = %@, msg = %@", @(code), msg);
    }];
}

//收到消息
- (void)receiveMsg:(NSNotification *)notification{
    TIMMessage *msg = notification.object;
    [self addMsg:msg];
}

//添加到聊天记录
- (void)addMsg:(TIMMessage *)msg{
    
    //转换成ViewModel
    IMMsgVM *msgVM = [[IMMsgVM alloc] init];
    msgVM.msg = msg;
    [_msgs addObject:msgVM];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_tableView numberOfRowsInSection:0] inSection:0];
    [_tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.msgs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IMChatCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    cell.msgVM = _msgs[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    IMMsgVM *msgVM = _msgs[indexPath.row];
    return msgVM.h;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"] && textView.text.length) {
        
        [self sendText:textView.text];
        textView.text = nil;
        
        return NO;
    }
    return YES;
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"didFinishPickingMediaWithInfo");
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *img = [info valueForKey:@"UIImagePickerControllerOriginalImage"];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *prefixPath = NSTemporaryDirectory();
    NSString *path = [NSString stringWithFormat:@"%@_uploadImgPath_%.3f", prefixPath, [NSDate timeIntervalSinceReferenceDate]];
    NSData *data = UIImagePNGRepresentation(img);
    if ([fileManager createFileAtPath:path contents:data attributes:nil]) {
        NSLog(@"创建文件成功 path = %@", path);
    }else{
        NSLog(@"创建文件失败 path = %@", path);
    }
    
    [self sendImg:path];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"imagePickerControllerDidCancel");
    [picker dismissViewControllerAnimated:YES completion:nil];

}

@end
