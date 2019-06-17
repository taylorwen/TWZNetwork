//
//  NetworkDefine.h
//  CommonProject
//
//  Created by 华美时代 on 15/4/21.
//  Copyright (c) 2015年 jiayi. All rights reserved.
//

//=======================尺寸相关宏定义=========================
///屏幕宽度
#define SCREEN_WIDTH        ([[UIScreen mainScreen] bounds].size.width)
///屏幕高度
#define SCREEN_HEIGHT       ([[UIScreen mainScreen] bounds].size.height)

//========================颜色定义=============================
///颜色值Color 传入0xCCFFFF
#define COLOR_FROM_RGB(value)       [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16))/255.0 green:((float)((value & 0xFF00) >> 8))/255.0 blue:((float)(value & 0xFF))/255.0 alpha:1.0]

//========================函数定义================================
#define DealWithJSONStringValueBB(_JSONVALUE)         (_JSONVALUE != [NSNull null] && _JSONVALUE!=nil) ?[NSString stringWithFormat:@"%@",_JSONVALUE]:@"0"
#define DealWithStringValue(String)         (String != nil)?[NSString stringWithFormat:@"%@",String]:@""
//输出是JSON对象
#define DealWithJSONValue(_JSONVALUE)         (_JSONVALUE != [NSNull null] && _JSONVALUE!=nil) ? _JSONVALUE:nil
//输出是Sting类
#define DealWithJSONStringValue(_JSONVALUE)         (_JSONVALUE != [NSNull null] && _JSONVALUE!=nil) ?[NSString stringWithFormat:@"%@",_JSONVALUE]:@""
#define NetWorkChanged              @"NetWorkChanged"
#define kNetworkErrorCode           @"-100000"                  //网络异常code
//存个网络状态在本地方便测试切换环境
#define kTestEnvironment                    @"testEnvironment"

#pragma mark - 环境类型

typedef NS_ENUM(NSInteger, NetworkEnvironment)
{
    EnvironmentCustom = 0,          //定制环境
    EnvironmentDevelopment,         //开发环境   99
    EnvironmentTest,                //测试环境
    EnvironmentPreRelease,          //预发布环境
    EnvironmentPreRelease2,         //新预发布环境
    EnvironmentPreRelease_28,       //预发布28环境
    EnvironmentOnLine,              //线上
    EnvironmentOnLine2,             //新线上
    EnvironmentTest2,               //新测试环境
    EnvironmentDevelopment2,        //新开发环境 104
};

typedef NS_ENUM(NSInteger, LYHttpMethod)
{
    LYHttpMethodPOST = 900,          //定制环境
    LYHttpMethodGET,         //开发环境   99
};
