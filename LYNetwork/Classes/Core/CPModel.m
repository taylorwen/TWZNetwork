//
//  CPModel.m
//  NetWork
//
//  Created by Oeasy on 16/3/9.
//  Copyright © 2016年 Oeasy. All rights reserved.
//

#import "CPModel.h"
#import <objc/runtime.h>

@implementation CPModel
    
+ (NSArray*)propertyKeys
{
    unsigned int outCount, i;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if(propertyName&&propertyName != nil){
            [keys addObject:propertyName];
        }
    }
    
    free(properties);
    return keys;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    
    NSArray *acode = [self propertyKeys];
    
    for(NSString *key in acode){
        
        NSObject *obj = [aDecoder decodeObjectForKey:key];
        if(obj != nil){
            [self setValue:obj forKey:key];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    NSArray *acode = [self propertyKeys];
    
    for(NSString *key in acode){
        
        NSObject *obj = [self valueForKey:key];
        
        if(obj != nil){
            
            [aCoder encodeObject:obj forKey:key];
            
        }
    }
}

- (NSArray *)propertyKeys{
    return [[self class] propertyKeys];
}

- (BOOL)reflectFromObject:(NSObject *)aObj{
    BOOL ret = NO;
    
    for (NSString *key in [self propertyKeys]){
        NSString *str = key;

        if([aObj isKindOfClass:[NSDictionary class]]){
            ret = ([aObj valueForKey:str] == nil) ?NO:YES;
        }else{
            ret = [aObj respondsToSelector:NSSelectorFromString(str)];
        }
        if(ret){
            id propertyValue = [aObj valueForKey:str];
            if(![propertyValue isKindOfClass:[NSNull class]] && propertyValue != nil){

                [self setValue:propertyValue forKey:key];
            }
        }
    }
    return ret;
}
    
- (id)copyWithZone:(NSZone *)zone{
    CPModel *model = [[[self class] allocWithZone:zone] init];
    size_t instanceCopy = class_getInstanceSize([self class]);
    memcmp((__bridge void*)(model), (__bridge const void*)(self), instanceCopy);
    return model;
}
    
- (id)mutableCopyWithZone:(NSZone *)zone{
    CPModel *model = [[[self class] allocWithZone:zone] init];
    size_t instanceCopy = class_getInstanceSize([self class]);
    memcmp((__bridge void*)(model), (__bridge const void*)(self), instanceCopy);
    return model;
}
    
- (NSString *)tableName
{
    return [[self class] tableNameWithClass:[self class]];
}

+ (NSString *)tableName
{
    return [[self class] tableNameWithClass:[self class]];
}
    
+ (Class)listToClass:(NSString*)aList
{
    if ([aList hasPrefix:@"items"]) {
        NSString * newKey = [aList substringFromIndex:4];
        NSString * className = [NSString stringWithFormat:@"CP%@",newKey];
        return NSClassFromString(className);
    }
    return NULL;
}

+ (NSString *)tableNameWithClass:(Class)aClas
{
    NSString * className = NSStringFromClass(aClas);
    
    if ([className hasPrefix:@"CP"]) {
        return [className substringFromIndex:2];
    }
    
    return className;
}
    
+ (Class)getType:(NSString*)aKey
{
    return [[self class] getType:aKey andClass:[self class]];
}


+ (BOOL)isTypeOfDB:(NSString*)key
{
    return [[self class] isTypeOfArray:key];
}


+ (BOOL)isTypeOfArray:(NSString*)key
{
    
    return [[self class] isTypeOfArray:key];
}


- (Class)getType:(NSString*)aKey
{
    return [[self class]getType:aKey];
}

+ (Class)getType:(NSString*)aKey andClass:(Class)aClas
{
    objc_property_t property = class_getProperty(aClas, [aKey UTF8String]);
    
    const char * attr = property_getAttributes(property);
    
    NSString * strAttr = [NSString stringWithUTF8String:attr];
    
    
    if ([strAttr rangeOfString:NSStringFromClass([NSString class])].location
        != NSNotFound) {
        
        return [NSString class];
        
    } else if ([strAttr rangeOfString:NSStringFromClass([NSNumber class])].location
               != NSNotFound) {
        
        return [NSNumber class];
        
    } else if ([strAttr rangeOfString:NSStringFromClass([NSArray class])].location
               != NSNotFound) {
        
        return [NSArray class];
        
    }
    
    return nil;
}
    
+ (BOOL)isTypeOfDB:(NSString*)key andClass:(Class)aClas
{
    Class classType = [self getType:key andClass:aClas];
    
    return ([classType isSubclassOfClass:[NSString class]] ||
            [classType isSubclassOfClass:[NSNumber class]]);
}



+ (BOOL)isTypeOfArray:(NSString*)key andClass:(Class)aClas
{
    Class classType = [self getType:key andClass:aClas];
    
    return [classType isSubclassOfClass:[NSArray class]];
}
    
- (NSNumber*)currentTime
{
    double interval = [[NSDate date]timeIntervalSince1970];
    
    return [NSNumber numberWithDouble:interval];
}
@end
