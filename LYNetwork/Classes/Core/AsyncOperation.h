//
//  AsyncOperation.h
//  PropertyCloud
//
//  Created by SZOeasy on 2017/2/22.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsyncOperation : NSOperation{
    BOOL        executing;
    BOOL        finished;
}

- (void)completeOperation;

@end
