//
//  IntercomPermissionProcessor.h
//  CommonProject
//
//  Created by xiangkui zeng on 2017/9/15.
//  Copyright © 2017年 oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UnderCallBack)(NSArray *data,BOOL isAllData);

@interface PermissionModel : NSObject

@property (nonatomic,assign)CGFloat width;
@property (nonatomic,  copy)NSString *name;
@property (nonatomic,  copy)NSString *telephone;
@property (nonatomic,assign)int type;
@property (nonatomic,  copy)NSString *typeDesc;
@property (nonatomic,assign)int isCall;
@property (nonatomic,assign)int isFirst;

@end

@protocol IntercomPermissionProcessorDelegate <NSObject>
/**
 *  typeFunc 回调方法 1:查询设置的房下帐号；2:设置可视对讲和优先呼叫
 *
 */

- (void)callBack:(int )typeFunc data:(id)data;

@end


@interface IntercomPermissionProcessor : NSObject

//@property (nonatomic,copy)UnderCallBack callBack;
/**
 * 一呼多响设置的房下账号(yihao01-ecommunity-api/outapi/switchapi/app/visibletalk/room/call/list)
 */
- (void)requestRoomUnderAccount:(NSDictionary *)params;

/**
 * 一呼多响设置的设置可视对讲和设置优先呼叫
 */
- (void)requestSetintercomAndFirstCall:(NSDictionary *)params;


/**
 *  代理属性
 */
@property (weak,nonatomic)id<IntercomPermissionProcessorDelegate> delegate;

- (void)fetchRoomUnderAccount:(NSDictionary *)params callBack:(UnderCallBack)callBack row:(NSString *)row;

@end
