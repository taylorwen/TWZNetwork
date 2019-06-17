//
//  RequestResult.h
//  LYNetwork_Example
//
//  Created by wenzhan on 2019/3/19.
//  Copyright © 2019年 zhangdaokui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RequestResult : NSObject

@property (nonatomic, assign) NSInteger         status;    // -1、失败   0、成功无数据返回  1、成功有数据返回
@property (nonatomic,   copy) NSString          *code;      //返回代码
@property (nonatomic,   copy) NSString          *message;   //返回消息
@property (nonatomic, strong) NSArray           *results;   //
@property (nonatomic, strong) NSDictionary      *resultInfo;
@property (nonatomic,   copy) NSString          *resultString;
@property (nonatomic,   copy) NSString          *reachEnd;  //是否取完数据（分页请求时 0、未取完 1、已取完）
@property (nonatomic, strong) NSNumber          *number;
@property (nonatomic, strong) NSDictionary      *unencryptedReqParams;
@property (nonatomic, strong) NSDictionary      *requestParameters;     //请求的参数

@end

NS_ASSUME_NONNULL_END
