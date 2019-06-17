//
//  QNFileManager.h
//  CommonProject
//
//  Created by lileilei on 15/11/13.
//  Copyright (c) 2015年 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QiniuSDK.h"

@interface QNFileManager : NSObject

@property QNUploadManager *upManager;

-(void)putFile:(NSString*)filePath biz:(NSString*)biz json:(NSDictionary*)jsonDic complete:(QNUpCompletionHandler)completionHandler failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

-(void)putFile:(NSString*)filePath key:(NSString*)key biz:(NSString*)biz json:(NSDictionary*)jsonDic complete:(QNUpCompletionHandler)completionHandler failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure progressHandler:(QNUpProgressHandler)progress;

@end
