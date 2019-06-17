//
//  UploadTask.h
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RNRequest.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^requestObject)(RNRequest *request);

@protocol UploadTaskDelegate <NSObject>


/*!
 *
 *discussion when fetch token operation finish, this method will be called
 *param taskId
 *param error if fail error is not nil
 *return void
 */
- (void)taskId:(NSString *)taskId callBackKey:(NSString *)key fetchTokenCallBack:(nullable id) token error:(nullable NSError *)error;



/*!
 *
 *@discussion when every image is uploaded to the server, this method will be called
 *@param imgKey the key identified image
 *@param keyCode the keyCode returned from QN
 *@param error if fail error is not nil
 *return
 */
- (void)taskId:(NSString *)taskId callBackKey:(NSString *)key uploadImg:(nullable id) imgKey finish:(nullable id)keyCode error:(nullable NSError *)error;

/*!
 *
 *@discussion when all upload are uploaded to the server, this method will be called
 *param keyCodes the keyCode returned from QN
 *@param error if fail error is not nil
 *return void
 */
- (void)taskId:(NSString *)taskId uploadImgsCallBack:(nullable NSArray *) keyCodeDicts ruquest:(RNRequest *)request error:(nullable NSError *)error requestObject:(requestObject)requestObject;


/*!
 *
 *@discussion tell the delegate of the progress of the UploadTask
 *@param progress (0,1]
 *return void
 */
- (void)taskId:(NSString *)taskId progressInUploading:(CGFloat) progress;


/*!
 *
 *@discussion when publish finish, this method will be called
 *param result
 *@param error if fail error is not nil
 *return
 */
- (void)taskId:(NSString *)taskId callBackKey:(NSString *)key publishCallBack:(nullable id) result error:(nullable NSError *)error;

@end
@interface UploadTask : CPModel

@property (nonatomic, strong, nonnull) NSString * taskId;
@property (nonatomic, strong, nonnull) NSString * failedTaskId;
@property (nonatomic, strong, nonnull) NSString * taskDescription;
@property (nonatomic, strong, nullable) NSArray * upLoadImageArray;
@property (nonatomic, strong, nullable) NSNumber *finishCount;
@property (nonatomic, strong, nonnull) RNRequest *request;
@property (nonatomic, strong, nullable) RNRequest *qnRequest;
@property (nonatomic, strong, nonnull) NSNumber *isFail;
@property (nonatomic, weak, nullable) id<UploadTaskDelegate> delegate;



@end
NS_ASSUME_NONNULL_END
