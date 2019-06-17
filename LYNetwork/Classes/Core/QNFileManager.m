//
//  QNFileManager.m
//  CommonProject
//
//  Created by lileilei on 15/11/13.
//  Copyright (c) 2015年 jiayi. All rights reserved.
//

#import "QNFileManager.h"
#import "QiniuSDK.h"
#import "NSString+Util.h"
#import "CPNetworkController.h"
#import "NetworkDefine.h"

#define      VisualTalkRequestQNToken @"/yihao01-app-api/app/qiniu/getImgUploadTokenAndDomain"

@implementation QNFileManager

- (id)init
{
    self = [super init];
    if (self) {
        if (!_upManager) {
            _upManager = [[QNUploadManager alloc] init];
        }
    }
    return self;
}

-(void)putFile:(NSString*)filePath biz:(NSString*)biz json:(NSDictionary*)jsonDic complete:(QNUpCompletionHandler)completionHandler failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure{
    [self putFile:filePath key:nil biz:biz json:jsonDic complete:completionHandler failure:failure progressHandler:nil];
}

-(void)putFile:(NSString*)filePath key:(NSString* _Nullable)key biz:(NSString*)biz json:(NSDictionary*)jsonDic complete:(QNUpCompletionHandler)completionHandler failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure progressHandler:(QNUpProgressHandler)progress{
    NSString *xid = [[NSUserDefaults standardUserDefaults] objectForKey:@"xid"];  //取 userdefaults的值
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] initWithObjectsAndKeys:
                                       xid,@"xid",
                                       biz,@"biz",
                                       nil];
    
    if (jsonDic) {
        NSString *jsonStr = [NSString toJSONString:jsonDic];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        [parameters setObject:jsonStr forKey:@"json"];
    }

    [[CPNetworkController shareController] requestVideo:LYHttpMethodPOST interface:VisualTalkRequestQNToken parameters:parameters successed:^(id resultData, NSString *desc, NSString *code) {
        NSDictionary *dict = (NSDictionary *)resultData;
        NSString *token = dict[@"data"][@"uploadToken"];
        if (token) {
            NSString *path = filePath;
            UIImage *image = [UIImage imageWithContentsOfFile:path];
            NSData *imageData = UIImageJPEGRepresentation(image, 1);
            
            __block BOOL flag = NO;
            QNUploadOption *opt = nil;
            if (progress) {
                opt = [[QNUploadOption alloc] initWithMime:nil progressHandler: progress params:nil checkCrc:NO cancellationSignal: ^BOOL () {
                    return flag;
                }];
            }
            [_upManager putData:imageData key:nil token:token complete:completionHandler option:opt];
        }
    } failed:^(NSError *error, NSString *desc, NSString *code) {
        NSLog(@"fail  error = %@, desc = %@, code = %@", error, desc, code);
    }];
}

@end
