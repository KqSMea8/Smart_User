//
//  YQEmptyView.h
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/1/19.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "LYEmptyView.h"

@interface YQEmptyView : LYEmptyView

+ (instancetype)diyEmptyView;

+ (instancetype)msgDiyEmptyView;

+ (instancetype)diyEmptyActionViewWithTarget:(id)target action:(SEL)action;

@end
