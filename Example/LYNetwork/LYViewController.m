//
//  LYViewController.m
//  LYNetwork
//
//  Created by zhangdaokui on 02/27/2019.
//  Copyright (c) 2019 zhangdaokui. All rights reserved.
//

#import "LYViewController.h"
#import "CPNetworkController.h"
#import "RequestResult.h"

@interface LYViewController ()<CPNetworkCallBackDelegate>

@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Network Request with delegate
    [[CPNetworkController shareController] request:@"url" parameters:@{@"token":@"ee578eldk566"} callBackDelegate:self];
    
    //Network Request with block
    [[CPNetworkController shareController] request:@"url" parameters:@{@"token":@"ee578eldk566"} completionHandler:^(RequestResult * _Nonnull result) {
        NSLog(@"%@",result.message);
    }];
    
}

- (void)networkCallBackWith:(NSString *)interface requestResult:(RequestResult *)result
{
    NSLog(@"%@",result.message);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
