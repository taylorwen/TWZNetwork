//
//  ImageOP.m
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import "ImageOP.h"

@implementation ImageOP

- (void)main
{
    NSLog(@"图片");
    UIImage *image = self.image;
    if (!image) {
        NSString *path = self.upImagePath;
        image = [UIImage imageWithContentsOfFile:path];
    }
    NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    if (imageData.length > 1024*200) {
        imageData = [self imageWithImageSimple:image scaledToSize:image.size];
    }
    
    self.upOpt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
        NSLog(@"七牛上传图片进度====%f",percent);
    } params:nil checkCrc:YES cancellationSignal:nil];
    
    [self.upManager putData:imageData key:self.fileName token:self.qnToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        if (resp!=nil) {
            
            self.keyCode = resp[@"key"];
            //                self.finishBlock(info,self.keyCode,nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.uploadTask.delegate && [self.uploadTask.delegate respondsToSelector:@selector(taskId:progressInUploading:)]) {
                    self.uploadTask.finishCount = [NSNumber numberWithInteger:self.uploadTask.finishCount.integerValue + 1];
                    CGFloat progress = self.uploadTask.finishCount.floatValue/self.fileCount;
                    [self.uploadTask.delegate taskId:self.uploadTask.taskId progressInUploading:progress];
                    
                }
            });
            
        }
        else if (info.statusCode == 579){
            NSString *jsoniDc = [info.error.userInfo objectForKey:@"error"];
            
            NSData * data = [jsoniDc dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary *responeDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:NULL];
            
            self.keyCode = responeDic[@"hash"];
            
            //                self.finishBlock(info,self.keyCode,nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.uploadTask.delegate && [self.uploadTask.delegate respondsToSelector:@selector(taskId:progressInUploading:)]) {
                    self.uploadTask.finishCount = [NSNumber numberWithInteger:self.uploadTask.finishCount.integerValue + 1];
                    CGFloat progress = self.uploadTask.finishCount.floatValue/self.fileCount;
                    [self.uploadTask.delegate taskId:self.uploadTask.taskId progressInUploading:progress];
                    
                }
            });
            
        }
        else
        {
            self.keyCode = nil;
            //                self.uploadFailBlock(self.fileName);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (self.uploadTask.delegate && [self.uploadTask.delegate respondsToSelector:@selector(taskId:callBackKey:uploadImg:finish:error:)]) {
                    [self.uploadTask.delegate taskId:self.uploadTask.taskId callBackKey:self.uploadTask.request.callBackKey uploadImg:self.fileName finish:nil error:info.error];
                    
                }
            });
        }
        
        [self completeOperation];
        
    } option:self.upOpt];
}

- (NSData *)imageWithImageSimple:( UIImage *)image scaledToSize:( CGSize )newSize

{
    CGSize size = newSize;
    NSData *data = [NSData data];
    while (1) {
        // Create a graphics image context
        
        UIGraphicsBeginImageContext (size);
        
        // Tell the old image to draw in this new context, with the desired
        
        // new size
        
        [image drawInRect : CGRectMake ( 0 , 0 ,size. width ,size. height )];
        
        // Get the new image from the context
        
        UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext ();
        
        // End the context
        
        UIGraphicsEndImageContext ();
        
        // Return the new image.
        
        data = UIImageJPEGRepresentation(newImage, 0.5);
        if (data.length > 1024*200*2) {
            size = CGSizeMake(size.width/2, size.height/2);
        }else if (data.length > 1024*200) {
            size = CGSizeMake(size.width/1.5, size.height/1.5);
        }else{
            return data;
        }
        
    }
    
    
}

@end
