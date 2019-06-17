//
//  CPNetworkController.h
//  CommonProject
//
//  Created by 华美时代 on 15/4/13.
//  Copyright (c) 2015年 jiayi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDefine.h"

NS_ASSUME_NONNULL_BEGIN
/**
 成功回调
 */
typedef void(^SuccessedBlock)(id resultData, NSString *desc, NSString *code);
/**
 失败回调
 */
typedef void(^FailureBlock)(NSError *error, NSString *desc, NSString *code);

@class RequestResult;

#pragma mark - CPNetworkController

@protocol CPNetworkCallBackDelegate <NSObject>

@optional

/**
 *  网络请求结果回调
 *
 *  @param interface 接口ID
 *  @param result    回调结果
 */
- (void)networkCallBackWith:(NSString *)interface requestResult:(RequestResult *)result;

@end

@interface CPNetworkController : NSObject


@property(nonatomic,strong) NSString *NetworkUrl_property_voip;//可视对讲
@property(nonatomic,strong) NSString *NetworkUrl_access_main;//停车场
@property(nonatomic,strong) NSString *NetworkUrl_help;//帮助
@property(nonatomic,strong) NSString *NetWorkUrl_NewApi;//默认的 BaseURL
@property(nonatomic,strong) NSString *FileUrl_Voip;
@property(nonatomic,strong) NSString *sipIp_voip;
@property(nonatomic,strong) NSString *NetWorkUrl_property_api;//物业后台接口
@property(nonatomic,strong) NSString *NetWorkUrl_park_api;//车场机器人接口
@property(nonatomic,strong) NSString *NetWorkUrl_crowdApi;//众筹测试接口
@property(nonatomic,strong) NSString *NetWorkUrl_uploadMsg;//上传推送消息的接口
@property(nonatomic,strong) NSString *NetWorkUrl_publicIP;//查找公网IP的接口
@property(nonatomic,strong) NSString *NetWorkUrl_LeaseIP;//查找租房IP的接口
@property(nonatomic,strong) NSString *NetWorkUrl_Activity_base;//嗨玩模块接口
@property(nonatomic,strong) NSString *NetworkUrl_Pay_For_Guests;//代客缴费接口
@property(nonatomic,strong) NSString *NetworkUrl_Pay_For_Guests_Detail;
@property(nonatomic,strong) NSString *NetworkUrl_Pay_Url_Prefix;
@property(nonatomic,  copy) NSString *NetworkUrl_AloT;//AloT平台接口
@property (nonatomic, copy) NSString *NetworkUrl_ecommunity_base;//ecommunity接口
@property (nonatomic, copy) NSString *NetworkUrl_VTNetwork_base;
@property (nonatomic, copy) NSString *NetworkUrl_ParkVoIP;
@property (nonatomic,readwrite,copy) NSString *kFaceCollectSingleUrl;
@property (nonatomic,readwrite,copy) NSString *kFaceDefaultCountUrl;
@property (nonatomic,readwrite,copy) NSString *kFaceCollectUrl;

/**
 *  实例分享(单例)
 *
 *  @return 返回CPNetworkController实例
 */
+ (CPNetworkController *)shareController;

-(void)startMonitor;

/**
 *  新接口  -  发起网络POST请求(网络请求总入口)
 *
 *  @param interface        接口ID
 *  @param parameters       POST参数
 *  @param completionHandler Block回调
 */
- (void)request:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler;
- (void)request:(NSString *)interface parameters:(NSDictionary *)parameters callBackDelegate:(id)delegate;

/**
 *  物业接口    ---   发起网络POST请求
 *
 *  @param interface        接口地址
 *  @param parameters       POST参数
 *  @param completionHandler 回调
 */
- (void)requestProperty:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler;
- (void)requestProperty:(NSString *)interface parameters:(NSDictionary *)parameters callBackDelegate:(id)delegate;

/**
 *  车场门禁接口    ---   发起网络POST请求
 *
 *  @param interface        接口地址
 *  @param parameters       POST参数
 *  @param completionHandler 回调
 */
- (void)requestAccess:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler;
- (void)requestAccess:(NSString *)interface parameters:(NSDictionary *)parameters callBackDelegate:(id)delegate;

/**
 *  车场门禁接口    ---   发起网络POST请求
 *
 *  @param interface        接口地址
 *  @param parameters       POST参数
 *  @param completionHandler 回调
 */
- (void)requestAloT:(NSString *)interface parameters:(NSDictionary *)parameters completionHandler:(void(^)(RequestResult *result))completionHandler;
- (void)requestAloT:(NSString *)interface parameters:(NSDictionary *)parameters callBackDelegate:(id)delegate;

/**
 *  可视对讲接口    ---   发起网络请求
 *  @param method           请求方式，POST，GET
 *  @param interface        接口地址
 *  @param parameters       POST参数
 *  @param successed        成功回调
 *  @param failed           失败回调
 */
- (void)requestVideo:(LYHttpMethod)method interface:(NSString *)interface parameters:(NSDictionary *)parameters successed:(SuccessedBlock)successed failed:(FailureBlock)failed;

/**
 *  配置网络环境(默认为线上环境)
 *
 *  @param environment 网络环境类型
 *  @param IP          定制IP(暂时没有实现,默认传nil)
 */
- (void)changeConfigure:(NetworkEnvironment)environment  customIP:(NSString *)IP;

@end
NS_ASSUME_NONNULL_END
