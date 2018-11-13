//
//  YQRefreshGifHeader.m
//  XTF_SmartPart_UserTerminal
//
//  Created by 焦平 on 2018/1/18.
//  Copyright © 2018年 焦平. All rights reserved.
//

#import "YQRefreshGifHeader.h"

@implementation YQRefreshGifHeader

- (void)prepare{
    [super prepare];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"weather_crcle%zd", i]];
        [refreshingImages addObject:image];
    }
    
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages duration:0.5 forState:MJRefreshStateRefreshing];
    
    //隐藏时间
    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
    self.stateLabel.hidden = YES;
}

@end
