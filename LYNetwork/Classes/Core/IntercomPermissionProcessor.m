//
//  IntercomPermissionProcessor.m
//  CommonProject
//
//  Created by xiangkui zeng on 2017/9/15.
//  Copyright © 2017年 oeasy. All rights reserved.
//

#import "IntercomPermissionProcessor.h"
#import "UploadTaskManager.h"
#import "LYNetwork.h"
#import "SVProgressHUD.h"

#define interComRoomUnderAccount            @"app/visibletalk/room/call/list"
#define interComPermissionSet               @"app/visibletalk/room/call/set"

static NSMutableDictionary * KeyToCallBackDic;

@implementation PermissionModel

-(id)copyWithZone:(NSZone*)zone{
    
    PermissionModel*copyObject=[[[self class]allocWithZone:zone]init];
    
    copyObject.name=[self.name mutableCopy];
    
    copyObject.width=self.width;
    
    copyObject.telephone=[self.telephone mutableCopy];
    
    copyObject.type=self.type;
    
    copyObject.typeDesc = [self.typeDesc mutableCopy];
    
    copyObject.isCall = self.isCall;
    
    copyObject.isFirst = self.isFirst;
    
    return copyObject;
    
}


@end

@interface IntercomPermissionProcessor ()<UploadTaskDelegate>
{
    UnderCallBack underCallBack;
}
@property (nonatomic,copy)NSMutableArray *statusArray;/*租客一呼多响状态集合*/
@end

@implementation IntercomPermissionProcessor

- (NSMutableArray *)statusArray{
    if(!_statusArray){
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
}

- (void)requestCallBackKey:(NSString *)key result:(id)result error:(nullable NSError *)error{
    
    NSString *callBackKey = key;
    
    if (callBackKey) {
        underCallBack = [IntercomPermissionProcessor callBackForKey:callBackKey];
        if (error) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setValue:@"-10000" forKey:@"code"];
            [dic setValue:@"网络异常" forKey:@"desc"];
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            NSArray *arr = [NSKeyedUnarchiver unarchiveObjectWithData:jsonData];
            underCallBack(arr,NO);
        }else{
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingAllowFragments
                                                              error:&error];
            NSArray *arr = dict[@"data"];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:arr forKey:key];
            [self.statusArray addObject:dic];
            if(KeyToCallBackDic.count == 0){
                underCallBack(self.statusArray,YES);
            }
        }
        underCallBack = nil;
    }
}
requestObject callBacks;

- (void)taskId:(NSString *)taskId callBackKey:(NSString *)key fetchTokenCallBack:(nullable id) token error:(nullable NSError *)error{
    
    if (error) {
        [self requestCallBackKey:key result:nil error:error];
        
        UploadTaskManager *taskManager = [UploadTaskManager sharedInstance];
        NSMutableDictionary *taskDict = [taskManager getTaskManagerDict];
        [taskDict removeObjectForKey:taskId];
        
    }
}

- (void)taskId:(NSString *)taskId callBackKey:(NSString *)key uploadImg:(nullable id)imgKey finish:(nullable id)keyCode error:(nullable NSError *)error{
    NSString *fileName = (NSString *)imgKey;
    NSLog(@"%@上传失败",fileName);
    
    UploadTaskManager *taskManager = [UploadTaskManager sharedInstance];
    NSMutableDictionary *taskDict = [taskManager getTaskManagerDict];
    [taskDict removeObjectForKey:taskId];

}


- (void)taskId:(NSString *)taskId uploadImgsCallBack:(NSArray *)keyCodeDicts ruquest:(RNRequest *)request error:(NSError *)error requestObject:(requestObject)requestObject{
    if (!error) {
        callBacks  = requestObject;
        
        NSMutableArray *imageUrls = [request.images mutableCopy];
        NSInteger imageCount = imageUrls.count;
        NSInteger keyCodeCount = keyCodeDicts.count;
        
        NSString *codes = @"";
        if (imageCount == keyCodeCount) {
            
            NSArray *keyCodes = [keyCodeDicts valueForKeyPath:@"keyCode"];
            codes = [keyCodes componentsJoinedByString:@","];
            
        } else {
            
            for (NSInteger i = 0; i < keyCodeCount; i++) {
                NSDictionary *keyCodeDict = keyCodeDicts[i];
                [imageUrls replaceObjectAtIndex:(imageCount - keyCodeCount + i) withObject:[keyCodeDict valueForKey:@"keyCode"]];
            }
            codes = [imageUrls componentsJoinedByString:@","];
        }
        
        
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:request.parameters];
        [dic setValue:codes forKey:request.imageParamerNames];
        
        request.parameters = dic;
        
        callBacks(request);
    }else{
        [self requestCallBackKey:request.callBackKey result:nil error:error];
    }
    
}


- (void)taskId:(NSString *)taskId progressInUploading:(CGFloat) progress{
    NSInteger sss = progress*100;
    NSLog(@"图片上传中%ld%%",(long)sss);
}

- (void)taskId:(NSString *)taskId callBackKey:(NSString *)key publishCallBack:(nullable id) result error:(nullable NSError *)error{
    
    [self requestCallBackKey:key result:result error:error];
    UploadTaskManager *taskManager = [UploadTaskManager sharedInstance];
    NSMutableDictionary *taskDict = [taskManager getTaskManagerDict];
    [taskDict removeObjectForKey:taskId];
    
}
#pragma mark - Class Methods
+ (void)setCallBack:(UnderCallBack)callback forKey:(NSString *)key
{
    NSAssert(key, @"key should not be null");
    NSAssert(callback, @"callback should not be null");
    
    if (!KeyToCallBackDic) {
        KeyToCallBackDic = [NSMutableDictionary new];
    }
    
    [KeyToCallBackDic setObject:callback forKey:key];
    NSLog(@"save callBackKey: %@", key);
}

+ (UnderCallBack)callBackForKey:(NSString *)key
{
    NSAssert(key, @"key should not be null");
    UnderCallBack callback = [KeyToCallBackDic objectForKey:key];
    [KeyToCallBackDic removeObjectForKey:key];
    NSAssert(callback, @"callback must be non-null");
    return callback;
}

- (void)requestRoomUnderAccount:(NSDictionary *)params{

    [[CPNetworkController shareController] requestProperty:interComRoomUnderAccount parameters:params callBackDelegate:self];
}

- (void)requestSetintercomAndFirstCall:(NSDictionary *)params{

    [[CPNetworkController shareController] requestProperty:interComPermissionSet parameters:params callBackDelegate:self];

}

- (void)fetchRoomUnderAccount:(NSDictionary *)params callBack:(UnderCallBack)callBack row:(NSString *)row{
    [IntercomPermissionProcessor setCallBack:callBack forKey:row];
    NSDictionary *dic = params;
    RNRequest *rnRequest = [[RNRequest alloc] init];
    rnRequest.requestUrl = [NSString stringWithFormat:@"%@%@",[CPNetworkController shareController].NetWorkUrl_property_api,@"app/visibletalk/room/call/list"];
    
    NSMutableDictionary *parametersDic = [[NSMutableDictionary alloc] initWithDictionary:dic];
    NSArray *keysArray = [parametersDic allKeys];
    if([keysArray containsObject:@"xid"]){
        //账号被挤下线，重新登录后，仍然无法正常调用接口(RN中xid未变)
//        UserInfo *userInfo = [GlobalMethod getUserInfo];
        NSString *nowXid = [[NSUserDefaults standardUserDefaults] objectForKey:@"xid"];
        [parametersDic setObject:nowXid forKey:@"xid"];
    }
    
    rnRequest.callBackKey = row;
    rnRequest.way = [dic objectForKey:@"way"];
    rnRequest.parameters = parametersDic;
    rnRequest.hasImageToUpload = [dic objectForKey:@"hasImageToUpload"];
    rnRequest.images = [dic objectForKey:@"images"];
    rnRequest.imageParamerNames = [dic objectForKey:@"imageParamerNames"];
    
    UploadTask *task = [[UploadTask alloc] init];
    task.delegate = self;
    task.taskDescription = @"";
    task.request = rnRequest;
    
    NSArray *images = rnRequest.images;
    NSInteger uploadCount = 0;
    NSMutableArray *uploadImageArray = [NSMutableArray array];
    
    for (int i = 0; i < images.count; i++) {
        
        NSString *imagePath = images[i];
        if ([imagePath containsString:@"http"]) continue;
        [uploadImageArray addObject:imagePath];
        uploadCount++;
    }
    if (images.count > 0 && uploadCount == 0) {  //都为从后台获取的图片url
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:rnRequest.parameters];
        [dic setValue:[images componentsJoinedByString:@","]forKey:rnRequest.imageParamerNames];
        rnRequest.parameters = dic;
        task.request = rnRequest;
    } else if (images.count == 0) {     //
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:rnRequest.parameters];
        [dic setValue:@"" forKey:rnRequest.imageParamerNames];
        rnRequest.parameters = dic;
        task.request = rnRequest;
    }
    
    if (rnRequest.hasImageToUpload && uploadCount > 0 && rnRequest.imageParamerNames && rnRequest.imageParamerNames.length > 0) {
        RNRequest *qnRequest = [[RNRequest alloc] init];
        qnRequest.callBackKey = rnRequest.callBackKey;
        qnRequest.parameters = [rnRequest.hasImageToUpload objectForKey:@"qnTokenParams"];
        qnRequest.requestUrl = [NSString stringWithFormat:@"%@%@",[CPNetworkController shareController].NetWorkUrl_Activity_base,[rnRequest.hasImageToUpload objectForKey:@"qnTokenUrl"]];
        qnRequest.way = [rnRequest.hasImageToUpload objectForKey:@"qnTokenWay"];
        qnRequest.qnTokenParse = [rnRequest.hasImageToUpload objectForKey:@"nqTokenParse"];
        task.qnRequest = qnRequest;
        
        task.upLoadImageArray = uploadImageArray;
    }
    
    UploadTaskManager *taskManager = [UploadTaskManager sharedInstance];
    [taskManager addTask:task error:nil];
}

- (void)networkCallBackWith:(NSString *)interface requestResult:(RequestResult *)result{

    if([interface isEqualToString: interComPermissionSet]){
    
        if(result.status == 0 || result.status == 1){
            
            if(self.delegate && [self.delegate respondsToSelector:@selector(callBack:data:)]){
                
                
                
                [self.delegate callBack:2 data:result.code];
            }
            
        }else if (result.status == -1){
            [self.delegate callBack:2 data:result.code];
//            [GlobalMethod showGlobalPrompt:result.message delay:1.0];
            [SVProgressHUD showErrorWithStatus:result.message];
        }
        
    }else if ([interface isEqualToString: interComRoomUnderAccount]){
        if(result.status == 0 || result.status == 1){
        
            if(self.delegate && [self.delegate respondsToSelector:@selector(callBack:data:)]){
            
                NSMutableArray *models = [NSMutableArray array];
                
                for(NSDictionary *dic in result.results){
                
                    PermissionModel  *model = [[PermissionModel alloc] init];
                    model.isCall = [dic[@"isCall"] intValue];
                    model.isFirst = [dic[@"isFirst"]intValue];
                    model.name = dic[@"name"];
                    model.width = [self p_returnStringOfWidth:dic[@"name"] fontSize:17];
                    model.type = [dic[@"type"] intValue];
                    model.typeDesc = dic[@"typeDesc"];
                    model.telephone = dic[@"telephone"];
                    
                    [models addObject:model];
                }
                
                [self.delegate callBack:1 data:models];
            }
            
        }else if (result.status == -1){
            
//            [GlobalMethod showGlobalPrompt:@"网络错误" delay:1.0];
            [SVProgressHUD showErrorWithStatus:@"网络错误"];
        }
    }
}

- (CGFloat)p_returnStringOfWidth:(NSString *)string fontSize:(NSInteger)fontSize{
    
    CGFloat width = [string  boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil].size.width;
    
    return width;
}
@end
