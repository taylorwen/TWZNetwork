//
//  RNRequest.h
//  CommonProject
//
//  Created by Ming Wang on 2017/3/1.
//  Copyright © 2017年 oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface RNRequest : CPModel

@property (nonatomic,   copy) NSString *requestUrl;

@property (nonatomic,   copy) NSString *callBackKey;

@property (nonatomic,   copy) NSString *way;

@property (nonatomic,   copy) NSDictionary * hasImageToUpload;

@property (nonatomic, strong) NSDictionary *parameters;

@property (nonatomic, strong) NSMutableArray *images;

@property (nonatomic,   copy) NSString *imageParamerNames;

@property (nonatomic,   copy) NSString *qnTokenParse; //七牛解析数据还是用的native的，用这个做兼容

@property (nonatomic,   copy) NSString *isAloT;     //是否是AloT平台接口

@end
NS_ASSUME_NONNULL_END
