//
//  UploadTaskManager.h
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UploadTask.h"

NS_ASSUME_NONNULL_BEGIN
typedef void(^TokenGetFailBlock)(NSString *desc);

@interface UploadTaskManager : NSObject


@property (nonatomic, strong) NSString *currentTaskId;

@property (nonatomic, copy) TokenGetFailBlock tokenGetFailBlock;

+ (instancetype)sharedInstance;

/*!
 * All below methods should be called on the singleton of UploadTaskManager
 */

- (NSMutableDictionary *)getTaskManagerDict;
/*!
 *
 *@discussion any business code can call this method from any threads,
 *@param task the task to be runned
 *@param error when something wrong happened this error will be instantiated within this method
 *@return the taskId of task, nil if it didn't added to UploadTaskManager
 */
- (NSString *)addTask:(UploadTask *)task error:(NSError **)error;

/*!
 *
 *@discussion any business code can call this method from any threads,
 *@param taskId  of the task to be runned again
 *@param error when something wrong happened this error will be instantiated within this method
 *@return true if the task run again, false otherwise
 */
- (BOOL)restartTask:(NSString *)taskId error:(NSError **) error;

/*!
 *
 *@discussion any business code can call this method from any threads, when the task is cancelled, the taskId will be invalid and can't be reused
 *@param taskId  of the task to be cancelled
 *@param error when something wrong happened this error will be instantiated within this method
 *@return true if the task is cancelled, false otherwise
 */
- (BOOL)cancelTask:(NSString *)taskId error:(NSError **) error;


/*!
 *
 *@discussion any business code can call this method from any threads, this method should be called when the app is in background and will be suspended by the system or will be killed by the user
 *@param error when something wrong happened this error will be instantiated within this method
 *@return true if save suc, false otherwise
 */
- (BOOL)saveToDiskAndError:(NSError **)error;

/*!
 *
 *@discussion any business code can call this method from any threads, this method should be called when the app didFinishLaunchedWithOptions
 *@param error when something wrong happened this error will be instantiated within this method
 *@return true if save suc, false otherwise
 */
- (BOOL)recoverFromDiskAndError:(NSError **)error;

@end
NS_ASSUME_NONNULL_END
