//
//  TokenGetOP.h
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncOperation.h"
#import "UploadTask.h"

NS_ASSUME_NONNULL_BEGIN
@interface TokenGetOP : AsyncOperation

@property (nonatomic, copy, nullable) NSString *uploadQNToken;

@property (nonatomic, copy) NSString *uploadQNDomain;

@property (nonatomic, weak) UploadTask *uploadTask;

@end
NS_ASSUME_NONNULL_END
