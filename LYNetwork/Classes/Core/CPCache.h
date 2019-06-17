//
//  CPCache.h
//  NetWork
//
//  Created by Oeasy on 16/3/9.
//  Copyright © 2016年 Oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 缓存类
 */
@interface CPCache : NSObject
/**
 初始化实例
 */
+ (CPCache*)shared;
/**
 存数据
 */
- (void)store:(id)aModel forIdentifier:(NSString*)identifier;
/**
 取数据
 */
- (id)getByIdentifier:(NSString*)identifier;

- (id)getByIdentifier:(NSString*)identifier forTime:(double)aInterval;
/**
 删除单条数据
 */
- (void)removeByIdentifier:(NSString*)identifier;
/**
 删除所有数据
 */
- (void)clear;

/**
 存储RSSI数据
 */
- (void)storeRSSI:(NSArray *)array forIdentifier:(NSString *)identifier;
/**
 取出所有RSSI数据
 */
- (NSDictionary *)getRSSI:(NSString *)identifier;
@end
NS_ASSUME_NONNULL_END
