//
//  RequestResult.m
//  LYNetwork_Example
//
//  Created by wenzhan on 2019/3/19.
//  Copyright © 2019年 zhangdaokui. All rights reserved.
//

#import "RequestResult.h"

#pragma mark - RequestResult
@implementation RequestResult
@synthesize status;
@synthesize code;
@synthesize message;
@synthesize results;
@synthesize resultInfo;
@synthesize resultString;
@synthesize reachEnd;

- (id)init {
    self = [super init];
    if (self) {
        status          = 0;
        code            = @"";
        message         = @"";
        results         = nil;
        resultInfo      = nil;
        resultString    = @"";
        reachEnd        = @"";
    }
    return  self;
}

@end
