//
//  YQEmptyView.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/1/19.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "YQEmptyView.h"

@implementation YQEmptyView

+ (instancetype)diyEmptyView{
    
    YQEmptyView *emView = [YQEmptyView emptyViewWithImageStr:@"sure_placeholder_error" titleStr:@"暂时没有数据~" detailStr:@""];
    
    emView.imageSize = CGSizeMake(142, 99);
    emView.titleLabTextColor = [UIColor colorWithHexString:@"#1B82D1"];
    
    return emView;
}

+ (instancetype)msgDiyEmptyView{
    
    YQEmptyView *emView = [YQEmptyView emptyViewWithImageStr:@"nomessage" titleStr:@"暂时没有消息~" detailStr:@""];
    
    emView.imageSize = CGSizeMake(124, 108);
    emView.titleLabTextColor = [UIColor colorWithHexString:@"#1B82D1"];
    
    return emView;
}

+ (instancetype)diyEmptyActionViewWithTarget:(id)target action:(SEL)action{
    
    YQEmptyView *emView = [YQEmptyView emptyActionViewWithImageStr:@"webView_noNetWork" titleStr:@"对不起，网络连接失败" detailStr:@"" btnTitleStr:@"加载失败,点击重试~" target:target action:action];
    
    emView.imageSize = CGSizeMake(150, 150);
    emView.titleLabTextColor = [UIColor colorWithHexString:@"#1B82D1"];
    emView.actionBtnBackGroundColor = [UIColor clearColor];
    emView.actionBtnBorderColor = [UIColor colorWithHexString:@"#e2e2e2"];
    emView.actionBtnTitleColor = [UIColor grayColor];
    emView.actionBtnFont = [UIFont systemFontOfSize:17];
    emView.actionBtnCornerRadius = 4;
    emView.actionBtnBorderWidth = 0.5;
    
    return emView;
}

- (void)prepare{
    [super prepare];
    
    self.autoShowEmptyView = NO;
    
}

@end
