//
//  RNNetworkManager.m
//  CommonProject
//
//  Created by Ming Wang on 2017/3/1.
//  Copyright © 2017年 oeasy. All rights reserved.
//

#import "RNNetworkManager.h"
#import <CommonCrypto/CommonCrypto.h>
#import "NSString+Util.h"
#import "CPNetworkController.h"

#define PARTNER_KEY         @"db426a9829e4b49a0dcac7b4162da6b6"
#define AIOT_PARTNER_KEY    @"e8868c67f51b4e2f96e2af69dd6b1dc4"

static RNNetworkManager *network = nil;
static AFHTTPSessionManager *manager = nil;

@implementation RNNetworkManager

+(RNNetworkManager *)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        network = [[self alloc] init];
    });
    return network;
}

+ (AFHTTPSessionManager *)getManager
{    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    
    return manager;
}

- (void)request:(RNRequest *)request success:(Successed)success fail:(Failed)fail
{
    if ([request.way integerValue] == 1) {
        [self request:request requestMethod:CPRequestForPost cache:NO cacheTime:0.0 success:success fail:fail];
    }else{
        [self request:request requestMethod:CPRequestForGet cache:NO cacheTime:0.0 success:success fail:fail];
    }
}

- (void)request:(RNRequest *)request requestMethod:(CPRequestMethod)requestMethod cache:(BOOL)cache cacheTime:(double)cacheTime success:(Successed)success fail:(Failed)fail {
    
    manager = [[self class] getManager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if([request.isAloT isEqualToString:@"1"]){
        manager.requestSerializer.timeoutInterval = 10.0;
    }else{
       manager.requestSerializer.timeoutInterval = 30.0;
    }
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    NSString *url = request.requestUrl;
    NSMutableDictionary *param = [RNNetworkManager addExtParamer:request.parameters];
    if([request.isAloT isEqualToString:@"1"]){
        [param setObject:@"AIoTWeb" forKey:@"appKey"];
        //特定字段单独处理
        NSArray *keyArray = [param allKeys];
        
        // 包含数组和字典字段的字段处理
        if([keyArray containsObject:@"sceneDeviceInfoS"]){
            NSString *jsonStr = param[@"sceneDeviceInfoS"];
            NSArray *jsonArray = [self stringToArray:jsonStr];
            [param setObject:jsonArray forKey:@"sceneDeviceInfoS"];
        }
        if([keyArray containsObject:@"shadowUpdateMOS"]){
            NSString *jsonStr = param[@"shadowUpdateMOS"];
            NSArray *jsonArray = [self stringToArray:jsonStr];
            [param setObject:jsonArray forKey:@"shadowUpdateMOS"];
        }
    }
    
    __block NSString *callBackKey = request.callBackKey;
    
    if(requestMethod == CPRequestForGet){
        
        NSString *params;
        if ([request.isAloT isEqualToString:@"1"]) {
            params = [RNNetworkManager myMD5Str:param andKey:AIOT_PARTNER_KEY];
        } else {
            params = [RNNetworkManager myMD5Str:param andKey:PARTNER_KEY];
        }
        url = [url stringByAppendingString:[NSString stringWithFormat:@"?%@",params]];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"url----%@-----%@",url,params);
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"网络请求url:%@, 返回数据:%@", url, responseObject);
            NSDictionary *dic = responseObject;
            success(self,responseObject,dic[@"desc"],dic[@"code"],callBackKey);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            fail(self,error,@"网络异常",@"-10000",callBackKey);
            NSLog(@"网络请求失败url: %@, errorData：%@ errorDescription: %@", url, [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding], error.localizedDescription);
        }];
    }
    else if (requestMethod == CPRequestForPost){
        
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *params;
        if ([request.isAloT isEqualToString:@"1"]) {
            params = [RNNetworkManager myMD5Dic:param andKey:AIOT_PARTNER_KEY];
        } else {
            params = [RNNetworkManager myMD5Dic:param andKey:PARTNER_KEY];
        }
        NSLog(@"url----%@-----%@",url,params);
        [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"网络请求url:%@, 返回数据:%@", url, responseObject);
            NSDictionary *dic = responseObject;
            success(self,responseObject,dic[@"desc"],dic[@"code"],callBackKey);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            fail(self,error,@"网络异常",@"-10000",callBackKey);
            NSLog(@"网络请求失败url: %@, errorData：%@ errorDescription: %@", url, [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding], error.localizedDescription);
        }];
    }
}

#pragma --mark
- (NSArray *)stringToArray:(NSString *)jsonStr
{
    if (jsonStr)
    {
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        id tmp = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments | NSJSONReadingMutableLeaves | NSJSONReadingMutableContainers error:nil];
        if (tmp)
        {
            if ([tmp isKindOfClass:[NSArray class]]){
                return tmp;
            } else if([tmp isKindOfClass:[NSString class]] || [tmp isKindOfClass:[NSDictionary class]]){
                return [NSArray arrayWithObject:tmp];
            } else {
                return nil;
            }
        } else {
            return nil;
        }
    } else {
        return nil;
    }
}


+(NSMutableDictionary*)addExtParamer:(NSDictionary*)parameters{
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [requestParameters setObject:[NSString getCurrentVersion] forKey:@"v"];  //版本号
    [requestParameters setObject:@"2" forKey:@"ttid"];   //设备  2.ios设备
//    NSLog(@"Shop--requestParameters:%@",requestParameters);
    return requestParameters;
}

+(NSString *)myMD5Str:(NSDictionary *)sourDic andKey:(NSString *)key{
    
    
    NSMutableString * keyValueStr = [[NSMutableString alloc] init];
    NSMutableArray * params = [NSMutableArray array];
    if (sourDic == nil) {
        return nil;
    }
    
    NSArray * keysArray = [self sortDictionary:sourDic];
    for (int i = 0; i < [keysArray count]; i++) {
        NSString * tmpKey = [keysArray objectAtIndex:i];
        [params addObject:[NSString stringWithFormat:@"%@=%@",tmpKey,[sourDic objectForKey:tmpKey]]];
        [keyValueStr appendFormat:@"%@=%@&",tmpKey,[sourDic objectForKey:tmpKey]];
    }
    
    [keyValueStr appendFormat:@"%@=%@",@"key",key];
    NSString * signStr = [self MD5Hash:keyValueStr];
    
    [params addObject:[NSString stringWithFormat:@"%@=%@",@"sign",signStr]];
    
    NSString *str = [params componentsJoinedByString:@"&"];
    return str;
}

+(NSDictionary *)myMD5Dic:(NSDictionary*)sourDic andKey:(NSString*)key{
    NSMutableDictionary * resltDic = [[NSMutableDictionary alloc] initWithDictionary:sourDic];
    
    NSMutableString * keyValueStr = [[NSMutableString alloc] init];
    if (sourDic == nil) {
        return nil;
    }
    
    NSArray * keysArray = [self sortDictionary:sourDic];
    for (int i = 0; i < [keysArray count]; i++) {
        NSString * tmpKey = [keysArray objectAtIndex:i];
        id data = [sourDic objectForKey:tmpKey];
        if([data isKindOfClass:[NSArray class]] || [data isKindOfClass:[NSDictionary class]]){
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil];
            NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [keyValueStr appendFormat:@"%@=%@&",tmpKey,str];
        }else{
            [keyValueStr appendFormat:@"%@=%@&",tmpKey, data];
        }
    }
    [keyValueStr appendFormat:@"%@=%@",@"key",key];
    NSString * signStr = [self MD5Hash:keyValueStr];
    [resltDic setObject:signStr forKey:@"sign"];
    return resltDic;
}

+(NSArray *)sortDictionary:(NSDictionary *)dictionary{
    NSArray* arr = [dictionary allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    return arr;
}

+ (NSString *)MD5Hash:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

@end
