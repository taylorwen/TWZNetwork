//
//  NSString+Util.m
//  LYNetwork_Example
//
//  Created by wenzhan on 2019/3/19.
//  Copyright © 2019年 zhangdaokui. All rights reserved.
//

#import "NSString+Util.h"

@implementation NSString (Util)

+ (NSString *)randomStringWithLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}

//年月日
+ (NSString *)getYearMonthDay
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    
    NSInteger year =  [dateComponent year];
    NSInteger month =  [dateComponent month];
    NSInteger day =  [dateComponent day];
    NSString *dateStr = [NSString stringWithFormat:@"%ld%ld%ld",(long)year,(long)month,(long)day];
    return dateStr;
}

//时分秒
+ (NSString *)getHourMinute
{
    NSDate *currentDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:currentDate];
    
    NSInteger hour =  [dateComponent hour];
    NSInteger minute =  [dateComponent minute];
    NSInteger second =  [dateComponent second];
    NSString *dateStr = [NSString stringWithFormat:@"%ld%ld%ld",(long)hour,(long)minute,(long)second];
    return dateStr;
}

+ (NSString *)returnStringOfTimestampRandomString {
    
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd_HH:mm:ss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 8];
    
    for (int i=0; i<8; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    NSString *result = [NSString stringWithFormat:@"%@_%@",dateString, randomString];
    
    return result;
}

- (id)MD5 {
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

+ (NSString *)getCurrentVersion {
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (version.length == 0) {
        version = @"";
    }
    return version;
}

+ (NSString *)toJSONString:(id)theData {
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                     encoding:NSUTF8StringEncoding];
        return jsonString;
    }else{
        return nil;
    }
}

@end
