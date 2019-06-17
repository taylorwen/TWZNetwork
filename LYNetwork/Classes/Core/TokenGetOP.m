//
//  TokenGetOP.m
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import "TokenGetOP.h"
#import "RNNetworkManager.h"

@implementation TokenGetOP

- (void)main
{
    //__block NSString * qnTokenParse = self.uploadTask.qnRequest.qnTokenParse;
    [[RNNetworkManager shared] request:self.uploadTask.qnRequest success:^(RNNetworkManager *network, id responseObject, NSString *desc, NSString *code, NSString *key) {
        ///获取成功
       
        if (code.intValue == 200) {
            NSLog(@"%@",responseObject);
            
            id data = responseObject[@"data"];
            
            if ([data isKindOfClass:[NSDictionary class]]) {
                self.uploadQNToken = data[@"uploadToken"];
                self.uploadQNDomain = data[@"domain"];
                
            } else if ([data isKindOfClass:[NSString class]]) {
                self.uploadQNToken = data;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.uploadTask.delegate && [self.uploadTask.delegate respondsToSelector:@selector(taskId:callBackKey:fetchTokenCallBack:error:)]) {
                    
                    [self.uploadTask.delegate taskId:self.uploadTask.taskId callBackKey:key fetchTokenCallBack:data error:nil];
                }
            });
            
        }else{
            self.uploadQNToken = nil;
            NSError *error = responseObject;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.uploadTask.delegate && [self.uploadTask.delegate respondsToSelector:@selector(taskId:callBackKey:fetchTokenCallBack:error:)]) {
                    
                    [self.uploadTask.delegate taskId:self.uploadTask.taskId callBackKey:key fetchTokenCallBack:desc error:error];
                    
                }
            });
            
        }
        
        [self completeOperation];
        
    } fail:^(RNNetworkManager *networkk, id data, NSString *desc, NSString *code, NSString *key) {
        NSLog(@"%@",data);
        self.uploadQNToken = nil;
        NSError *error = data;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.uploadTask.delegate && [self.uploadTask.delegate respondsToSelector:@selector(taskId:callBackKey:fetchTokenCallBack:error:)]) {
                [self.uploadTask.delegate taskId:self.uploadTask.taskId callBackKey:key fetchTokenCallBack:desc error:error];
                
            }
        });
        
        [self completeOperation];
    }];
}

@end
