//
//  YQButton.h
//  ZHYQ
//
//  Created by 焦平 on 2017/10/30.
//  Copyright © 2017年 焦平. All rights reserved.
//


/*
 图片在上，文字在下的按钮
 */

#import <UIKit/UIKit.h>

typedef void(^tapHandler)(UIButton *sender);

@interface YQButton : UIButton

@property (nonatomic,strong) tapHandler handler;

+(id)buttonWithType:(UIButtonType)buttonType btnFrame:(CGRect)frame BtnTitle:(NSString *)title BtnImage:(UIImage *)image BtnHandler:(tapHandler)handler;

@end
