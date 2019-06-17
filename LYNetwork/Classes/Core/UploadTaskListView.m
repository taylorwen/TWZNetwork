//
//  UploadTaskListView.m
//  PropertyCloud
//
//  Created by Ming on 2017/2/27.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#define restartTag      100
#define cancelTag       200

#import "UploadTaskListView.h"
#import "UploadTaskManager.h"
#import "NSString+Util.h"
#import "NetworkDefine.h"

static UploadTaskListView *taskListView = nil;
static dispatch_once_t onceToken;

@interface UploadTaskListView ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) UIView *closeView;

@end

@implementation UploadTaskListView

+ (UploadTaskListView *)shareView
{
    dispatch_once(&onceToken, ^{
        taskListView = [[self alloc] init];
    });
    return taskListView;
}

+ (void)attemptDealloc
{
    
    onceToken = 0;
    taskListView = nil;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _dataSource = [NSMutableArray array];
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = COLOR_FROM_RGB(0x999999);
    _uploadTaskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.frame.size.height) style:UITableViewStylePlain];
    _uploadTaskTableView.delegate = self;
    _uploadTaskTableView.dataSource = self;
    [self addSubview:_uploadTaskTableView];
    
    ///手势
    UISwipeGestureRecognizer *rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeAction:)];
    rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
    rightSwipeGestureRecognizer.delegate = self;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:rightSwipeGestureRecognizer];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _taskDicSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    return cell;
}

- (void)setTaskDicSource:(NSMutableDictionary *)taskDicSource{
    
    _taskDicSource = taskDicSource;
    
    CGFloat height = 0;
    if (_taskDicSource.count >= 3) {
        height = 110;
    }else{
        height = _taskDicSource.count*40 + 30;
    }
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, height);
    self.uploadTaskTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, height-30);
    
    if (_taskDicSource.count > 0) {
        self.hidden = NO;
        [self getCurrentWindow].windowLevel = UIWindowLevelAlert;
    }else{
        self.hidden = YES;
        [self getCurrentWindow].windowLevel = UIWindowLevelNormal;
    }
    
    
    for (NSString *key  in _taskDicSource.allKeys) {
        
        UploadTask *uploadTask = _taskDicSource[key];
        [_dataSource addObject:uploadTask];
        
    }
    
    [_uploadTaskTableView reloadData];
}

- (void)restartBtnClick:(UIButton *)sender{
    UploadTask *uploadTask = _dataSource[sender.tag - restartTag];
    NSString *taskId = uploadTask.taskId;
    [[UploadTaskManager sharedInstance] restartTask:taskId error:nil];
}

- (void)cancelBtnClick:(UIButton *)sender{
    UploadTask *uploadTask = _dataSource[sender.tag - cancelTag];
    NSString *taskId = uploadTask.taskId;
    [[UploadTaskManager sharedInstance] cancelTask:taskId error:nil];
}

- (void)handleSwipeAction:(UISwipeGestureRecognizer*)recognizer{
    self.hidden = YES;
    [self getCurrentWindow].windowLevel = UIWindowLevelNormal;
}

- (UIWindow *)getCurrentWindow {
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    return window;
}

@end
