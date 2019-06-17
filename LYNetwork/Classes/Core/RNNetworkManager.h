//
//  RNNetworkManager.h
//  CommonProject
//
//  Created by Ming Wang on 2017/3/1.
//  Copyright © 2017年 oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "RNRequest.h"

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    CPRequestForGet,
    CPRequestForPost
}CPRequestMethod;
@class RNNetworkManager;

/**
 成功回调
 */
typedef void(^Successed)(RNNetworkManager *network,id responseObject,NSString *desc,NSString *code,NSString *key);
/**
 失败回调
 */
typedef void(^Failed)(RNNetworkManager *networkk,id responseObject,NSString *desc,NSString *code,NSString *key);


@interface RNNetworkManager : NSObject

+(RNNetworkManager *)shared;

- (void)request:(RNRequest *)request success:(Successed)success fail:(Failed)fail;

+(NSDictionary *)myMD5Dic:(NSDictionary*)sourDic andKey:(NSString*)key;

@end
NS_ASSUME_NONNULL_END
