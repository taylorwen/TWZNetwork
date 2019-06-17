//
//  CPCache.m
//  NetWork
//
//  Created by Oeasy on 16/3/9.
//  Copyright © 2016年 Oeasy. All rights reserved.
//

#import "CPCache.h"
#import "NSString+Util.h"

// 常用路径
#define kPathDocuments  [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kPathLibrary    [NSHomeDirectory() stringByAppendingPathComponent:@"Library"]
#define kPathTmp        [NSHomeDirectory() stringByAppendingPathComponent:@"tmp"]
#define kPathCache      [kPathLibrary stringByAppendingPathComponent:@"Caches"]

@interface CPCache()

@property (nonatomic,strong) NSString * cachePath;

@end

@implementation CPCache

- (id)initWithCoder:(NSCoder *)aDecoder{
    return self;
}
+ (CPCache*)shared
{
    static CPCache * cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [[self alloc] init];
    });
    return cache;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cachePath = [kPathCache stringByAppendingPathComponent:@"ascache"];
        BOOL isDir = NO;
        if (![[NSFileManager defaultManager]fileExistsAtPath:_cachePath isDirectory:&isDir] || !isDir) {
            
            [[NSFileManager defaultManager]createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
            
        }
    }
    return self;
}

- (void)store:(id)aModel forIdentifier:(NSString*)identifier
{
        identifier = [identifier MD5];
    
    NSString * cachefile = [_cachePath stringByAppendingPathComponent:identifier];
    
    NSData * data = [NSKeyedArchiver archivedDataWithRootObject:aModel];
    
    [data writeToFile:cachefile atomically:YES];
    
}

- (id)getByIdentifier:(NSString*)identifier
{
        identifier = [identifier MD5];
    
    NSString * cachefile = [_cachePath stringByAppendingPathComponent:identifier];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:cachefile]) {
        return nil;
    }
    
    //NSData *data = [NSData dataWithContentsOfMappedFile:cachefile];
    NSData *data = [NSData dataWithContentsOfFile:cachefile options:NSDataReadingMappedIfSafe error:nil];
    
    if(data){
        @try {
            
            id dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            
            return dict;
            
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {
            
        }
    }
}

- (id)getByIdentifier:(NSString*)identifier forTime:(double)aInterval
{
        identifier = [identifier MD5];
    
    NSString * cachefile = [_cachePath stringByAppendingPathComponent:identifier];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:cachefile]) {
        return nil;
    }
    
    NSDictionary *fileAttributes = [[NSFileManager defaultManager]attributesOfItemAtPath:cachefile error:nil];
    
    NSDate * modifyDate = [fileAttributes fileModificationDate];
    
    NSDate * currentDate = [NSDate date];
    
    NSTimeInterval intelval = [currentDate timeIntervalSince1970] - [modifyDate timeIntervalSince1970];
    
    if (intelval > aInterval) {
        [[NSFileManager defaultManager]removeItemAtPath:cachefile error:nil];
        return nil;
    }
    
    //NSData *data = [NSData dataWithContentsOfMappedFile:cachefile];
    NSData *data = [NSData dataWithContentsOfFile:cachefile options:NSDataReadingMappedIfSafe error:nil];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
}

- (void)removeByIdentifier:(NSString*)identifier
{
        identifier = [identifier MD5];
    
    NSString * cachefile = [_cachePath stringByAppendingPathComponent:identifier];
    
    if ([[NSFileManager defaultManager]fileExistsAtPath:cachefile]) {
        [[NSFileManager defaultManager]removeItemAtPath:cachefile error:nil];
    }
}
//清除缓存
- (void)clear
{
    [[NSFileManager defaultManager]removeItemAtPath:_cachePath error:nil];
    BOOL isDir = NO;
    if (![[NSFileManager defaultManager]fileExistsAtPath:_cachePath isDirectory:&isDir] || !isDir) {
        [[NSFileManager defaultManager]createDirectoryAtPath:_cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        
    }
}
- (void)storeRSSI:(NSArray *)array forIdentifier:(NSString *)identifier{
    NSString * RSSIfile = [_cachePath stringByAppendingPathComponent:@"RSSI.plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:RSSIfile];
    if(!dic){
        dic = [[NSMutableDictionary alloc] init];
    }
    [dic setValue:array forKey:[self currentDate]];
    [dic writeToFile:RSSIfile atomically:YES];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"storeRSSI" ofType:@"plist"];
//    NSMutableArray *fileArray = [NSMutableArray arrayWithContentsOfFile:filePath];
//    [fileArray addObject:array];
//    [fileArray writeToFile:filePath atomically:YES];
}
- (NSDictionary *)getRSSI:(NSString *)identifier{
    NSString * RSSIfile = [_cachePath stringByAppendingPathComponent:@"RSSI.plist"];
    
    if (![[NSFileManager defaultManager]fileExistsAtPath:RSSIfile]) {
        return nil;
    }
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:RSSIfile];
    return  dic;
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"storeRSSI" ofType:@"plist"];
//    NSMutableArray *fileArray = [NSMutableArray arrayWithContentsOfFile:filePath];
//    return fileArray;
}
- (NSString *)currentDate{
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval time=[date timeIntervalSince1970];
    
    NSString *currentTime=[NSString stringWithFormat:@"%.0f",time];

    return currentTime;
}
@end
