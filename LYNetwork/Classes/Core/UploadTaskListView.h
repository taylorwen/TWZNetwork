//
//  UploadTaskListView.h
//  PropertyCloud
//
//  Created by Ming on 2017/2/27.
//  Copyright © 2017年 Oeasy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface UploadTaskListView : UIView

+ (UploadTaskListView *)shareView;

@property (nonatomic, strong) UITableView *uploadTaskTableView;

@property (nonatomic, strong) NSMutableDictionary *taskDicSource;

@end
NS_ASSUME_NONNULL_END
