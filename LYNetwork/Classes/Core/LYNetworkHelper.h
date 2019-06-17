//
//  LYNetworkHelper.h
//  LYNetwork_Example
//
//  Created by wenzhan on 2019/4/24.
//  Copyright © 2019 zhangdaokui. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class RequestInfo,RequestResult;

@interface LYNetworkHelper : NSObject

+ (LYNetworkHelper *)sharedHelper;

#pragma mark - Configure Request
- (RequestInfo *)configureServiceRequestWithInterface:(NSString *)interface parameters:(NSDictionary *)parameters;

- (RequestInfo *)configurePropertyRequestWithInterface:(NSString *)interface parameters:(NSDictionary *)parameters;

- (RequestInfo *)configureAccessRequestWithInterface:(NSString *)interface parameters:(NSDictionary *)parameters;

- (RequestInfo *)configureAloTRequestWithInterface:(NSString *)interface parameters:(NSDictionary *)parameters;

- (RequestInfo *)configureVideoRequestWithInterface:(NSString *)interface parameters:(NSDictionary *)parameters;

#pragma mark - Parse Data
- (RequestResult *)parseDataStringForNewPort:(id)string requestInterface:(NSString *)interface;

- (RequestResult *)parseDataStringForProperty:(id)string requestInterface:(NSString *)interface;

- (RequestResult *)parseDataStringForAccess:(id)string requestInterface:(NSString *)interface;

- (RequestResult *)parseDataStringForAloT:(id)string requestInterface:(NSString *)interface;

@end

NS_ASSUME_NONNULL_END
