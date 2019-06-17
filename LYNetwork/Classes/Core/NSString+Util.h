//
//  NSString+Util.h
//  LYNetwork_Example
//
//  Created by wenzhan on 2019/3/19.
//  Copyright © 2019年 zhangdaokui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Util)

+ (NSString *)randomStringWithLength:(int)len;

+ (NSString *)getYearMonthDay;

+ (NSString *)getHourMinute;

+ (NSString *)returnStringOfTimestampRandomString;

+ (NSString *)getCurrentVersion;

- (id)MD5;

+ (NSString *)toJSONString:(id)theData;

@end

NS_ASSUME_NONNULL_END
