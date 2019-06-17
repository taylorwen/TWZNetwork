//
//  CGIOP.m
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import "CGIOP.h"
#import "RNNetworkManager.h"

@implementation CGIOP


- (void)main
{
    NSLog(@"结束");
    [[RNNetworkManager shared] request:self.request success:^(RNNetworkManager *network, id data, NSString *desc, NSString *code, NSString *key) {
        NSLog(@"%@",data);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.uploadtask.delegate && [self.uploadtask.delegate respondsToSelector:@selector(taskId:callBackKey:publishCallBack:error:)]) {
                
                [self.uploadtask.delegate taskId:self.uploadtask.taskId callBackKey:key publishCallBack:data error:nil];
                
            }
        });
        [self completeOperation];
    } fail:^(RNNetworkManager *networkk, id data, NSString *desc, NSString *code, NSString *key) {
        NSLog(@"%@",data);
        NSError *error = data;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.uploadtask.delegate && [self.uploadtask.delegate respondsToSelector:@selector(taskId:callBackKey:publishCallBack:error:)]) {
                
                [self.uploadtask.delegate taskId:self.uploadtask.taskId callBackKey:key publishCallBack:nil error:error];
                
            }
        });
        [self completeOperation];
    }];
}

@end
