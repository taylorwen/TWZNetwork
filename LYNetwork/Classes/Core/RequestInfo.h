//
//  RequestInfo.h
//  LYNetwork_Example
//
//  Created by wenzhan on 2019/3/19.
//  Copyright © 2019年 zhangdaokui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestResult.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestInfo : NSObject

@property (nonatomic,   copy) NSString         *url;      //返回代码
@property (nonatomic, strong) NSDictionary     *paramers;
@property (nonatomic,   weak) id delegate;
@property (nonatomic,   copy) NSString      *reqinteface;
@property (nonatomic, assign) int requestType; // 1:json
@property (nonatomic, assign) int responeType; //1:repsone系列化
@property (nonatomic, strong) NSDictionary    *unencryptedParams;//不加密的请求参数，返回时会使用
@property (nonatomic,   copy) void(^completeHandler)(RequestResult *result);

@end

NS_ASSUME_NONNULL_END
