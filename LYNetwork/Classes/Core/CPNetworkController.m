//
//  CPNetworkController.m
//  CommonProject
//
//  Created by 华美时代 on 15/4/13.
//  Copyright (c) 2015年 jiayi. All rights reserved.
//

#import "CPNetworkController.h"
#import <AFNetworking/AFNetworking.h>
#import "RequestResult.h"
#import "RequestInfo.h"
#import "LYNetworkHelper.h"
#import "NSString+Util.h"
#import "NetworkDefine.h"

#define kRequestForInterface        @"RequestForInterface"      //请求ID
#define kRequestForDelegate         @"RequestForDelegate"       //请求回调代理
#define kRequestForParameters       @"RequestForParameters"     //请求参数

@interface CPNetworkController()

@property(nonatomic,assign)NSInteger operationCount;
@property(nonatomic,assign)NetworkEnvironment environment;

@end

@implementation CPNetworkController

@synthesize operationCount;
@synthesize NetworkUrl_property_voip;//可视对讲
@synthesize NetworkUrl_access_main;//停车场
@synthesize NetworkUrl_help;//帮助
@synthesize NetWorkUrl_uploadMsg;//上传推送消息接口
@synthesize NetWorkUrl_NewApi;//新接口URL
@synthesize NetWorkUrl_property_api;//物业后台接口
@synthesize NetWorkUrl_park_api;//车场接口
@synthesize NetWorkUrl_crowdApi;//众筹测试接口
@synthesize NetWorkUrl_publicIP;//获取公网IP接口
@synthesize NetWorkUrl_LeaseIP;//查找租房IP的接口
@synthesize NetWorkUrl_Activity_base;//嗨玩模块接口
@synthesize FileUrl_Voip,sipIp_voip;
@synthesize NetworkUrl_Pay_For_Guests;
@synthesize NetworkUrl_Pay_For_Guests_Detail;
@synthesize NetworkUrl_Pay_Url_Prefix;
@synthesize NetworkUrl_AloT;
@synthesize NetworkUrl_ecommunity_base;//ecommunity接口
@synthesize NetworkUrl_ParkVoIP,NetworkUrl_VTNetwork_base;
@synthesize kFaceCollectUrl,kFaceDefaultCountUrl,kFaceCollectSingleUrl;

+ (CPNetworkController *)shareController
{
    static CPNetworkController   *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[CPNetworkController alloc] init];
    });
    return shared;
}

#pragma mark - request init
//New Port
- (void)request:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler
{
    [self request:interface parameters:parameters completionHandler:completionHandler delegate:nil];
}
- (void)request:(NSString *)interface parameters:(NSDictionary *)parameters callBackDelegate:(id)delegate
{
    [self request:interface parameters:parameters completionHandler:nil delegate:delegate];
}

//Property
- (void)requestProperty:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler
{
    [self requestProperty:interface parameters:parameters completionHandler:completionHandler delegate:nil];
}
- (void)requestProperty:(NSString *)interface parameters:(NSDictionary *)parameters callBackDelegate:(id)delegate
{
    [self requestProperty:interface parameters:parameters completionHandler:nil delegate:delegate];
}

//Access
- (void)requestAccess:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler
{
    [self requestAccess:interface parameters:parameters completionHandler:completionHandler delegate:nil];
}
- (void)requestAccess:(NSString *)interface parameters:(NSDictionary *)parameters callBackDelegate:(id)delegate
{
    [self requestAccess:interface parameters:parameters completionHandler:nil delegate:delegate];
}

//AloT
- (void)requestAloT:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler
{
    [self requestAloT:interface parameters:parameters completionHandler:completionHandler delegate:nil];
}
- (void)requestAloT:(NSString *)interface parameters:(NSDictionary *)parameters callBackDelegate:(id)delegate
{
    [self requestAloT:interface parameters:parameters completionHandler:nil delegate:delegate];
}

//Video
- (void)requestVideo:(LYHttpMethod)method interface:(NSString *)interface parameters:(NSDictionary *)parameters successed:(SuccessedBlock)successed failed:(FailureBlock)failed
{
    if (method == LYHttpMethodGET) {
        [self requestVideoWithGet:interface parameters:parameters successed:successed failed:failed];
    }else if (method == LYHttpMethodPOST){
        [self requestVideoWithPost:interface parameters:parameters successed:successed failed:failed];
    }
}

#pragma mark - 发起POST请求

- (void)request:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler delegate:(id)delegate
{
    __block RequestInfo *requestInfo;
    
    ////////////////RequestInfo/////////////////////
    requestInfo = [[LYNetworkHelper sharedHelper] configureServiceRequestWithInterface:interface parameters:parameters];
    requestInfo.delegate = delegate;
    requestInfo.completeHandler = completionHandler;
    ////////////////ManagerConfig///////////////////
    AFHTTPSessionManager *sManager = [AFHTTPSessionManager manager];
    if ([interface isEqualToString:@"app/rent/community/publishorder/list"] ||
        [interface isEqualToString:@"app/rent/community/order/addorupdate"] ||
        [interface isEqualToString:@"app/rent/community/room/list"] ||
        [interface isEqualToString:@"app/rent/community/room/certification"] ||
        [interface isEqualToString:@"app/rent/community/room/useable"] ||
        [interface isEqualToString:@"app/rent/community/order/update"] ||
        [interface isEqualToString:@"app/rent/community/order/detail"] ||
        [interface isEqualToString:@"app/wygl/intelligenthouseapply/bindDevice"] ||
        [interface isEqualToString:@"app/wygl/feibit/device/add"])
    {
        sManager.requestSerializer = [AFJSONRequestSerializer serializer];
        sManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    if ([interface isEqualToString:@"app/parkinglock/operateRecord"] ||
        [interface isEqualToString:@"app/main/saveIdentityInfo"] ||
        [interface isEqualToString:@"app/main/identityClaim"] ||
        [interface isEqualToString:@"app/payment/scanQRCodeCheckOrder"] ||
        [interface isEqualToString:@"app/aroundCouponNew/getRedList"] ||
        [interface isEqualToString:@"app/aroundCouponNew/getRedDetail"] ||
        [interface isEqualToString:@"app/aroundCouponNew/getProductDetail"] ||
        [interface isEqualToString:@"app/aroundCouponNew/getShopDetail"] ||
        [interface isEqualToString:@"app/aroundCouponNew/getShopRedList"] ||
        [interface isEqualToString:@"app/aroundCouponNew/collectShopByScan"] ||
        [interface isEqualToString:@"app/aroundCouponNew/collect"]  ||
        [interface isEqualToString:@"app/aroundCouponNew/getMyRedList"]  ||
        [interface isEqualToString:@"app/aroundCouponNew/receive"] ||
        [interface isEqualToString:@"app/aroundCouponNew/getProductListByPage"] ||
        [interface isEqualToString:@"app/visibletalk/netdoor/open"] ||
        [interface isEqualToString:@"merchant/merchantShop/getShopServices"] ||
        [interface isEqualToString:@"app/aroundCouponNew/getShopCategoryList"] ||
        [interface isEqualToString:@"app/activity/scanReceiveMediaRedEnv"] ||
        [interface isEqualToString:@"outapi/patrolcheck/take/device/maintenance/list"] ||
        [interface isEqualToString:@"outapi/wygl/messages/logout/push/record"])
    {
        sManager.requestSerializer = [AFJSONRequestSerializer serializer];
        [sManager.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        sManager.requestSerializer.timeoutInterval = 10.0;
    }
    if ([interface isEqualToString:@"app/parkinglock/getCurrentUnitParkinglockList"])
    {
        sManager.requestSerializer.timeoutInterval = 3.0;
    }
    if([interface isEqualToString:@"app/payment/scanQRCodeCheckOrder"] ||
       [interface isEqualToString:@"app/user/getUserByNameIsExist"] ||
       [interface isEqualToString:@"app/sms/getPhoneVerifyCode"] )
    {
        sManager.requestSerializer.timeoutInterval = 5.0;
    }
    if (requestInfo.requestType==1) {
        sManager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    NSLog(@"URL--------%@\nParamers-----------%@",requestInfo.url,requestInfo.paramers);
    
    __weak __typeof(self) weakSelf = self;
    [sManager POST:requestInfo.url parameters:requestInfo.paramers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络请求url:%@, 返回数据:%@", requestInfo.url, responseObject);
        __strong RequestInfo *strongReqInfo = requestInfo;
        [weakSelf p_completeRequestForNewPort:responseObject withStatus:YES requsetInfo:strongReqInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败url: %@, errorData：%@ errorDescription: %@", requestInfo.url, [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding], error.localizedDescription);
        __strong RequestInfo *strongReqInfo = requestInfo;
        [weakSelf p_completeRequestForNewPort:nil withStatus:NO requsetInfo:strongReqInfo];
    }];
}

- (void)requestProperty:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler delegate:(id)delegate
{
    ////////////////RequestInfo///////////////////////
    __block RequestInfo *requestInfo;
    requestInfo = [[LYNetworkHelper sharedHelper] configurePropertyRequestWithInterface:interface parameters:parameters];
    requestInfo.completeHandler = completionHandler;
    requestInfo.delegate = delegate;
    
    ////////////////ManagerConfig/////////////////////
    AFHTTPSessionManager *sManager = [AFHTTPSessionManager manager];
    if([interface isEqualToString:@"app/door/saveAppLiftDoorOpenRecord"])
    {
        sManager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if([interface isEqualToString:@"app/wygl/queryunit"] ||
       [interface isEqualToString:@"app/wygl/listapprove"] ||
       [interface isEqualToString:@"app/wygl/submitapprove"] ||
       [interface isEqualToString:@"app/wygl/applycard"] ||
       [interface isEqualToString:@"app/wygl/applycard/relationship/list"])
    {
        sManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    sManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];//设置相应内容类型
    sManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    sManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    if (requestInfo.requestType==1) {
        sManager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    NSLog(@"URL--------%@\nParamers-----------%@",requestInfo.url,requestInfo.paramers);
    
    __weak __typeof(self) weakSelf = self;
    [sManager POST:requestInfo.url parameters:requestInfo.paramers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络请求url:%@, 返回数据:%@", requestInfo.url, responseObject);
        __strong RequestInfo *strongReqInfo = requestInfo;
        [weakSelf p_completeRequestForProperty:responseObject withStatus:YES requsetInfo:strongReqInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败url: %@, errorData：%@ errorDescription: %@", requestInfo.url, [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding], error.localizedDescription);
        __strong RequestInfo *strongReqInfo = requestInfo;
        [weakSelf p_completeRequestForProperty:nil withStatus:NO requsetInfo:strongReqInfo];
    }];
}

- (void)requestAccess:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler delegate:(id)delegate
{
    ////////////////mainUrl/////////////
    __block RequestInfo *requestInfo;
    requestInfo = [[LYNetworkHelper sharedHelper] configureAccessRequestWithInterface:interface parameters:parameters];
    requestInfo.completeHandler = completionHandler;
    requestInfo.delegate = delegate;
    
    AFHTTPSessionManager *sManager = [AFHTTPSessionManager manager];
    if (requestInfo.requestType==1) {
        sManager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    sManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];//设置相应内容类型
    NSLog(@"URL--------%@\nParamers-----------%@",requestInfo.url,requestInfo.paramers);
    
    sManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    sManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    __weak __typeof(self) weakSelf = self;
    [sManager POST:requestInfo.url parameters:requestInfo.paramers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络请求url:%@, 返回数据:%@", requestInfo.url, responseObject);
        __strong RequestInfo *strongReqInfo = requestInfo;
        [weakSelf p_completeRequestForAccess:responseObject withStatus:YES requsetInfo:strongReqInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败url: %@, errorData：%@ errorDescription: %@", requestInfo.url, [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding], error.localizedDescription);
        __strong RequestInfo *strongReqInfo = requestInfo;
        [weakSelf p_completeRequestForAccess:nil withStatus:NO requsetInfo:strongReqInfo];
    }];
}

- (void)requestAloT:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler delegate:(id)delegate
{
    ////////////////mainUrl/////////////
    __block RequestInfo *requestInfo;
    requestInfo = [[LYNetworkHelper sharedHelper] configureAloTRequestWithInterface:interface parameters:parameters];
    requestInfo.completeHandler = completionHandler;
    requestInfo.delegate = delegate;
    
    AFHTTPSessionManager *sManager = [AFHTTPSessionManager manager];
    if (requestInfo.requestType==1) {
        sManager.requestSerializer=[AFJSONRequestSerializer serializer];
    }
    sManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];//设置相应内容类型
    NSLog(@"URL--------%@\nParamers-----------%@",requestInfo.url,requestInfo.paramers);
    
    sManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    sManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    __weak __typeof(self) weakSelf = self;
    [sManager POST:requestInfo.url parameters:requestInfo.paramers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"网络请求url:%@, 返回数据:%@", requestInfo.url, responseObject);
        __strong RequestInfo *strongReqInfo = requestInfo;
        [weakSelf p_completeRequestForAloT:responseObject withStatus:YES requsetInfo:strongReqInfo];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"网络请求失败url: %@, errorData：%@ errorDescription: %@", requestInfo.url, [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding], error.localizedDescription);
        __strong RequestInfo *strongReqInfo = requestInfo;
        [weakSelf p_completeRequestForAloT:nil withStatus:NO requsetInfo:strongReqInfo];
    }];
}

- (void)requestVideoWithPost:(NSString *)interface parameters:(NSDictionary *)parameters successed:(SuccessedBlock)successed failed:(FailureBlock)failed
{
    __block RequestInfo *requestInfo;
    requestInfo = [[LYNetworkHelper sharedHelper] configureVideoRequestWithInterface:interface parameters:parameters];
    requestInfo.reqinteface = interface;
    
    AFHTTPSessionManager *sManager = [AFHTTPSessionManager manager];
    //申明请求的数据是json类型
    sManager.requestSerializer = [AFJSONRequestSerializer serializer];
    //申明返回的结果是json类型
    sManager.responseSerializer = [AFJSONResponseSerializer serializer];
    sManager.requestSerializer.timeoutInterval = 30.0;
    sManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    
    sManager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    sManager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    NSLog(@"URL--------%@\nParamers-----------%@",requestInfo.url,requestInfo.paramers);
    [sManager POST:requestInfo.url parameters:requestInfo.paramers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *dic = (NSDictionary *)responseObject;
            successed(responseObject, dic[@"desc"],dic[@"code"]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 有问题
        NSLog(@"error = %@", error);
    }];
}

- (void)requestVideoWithGet:(NSString *)interface parameters:(NSDictionary *)parameters successed:(SuccessedBlock)successed failed:(FailureBlock)failed
{
    __block RequestInfo *requestInfo;
    requestInfo = [[LYNetworkHelper sharedHelper] configureVideoRequestWithInterface:interface parameters:parameters];
    requestInfo.reqinteface = interface;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明请求的数据类型
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    //申明返回的结果类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    manager.securityPolicy = [AFSecurityPolicy defaultPolicy];
    manager.requestSerializer.cachePolicy = NSURLRequestUseProtocolCachePolicy;
    
    NSLog(@"URL--------%@\nParamers-----------%@",requestInfo.url,requestInfo.paramers);
    [manager GET:requestInfo.url parameters:requestInfo.paramers progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject isKindOfClass:[NSDictionary class]]){
            NSDictionary *dic = (NSDictionary *)responseObject;
            successed(dic, dic[@"desc"],dic[@"code"]);
        }
        if ([responseObject isKindOfClass:[NSData class]]) {
            id jsonObject = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if ([jsonObject isKindOfClass:[NSDictionary class]]){
                
                NSDictionary *dic = (NSDictionary *)jsonObject;
                successed(dic, dic[@"desc"],dic[@"code"]);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error, @"网络异常",@"-1000");
        NSLog(@"error = %@", error);
    }];
    
}

#pragma mark - 处理回调结果

- (void)p_completeRequestForAccess:(id)responseString withStatus:(BOOL)status requsetInfo:(__strong RequestInfo*)info
{
    NSString *requestInterface = info.reqinteface;
    id<CPNetworkCallBackDelegate>  delegate = info.delegate;
    
    RequestResult *result;
    
    if((info.responeType==1) && responseString)
    {
        responseString = [[NSString alloc] initWithData:responseString encoding:NSUTF8StringEncoding];
    }
    
    if (status && responseString)
    {
        result = [[LYNetworkHelper sharedHelper] parseDataStringForAccess:responseString requestInterface:requestInterface];
        if (result.status == 1 && result.results.count == 0 && result.resultInfo.allKeys.count == 0)
        {
            result.status = 0;//修正返回值
        }
    }else{
        //失败的请求
        result = [[RequestResult alloc] init];
        result.status = -1;
        result.message = @"网络异常，请重试~";
        result.code = kNetworkErrorCode;
    }
    
    if (info.unencryptedParams) {
        result.unencryptedReqParams = info.unencryptedParams;
    }
    if (info.paramers) {
        result.requestParameters = info.paramers;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(networkCallBackWith:requestResult:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //TODO 先暂时放到主线程去处理，实际应该放到后台线程处理完再dispatch给主线程，这么做是为了避免crash
            [delegate networkCallBackWith:requestInterface requestResult:result];
        });
    } else if (info.completeHandler) {
        info.completeHandler(result);
    }
    
}

- (void)p_completeRequestForAloT:(id)responseString withStatus:(BOOL)status requsetInfo:(__strong RequestInfo*)info
{
    NSString *requestInterface = info.reqinteface;
    id<CPNetworkCallBackDelegate>  delegate = info.delegate;
    RequestResult *result;
    
    if((info.responeType==1) && responseString)
    {
        responseString = [[NSString alloc] initWithData:responseString encoding:NSUTF8StringEncoding];
    }
    
    if (status && responseString)
    {
        //解析返回结果
        
        result = [[LYNetworkHelper sharedHelper] parseDataStringForAloT:responseString requestInterface:requestInterface];
        
        if (result.status == 1 && result.results.count == 0 && result.resultInfo.allKeys.count == 0)
        {
            result.status = 0;//修正返回值
        }
    }
    else
    {
        //失败的请求
        result = [[RequestResult alloc] init];
        result.status = -1;
        result.message = @"网络异常，请重试~";
        result.code = kNetworkErrorCode;
    }
    
    if (info.unencryptedParams) {
        result.unencryptedReqParams = info.unencryptedParams;
    }
    if (info.paramers) {
        result.requestParameters = info.paramers;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(networkCallBackWith:requestResult:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //TODO 先暂时放到主线程去处理，实际应该放到后台线程处理完再dispatch给主线程，这么做是为了避免crash
            [delegate networkCallBackWith:requestInterface requestResult:result];
        });
    } else if (info.completeHandler) {
        info.completeHandler(result);
    }
}

- (void)p_completeRequestForProperty:(id)responseString withStatus:(BOOL)status requsetInfo:(__strong RequestInfo*)info
{
    NSString *requestInterface = info.reqinteface;
    id<CPNetworkCallBackDelegate>  delegate = info.delegate;
    RequestResult *result;
    
    if((info.responeType==1) && responseString)
    {
        responseString = [[NSString alloc] initWithData:responseString encoding:NSUTF8StringEncoding];
    }
    
    if (status && responseString)
    {
        //解析返回结果
        
        result = [[LYNetworkHelper sharedHelper] parseDataStringForNewPort:responseString requestInterface:requestInterface];
        
        if (result.status == 1 && result.results.count == 0 && result.resultInfo.allKeys.count == 0)
        {
            result.status = 0;//修正返回值
        }
    }
    else
    {
        //失败的请求
        result = [[RequestResult alloc] init];
        result.status = -1;
        result.message = @"网络异常，请重试~";
        result.code = kNetworkErrorCode;
    }
    
    if (info.unencryptedParams) {
        result.unencryptedReqParams = info.unencryptedParams;
    }
    if (info.paramers) {
        result.requestParameters = info.paramers;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(networkCallBackWith:requestResult:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //TODO 先暂时放到主线程去处理，实际应该放到后台线程处理完再dispatch给主线程，这么做是为了避免crash
            [delegate networkCallBackWith:requestInterface requestResult:result];
        });
    } else if (info.completeHandler) {
        info.completeHandler(result);
    }
}

- (void)p_completeRequestForNewPort:(id)responseString withStatus:(BOOL)status requsetInfo:(__strong RequestInfo*)info
{
    NSString *requestInterface = info.reqinteface;
    id<CPNetworkCallBackDelegate>  delegate = info.delegate;
    RequestResult *result;
    
    if((info.responeType==1) && responseString)
    {
        responseString = [[NSString alloc] initWithData:responseString encoding:NSUTF8StringEncoding];
    }

    if (status && responseString)
    {
        //解析返回结果
        
        result = [[LYNetworkHelper sharedHelper] parseDataStringForNewPort:responseString requestInterface:requestInterface];
        
        if (result.status == 1 && result.results.count == 0 && result.resultInfo.allKeys.count == 0)
        {
            result.status = 0;//修正返回值
        }
    }
    else
    {
        //失败的请求
        result = [[RequestResult alloc] init];
        result.status = -1;
        result.message = @"网络异常，请重试~";
        result.code = kNetworkErrorCode;
    }
    
    if (info.unencryptedParams) {
        result.unencryptedReqParams = info.unencryptedParams;
    }
    if (info.paramers) {
        result.requestParameters = info.paramers;
    }
    
    if (delegate && [delegate respondsToSelector:@selector(networkCallBackWith:requestResult:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            //TODO 先暂时放到主线程去处理，实际应该放到后台线程处理完再dispatch给主线程，这么做是为了避免crash
            [delegate networkCallBackWith:requestInterface requestResult:result];
        });
    } else if (info.completeHandler) {
        info.completeHandler(result);
    }
}

#pragma mark - Config

-(void)startMonitor
{
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NetWorkChanged object:[NSNumber numberWithInt:status]];//通知网络变化
    }];
    [mgr startMonitoring];
}

- (void)changeConfigure:(NetworkEnvironment)environment  customIP:(NSString *)IP
{
    
    NSDictionary *networkUrlDic = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"ServerIPAddressDic_%ld",(long)environment]];
    
    _environment = environment;
    
    switch (environment) {
            
        case EnvironmentPreRelease_28:
            
        case EnvironmentOnLine:{
            
            NetworkUrl_access_main =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] :
            @"https://sapp.0easy.com/mapi/";
            
            NetworkUrl_property_voip   =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] :
            @"https://sapp.0easy.com/yihao01-switch-api/";
            
            NetWorkUrl_NewApi =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] :
            @"https://sapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_property_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] :
            @"https://sapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetWorkUrl_park_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] :
            @"https://sapp.0easy.com/yihao01-switch-api/";
            
            FileUrl_Voip = @"oeasy_phone_sip.conf";
            sipIp_voip = @"139.196.107.130";
            NetworkUrl_help =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] :
            @"https://sapp.0easy.com/yihao01-app-api/help/";
            
            NetWorkUrl_uploadMsg =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] :
            @"https://sapp.0easy.com/yihao01-base-center/door/data-report?";
            
            NetWorkUrl_publicIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] :
            @"https://sapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_LeaseIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] :
            @"https://sapp.0easy.com/yihao01-ecommunity-api/outapi/";
            
            NetWorkUrl_Activity_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] :
            @"https://sapp.0easy.com/";
            
            NetworkUrl_Pay_For_Guests =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] :
            @"https://sapp.0easy.com/yihao01-park-payment/payment/payIndex.html";
            
            NetworkUrl_Pay_For_Guests_Detail =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] :
            @"https://sapp.0easy.com/yihao01-park-payment/payment/payDetail.html";
            
            NetworkUrl_Pay_Url_Prefix =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] :
            @"https://sapp.0easy.com";
            
            NetworkUrl_AloT =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://testaiot.0easy.com/";
            
            NetworkUrl_VTNetwork_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://sapp.0easy.com";
            
            NetworkUrl_ParkVoIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://sapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetworkUrl_ecommunity_base = @"https://sapp.0easy.com/yihao01-ecommunity-api/";
            
            if ([self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"] forKey:@"IPAddress"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"https://smart.0easy.com/yihao01-datastream-collector" forKey:@"IPAddress"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
            break;
            
        case EnvironmentOnLine2:{
            
            NetworkUrl_access_main =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] :
            @"https://nsapp.0easy.com/mapi/";
            
            NetworkUrl_property_voip   =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] :
            @"https://nsapp.0easy.com/yihao01-switch-api/";
            
            NetWorkUrl_NewApi =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] :
            @"https://nsapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_property_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] :
            @"https://nsapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetWorkUrl_park_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] :
            @"https://nsapp.0easy.com/yihao01-switch-api/";
            
            FileUrl_Voip = @"oeasy_phone_sip.conf";
            sipIp_voip = @"139.196.107.130";
            NetworkUrl_help =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] :
            @"https://nsapp.0easy.com/yihao01-app-api/help/";
            
            NetWorkUrl_uploadMsg =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] :
            @"https://nsapp.0easy.com/yihao01-base-center/door/data-report?";
            
            NetWorkUrl_publicIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] :
            @"https://nsapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_LeaseIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] :
            @"https://nsapp.0easy.com/yihao01-ecommunity-api/outapi/";
            
            NetWorkUrl_Activity_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] :
            @"https://nsapp.0easy.com/";
            
            NetworkUrl_Pay_For_Guests =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] :
            @"https://nsapp.0easy.com/yihao01-park-payment/payment/payIndex.html";
            
            NetworkUrl_Pay_For_Guests_Detail =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] :
            @"https://nsapp.0easy.com/yihao01-park-payment/payment/payDetail.html";
            
            NetworkUrl_Pay_Url_Prefix =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] :
            @"https://nsapp.0easy.com";
            
            NetworkUrl_AloT =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://aiot.0easy.com/";
            
            NetworkUrl_VTNetwork_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://nsapp.0easy.com";
            
            NetworkUrl_ParkVoIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://nsapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetworkUrl_ecommunity_base = @"https://nsapp.0easy.com/yihao01-ecommunity-api/";
            
            kFaceCollectUrl = @"https://security.S0easy.com/yihao01-face-recognize/face_import";
            kFaceCollectSingleUrl = @"https://security.0easy.com/yihao01-face-recognize/add_face"; //单张采集
            kFaceDefaultCountUrl = @"https://security.0easy.com/yihao01-face-recognize/feature_count";
            
            if ([self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"] forKey:@"IPAddress"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"https://smart.0easy.com/yihao01-datastream-collector" forKey:@"IPAddress"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
            break;
            
        case EnvironmentPreRelease:{
            
            NetworkUrl_access_main =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] :
            @"https://preapp.0easy.com/mapi/";
            
            NetworkUrl_property_voip   =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] :
            @"https://preapp.0easy.com/yihao01-switch-api/";
            
            NetWorkUrl_NewApi =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] :
            @"https://preapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_property_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] :
            @"https://preapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetWorkUrl_park_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] :
            @"https://preapp.0easy.com/yihao01-switch-api/";
            
            FileUrl_Voip = @"oeasy_phone_sip.conf";
            sipIp_voip = @"139.196.107.130";
            NetworkUrl_help =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] :
            @"https://preapp.0easy.com/yihao01-app-api/help/";
            
            NetWorkUrl_uploadMsg =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] :
            @"https://preapp.0easy.com/yihao01-base-center/door/data-report?";
            
            NetWorkUrl_publicIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] :
            @"https://preapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_LeaseIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] :
            @"https://presapp.0easy.com/yihao01-ecommunity-api/outapi/";
            
            NetWorkUrl_Activity_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] :
            @"https://preapp.0easy.com/";
            
            NetworkUrl_Pay_For_Guests =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] :
            @"https://preapp.0easy.com/yihao01-park-payment/payment/payIndex.html";
            
            NetworkUrl_Pay_For_Guests_Detail =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] :
            @"https://preapp.0easy.com/yihao01-park-payment/payment/payDetail.html";
            
            NetworkUrl_Pay_Url_Prefix =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] :
            @"https://preapp.0easy.com";
            
            NetworkUrl_AloT =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://testaiot.0easy.com/";
            
            NetworkUrl_VTNetwork_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://preapp.0easy.com";
            
            NetworkUrl_ParkVoIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://preapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetworkUrl_ecommunity_base = @"https://preapp.0easy.com/yihao01-ecommunity-api/";
            
            ///埋点需用到的ip 地址
            if ([self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"] forKey:@"IPAddress"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"https://smart.0easy.com/yihao01-datastream-collector" forKey:@"IPAddress"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
            break;
            
        case EnvironmentPreRelease2:{
            
            NetworkUrl_access_main =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] :
            @"https://presapp.0easy.com/mapi/";
            
            NetworkUrl_property_voip   =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] :
            @"https://presapp.0easy.com/yihao01-switch-api/";
            
            NetWorkUrl_NewApi =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] :
            @"https://presapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_property_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] :
            @"https://presapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetWorkUrl_park_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] :
            @"https://presapp.0easy.com/yihao01-switch-api/";
            
            FileUrl_Voip = @"oeasy_phone_sip.conf";
            sipIp_voip = @"139.196.107.130";
            NetworkUrl_help =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] :
            @"https://presapp.0easy.com/yihao01-app-api/help/";
            
            NetWorkUrl_uploadMsg =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] :
            @"https://presapp.0easy.com/yihao01-base-center/door/data-report?";
            
            NetWorkUrl_publicIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] :
            @"https://presapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_LeaseIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] :
            @"https://presapp.0easy.com/yihao01-ecommunity-api/outapi/";
            
            NetWorkUrl_Activity_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] :
            @"https://presapp.0easy.com/";
            
            NetworkUrl_Pay_For_Guests =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] :
            @"https://presapp.0easy.com/yihao01-park-payment/payment/payIndex.html";
            
            NetworkUrl_Pay_For_Guests_Detail =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] :
            @"https://presapp.0easy.com/yihao01-park-payment/payment/payDetail.html";
            
            NetworkUrl_Pay_Url_Prefix =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] :
            @"https://presapp.0easy.com";
            
            NetworkUrl_AloT =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://preaiot.0easy.com/";
            
            NetworkUrl_VTNetwork_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://presapp.0easy.com";
            
            NetworkUrl_ParkVoIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://presapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetworkUrl_ecommunity_base = @"https://presapp.0easy.com/yihao01-ecommunity-api/";
            
            kFaceCollectUrl = @"https://security.0easy.com/yihao01-face-recognize/face_import";
            kFaceCollectSingleUrl = @"https://security.0easy.com/yihao01-face-recognize/add_face"; //单张采集
            kFaceDefaultCountUrl = @"";
            
            ///埋点需用到的ip 地址
            if ([self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"] forKey:@"IPAddress"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"https://smart.0easy.com/yihao01-datastream-collector" forKey:@"IPAddress"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
            break;
            
        case EnvironmentTest:{
            
            NetworkUrl_access_main =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] :
            @"http://192.168.0.96/mapi/";
            
            NetworkUrl_property_voip   =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] :
            @"http://192.168.0.96/yihao01-switch-api/";
            
            NetWorkUrl_NewApi =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] :
            @"http://192.168.0.96/yihao01-app-api/";
            
            NetWorkUrl_property_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] :
            @"http://192.168.0.96/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetWorkUrl_park_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] :
            @"http://192.168.0.96/yihao01-switch-api/";
            
            FileUrl_Voip = @"oeasy_phone_dev_sip.conf";
            sipIp_voip = @"192.168.0.98";
            NetworkUrl_help =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] :
            @"https://testapp.0easy.com/yihao01-app-api/help/";
            
            NetWorkUrl_uploadMsg =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] :
            @"https://testapp.0easy.com/yihao01-base-center/door/data-report?";
            
            NetWorkUrl_publicIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] :
            @"https://preapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_Activity_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] :
            @"http://192.168.0.96/";
            
            NetworkUrl_Pay_For_Guests =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] :
            @"http://192.168.0.96/yihao01-park-payment/payment/payIndex.html";
            
            NetworkUrl_Pay_For_Guests_Detail =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] :
            @"http://192.168.0.96/yihao01-park-payment/payment/payDetail.html";
            
            NetworkUrl_Pay_Url_Prefix =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] :
            @"http://192.168.0.96";
            
            NetworkUrl_AloT =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://testaiot.0easy.com/";
            
            NetworkUrl_VTNetwork_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"http://192.168.0.96";
            
            NetworkUrl_ParkVoIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"http://192.168.0.96/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetworkUrl_ecommunity_base = @"https://testapp.0easy.com/yihao01-ecommunity-api/";
            
            ///埋点需用到的ip 地址
            if ([self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"] forKey:@"IPAddress"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.0.235:7890/log" forKey:@"IPAddress"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
            break;
            
        case EnvironmentTest2:{
            
            NetworkUrl_access_main =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] :
            @"https://testapp.0easy.com/mapi/";
            
            NetworkUrl_property_voip   =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] :
            @"https://testapp.0easy.com/yihao01-switch-api/";
            
            NetWorkUrl_NewApi =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] :
            @"https://testapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_property_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] :
            @"https://testapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetWorkUrl_park_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] :
            @"https://testapp.0easy.com/yihao01-switch-api/";
            
            FileUrl_Voip = @"oeasy_phone_dev_sip.conf";
            sipIp_voip = @"192.168.0.98";
            NetworkUrl_help =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] :
            @"https://testapp.0easy.com/yihao01-app-api/help/";
            
            NetWorkUrl_uploadMsg =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] :
            @"https://testapp.0easy.com/yihao01-base-center/door/data-report?";
            
            NetWorkUrl_publicIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] :
            @"https://testapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_LeaseIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] :
            @"https://testapp.0easy.com/yihao01-ecommunity-api/outapi/";
            
            NetWorkUrl_Activity_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] :
            @"https://testapp.0easy.com/";
            
            NetworkUrl_Pay_For_Guests =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] :
            @"https://testapp.0easy.com/yihao01-park-payment/payment/payIndex.html";
            
            NetworkUrl_Pay_For_Guests_Detail =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] :
            @"https://testapp.0easy.com/yihao01-park-payment/payment/payDetail.html";
            
            NetworkUrl_Pay_Url_Prefix =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] :
            @"https://testapp.0easy.com";
            
            NetworkUrl_AloT =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://testaiot.0easy.com/";
            
            NetworkUrl_VTNetwork_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://testapp.0easy.com";
            
            NetworkUrl_ParkVoIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://testapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetworkUrl_ecommunity_base = @"https://testapp.0easy.com/yihao01-ecommunity-api/";
            
            kFaceCollectUrl = @"https://testapp.0easy.com/yihao01-face-recognize/face_import";
            kFaceCollectSingleUrl = @"http://192.168.0.238:4004/yihao01-face-recognize/add_face"; //单张采集
            kFaceDefaultCountUrl = @"https://testapp.0easy.com/yihao01-face-recognize/feature_count";
            
            ///埋点需用到的ip 地址
            if ([self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"] forKey:@"IPAddress"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.0.235:7890/log" forKey:@"IPAddress"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
            break;
            
        case EnvironmentDevelopment:{
            
            NetworkUrl_access_main =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] :
            @"http://192.168.0.98:9078/mapi/";
            
            NetworkUrl_property_voip   =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] :
            @"http://192.168.0.96/yihao01-switch-api/";
            
            NetWorkUrl_NewApi =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] :
            @"https://devapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_property_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] :
            @"https://devapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetWorkUrl_park_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] :
            @"https://devapp.0easy.com/yihao01-switch-api/";
            
            FileUrl_Voip = @"oeasy_phone_dev_sip.conf";
            sipIp_voip = @"192.168.0.98";
            NetworkUrl_help =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] :
            @"http://192.168.0.99:7009/yihao01-app-api/help/";
            
            NetWorkUrl_uploadMsg =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] :
            @"http://192.168.0.99:7009/yihao01-base-center/door/data-report?";
            
            NetWorkUrl_publicIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] :
            @"https://sapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_Activity_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] :
            @"http://192.168.0.99:7009/";
            
            NetworkUrl_Pay_For_Guests =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] :
            @"http://192.168.0.99:8080/yihao01-park-payment/payment/payIndex.html";
            
            NetworkUrl_Pay_For_Guests_Detail =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] :
            @"http://192.168.0.99:8080/yihao01-park-payment/payment/payDetail.html";
            
            NetworkUrl_Pay_Url_Prefix =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] :
            @"http://192.168.0.99:8080";
            
            NetworkUrl_VTNetwork_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"http://192.168.0.99:8080";
            
            NetworkUrl_ParkVoIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"http://192.168.0.99:8080/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetworkUrl_ecommunity_base = @"https://devapp.0easy.com/yihao01-ecommunity-api/";
            
            ///埋点需用到的ip 地址
            if ([self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"] forKey:@"IPAddress"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.0.235:7890/log" forKey:@"IPAddress"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
            break;
            
        case EnvironmentDevelopment2:{
            
            NetworkUrl_access_main =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_access_main"] :
            @"https://devapp.0easy.com/mapi/";
            
            NetworkUrl_property_voip   =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_property_voip"] :
            @"https://devapp.0easy.com/yihao01-switch-api/";
            
            NetWorkUrl_NewApi =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_NewApi"] :
            @"https://devapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_property_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_property_api"] :
            @"https://devapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetWorkUrl_park_api =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_park_api"] :
            @"https://devapp.0easy.com/yihao01-switch-api/";
            
            FileUrl_Voip = @"oeasy_phone_dev_sip.conf";
            sipIp_voip = @"192.168.0.98";
            NetworkUrl_help =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_help"] :
            @"https://devapp.0easy.com/yihao01-app-api/help/";
            
            NetWorkUrl_uploadMsg =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_uploadMsg"] :
            @"https://devapp.0easy.com/yihao01-base-center/door/data-report?";
            
            NetWorkUrl_publicIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_publicIP"] :
            @"https://devapp.0easy.com/yihao01-app-api/";
            
            NetWorkUrl_LeaseIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_LeaseIP"] :
            @"https://devapp.0easy.com/yihao01-ecommunity-api/outapi/";
            
            NetWorkUrl_Activity_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetWorkUrl_Activity_base"] :
            @"https://devapp.0easy.com/";
            
            NetworkUrl_Pay_For_Guests =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests"] :
            @"https://devapp.0easy.com/yihao01-park-payment/payment/payIndex.html";
            
            NetworkUrl_Pay_For_Guests_Detail =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_For_Guests_Detail"] :
            @"https://devapp.0easy.com/yihao01-park-payment/payment/payDetail.html";
            
            NetworkUrl_Pay_Url_Prefix =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_Pay_Url_Prefix"] :
            @"https://devapp.0easy.com";
            
            NetworkUrl_AloT =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://devaiot.0easy.com/";
            
            NetworkUrl_VTNetwork_base =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://devapp.0easy.com";
            
            NetworkUrl_ParkVoIP =
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] ?
            [self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_AloT"] :
            @"https://devapp.0easy.com/yihao01-ecommunity-api/outapi/switchapi/";
            
            NetworkUrl_ecommunity_base = @"https://devapp.0easy.com/yihao01-ecommunity-api/";
            
            kFaceCollectUrl = @"https://testapp.0easy.com/yihao01-face-recognize/face_import";
            kFaceCollectSingleUrl = @"http://192.168.0.238:4004/yihao01-face-recognize/add_face"; //单张采集
            kFaceDefaultCountUrl = @"https://testapp.0easy.com/yihao01-face-recognize/feature_count";
            
            ///埋点需用到的ip 地址
            if ([self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"]) {
                [[NSUserDefaults standardUserDefaults] setObject:[self networkUrl_service:networkUrlDic AndUrlName:@"NetworkUrl_bigData_log"] forKey:@"IPAddress"];
            }else{
                [[NSUserDefaults standardUserDefaults] setObject:@"http://192.168.0.235:7890/log" forKey:@"IPAddress"];
            }
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
            break;
            
            
        case EnvironmentCustom:{
            
            
        }
            break;
            
        default:
            break;
    }
    
    
}

- (NSString *)networkUrl_service:(NSDictionary *)networkUrlDic AndUrlName:(NSString *)urlName
{
    NSDictionary *httpDic = networkUrlDic;
    NSString *networkUrl = nil;
    if (!httpDic) {
        return nil;
    }
    
    if ([urlName isEqualToString:@"NetworkUrl_access_main"]) {
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_MAPI"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/",
                      confValueDic[@"host"],confValueDic[@"serviceName"]];
        
    }
    else if ([urlName isEqualToString:@"NetworkUrl_property_voip"]) {
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_DHOME"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/",
                      confValueDic[@"host"],confValueDic[@"serviceName"]];
        
    }
    else if ([urlName isEqualToString:@"NetWorkUrl_NewApi"]) {
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_APP_API"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/",
                      confValueDic[@"host"],confValueDic[@"serviceName"]];
        
    }
    else if ([urlName isEqualToString:@"NetWorkUrl_property_api"]) {
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_SWITCH_API"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/",
                      confValueDic[@"host"],confValueDic[@"serviceName"]];
        
    }
    else if ([urlName isEqualToString:@"NetWorkUrl_park_api"]) {
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_SWITCH_API"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/",
                      confValueDic[@"host"],confValueDic[@"serviceName"]];
        
    }
    else if ([urlName isEqualToString:@"FileUrl_Voip"]) {
        
        networkUrl = nil;
        
    }
    else if ([urlName isEqualToString:@"NetworkUrl_help"]) {
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_APP_API"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/%@/",
                      confValueDic[@"host"],confValueDic[@"serviceName"],@"help"];
        
    }
    else if ([urlName isEqualToString:@"NetWorkUrl_uploadMsg"]) {
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_APP_REPORT"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/%@?",
                      confValueDic[@"host"],confValueDic[@"serviceName"],@"api"];
        
    }
    else if ([urlName isEqualToString:@"NetWorkUrl_publicIP"]) {
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_APP_API"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/",
                      confValueDic[@"host"],confValueDic[@"serviceName"]];
        
    }
    else if ([urlName isEqualToString:@"NetWorkUrl_Activity_base"]) {
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_APP_API"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/",
                      confValueDic[@"host"]];
    }
    else if ([urlName isEqualToString:@"NetworkUrl_Pay_For_Guests"]) {
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_APP_PAYMENT"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/%@",
                      confValueDic[@"host"],confValueDic[@"serviceName"],@"payment/payIndex.html"];
    }
    else if ([urlName isEqualToString:@"NetworkUrl_Pay_For_Guests_Detail"]) {
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_APP_PAYMENT"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/%@",
                      confValueDic[@"host"],confValueDic[@"serviceName"],@"payment/payDetail.html"];
        
    }
    else if ([urlName isEqualToString:@"NetworkUrl_Pay_Url_Prefix"]) {
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_APP_API"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@",confValueDic[@"host"]];
        
    }
    else if ([urlName isEqualToString:@"NetworkUrl_bigData_log"]){
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_BIGDATA_LOG"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@",confValueDic[@"host"],confValueDic[@"serviceName"]];
        
    }
    else if ([urlName isEqualToString:@"NetworkUrl_AloT"]){
        
        NSDictionary *confValueDic = httpDic[@"SERVICE_NAME_MAPI"];
        if (!confValueDic) {
            return nil;
        }
        networkUrl = [NSString stringWithFormat:@"%@/%@/",confValueDic[@"host"],confValueDic[@"serviceName"]];
    }
    return networkUrl;
}

@end
