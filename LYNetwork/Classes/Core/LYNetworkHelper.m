//
//  LYNetworkHelper.m
//  LYNetwork_Example
//
//  Created by wenzhan on 2019/4/24.
//  Copyright © 2019 zhangdaokui. All rights reserved.
//

#import "LYNetworkHelper.h"
#import <CommonCrypto/CommonCrypto.h>
#import <CommonCrypto/CommonDigest.h>
#import "CPNetworkController.h"
#import "RequestInfo.h"
#import "NSString+Util.h"
#import "NetworkDefine.h"

#define PARTNER_KEY             @"db426a9829e4b49a0dcac7b4162da6b6"    //正确的key
#define ACCESS_PARTNER_KEY      @"219F223CB59B183D3A80708E8553AFA71b49"    //正确的key
#define PARK_KEY                @"219F223CB59B183D3A80708E8553AFA71b49"    //车场key
#define ALOT_PARTNER_KEY        @"219F223CB59B183D3A80708E8553AFA71b49"    //正确的key
#define kAloTAppKey             @"AIoTWeb"

@implementation LYNetworkHelper

+ (LYNetworkHelper *)sharedHelper
{
    static LYNetworkHelper   *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[LYNetworkHelper alloc] init];
    });
    return shared;
}

#pragma mark - configure request

- (RequestInfo *)configureServiceRequestWithInterface:(NSString *)interface parameters:(NSDictionary *)parameters
{
    NSString *baseURL = [self getBaseURLForNewPort:interface];
    //合并参数
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    //检查版本号不需要传这个参数
    if (![interface isEqualToString:@"app/getVersion"])
    {
        [requestParameters setObject:[NSString getCurrentVersion] forKey:@"v"];  //版本号
    }
    [requestParameters setObject:@"2" forKey:@"ttid"];   //设备  2.ios设备
    NSLog(@"Shop--requestParameters:%@",requestParameters);
    //加密参数
    RequestInfo *reqInfo = [[RequestInfo alloc]init];
    reqInfo.url = [NSString stringWithFormat:@"%@%@",baseURL,interface];
    reqInfo.paramers = [self md5DicForNewPort:requestParameters];
    reqInfo.requestType = [self p_getServiceRequestType:interface];
    reqInfo.reqinteface = interface;
    
    NSString * callBackKey = nil;
    if ([parameters objectForKey:@"callBackKey"])
    {
        callBackKey = [parameters objectForKey:@"callBackKey"];
        NSMutableDictionary * mutableUnencryptedParams = nil;
        if (reqInfo.unencryptedParams)
        {
            mutableUnencryptedParams = [NSMutableDictionary mutableCopy];
        }else{
            mutableUnencryptedParams = [NSMutableDictionary new];
        }
        [mutableUnencryptedParams setObject:callBackKey forKey:@"callBackKey"];
        reqInfo.unencryptedParams = mutableUnencryptedParams;
    }
    return reqInfo;
}

- (RequestInfo *)configurePropertyRequestWithInterface:(NSString *)interface parameters:(NSDictionary *)parameters
{
    NSString *baseURL = [self getBaseURLForProperty:interface];
    //合并参数
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [requestParameters setObject:[NSString getCurrentVersion] forKey:@"v"];//版本号
    [requestParameters setObject:@"2" forKey:@"ttid"];   //设备  2.ios设备
    NSLog(@"Shop--requestParameters:%@",requestParameters);
    //加密参数
    RequestInfo *reqInfo = [[RequestInfo alloc]init];
    reqInfo.url = [NSString stringWithFormat:@"%@%@",baseURL,interface];
    reqInfo.paramers = [self md5DicForProperty:requestParameters];
    reqInfo.requestType = [self p_getServiceRequestType:interface];
    reqInfo.reqinteface = interface;
    
    NSString * callBackKey = nil;
    if ([parameters objectForKey:@"callBackKey"])
    {
        callBackKey = [parameters objectForKey:@"callBackKey"];
        NSMutableDictionary * mutableUnencryptedParams = nil;
        if (reqInfo.unencryptedParams)
        {
            mutableUnencryptedParams = [NSMutableDictionary mutableCopy];
        }else{
            mutableUnencryptedParams = [NSMutableDictionary new];
        }
        [mutableUnencryptedParams setObject:callBackKey forKey:@"callBackKey"];
        reqInfo.unencryptedParams = mutableUnencryptedParams;
    }
    return reqInfo;
}

- (RequestInfo *)configureAccessRequestWithInterface:(NSString *)interface parameters:(NSDictionary *)parameters
{
    NSString *baseURL = [self getBaseURLForAccess:interface];
    //合并参数
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [requestParameters setObject:[NSString getCurrentVersion] forKey:@"v"];  //版本号
    [requestParameters setObject:@"2" forKey:@"ttid"];   //设备  2.ios设备
    //加密参数
    RequestInfo *reqInfo = [[RequestInfo alloc]init];
    reqInfo.url = [NSString stringWithFormat:@"%@%@",baseURL,interface];
    
    NSInteger type = 1;
    if ([interface isEqualToString:@"visitor/getVisitorCarList"] ||
        [interface isEqualToString:@"visitor/saveVisitorCar"] ||
        [interface isEqualToString:@"visitor/visitingCarOpenStrobe"]) {
        type = 2;
    }
    reqInfo.paramers = [self md5DicForAccess:requestParameters andType:type];
    reqInfo.requestType = 1;
    reqInfo.reqinteface = interface;
    
    NSString * callBackKey = nil;
    if ([parameters objectForKey:@"callBackKey"])
    {
        callBackKey = [parameters objectForKey:@"callBackKey"];
        NSMutableDictionary * mutableUnencryptedParams = nil;
        if (reqInfo.unencryptedParams)
        {
            mutableUnencryptedParams = [NSMutableDictionary mutableCopy];
        }else{
            mutableUnencryptedParams = [NSMutableDictionary new];
        }
        [mutableUnencryptedParams setObject:callBackKey forKey:@"callBackKey"];
        reqInfo.unencryptedParams = mutableUnencryptedParams;
    }
    return reqInfo;
    
}

- (RequestInfo *)configureAloTRequestWithInterface:(NSString *)interface parameters:(NSDictionary *)parameters
{
    NSString *baseURL = [self getBaseURLForAloT:interface];
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [requestParameters setObject:[NSString getCurrentVersion] forKey:@"v"];  //版本号
    [requestParameters setObject:@"2" forKey:@"ttid"];   //设备  2.ios设备
    [requestParameters setObject:kAloTAppKey forKey:@"kAppKey"];
    //加密参数
    RequestInfo *reqInfo = [[RequestInfo alloc]init];
    reqInfo.url = [NSString stringWithFormat:@"%@%@", baseURL, interface];
    reqInfo.paramers = [self md5DicForAloT:requestParameters];
    reqInfo.requestType = 1;
    reqInfo.reqinteface = interface;
    
    NSString * callBackKey = nil;
    if ([parameters objectForKey:@"callBackKey"])
    {
        callBackKey = [parameters objectForKey:@"callBackKey"];
        NSMutableDictionary * mutableUnencryptedParams = nil;
        if (reqInfo.unencryptedParams)
        {
            mutableUnencryptedParams = [NSMutableDictionary mutableCopy];
        }else{
            mutableUnencryptedParams = [NSMutableDictionary new];
        }
        [mutableUnencryptedParams setObject:callBackKey forKey:@"callBackKey"];
        reqInfo.unencryptedParams = mutableUnencryptedParams;
    }
    return reqInfo;
}

- (RequestInfo *)configureVideoRequestWithInterface:(NSString *)interface parameters:(NSDictionary *)parameters
{
    NSString *baseURL = [self getBaseURLForVideo:interface];
    NSMutableDictionary *requestParameters = [NSMutableDictionary dictionaryWithDictionary:parameters];
    [requestParameters setObject:[NSString getCurrentVersion] forKey:@"v"];  //版本号
    [requestParameters setObject:@"2" forKey:@"ttid"];   //设备  2.ios设备
    //加密参数
    RequestInfo *reqInfo = [[RequestInfo alloc]init];
    reqInfo.url = [NSString stringWithFormat:@"%@%@",baseURL,interface];
    reqInfo.paramers = [self md5DicForVideo:requestParameters];
    reqInfo.requestType = 0;
    return reqInfo;
}

#pragma mark - parse data

- (RequestResult *)parseDataStringForNewPort:(id)string requestInterface:(NSString *)interface{
    
    RequestResult *result = [[RequestResult alloc] init];
    //resultContainer
    NSDictionary    *resultContainer = string;
    //处理结果
    if(!resultContainer){         //解析字典为空
        result.status = -1;
        result.message = @"获取数据失败,请重新刷新获取";
    }else{
        //状态
        NSString *succeed = DealWithJSONStringValue([resultContainer objectForKey:@"code"]);
        NSString *errorCode = DealWithJSONStringValue([resultContainer objectForKey:@"code"]);
        NSString *errorDesc = DealWithJSONStringValue([resultContainer objectForKey:@"desc"]);
        result.code = errorCode;   // 状态信息 用来判断！
        //数据
        id messageContainer  = DealWithJSONValue([resultContainer objectForKey:@"data"]);
        
        if (![succeed isEqualToString:@"200"] && ![interface isEqualToString:@"app/activity/getNotReceiveRedCount"])
        {   //返回错误  不为"0"的时候
            result.status = -1;
            result.message = errorDesc;
            NSArray * arr = [errorDesc componentsSeparatedByString:errorCode];
            if (arr.count > 1) //处理掉errorDesc中的errorCode
            {
                NSUInteger count = [arr count];
                NSString * desc = arr[count-1];
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
                desc = [desc stringByTrimmingCharactersInSet:set];
                result.message = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            if ([errorCode isEqualToString:@"403"])
            {
                NSError *parseError = nil;
                NSDictionary *infoDic = @{@"method":interface,@"code":errorCode,@"desc":errorDesc};
                NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:infoDic options:0 error:&parseError];
                NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotif_Invalid_Session_Notification" object:str];
                result.message = @"";//@"由于您长时间未操作，为安全起见，系统已自动退出。如需操作，请重新登录。";
                //[GlobalMethod loginoutWithInvalidSession:2];    //???????????????????????
            }
        }
        else if(!messageContainer)
        {   //返回成功信息(无数据)
            result.status = 0;
            NSLog(@"%@",result.results);
        }else
        {   //返回成功信息(有数据)
            result.status = 1;
            if ([[messageContainer class] isSubclassOfClass:[NSDictionary class]] ) {
                result.resultInfo = messageContainer;
            }else if([[messageContainer class] isSubclassOfClass:[NSArray class]]){
                result.results = messageContainer;
            }else if([[messageContainer class] isSubclassOfClass:[NSString class]]){
                result.resultString = messageContainer;
            }else if([[messageContainer class] isSubclassOfClass:[NSNumber class]]){
                result.number = messageContainer;
            }
        }
    }
    return result;
}

- (RequestResult *)parseDataStringForProperty:(id)string requestInterface:(NSString *)interface{
    
    RequestResult *result = [[RequestResult alloc] init];
    //resultContainer
    NSDictionary    *resultContainer = string;
    //处理结果
    if(!resultContainer){         //解析字典为空
        result.status = -1;
        result.message = @"获取数据失败,请重新刷新获取";
    }else{
        //状态
        NSString *succeed = DealWithJSONStringValue([resultContainer objectForKey:@"code"]);
        NSString *errorCode = DealWithJSONStringValue([resultContainer objectForKey:@"code"]);
        NSString *errorDesc = DealWithJSONStringValue([resultContainer objectForKey:@"desc"]);
        result.code = errorCode;   // 状态信息 用来判断！
        //数据
        id messageContainer  = DealWithJSONValue([resultContainer objectForKey:@"data"]);
        
        if (![succeed isEqualToString:@"200"] && ![interface isEqualToString:@"app/activity/getNotReceiveRedCount"])
        {   //返回错误  不为"0"的时候
            result.status = -1;
            result.message = errorDesc;
            NSArray * arr = [errorDesc componentsSeparatedByString:errorCode];
            if (arr.count > 1) //处理掉errorDesc中的errorCode
            {
                NSUInteger count = [arr count];
                NSString * desc = arr[count-1];
                NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
                desc = [desc stringByTrimmingCharactersInSet:set];
                result.message = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            }
            if ([errorCode isEqualToString:@"403"])
            {
                NSError *parseError = nil;
                NSDictionary *infoDic = @{@"method":interface,@"code":errorCode,@"desc":errorDesc};
                NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:infoDic options:0 error:&parseError];
                NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotif_Invalid_Session_Notification" object:str];
                result.message = @"";//@"由于您长时间未操作，为安全起见，系统已自动退出。如需操作，请重新登录。";
                //[GlobalMethod loginoutWithInvalidSession:2];    //???????????????????????
            }
        }
        else if(!messageContainer)
        {   //返回成功信息(无数据)
            result.status = 0;
            NSLog(@"%@",result.results);
        }else
        {   //返回成功信息(有数据)
            result.status = 1;
            if ([[messageContainer class] isSubclassOfClass:[NSDictionary class]] ) {
                result.resultInfo = messageContainer;
            }else if([[messageContainer class] isSubclassOfClass:[NSArray class]]){
                result.results = messageContainer;
            }else if([[messageContainer class] isSubclassOfClass:[NSString class]]){
                result.resultString = messageContainer;
            }else if([[messageContainer class] isSubclassOfClass:[NSNumber class]]){
                result.number = messageContainer;
            }
        }
    }
    return result;
}

- (RequestResult *)parseDataStringForAccess:(id)string requestInterface:(NSString *)interface{
    
    RequestResult *result = [[RequestResult alloc] init];
    //resultContainer
    NSDictionary    *resultContainer = string;
    if(!resultContainer){         //解析字典为空
        
        result.status = -1;
        result.message = @"获取数据失败,请重新刷新获取";
        
    }else{
        
        //状态
        NSString *errorCode = DealWithJSONStringValue([resultContainer objectForKey:@"errcode"]);
        NSString *errmsg = DealWithJSONStringValue([resultContainer objectForKey:@"errmsg"]);
        NSString *code = DealWithJSONStringValue([resultContainer objectForKey:@"code"]);
        NSString *desc = DealWithJSONStringValue([resultContainer objectForKey:@"desc"]);
        //数据
        id messageContainer  = DealWithJSONValue([resultContainer objectForKey:@"data"]);
        
        if ((![errorCode isEqualToString:@"22000"] &&
             ![errorCode isEqualToString:@"24041"] &&
             ![errorCode isEqualToString:@"24127"] &&
             ![interface isEqualToString:@"visitor/getVisitorCarList"] &&
             ![interface isEqualToString:@"visitor/saveVisitorCar"] &&
             ![interface isEqualToString:@"visitor/visitingCarOpenStrobe"]) ||
            (![code isEqualToString:@"200"] &&
             ([interface isEqualToString:@"visitor/getVisitorCarList"] ||
              [interface isEqualToString:@"visitor/saveVisitorCar"] ||
              [interface isEqualToString:@"visitor/visitingCarOpenStrobe"])))
        {   //返回错误  不为"0"的时候
            result.status = -1;
            if([interface isEqualToString:@"visitor/getVisitorCarList"] ||
               [interface isEqualToString:@"visitor/saveVisitorCar"] ||
               [interface isEqualToString:@"visitor/visitingCarOpenStrobe"])
            {
                result.message = desc;
                NSArray * arr = [desc componentsSeparatedByString:code];
                if (arr.count > 1) //处理掉errorDesc中的errorCode
                {
                    NSUInteger count = [arr count];
                    NSString * desc = arr[count-1];
                    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"[]"];
                    desc = [desc stringByTrimmingCharactersInSet:set];
                    result.message = [desc stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                }
                
                if ([errorCode isEqualToString:@"403"])
                {
                    NSError *parseError = nil;
                    NSDictionary *infoDic = @{@"method":interface,@"code":code,@"desc":desc};
                    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:infoDic options:0 error:&parseError];
                    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotif_Invalid_Session_Notification" object:str];
                    result.message = @"";//@"由于您长时间未操作，为安全起见，系统已自动退出。如需操作，请重新登录。";
                    //[GlobalMethod loginoutWithInvalidSession:2];//?????????????????????
                }
            }else{
                result.message = errmsg;
                result.code = errorCode;
                if ([errorCode isEqualToString:@"24011"])
                {
                    NSError *parseError = nil;
                    NSDictionary *infoDic = @{@"method":interface,@"code":errorCode,@"desc":errmsg};
                    
                    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:infoDic options:0 error:&parseError];
                    NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"kNotif_Invalid_Session_Notification" object:str];
                    
                    result.message = @"";//@"由于您长时间未操作，为安全起见，系统已自动退出。如需操作，请重新登录。";
                    //[GlobalMethod loginoutWithInvalidSession:2];//??????????????????/
                }
            }
        }
        else if(!messageContainer)
        {   //返回成功信息(无数据)
            
            result.status = 0;
            
        }
        else
        {                         //返回成功信息(有数据)
            
            result.status = 1;
            
            result.message = errmsg;
            
            if ([[messageContainer class] isSubclassOfClass:[NSDictionary class]] )
            {
                
                result.resultInfo = messageContainer;
                
            }else if([[messageContainer class] isSubclassOfClass:[NSArray class]])
            {
                
                result.results = messageContainer;
                
            }
            else if([[messageContainer class] isSubclassOfClass:[NSString class]]){
                
                result.resultString = messageContainer;
                
            }
        }
    }
    
    return result;
    
}

- (RequestResult *)parseDataStringForAloT:(id)string requestInterface:(NSString *)interface
{
    RequestResult *result = [[RequestResult alloc] init];
    NSDictionary *resultContainer = string;
    //处理结果
    if(!resultContainer){ //解析字典为空
        result.status = -1;
        result.message = @"获取数据失败,请重新刷新获取";
    }
    else
    {
        NSString *succeed = DealWithJSONStringValue([resultContainer objectForKey:@"code"]);
        NSString *errorCode = DealWithJSONStringValue([resultContainer objectForKey:@"code"]);
        NSString *errorDesc = DealWithJSONStringValue([resultContainer objectForKey:@"msg"]);
        result.code = errorCode;   // 状态信息 用来判断！
        //数据
        id messageContainer  = DealWithJSONValue([resultContainer objectForKey:@"data"]);
        
        if (![succeed isEqualToString:@"200"])
        {   //返回错误  不为"0"的时候
            result.status = -1;
            result.message = errorDesc;
        }
        else if(!messageContainer)
        {   //返回成功信息(无数据)
            result.status = 0;
        }
        else
        {   //返回成功信息(有数据)
            result.status = 1;
            if ([[messageContainer class] isSubclassOfClass:[NSDictionary class]] ) {
                
                result.resultInfo = messageContainer;
                
            }else if([[messageContainer class] isSubclassOfClass:[NSArray class]]){
                
                result.results = messageContainer;
                
            }else if([[messageContainer class] isSubclassOfClass:[NSString class]]){
                
                result.resultString = messageContainer;
                
            }else if([[messageContainer class] isSubclassOfClass:[NSNumber class]]){
                result.number = messageContainer;
            }
        }
    }
    
    return result;
}

#pragma mark - Base URL
//新接口
- (NSString *)getBaseURLForNewPort:(NSString *)interface
{
    NSString *mainUrl;
    
    if ([interface isEqualToString:@"app/rent/community/publishorder/list"] ||
        [interface isEqualToString:@"app/rent/community/order/addorupdate"] ||
        [interface isEqualToString:@"app/rent/community/room/list"] ||
        [interface isEqualToString:@"app/rent/community/room/certification"] ||
        [interface isEqualToString:@"app/rent/community/room/useable"] ||
        [interface isEqualToString:@"app/rent/community/order/update"] ||
        [interface isEqualToString:@"app/rent/community/order/detail"])
    {
        mainUrl = [CPNetworkController shareController].NetWorkUrl_LeaseIP;
    }else if ([interface isEqualToString:@"method=data.report.upload"]) {
        mainUrl = [CPNetworkController shareController].NetWorkUrl_uploadMsg;//上报信息
    }else if ([interface isEqualToString:@"app/tools/myip"]) {
        mainUrl = [CPNetworkController shareController].NetWorkUrl_publicIP;//公共IP
    }
    else {
        mainUrl = [CPNetworkController shareController].NetWorkUrl_NewApi;
    }
    return mainUrl;
}

//物业接口
- (NSString *)getBaseURLForProperty:(NSString *)interface
{
    NSString *mainUrl;
    
    if ([interface isEqualToString:@"outapi/patrolcheck/take/device/maintenance/list"] || [interface isEqualToString:@"outapi/wygl/messages/logout/push/record"]) {
        mainUrl = [CPNetworkController shareController].NetworkUrl_ecommunity_base;//巡检维保记录
    }else {
        mainUrl = [CPNetworkController shareController].NetWorkUrl_property_api;//物业通道
    }
    
    return mainUrl;
}

//车场接口
- (NSString *)getBaseURLForAccess:(NSString *)interface
{
    return [CPNetworkController shareController].NetWorkUrl_park_api;
}

//AloT接口
- (NSString *)getBaseURLForAloT:(NSString *)interface
{
    return [CPNetworkController shareController].NetworkUrl_AloT;
}

- (NSString *)getBaseURLForVideo:(NSString *)interface
{
    NSString *mainUrl;                   //默认
    if([interface isEqualToString:@"dhome/sync/data/update/islogout"] ||
       [interface isEqualToString:@"visibletalk/app/unit/config/newversion"] ||
       [interface isEqualToString:@"dhome/query/calltarget"] ||
       [interface isEqualToString:@"dhome/query/mobile/exists"] ||
       [interface isEqualToString:@"dhome/query/visibletalk/admin/pwd"]){
        mainUrl = [[CPNetworkController shareController] NetworkUrl_ParkVoIP];
    }else{
        mainUrl = [[CPNetworkController shareController] NetworkUrl_VTNetwork_base];//默认
    }
    return mainUrl;
}

#pragma mark - encrypt parameters
//参数加密
- (NSDictionary *)md5DicForNewPort:(NSDictionary*)sourDic
{
    NSMutableDictionary * resltDic = [[NSMutableDictionary alloc] initWithDictionary:sourDic];
    
    NSMutableString * keyValueStr = [[NSMutableString alloc] init];
    if (sourDic == nil) {
        return nil;
    }
    
    NSArray * keysArray = [self sortDictionary:sourDic];
    for (int i = 0; i < [keysArray count]; i++) {
        NSString * tmpKey = [keysArray objectAtIndex:i];
        [keyValueStr appendFormat:@"%@=%@&",tmpKey,[sourDic objectForKey:tmpKey]];
    }
    
    [keyValueStr appendFormat:@"%@=%@",@"key",PARTNER_KEY];
    NSString * signStr = [self MD5Hash:keyValueStr];
    [resltDic setObject:signStr forKey:@"sign"];
    return resltDic;
}

- (NSDictionary *)md5DicForProperty:(NSDictionary*)sourDic
{
    NSMutableDictionary * resltDic = [[NSMutableDictionary alloc] initWithDictionary:sourDic];
    
    NSMutableString * keyValueStr = [[NSMutableString alloc] init];
    if (sourDic == nil) {
        return nil;
    }
    
    NSArray * keysArray = [self sortDictionary:sourDic];
    for (int i = 0; i < [keysArray count]; i++) {
        NSString * tmpKey = [keysArray objectAtIndex:i];
        [keyValueStr appendFormat:@"%@=%@&",tmpKey,[sourDic objectForKey:tmpKey]];
    }
    
    [keyValueStr appendFormat:@"%@=%@",@"key",PARTNER_KEY];
    NSString * signStr = [self MD5Hash:keyValueStr];
    [resltDic setObject:signStr forKey:@"sign"];
    return resltDic;
}

- (NSDictionary *)md5DicForAccess:(NSDictionary*)sourDic andType:(NSInteger)type {
    NSMutableDictionary * resltDic = [[NSMutableDictionary alloc] initWithDictionary:sourDic];
    
    NSMutableString * keyValueStr = [[NSMutableString alloc] init];
    if (sourDic == nil) {
        return nil;
    }
    
    NSArray * keysArray = [self sortDictionary:sourDic];
    for (int i = 0; i < [keysArray count]; i++)
    {
        NSString * tmpKey = [keysArray objectAtIndex:i];
        [keyValueStr appendFormat:@"%@=%@&",tmpKey,[sourDic objectForKey:tmpKey]];
    }
    
    NSString *key = ACCESS_PARTNER_KEY;
    
    if (type == 2) {
        key = PARK_KEY;
    }
    
    [keyValueStr appendFormat:@"%@=%@",@"key",key];
    
    NSString * signStr = [self MD5Hash:keyValueStr];
    [resltDic setObject:signStr forKey:@"sign"];
    return resltDic;
}

- (NSDictionary *)md5DicForAloT:(NSDictionary*)sourDic
{
    NSMutableDictionary * resltDic = [[NSMutableDictionary alloc] initWithDictionary:sourDic];
    NSMutableString * keyValueStr = [[NSMutableString alloc] init];
    if (sourDic == nil) {
        return nil;
    }
    
    NSArray * keysArray = [self sortDictionary:sourDic];
    for (int i = 0; i < [keysArray count]; i++)
    {
        NSString * tmpKey = [keysArray objectAtIndex:i];
        [keyValueStr appendFormat:@"%@=%@&",tmpKey,[sourDic objectForKey:tmpKey]];
    }
    [keyValueStr appendFormat:@"%@=%@",@"key",ALOT_PARTNER_KEY];
    NSString * signStr = [self MD5Hash:keyValueStr];
    [resltDic setObject:signStr forKey:@"sign"];
    return resltDic;
}

- (NSDictionary *)md5DicForVideo:(NSDictionary*)sourDic
{
    NSMutableDictionary * resltDic = [[NSMutableDictionary alloc] initWithDictionary:sourDic];
    
    NSMutableString * keyValueStr = [[NSMutableString alloc] init];
    if (sourDic == nil) {
        return nil;
    }
    
    NSArray * keysArray = [self sortDictionary:sourDic];
    for (int i = 0; i < [keysArray count]; i++) {
        NSString * tmpKey = [keysArray objectAtIndex:i];
        [keyValueStr appendFormat:@"%@=%@&",tmpKey,[sourDic objectForKey:tmpKey]];
    }
    [keyValueStr appendFormat:@"%@=%@",@"key",PARTNER_KEY];
    NSString * signStr = [self MD5Hash:keyValueStr];
    [resltDic setObject:signStr forKey:@"sign"];
    return resltDic;
}

#pragma mark - private methods

- (NSArray *)sortDictionary:(NSDictionary *)dictionary{
    NSArray* arr = [dictionary allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    return arr;
}

- (NSString *)MD5Hash:(NSString *)str{
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

//请求类型：1：JSON
- (int)p_getServiceRequestType:(NSString *)interface
{
    if ([interface isEqualToString:@"app/wygl/selectAnnounceListByNew"] ||
        [interface isEqualToString:@"app/wygl/findNoticeById"] ||
        [interface isEqualToString:@"app/wygl/selectAnnounceScrollListByNew"] ||
        [interface isEqualToString:@"app/wygl/insertOverhaul"] ||
        [interface isEqualToString:@"app/wygl/selectOverhaulList"] ||
        [interface isEqualToString:@"app/wygl/selectOverhaulById"] ||
        [interface isEqualToString:@"app/wygl/selectOverhaulTime"] ||
        [interface isEqualToString:@"app/wygl/complaint/type"] ||
        [interface isEqualToString:@"app/wygl/complaint/oper/info"] ||
        [interface isEqualToString:@"app/wygl/updateOverhaulById"] ||
        [interface isEqualToString:@"app/wygl/insertComplaint"] ||
        [interface isEqualToString:@"app/wygl/selectComplaintList"] ||
        [interface isEqualToString:@"app/wygl/selectComplaintById"] ||
        [interface isEqualToString:@"app/wygl/insertReview"] ||
        [interface isEqualToString:@"app/wygl/selectReviewList"] ||
        [interface isEqualToString:@"app/wygl/selectReviewById"] ||
        [interface isEqualToString:@"app/wygl/addPraiseCnt"] ||
        [interface isEqualToString:@"app/wygl/selectPaymentTotalMoney"] ||
        [interface isEqualToString:@"app/order/addOrder"] ||
        [interface isEqualToString:@"app/lift/setFloor"] ||
        [interface isEqualToString:@"app/hiplayActivity/createActivityPost"] ||
        [interface isEqualToString:@"app/hiplayActivity/createShow"] ||
        [interface isEqualToString:@"app/hiplayActivity/addHiplayActivityOrder"] ||
        [interface isEqualToString:@"app/door/saveAppDoorOpenRecord"] ||
        [interface isEqualToString:@"app/door/saveAppLiftDoorOpenRecord"] ||
        [interface isEqualToString:@"app/mailboxes/saveOpenRecordBatch"] ||
        [interface isEqualToString:@"app/wygl/selectPaymentList"]) {
        return 1;
    }
    return 0;
}

@end
