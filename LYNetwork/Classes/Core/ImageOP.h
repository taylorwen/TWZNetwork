//
//  ImageOP.h
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncOperation.h"
#import "UploadTask.h"
#import "QNUploadOption.h"  //七牛
#import "QNUploadManager.h"
#import "QNResponseInfo.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^IOPCompletionBlock)(QNResponseInfo *, NSString *, NSString *);
typedef void(^IOPUploadFailBlock)(NSString * fileName);

@interface ImageOP : AsyncOperation

#pragma mark - input parameters

@property (nonatomic, copy) NSString *qnToken;

@property (nonatomic, copy) NSString *qnDomain;

@property (nonatomic, strong) NSString * upImagePath;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) NSString *imageKey;

@property (nonatomic, strong) NSString * fileName;

@property (nonatomic, strong) QNUploadOption * upOpt;

@property (nonatomic, strong) QNUploadManager * upManager;

@property (nonatomic, weak) UploadTask *uploadTask;

@property (nonatomic, assign) NSInteger fileCount;

#pragma mark - output
@property (nonatomic, assign) BOOL uploaded;
@property (nonatomic, strong, nullable) NSString * keyCode;

#pragma mark - Completion Block
@property (nonatomic, copy) IOPCompletionBlock finishBlock;
@property (nonatomic, copy) IOPUploadFailBlock uploadFailBlock;

@end
NS_ASSUME_NONNULL_END
