//
//  CGIOP.h
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncOperation.h"
#import "UploadTask.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^ExecuteBlock)(RNRequest * request);

@interface CGIOP :  AsyncOperation

@property (nonatomic, strong, nullable) NSArray * keyCodes;
@property (nonatomic, strong) RNRequest *request;
@property (nonatomic, weak) UploadTask *uploadtask;
@property (nonatomic, copy)   ExecuteBlock exeBlock;

@end
NS_ASSUME_NONNULL_END
