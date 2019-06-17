//
//  UploadTask.m
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import "UploadTask.h"

@implementation UploadTask

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.taskId forKey:@"taskId"];
    [aCoder encodeObject:self.taskDescription forKey:@"taskDescription"];
    [aCoder encodeObject:self.failedTaskId forKey:@"failedTaskId"];
    [aCoder encodeObject:self.upLoadImageArray forKey:@"upLoadImageArray"];
    [aCoder encodeObject:self.request forKey:@"request"];
    [aCoder encodeObject:self.finishCount forKey:@"finishCount"];
    [aCoder encodeObject:self.isFail forKey:@"isFail"];
    
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        self.taskId = [aDecoder decodeObjectForKey:@"taskId"];
        self.taskDescription = [aDecoder decodeObjectForKey:@"taskDescription"];
        self.failedTaskId = [aDecoder decodeObjectForKey:@"failedTaskId"];
        self.upLoadImageArray = [aDecoder decodeObjectForKey:@"upLoadImageArray"];
        self.request = [aDecoder decodeObjectForKey:@"request"];
        self.finishCount = [aDecoder decodeObjectForKey:@"finishCount"];
        self.isFail = [aDecoder decodeObjectForKey:@"isFail"];
    }
    
    return self;
}
@end
