//
//  YQButton.m
//  ZHYQ
//
//  Created by 焦平 on 2017/10/30.
//  Copyright © 2017年 焦平. All rights reserved.
//

#import "YQButton.h"

#define kTitleRatio 0.4

@implementation YQButton

+(id)buttonWithType:(UIButtonType)buttonType btnFrame:(CGRect)frame BtnTitle:(NSString *)title BtnImage:(UIImage *)image BtnHandler:(tapHandler)handler
{
    YQButton *btn = [super buttonWithType:buttonType];
    btn.frame = frame;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.imageView.contentMode = UIViewContentModeCenter;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:image forState:UIControlStateNormal];
    btn.handler = handler;
    [btn addTarget:btn action:@selector(btnTapped:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
    
}

#pragma mark --btnTapped
-(void)btnTapped:(id)sender
{
    if (self.handler) {
        self.handler(sender);
    }
}

#pragma mark 调整图片与标题
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * (1 - kTitleRatio);
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleHeight = contentRect.size.height * kTitleRatio;
    CGFloat titleY = contentRect.size.height - titleHeight + 10;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

@end
