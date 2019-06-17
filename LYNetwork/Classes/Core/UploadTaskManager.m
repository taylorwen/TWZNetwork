//
//  UploadTaskManager.m
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import "UploadTaskManager.h"
#import "TokenGetOP.h"
#import "ImageOP.h"
#import "CGIOP.h"
#import "UploadTaskListView.h"
#import "NSString+Util.h"

@implementation UploadTaskManager

QNUploadManager *_upManager;

dispatch_queue_t _queue;
static NSMutableDictionary <NSString *, UploadTask *> *_taskDict;

#pragma mark - Class methods

#define SharedInstance (UploadTaskManager ## SharedInstance)
static UploadTaskManager * SharedInstance;

#define DispatchOnce (UploadTaskManager ## once)
/*
 * Use this method to return singleton
 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t DispatchOnce;
    
    dispatch_once(&DispatchOnce, ^{
        SharedInstance = [[self alloc] init];
        _queue = dispatch_queue_create("wm", DISPATCH_QUEUE_SERIAL);
    });
    
    return SharedInstance;
}

- (instancetype)init
{
    if (self = [super init]){
        
        _taskDict = [[NSMutableDictionary alloc] init];
        _upManager = [[QNUploadManager alloc] init];
    }
    return self;
}

+ (void)load
{
    UploadTaskManager *manage = [UploadTaskManager sharedInstance];
    if ([manage recoverFromDiskAndError:nil]){
        NSLog(@"-----恢复成功");
    }else {
        NSLog(@"-----恢复不成功");
    }
    
}

#pragma mark - init methods

#pragma mark - instance methods

#pragma mark - TODO

- (NSMutableDictionary *)getTaskManagerDict
{
    return _taskDict;
}

- (NSString *)addTask:(UploadTask *)task error:(NSError *__autoreleasing *)error
{
    
    dispatch_async(_queue, ^{
        
        if (!task.taskId || task.taskId.length == 0) {
            task.taskId = [NSString returnStringOfTimestampRandomString];
        }
        
        task.isFail = [NSNumber numberWithInteger:0];
        
        [_taskDict setObject:task forKey:task.taskId];
        
        NSLog(@"---%@----", _taskDict);

        NSOperationQueue * oq1 = [[NSOperationQueue alloc] init];
        NSOperationQueue * oq2 = [[NSOperationQueue alloc] init];
        NSOperationQueue * oq3 = [[NSOperationQueue alloc] init];
        
        // 取七牛上传Token操作
        TokenGetOP * getToken = [[TokenGetOP alloc] init];
        NSMutableArray *imageArray = [NSMutableArray arrayWithArray:task.upLoadImageArray];
        
        getToken.uploadTask = task;
        
        // 上传图片操作数组
        NSMutableArray *uploadOps = [NSMutableArray array];
        
        for (id image in imageArray) {
            ImageOP * imgOp = [[ImageOP alloc] init];
            
            if ([image isKindOfClass:[NSString class]]) {
                imgOp.upImagePath = image;
            } else if ([image isKindOfClass:[NSDictionary class]]){
                imgOp.image = image[@"image"];
                imgOp.imageKey = image[@"imageKey"];
            }
            imgOp.fileName = [self getUploadFileName:@"property"];
            imgOp.upManager = _upManager;
            imgOp.uploadTask = task;
            imgOp.fileCount = imageArray.count;
            [uploadOps addObject:imgOp];
            
        }
        
        // 链接取Token和上传图片操作（取token的结果作为上传图片的入参）
        NSBlockOperation * chainTokenImageBlock = [NSBlockOperation blockOperationWithBlock:^{
            for (ImageOP * imgOp in uploadOps) {
                if (getToken.uploadQNToken) {
                    imgOp.qnToken = getToken.uploadQNToken;
                }
                if (getToken.uploadQNDomain) {
                    imgOp.qnDomain = getToken.uploadQNDomain;
                }
                else{
                    
                    [oq2 cancelAllOperations];
                    [oq3 cancelAllOperations];
                }
            }
        }];
   
        // 发布操作
        CGIOP * cgiOp = [[CGIOP alloc] init];
        // 链接上传图片操作和发布操作（所有图片上传完再发布）
        cgiOp.uploadtask = task;
        cgiOp.request = task.request;
        
        __block BOOL allFinish = true;
        __weak CGIOP *weakCgiOp = cgiOp;
        NSBlockOperation * chainImagePublishBlock = [NSBlockOperation blockOperationWithBlock:^{
            
            NSMutableArray * keyCodes = [NSMutableArray array];
            for (ImageOP * imgOp in uploadOps) {
                
                if (imgOp.keyCode) {
                    NSString *imageUrl = @"";
                    
                    if (imgOp.qnDomain) {
                        imageUrl = [NSString stringWithFormat:@"%@%@", imgOp.qnDomain, imgOp.keyCode];
                    }
                    [keyCodes addObject:@{@"keyCode": imgOp.keyCode,
                                          @"imageKey": imgOp.imageKey ?: @"",
                                          @"imageUrl": imageUrl}];
                }
                else
                {
                    allFinish = false;
                    break;
                }
            }
            
            if (allFinish) {
                weakCgiOp.keyCodes = [keyCodes copy];
                if (task.delegate && [task.delegate respondsToSelector:@selector(taskId:uploadImgsCallBack:ruquest:error:requestObject:)]) {
                    
                    [task.delegate taskId:task.taskId uploadImgsCallBack:keyCodes ruquest:task.request error:nil requestObject:^(RNRequest *request) {
                        
                        if (request) {
                            weakCgiOp.request = request;
                        }else{
                            [oq2 cancelAllOperations];
                            [oq3 cancelAllOperations];
                            weakCgiOp.keyCodes = nil;
                        }
                        
                    }];
                    
                    
                }
            }
            else
            {
                NSError *error = [NSError errorWithDomain:@"" code:-10000 userInfo:nil];
                [task.delegate taskId:task.taskId uploadImgsCallBack:keyCodes ruquest:task.request error:error requestObject:^(RNRequest *request) {
                    
                    
                }];
                
                [oq2 cancelAllOperations];
                [oq3 cancelAllOperations];
                weakCgiOp.keyCodes = nil;
            }
        }];
        
        
        /*
         * 添加依赖
         */
        // 链接block操作依赖于取Token
        [chainTokenImageBlock addDependency:getToken];
        
        // 上传图片操作依赖于链接TokenImageblock,发布操作依赖于链接
        for (ImageOP * imgOp in uploadOps) {
            [imgOp addDependency:chainTokenImageBlock];
            [chainImagePublishBlock addDependency:imgOp];
        }
        
        // 发布操作依赖于链接block操作
        if (task.upLoadImageArray && task.upLoadImageArray.count > 0) {
            [oq1 addOperation:getToken];
            
            [oq1 addOperation:chainTokenImageBlock];
            
            for (ImageOP * imgOp in uploadOps) {
                [oq2 addOperation:imgOp];
            }
            
            [oq2 addOperation:chainImagePublishBlock];
            [cgiOp addDependency:chainImagePublishBlock];
        }
        
        /*
         * 添加操作
         */
        
        
        [oq3 addOperation:cgiOp];
        
        
    });
    return task.taskId;
}

- (BOOL)restartTask:(NSString *)taskId error:(NSError *__autoreleasing *)error
{
    BOOL isSuccess = NO;
    if (_taskDict && _taskDict.count > 0) {
        
        for (NSString *key in _taskDict.allKeys) {
            if ([key isEqualToString:taskId]) {
                isSuccess = YES;
            }
        }
        
        if (isSuccess){
            [self addTask:_taskDict[taskId] error:nil];
        }
    }
    return isSuccess;
}

- (BOOL)cancelTask:(NSString *)taskId error:(NSError *__autoreleasing *)error
{
    [_taskDict removeObjectForKey:taskId];
    [[UploadTaskListView shareView] setTaskDicSource:_taskDict];
    return true;
}

- (BOOL)saveToDiskAndError:(NSError **)error
{
    BOOL isSaved = NO;
    if (_taskDict && _taskDict.count > 0) {
        NSData *taskData = [NSKeyedArchiver archivedDataWithRootObject:_taskDict];
        [[NSUserDefaults standardUserDefaults] setObject:taskData forKey:@"myTaskDict"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        isSaved = YES;
    }
    return isSaved;
}


- (BOOL)recoverFromDiskAndError:(NSError *__autoreleasing *)error
{
    BOOL isRecover = NO;
    NSData *taskData = [[NSUserDefaults standardUserDefaults] objectForKey:@"myTaskDict"];
    if (taskData) {
        [_taskDict removeAllObjects];
        NSMutableDictionary *recoverTask = (NSMutableDictionary *)[NSKeyedUnarchiver unarchiveObjectWithData:taskData];
        if (recoverTask && recoverTask.count > 0) {
            isRecover = YES;
            _taskDict = [NSMutableDictionary dictionaryWithDictionary:recoverTask];
        }
    }
    return isRecover;
}

- (NSString *)getUploadFileName:(NSString *)moduleName
{
    NSString *fileName = @"yihaoshequ";
    NSString *dateStr = [NSString getYearMonthDay];
    NSString *timeStr = [NSString getHourMinute];
    NSString *randomStr = [NSString randomStringWithLength:8];
    NSString *areaID = [[NSUserDefaults standardUserDefaults] objectForKey:@"areaID"];   //取 userdefaults的值
    NSString *finalStr = [NSString stringWithFormat:@"%@_%@",timeStr,randomStr];
    fileName = [NSString stringWithFormat:@"%@_%@_%@_%@_%@.png",fileName,moduleName,areaID,dateStr,finalStr];
    return fileName;
}


@end
