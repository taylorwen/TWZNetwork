//
//  CPModel.h
//  NetWork
//
//  Created by Oeasy on 16/3/9.
//  Copyright © 2016年 Oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
    model基类
 */
@interface CPModel : NSObject
///**
// 用户唯一标示
// */
//@property (nonatomic,copy)NSString *xid;
/**
 参数签名
 */
@property (nonatomic,copy)NSString *sign;
/**
 回调描述
 */
@property (nonatomic,copy)NSString *desc;
/**
 回调code码（200，404，500之类的）
 */
@property (nonatomic,copy)NSString *code;
/**
 　 获取类属性
 */
+ (NSArray *)propertyKeys;
- (NSArray *)propertyKeys;
/**
 反射机制实现方法
 */

- (BOOL)reflectFromObject:(NSObject*)aObj;

#pragma mark 类型判断方法
+ (NSString *)tableNameWithClass:(Class)aClas;
+ (Class)getType:(NSString*)aKey andClass:(Class)aClas;
- (Class)getType:(NSString*)aKey;
+ (BOOL)isTypeOfArray:(NSString*)key;
+ (BOOL)isTypeOfDB:(NSString*)key;
+ (Class)getType:(NSString*)aKey;

+ (BOOL)isTypeOfArray:(NSString*)key andClass:(Class)aClas;
+ (BOOL)isTypeOfDB:(NSString*)key andClass:(Class)aClas;
+ (Class)listToClass:(NSString*)aList;
- (NSString *)tableName;

+ (NSString *)tableName;
- (NSNumber *)currentTime;
@end
NS_ASSUME_NONNULL_END
